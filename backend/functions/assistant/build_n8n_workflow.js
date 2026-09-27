// Creates / updates the "مُجتمعي – AI Assistant" workflow on the
// company n8n (same pattern as the Apex website agent: Webhook → Agent
// with Gemini + window memory + Telegram / ticket tools → Respond).
//
//   node build_n8n_workflow.js            create or update, then activate
//
// Reads the n8n API key from ../../../.n8n-api-key and the shared secret
// (also set as ASSISTANT_SHARED_SECRET on Supabase) from
// ../../../.assistant-secret — both git-ignored. The system prompt is
// system_prompt.md next to this file.
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..', '..', '..');
const KEY = fs.readFileSync(path.join(ROOT, '.n8n-api-key'), 'utf8').trim();
const SECRET = fs.readFileSync(path.join(ROOT, '.assistant-secret'), 'utf8').trim();
const SYSTEM_PROMPT = fs.readFileSync(path.join(__dirname, 'system_prompt.md'), 'utf8');
const BASE = 'https://n8n.srv1967321.hstgr.cloud/api/v1';

const WORKFLOW_NAME = 'مُجتمعي – AI Assistant';
const SECRET_CREDENTIAL_NAME = 'Mogtama3y Assistant Secret';
// Existing credentials on this n8n (shared with the Apex agent).
const GEMINI = { id: 'QhlWQcSXcyjfeoij', name: 'Google Gemini(PaLM) Api account' };
const TELEGRAM = { id: '9cTMXHYHQERpCO7M', name: 'Telegram account' };
const OWNER_TELEGRAM_CHAT_ID = '7125544041';
const SUPABASE_FUNCTION_URL = 'https://pxiabifybakbsqlycffc.supabase.co/functions/v1/hyper-api';
const SUPABASE_PUBLISHABLE_KEY = 'sb_publishable_3QS4C4PPUUCZuvjUi8Ifmg_EJ44uxhE';

async function api(method, p, body) {
  const res = await fetch(BASE + p, {
    method,
    headers: { 'X-N8N-API-KEY': KEY, 'Content-Type': 'application/json', Accept: 'application/json' },
    body: body ? JSON.stringify(body) : undefined,
  });
  const text = await res.text();
  if (!res.ok) throw new Error(`${method} ${p} -> ${res.status}: ${text.slice(0, 600)}`);
  return text ? JSON.parse(text) : null;
}

async function ensureSecretCredential() {
  const list = await api('GET', '/credentials?limit=200');
  const existing = (list.data || []).find((c) => c.name === SECRET_CREDENTIAL_NAME);
  if (existing) return { id: existing.id, name: existing.name };
  const created = await api('POST', '/credentials', {
    name: SECRET_CREDENTIAL_NAME,
    type: 'httpHeaderAuth',
    data: { name: 'X-Mogtama3y-Secret', value: SECRET },
  });
  return { id: created.id, name: created.name };
}

const PREPARE_CODE = `const req = $input.first().json;
let b = req.body || {};
if (typeof b === 'string') { try { b = JSON.parse(b); } catch (e) { b = {}; } }
const clip = (v, n) => String(v == null ? '' : v).replace(/[\\u0000-\\u0009\\u000b-\\u001f]/g, ' ').trim().slice(0, n);
const message = clip(b.message, 1000);
const isGuest = b.is_guest !== false || !b.user_id;
const userName = clip(b.user_name, 80);
const userPhone = clip(b.user_phone, 20);
const userBuilding = clip(b.user_building, 120);
const membership = clip(b.user_membership, 40) || 'none';
const context = isGuest
  ? '[بيانات المستخدم] زائر غير مسجّل دخول'
  // No name here on purpose: the agent must not guess gender from it. The
  // name still reaches the owner in the Telegram hand-off below.
  : '[بيانات المستخدم] مسجّل دخول | العمارة: ' + (userBuilding || 'لم ينضم لعمارة') + ' | العضوية: ' + membership;
return [{ json: {
  sessionId: clip(b.session_id, 100) || 'anon',
  userId: isGuest ? '' : clip(b.user_id, 36),
  userName: userName || (isGuest ? 'زائر' : ''),
  userPhone: userPhone || '-',
  userBuilding: userBuilding || '-',
  isGuest,
  promptText: context + '\\n[رسالة المستخدم]\\n' + message,
} }];`;

