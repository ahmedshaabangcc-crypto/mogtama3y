// Writes a flavour's landing (tajer / ittihad / masjid) into the built
// index.html, in place of the مُجتمعي one, so the HTML crawlers read has that
// app's own single H1 and copy instead of مُجتمعي's (the script in the page
// swaps the same markup in at run time, so nothing changes for visitors).
// Also points og:image / twitter:image at the flavour's share image.
//
//   node tool/flavor_landing.mjs build/web_tajer/index.html tajer
import fs from 'node:fs';

const [file, flavor] = process.argv.slice(2);
let html = fs.readFileSync(file, 'utf8');

const block = /var pages = (\{[\s\S]*?\n {6}\});/.exec(html);
if (!block) throw new Error('pages block not found');
const pages = new Function(`return ${block[1]};`)();
if (!pages[flavor]) throw new Error(`no landing for ${flavor}`);

const main = /(<main id="landing">)[\s\S]*?(\s*<footer class="lp-foot">)/;
if (!main.test(html)) throw new Error('landing markup not found');
html = html.replace(main, (_, open, foot) => `${open}\n    ${pages[flavor]}${foot}`);

const og = `https://mogtama3y.com/og-${flavor}.jpg`;
html = html.replace(/(<meta (?:property="og:image"|name="twitter:image") content=")[^"]*/g, `$1${og}`);

fs.writeFileSync(file, html);
const h1s = (/<main id="landing">[\s\S]*?<\/main>/.exec(html)[0].match(/<h1/g) || []).length;
if (h1s !== 1) throw new Error(`${flavor} landing has ${h1s} h1`);
console.log(`${file}: ${flavor} landing written`);
