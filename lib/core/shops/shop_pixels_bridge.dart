// The merchant pixels bridge (web/shop-pixels.js). Off the web: no-op.
export 'shop_pixels_bridge_stub.dart' if (dart.library.js_interop) 'shop_pixels_bridge_web.dart';
