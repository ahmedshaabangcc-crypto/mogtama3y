// The n8n "Prepare" Code node of the assistant workflow: turns the Edge
// Function's POST body into the agent's prompt text (user context + the
// message). Shared by build_n8n_workflow.js (full rebuild) and
// update_prompt.js (which syncs this node and the system message).
module.exports = `const req = $input.first().json;
let b = req.body || {};
if (typeof b === 'string') { try { b = JSON.parse(b); } catch (e) { b = {}; } }
const clip = (v, n) => String(v == null ? '' : v).replace(/[\\u0000-\\u0009\\u000b-\\u001f]/g, ' ').trim().slice(0, n);
const message = clip(b.message, 1000);
const isGuest = b.is_guest !== false || !b.user_id;
const userName = clip(b.user_name, 80);
const userPhone = clip(b.user_phone, 20);
const userBuilding = clip(b.user_building, 120);
const membership = clip(b.user_membership, 40) || 'none';
const country = clip(b.user_country, 2).toUpperCase() || 'EG';
const countryName = clip(b.user_country_name, 40) || 'مصر';
const dialect = clip(b.user_dialect, 200) || 'العامية المصرية';
// Where the user is and how to talk to them (system prompt: «طريقة كلامك»).
const where = ' | البلد: ' + countryName + ' (' + country + ') | اللهجة: ' + dialect;
const context = isGuest
  ? '[بيانات المستخدم] زائر غير مسجّل دخول' + where
  // No name here on purpose: the agent must not guess gender from it. The
  // name still reaches the owner in the Telegram hand-off below.
  : '[بيانات المستخدم] مسجّل دخول' + where + ' | العمارة: ' + (userBuilding || 'لم ينضم لعمارة') + ' | العضوية: ' + membership;
return [{ json: {
  sessionId: clip(b.session_id, 100) || 'anon',
  userId: isGuest ? '' : clip(b.user_id, 36),
  userName: userName || (isGuest ? 'زائر' : ''),
  userPhone: userPhone || '-',
  userBuilding: userBuilding || '-',
  userCountry: country,
  isGuest,
  promptText: context + '\\n[رسالة المستخدم]\\n' + message,
} }];`;
