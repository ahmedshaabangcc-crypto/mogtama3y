import 'dart:js_interop';

@JS('mogtama3yPhoneSend')
external JSPromise<JSString> _send(JSString phone);

@JS('mogtama3yPhoneConfirm')
external JSPromise<JSString> _confirm(JSString code);

/// '' when the SMS is on its way, else a Firebase error code.
Future<String> sendSmsCode(String phone) async {
  try {
    return (await _send(phone.toJS).toDart).toDart;
  } catch (_) {
    return 'sdk-load-failed'; // helper missing (e.g. an old cached index.html)
  }
}

/// The Firebase ID token, or 'ERR:<code>'.
Future<String> confirmSmsCode(String code) async {
  try {
    return (await _confirm(code.toJS).toDart).toDart;
  } catch (_) {
    return 'ERR:sdk-load-failed';
  }
}
