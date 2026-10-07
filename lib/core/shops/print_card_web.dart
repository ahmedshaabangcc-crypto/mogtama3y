import 'dart:js_interop';

@JS('mogtama3yDownloadImage')
external JSBoolean? _download(JSString dataUrl, JSString filename);

@JS('mogtama3yPrintA5')
external JSBoolean? _printA5(JSString dataUrl, JSString title);

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
