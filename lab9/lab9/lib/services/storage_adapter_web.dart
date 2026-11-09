import 'dart:convert';
import 'storage_adapter.dart';
import 'default_data.dart';
import '../models/note_item.dart';
import '../models/product_item.dart';

StorageAdapter getStorageAdapter() => WebStorageAdapter();

class WebStorageAdapter implements StorageAdapter {
  static String? _inMemoryNotesJson;
  static String? _inMemoryDatabaseJson;

  @override
  Future<String> getNotesPath() async => 'Web Browser Sandbox: lab9_2_notes.json';

  @override
  Future<List<NoteItem>> readNotes() async {
    if (_inMemoryNotesJson == null) {
      final defaults = defaultNotes();
      await writeNotes(defaults);
      return defaults;
    }
    final List<dynamic> list = jsonDecode(_inMemoryNotesJson!) as List<dynamic>;
    return list.map((e) => NoteItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> writeNotes(List<NoteItem> notes) async {
    const encoder = JsonEncoder.withIndent('  ');
    _inMemoryNotesJson = encoder.convert(notes.map((e) => e.toJson()).toList());
  }

  @override
  Future<String> getRawNotes() async => _inMemoryNotesJson ?? '[]';

  @override
  Future<void> clearNotes() async {
    _inMemoryNotesJson = null;
  }

  @override
  Future<String> getDatabasePath() async => 'Web Browser Sandbox: lab9_3_database.json';

  @override
  Future<List<ProductItem>> readDatabase() async {
    if (_inMemoryDatabaseJson == null) {
      final defaults = defaultProducts();
      await writeDatabase(defaults);
      return defaults;
    }
    final List<dynamic> list = jsonDecode(_inMemoryDatabaseJson!) as List<dynamic>;
    return list.map((e) => ProductItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> writeDatabase(List<ProductItem> items) async {
    const encoder = JsonEncoder.withIndent('  ');
    _inMemoryDatabaseJson = encoder.convert(items.map((e) => e.toJson()).toList());
  }

  @override
  Future<String> getRawDatabase() async => _inMemoryDatabaseJson ?? '[]';

  @override
  Future<List<ProductItem>> resetDatabase() async {
    _inMemoryDatabaseJson = null;
    return readDatabase();
  }
}
