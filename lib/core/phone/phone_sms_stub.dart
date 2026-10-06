/// Non-web builds: SMS verification isn't wired up there.
Future<String> sendSmsCode(String phone) async => 'unsupported';

Future<String> confirmSmsCode(String code) async => 'ERR:unsupported';
