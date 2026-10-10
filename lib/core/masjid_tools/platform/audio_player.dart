// «استماع»: one shared HTML <audio> element plus the Media Session API
// (lock-screen / headset controls) on the web; a silent no-op elsewhere.
export 'audio_player_stub.dart' if (dart.library.js_interop) 'audio_player_web.dart';
