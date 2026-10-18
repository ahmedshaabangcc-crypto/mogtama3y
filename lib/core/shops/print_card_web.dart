import 'dart:js_interop';

@JS('mogtama3yDownloadImage')
external JSBoolean? _download(JSString dataUrl, JSString filename);

@JS('mogtama3yPrintA5')
external JSBoolean? _printA5(JSString dataUrl, JSString title);

@JS('mogtama3yDownloadText')
external JSBoolean? _downloadText(JSString text, JSString filename, JSString mime);

@JS('mogtama3yPrintHtml')
external JSBoolean? _printHtml(JSString html, JSString title);

@JS('mogtama3yChime')
external JSBoolean? _chime();

@JS('mogtama3yPickTextFile')
external JSPromise<JSString> _pickTextFile(JSString accept);

/// Lets the user pick a text file (a CSV): its text, '' when cancelled,
/// null when the browser can't (old cached index.html, too big, unreadable).
Future<String?> pickTextFile({String accept = '.csv,text/csv'}) async {
  try {
    final v = (await _pickTextFile(accept.toJS).toDart).toDart;
    return v.startsWith('ERR:') ? null : v;
  } catch (_) {
    return null;
  }
}

/// Saves a `data:image/png;base64,…` URL as [filename].
bool downloadImage(String dataUrl, String filename) {
  try {
    return _download(dataUrl.toJS, filename.toJS)?.toDart ?? false;
  } catch (_) {
    return false; // helper missing (e.g. an old cached index.html)
  }
}

/// Opens the browser's print dialog with the image on an A5 page.
bool printA5Image(String dataUrl, String title) {
  try {
    return _printA5(dataUrl.toJS, title.toJS)?.toDart ?? false;
  } catch (_) {
    return false;
  }
}

/// Saves [text] as [filename] (e.g. a CSV).
bool downloadText(String text, String filename, {String mime = 'text/plain;charset=utf-8'}) {
  try {
    return _downloadText(text.toJS, filename.toJS, mime.toJS)?.toDart ?? false;
  } catch (_) {
    return false;
  }
}

/// Prints a complete HTML document (every value already escaped).
bool printHtml(String html, String title) {
  try {
    return _printHtml(html.toJS, title.toJS)?.toDart ?? false;
  } catch (_) {
    return false;
  }
}

/// A short chime (Web Audio). False when the browser can't play it.
bool playChime() {
  try {
    return _chime()?.toDart ?? false;
  } catch (_) {
    return false;
  }
}