function buildWorkflow(secretCred) {
  const pos = (x, y) => [x, y];
  return {
    name: WORKFLOW_NAME,
    settings: { executionOrder: 'v1' },
    nodes: [
      {
        id: 'wh', name: 'POST /mogtama3y-assistant', type: 'n8n-nodes-base.webhook', typeVersion: 2.1, position: pos(0, 0),
        webhookId: 'mogtama3y-assistant',
        parameters: { httpMethod: 'POST', path: 'mogtama3y-assistant', authentication: 'headerAuth', responseMode: 'responseNode', options: {} },
        credentials: { httpHeaderAuth: secretCred },
      },
      {
        id: 'prep', name: 'Prepare', type: 'n8n-nodes-base.code', typeVersion: 2, position: pos(220, 0),
        parameters: { mode: 'runOnceForAllItems', language: 'javaScript', jsCode: PREPARE_CODE },
      },
      {
        id: 'agent', name: 'Mogtama3y Agent', type: '@n8n/n8n-nodes-langchain.agent', typeVersion: 3.1, position: pos(460, 0),
        // Gemini free tier allows ~5 requests/minute — retry instead of failing.
        retryOnFail: true, maxTries: 3, waitBetweenTries: 5000,
        parameters: { promptType: 'define', text: '={{ $json.promptText }}', hasOutputParser: false, options: { systemMessage: SYSTEM_PROMPT } },
      },
      {
        id: 'gemini', name: 'Gemini Flash', type: '@n8n/n8n-nodes-langchain.lmChatGoogleGemini', typeVersion: 1.1, position: pos(360, 240),
        parameters: { modelName: 'models/gemini-3.6-flash', options: { maxOutputTokens: 1024, temperature: 0.4 } },
        credentials: { googlePalmApi: GEMINI },
      },
      {
        id: 'memory', name: 'Conversation Memory', type: '@n8n/n8n-nodes-langchain.memoryBufferWindow', typeVersion: 1.4, position: pos(500, 240),
        parameters: { sessionIdType: 'customKey', sessionKey: "={{ $('Prepare').item.json.sessionId }}", contextWindowLength: 10 },
      },
      {
        id: 'tg', name: 'Notify Owner On Telegram', type: 'n8n-nodes-base.telegramTool', typeVersion: 1.2, position: pos(640, 240),
        parameters: {
          resource: 'message', operation: 'sendMessage', chatId: OWNER_TELEGRAM_CHAT_ID,
          text: "=🏢 مُجتمعي — مستخدم يطلب التواصل مع الدعم\nالاسم: {{ $('Prepare').item.json.userName }}\nالموبايل: {{ $('Prepare').item.json.userPhone }}\nالعمارة: {{ $('Prepare').item.json.userBuilding }}\n\n{{ /*n8n-auto-generated-fromAI-override*/ $fromAI('summary', 'One or two sentences in Arabic summarizing what the user needs help with') }}",
          additionalFields: { appendAttribution: false },
        },
        credentials: { telegramApi: TELEGRAM },
      },
      {
        id: 'ticket', name: 'Open Support Ticket', type: 'n8n-nodes-base.httpRequestTool', typeVersion: 4.2, position: pos(780, 240),
        parameters: {
          toolDescription: 'Opens a support ticket in the مُجتمعي admin panel for the current signed-in user so the team can reply inside the app. Only use for signed-in users who asked for human help.',
          method: 'POST', url: SUPABASE_FUNCTION_URL,
          authentication: 'genericCredentialType', genericAuthType: 'httpHeaderAuth',
          sendHeaders: true, headerParameters: { parameters: [{ name: 'apikey', value: SUPABASE_PUBLISHABLE_KEY }] },
          sendBody: true, contentType: 'json', specifyBody: 'keypair',
          bodyParameters: { parameters: [
            { name: 'action', value: 'ticket' },
            { name: 'user_id', value: "={{ $('Prepare').item.json.userId }}" },
            { name: 'summary', value: "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('summary', 'What the user needs, in Arabic, 1-3 sentences') }}" },
          ] },
          options: {},
        },
        credentials: { httpHeaderAuth: secretCred },
      },
      {
        id: 'respond', name: 'Respond Reply', type: 'n8n-nodes-base.respondToWebhook', typeVersion: 1.5, position: pos(720, 0),
        parameters: { respondWith: 'json', responseBody: '={{ JSON.stringify({ ok: true, reply: $json.output }) }}', options: { responseCode: 200 } },
      },
    ],
    connections: {
      'POST /mogtama3y-assistant': { main: [[{ node: 'Prepare', type: 'main', index: 0 }]] },
      Prepare: { main: [[{ node: 'Mogtama3y Agent', type: 'main', index: 0 }]] },
      'Mogtama3y Agent': { main: [[{ node: 'Respond Reply', type: 'main', index: 0 }]] },
      'Gemini Flash': { ai_languageModel: [[{ node: 'Mogtama3y Agent', type: 'ai_languageModel', index: 0 }]] },
      'Conversation Memory': { ai_memory: [[{ node: 'Mogtama3y Agent', type: 'ai_memory', index: 0 }]] },
      'Notify Owner On Telegram': { ai_tool: [[{ node: 'Mogtama3y Agent', type: 'ai_tool', index: 0 }]] },
      'Open Support Ticket': { ai_tool: [[{ node: 'Mogtama3y Agent', type: 'ai_tool', index: 0 }]] },
    },
  };
}

(async () => {
  const secretCred = await ensureSecretCredential();
  const wf = buildWorkflow(secretCred);
  const list = await api('GET', '/workflows?limit=200');
  const existing = (list.data || []).find((w) => w.name === WORKFLOW_NAME);
  let id;
  if (existing) {
    id = existing.id;
    if (existing.active) await api('POST', `/workflows/${id}/deactivate`);
    await api('PUT', `/workflows/${id}`, wf);
    console.log('updated workflow', id);
  } else {
    const created = await api('POST', '/workflows', wf);
    id = created.id;
    console.log('created workflow', id);
  }
  await api('POST', `/workflows/${id}/activate`);
  console.log('activated — webhook: https://n8n.srv1967321.hstgr.cloud/webhook/mogtama3y-assistant');
})().catch((e) => { console.error(e.message); process.exit(1); });
