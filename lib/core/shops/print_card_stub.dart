/// Non-web builds: no browser download / print / chime.
bool downloadImage(String dataUrl, String filename) => false;

bool printA5Image(String dataUrl, String title) => false;

bool downloadText(String text, String filename, {String mime = 'text/plain;charset=utf-8'}) => false;

bool printHtml(String html, String title) => false;

bool playChime() => false;
