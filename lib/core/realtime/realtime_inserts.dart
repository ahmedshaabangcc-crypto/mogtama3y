import 'package:supabase_flutter/supabase_flutter.dart';

/// Subscribes to new rows in [table] where [column] = [value] (Supabase
/// Realtime, migration 0043). RLS still applies per subscriber, so this
/// only ever delivers rows the user could already read. Pass the returned
/// channel to [unsubscribe] in dispose().
RealtimeChannel subscribeToInserts({
  required String table,
  required String column,
  required String value,
  required void Function(Map<String, dynamic> newRecord) onInsert,
}) {
  return Supabase.instance.client
      .channel('$table:$column=$value')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: table,
        filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: column, value: value),
        callback: (payload) => onInsert(payload.newRecord),
      )
      .subscribe();
}

Future<void> unsubscribe(RealtimeChannel channel) => Supabase.instance.client.removeChannel(channel);
