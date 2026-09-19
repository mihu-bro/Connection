import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Simple local message cache for offline + instant open.
/// Stores last N messages per room as JSON files.
class MessageCacheService {
  MessageCacheService._();
  static final instance = MessageCacheService._();

  static const _maxMessages = 300;

  Future<Directory> _dir() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory('${root.path}/msg_cache');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<File> _file(String roomId) async {
    final dir = await _dir();
    return File('${dir.path}/$roomId.json');
  }

  /// Save messages (newest first or chronological — we store as list of maps).
  Future<void> save(String roomId, List<Map<String, dynamic>> messages) async {
    if (roomId.isEmpty) return;
    try {
      final trimmed = messages.length > _maxMessages
          ? messages.sublist(0, _maxMessages)
          : messages;
      final file = await _file(roomId);
      await file.writeAsString(jsonEncode(trimmed));
    } catch (_) {}
  }

  /// Load cached messages. Returns empty list on failure.
  Future<List<Map<String, dynamic>>> load(String roomId) async {
    if (roomId.isEmpty) return [];
    try {
      final file = await _file(roomId);
      if (!await file.exists()) return [];
      final raw = await file.readAsString();
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Append one message (for offline queue / optimistic UI).
  Future<void> append(String roomId, Map<String, dynamic> message) async {
    final existing = await load(roomId);
    existing.insert(0, message);
    await save(roomId, existing);
  }

  Future<void> clear(String roomId) async {
    try {
      final file = await _file(roomId);
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }

  Future<void> clearAll() async {
    try {
      final dir = await _dir();
      if (await dir.exists()) await dir.delete(recursive: true);
    } catch (_) {}
  }
}
