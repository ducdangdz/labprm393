import '../models/note_item.dart';
import '../models/product_item.dart';
import 'storage_adapter_stub.dart'
    if (dart.library.io) 'storage_adapter_io.dart'
    if (dart.library.html) 'storage_adapter_web.dart';

abstract class StorageAdapter {
  factory StorageAdapter() => getStorageAdapter();

  Future<String> getNotesPath();
  Future<List<NoteItem>> readNotes();
  Future<void> writeNotes(List<NoteItem> notes);
  Future<String> getRawNotes();
  Future<void> clearNotes();

  Future<String> getDatabasePath();
  Future<List<ProductItem>> readDatabase();
  Future<void> writeDatabase(List<ProductItem> items);
  Future<String> getRawDatabase();
  Future<List<ProductItem>> resetDatabase();
}
