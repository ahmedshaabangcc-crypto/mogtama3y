// The in-app YouTube player surface. Web: an <iframe> to
// youtube-nocookie.com shown through HtmlElementView. Elsewhere there is
// no embed and the player opens the YouTube URL instead.
export 'youtube_embed_stub.dart' if (dart.library.js_interop) 'youtube_embed_web.dart';
