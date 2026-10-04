// "Install the app on your phone" (web only). Backed by the helpers in
// web/index.html; every check is false off the web.
export 'install_prompt_stub.dart' if (dart.library.js_interop) 'install_prompt_web.dart';
