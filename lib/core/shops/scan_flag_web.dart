import 'dart:js_interop';

@JS('__mogtama3yScanRecorded')
external JSBoolean? get _flag;

bool get scanAlreadyRecorded => _flag?.toDart ?? false;
