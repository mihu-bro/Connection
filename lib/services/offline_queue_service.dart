import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Queues outgoing messages when offline. Flushed when network returns.
class OfflineQueueService {
  OfflineQueueService._();
  static final instance = OfflineQueueService._();

  Future<File> _file() async {
    final root = await getApplicationDocumentsDirectory();
    return File('${root.path}/offline_queue.json');
  }

  Future<List<Map<String, dynamic>>> peekAll() async {
    try {
      final file = await _file();
      if (!await file.exists()) return [];
      final raw = await file.readAsString();
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> enqueue(Map<String, dynamic> message) async {
    final list = await peekAll();
    message['_queuedAt'] = DateTime.now().millisecondsSinceEpoch;
    list.add(message);
    final file = await _file();
    await file.writeAsString(jsonEncode(list));
  }

  Future<void> removeWhere(bool Function(Map<String, dynamic>) test) async {
    final list = await peekAll();
    list.removeWhere(test);
    final file = await _file();
    await file.writeAsString(jsonEncode(list));
  }

  Future<void> clear() async {
    try {
      final file = await _file();
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}
