// «المحفّظ» engine: on the web it lazily imports web/quran_tutor/tutor.js
// (which starts the speech worker); elsewhere it is unsupported.
export 'tutor_engine_stub.dart' if (dart.library.js_interop) 'tutor_engine_web.dart';
export 'tutor_types.dart';
