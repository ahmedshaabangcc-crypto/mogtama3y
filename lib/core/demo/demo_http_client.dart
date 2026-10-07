import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'demo_store.dart';

/// The demo build's whole "network": handed to `Supabase.initialize` as
/// its `httpClient`, so every PostgREST / RPC / Auth / Storage / Functions
/// call made by the normal services is answered from [DemoStore] in
/// memory. It never opens a connection — there is no inner client.
class DemoHttpClient extends http.BaseClient {
  DemoHttpClient(this.store);

  final DemoStore store;

  /// A short pause so loading states look natural in the recordings.
  static const _latency = Duration(milliseconds: 140);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final bodyBytes = await request.finalize().toBytes();
    final body = bodyBytes.isEmpty ? null : utf8.decode(bodyBytes);
    await Future<void>.delayed(_latency);
    try {
      final (status, json) = _route(request, body);
      return _respond(request, status, json);
    } on DemoError catch (e) {
      return _respond(request, e.status, {'message': e.message, 'code': 'P0001', 'details': null, 'hint': null});
    } catch (e) {
      return _respond(request, 500, {'message': 'Demo backend error: $e', 'code': 'DEMO', 'details': null, 'hint': null});
    }
  }

  http.StreamedResponse _respond(http.BaseRequest request, int status, Object? json) {
    final bytes = status == 204 ? <int>[] : utf8.encode(jsonEncode(json));
    return http.StreamedResponse(
      Stream.value(bytes),
      status,
      contentLength: bytes.length,
      request: request,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }

  (int, Object?) _route(http.BaseRequest request, String? body) {
    final path = request.url.path;
    final method = request.method.toUpperCase();
    final query = request.url.queryParameters;

    if (path.startsWith('/rest/v1/rpc/')) {
      final fn = path.substring('/rest/v1/rpc/'.length);
      final params = body == null || body.isEmpty ? <String, dynamic>{} : Map<String, dynamic>.from(jsonDecode(body) as Map);
      return (200, store.rpc(fn, params));
    }

    if (path.startsWith('/rest/v1/')) {
      final table = path.substring('/rest/v1/'.length);
      final wantsObject = (request.headers['Accept'] ?? request.headers['accept'] ?? '').contains('vnd.pgrst.object');
      final prefer = request.headers['Prefer'] ?? request.headers['prefer'] ?? '';
      final returnRows = prefer.contains('return=representation');
      List<DemoRow> rows;
      switch (method) {
        case 'GET':
        case 'HEAD':
          rows = store.select(table, query);
        case 'POST':
          rows = store.insert(table, jsonDecode(body ?? '{}') as Object, select: query['select']);
          if (!returnRows) return (201, null);
        case 'PATCH':
          rows = store.update(table, query, Map<String, dynamic>.from(jsonDecode(body ?? '{}') as Map), select: query['select']);
          if (!returnRows) return (204, null);
        case 'DELETE':
          rows = store.delete(table, query);
          if (!returnRows) return (204, null);
        default:
          throw DemoError('Unsupported method $method', 405);
      }
      if (wantsObject) {
        if (rows.length != 1) {
          throw DemoError('JSON object requested, multiple (or no) rows returned', 406);
        }
        return (200, rows.first);
      }
      return (200, rows);
    }

    if (path.startsWith('/auth/v1/')) {
      final endpoint = path.substring('/auth/v1/'.length);
      if (endpoint == 'logout') return (204, null);
      if (endpoint == 'user') {
        final p = store.profileOf(store.me);
        return (200, {
          'id': store.me,
          'aud': 'authenticated',
          'role': 'authenticated',
          'email': 'demo@demo.invalid',
          'app_metadata': {'provider': 'email'},
          'user_metadata': {'full_name': p?['full_name']},
          'created_at': p?['created_at'],
        });
      }
      throw DemoError('النسخة التجريبية: استخدم مبدّل الأدوار بدل تسجيل الدخول');
    }

    if (path.startsWith('/functions/v1/')) {
      // e.g. 'places' (building search) — nothing external in the demo.
      return (200, {'results': <Object>[], 'places': <Object>[], 'ok': false, 'error': 'غير متاح في النسخة التجريبية'});
    }

    throw DemoError('غير متاح في النسخة التجريبية', 404);
  }
}
