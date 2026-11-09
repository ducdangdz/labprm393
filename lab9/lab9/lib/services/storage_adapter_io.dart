import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'storage_adapter.dart';
import 'default_data.dart';
import '../models/note_item.dart';
import '../models/product_item.dart';

StorageAdapter getStorageAdapter() => IoStorageAdapter();

class IoStorageAdapter implements StorageAdapter {
  static const String notesFileName = 'lab9_2_notes.json';
  static const String databaseFileName = 'lab9_3_database.json';

  Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  @override
  Future<String> getNotesPath() async {
    final path = await _localPath;
    return '$path/$notesFileName';
  }

  @override
  Future<List<NoteItem>> readNotes() async {
    try {
      final filePath = await getNotesPath();
      final file = File(filePath);
      if (!await file.exists()) {
        final defaults = defaultNotes();
        await writeNotes(defaults);
        return defaults;
      }
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final List<dynamic> list = jsonDecode(content) as List<dynamic>;
      return list.map((e) => NoteItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error reading notes: $e');
      return [];
    }
  }

  @override
  Future<void> writeNotes(List<NoteItem> notes) async {
    final filePath = await getNotesPath();
    final file = File(filePath);
    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(notes.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString, flush: true);
  }

  @override
  Future<String> getRawNotes() async {
    final filePath = await getNotesPath();
    final file = File(filePath);
    if (await file.exists()) {
      return file.readAsString();
    }
    return '(File does not exist yet)';
  }

  @override
  Future<void> clearNotes() async {
    final filePath = await getNotesPath();
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<String> getDatabasePath() async {
    final path = await _localPath;
    return '$path/$databaseFileName';
  }

  @override
  Future<List<ProductItem>> readDatabase() async {
    try {
      final filePath = await getDatabasePath();
      final file = File(filePath);
      if (!await file.exists()) {
        final defaults = defaultProducts();
        await writeDatabase(defaults);
        return defaults;
      }
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final List<dynamic> list = jsonDecode(content) as List<dynamic>;
      return list.map((e) => ProductItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error reading database: $e');
      return [];
    }
  }

  @override
  Future<void> writeDatabase(List<ProductItem> items) async {
    final filePath = await getDatabasePath();
    final file = File(filePath);
    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(items.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString, flush: true);
  }

  @override
  Future<String> getRawDatabase() async {
    final filePath = await getDatabasePath();
    final file = File(filePath);
    if (await file.exists()) {
      return file.readAsString();
    }
    return '(File does not exist yet)';
  }

  @override
  Future<List<ProductItem>> resetDatabase() async {
    final filePath = await getDatabasePath();
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
    return readDatabase();
  }
}
