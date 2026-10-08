import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

import 'tutorial_service.dart';

const bool youtubeEmbedSupported = true;

const _viewType = 'mogtama3y-youtube-embed';
bool _registered = false;

void _register() {
  if (_registered) return;
  _registered = true;
  ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId, {Object? params}) {
    final id = params is String ? params : '';
    final document = globalContext.getProperty<JSObject>('document'.toJS);
    final iframe = document.callMethod<JSObject>('createElement'.toJS, 'iframe'.toJS);
    void attr(String name, String value) => iframe.callMethod<JSAny?>('setAttribute'.toJS, name.toJS, value.toJS);
    attr('src', youtubeEmbedUrl(id));
    attr('allow', 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share');
    attr('allowfullscreen', '');
    attr('referrerpolicy', 'strict-origin-when-cross-origin');
    attr('title', 'YouTube');
    attr('style', 'border:0;width:100%;height:100%;display:block;background:#000');
    return iframe;
  });
}

/// The iframe for [youtubeId]; it fills its parent (give it a 9:16 box).
/// Flutter removes the element — and so stops playback — when this
/// widget leaves the tree.
Widget youtubeEmbed(String youtubeId) {
  _register();
  return HtmlElementView(key: ValueKey(youtubeId), viewType: _viewType, creationParams: youtubeId);
}
