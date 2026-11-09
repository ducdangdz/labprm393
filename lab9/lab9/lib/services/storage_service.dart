import '../models/note_item.dart';
import '../models/product_item.dart';
import 'storage_adapter.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final StorageAdapter _adapter = StorageAdapter();

  // ===========================================================================
  // LAB 9.2: NOTES FILE STORAGE METHODS
  // ===========================================================================

  Future<String> getNotesFilePath() => _adapter.getNotesPath();

  Future<List<NoteItem>> readNotes() => _adapter.readNotes();

  Future<void> writeNotes(List<NoteItem> notes) => _adapter.writeNotes(notes);

  Future<String> getRawNotesContent() => _adapter.getRawNotes();

  Future<void> clearNotesFile() => _adapter.clearNotes();

  // ===========================================================================
  // LAB 9.3: MINI DATABASE FILE STORAGE METHODS
  // ===========================================================================

  Future<String> getDatabaseFilePath() => _adapter.getDatabasePath();

  Future<List<ProductItem>> readDatabase() => _adapter.readDatabase();

  Future<void> writeDatabase(List<ProductItem> items) => _adapter.writeDatabase(items);

  Future<String> getRawDatabaseContent() => _adapter.getRawDatabase();

  Future<List<ProductItem>> resetDatabaseToDefaults() => _adapter.resetDatabase();
}
