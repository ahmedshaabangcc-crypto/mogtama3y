// A short vibration and a gentle chime (generated with Web Audio — no
// audio file needed). No-ops off the web.
export 'feedback_stub.dart' if (dart.library.js_interop) 'feedback_web.dart';
