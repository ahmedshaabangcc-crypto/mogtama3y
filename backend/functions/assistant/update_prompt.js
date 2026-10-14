// Pushes system_prompt.md into the live n8n assistant workflow — changing
// only the AI agent's system message and the "Prepare" node's code
// (prepare_code.js — the user context, incl. country + dialect since the
// Arab-world phase 5). Nothing else in the workflow changes.
//   node backend/functions/assistant/update_prompt.js
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..', '..', '..');
const KEY = fs.readFileSync(path.join(ROOT, '.n8n-api-key'), 'utf8').trim();
const BASE = 'https://n8n.srv1967321.hstgr.cloud/api/v1';
const WORKFLOW_NAME = 'مُجتمعي – AI Assistant';
const PREPARE_CODE = require('./prepare_code');
const PROMPT = fs.readFileSync(path.join(__dirname, 'system_prompt.md'), 'utf8').replace(/\r\n/g, '\n');

async function api(method, p, body) {
  const res = await fetch(BASE + p, {
    method,
    headers: { 'X-N8N-API-KEY': KEY, 'Content-Type': 'application/json', Accept: 'application/json' },
    body: body ? JSON.stringify(body) : undefined,
  });
  const text = await res.text();
  if (!res.ok) throw new Error(`${method} ${p} -> ${res.status}: ${text.slice(0, 300)}`);
  return text ? JSON.parse(text) : null;
}

(async () => {
  const list = await api('GET', '/workflows?limit=200');
  const found = list.data.find((w) => w.name === WORKFLOW_NAME);
  if (!found) throw new Error('workflow not found');
  const wf = await api('GET', `/workflows/${found.id}`);
  let changed = 0;
  for (const n of wf.nodes) {
    if (n.parameters?.options && 'systemMessage' in n.parameters.options) {
      n.parameters.options.systemMessage = PROMPT;
      changed++;
    }
  }
  if (changed !== 1) throw new Error(`expected 1 agent node, found ${changed}`);
  const prepare = wf.nodes.filter((n) => n.name === 'Prepare' && n.type === 'n8n-nodes-base.code');
  if (prepare.length !== 1) throw new Error(`expected 1 Prepare node, found ${prepare.length}`);
  prepare[0].parameters.jsCode = PREPARE_CODE;
  // The public API accepts only these fields on update.
  const body = { name: wf.name, nodes: wf.nodes, connections: wf.connections, settings: { executionOrder: wf.settings?.executionOrder || 'v1' } };
  await api('PUT', `/workflows/${found.id}`, body);
  if (!wf.active) await api('POST', `/workflows/${found.id}/activate`);
  console.log(`updated ${wf.name} (${found.id}), prompt ${PROMPT.length} chars, active`);
})().catch((e) => {
  console.error(e.message);
  process.exit(1);
});
