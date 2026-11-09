import 'package:flutter/material.dart';
import '../models/note_item.dart';
import '../services/storage_service.dart';

// =============================================================================
// LAB 9.2 – SAVE & LOAD JSON FROM DEVICE STORAGE
// =============================================================================

class Lab92Screen extends StatefulWidget {
  const Lab92Screen({super.key});

  @override
  State<Lab92Screen> createState() => _Lab92ScreenState();
}

class _Lab92ScreenState extends State<Lab92Screen> {
  final StorageService _storageService = StorageService();

  List<NoteItem> _notes = [];
  bool _isLoading = true;
  String _filePath = '';
  bool _hasUnsavedChanges = false;

  // Controllers for adding items
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = 'Study';

  final List<String> _categories = ['Study', 'Work', 'Personal', 'Important'];

  @override
  void initState() {
    super.initState();
    _initStorageAndLoad();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Locate application documents directory and load JSON file
  Future<void> _initStorageAndLoad() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _filePath = await _storageService.getNotesFilePath();

      final loadedNotes = await _storageService.readNotes();
      setState(() {
        _notes = loadedNotes;
        _isLoading = false;
        _hasUnsavedChanges = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error loading local notes: $e', isError: true);
    }
  }

  /// Add new item to the in-memory list
  void _addNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      _showSnackBar('Please enter a note title', isError: true);
      return;
    }

    final newNote = NoteItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content.isEmpty ? 'No description' : content,
      category: _selectedCategory,
      createdAt: _formatTimestamp(DateTime.now()),
    );

    setState(() {
      _notes.insert(0, newNote);
      _hasUnsavedChanges = true;
    });

    _titleController.clear();
    _contentController.clear();
    FocusScope.of(context).unfocus();

    _showSnackBar('Note added to list! Tap "Save to File" to persist.');
  }

  /// Save updates back to the local JSON file
  Future<void> _saveNotesToFile() async {
    try {
      await _storageService.writeNotes(_notes);
      setState(() {
        _hasUnsavedChanges = false;
      });
      _showSnackBar('Saved ${_notes.length} notes to local JSON file successfully!');
    } catch (e) {
      _showSnackBar('Failed to save to storage: $e', isError: true);
    }
  }

  /// Delete note from list
  void _deleteNote(int index) {
    final deleted = _notes[index];
    setState(() {
      _notes.removeAt(index);
      _hasUnsavedChanges = true;
    });

    _showSnackBar(
      'Removed "${deleted.title}" (Unsaved changes)',
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _notes.insert(index, deleted);
          });
        },
      ),
    );
  }

  /// Confirm and clear all notes
  Future<void> _confirmClearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Notes?'),
        content: const Text(
          'This will remove all notes and delete the local JSON file. Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.clearNotesFile();
      setState(() {
        _notes.clear();
        _hasUnsavedChanges = false;
      });
      _showSnackBar('Local notes JSON file cleared.');
    }
  }

  /// View raw JSON file from device storage
  Future<void> _viewRawStorageFile() async {
    try {
      final content = await _storageService.getRawNotesContent();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.insert_drive_file, color: Colors.teal),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Local JSON File Content',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Path: $_filePath',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      content,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.lightGreenAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      _showSnackBar('Cannot read file: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false, SnackBarAction? action}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.teal.shade800,
        action: action,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2: Local Storage JSON'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'View Raw JSON File',
            onPressed: _viewRawStorageFile,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload from Disk',
            onPressed: _initStorageAndLoad,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear Storage',
            onPressed: _confirmClearAll,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _initStorageAndLoad,
        child: Column(
          children: [
            // Storage file path banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.teal.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.save, color: Colors.teal, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Device Storage Path:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const Spacer(),
                      if (_hasUnsavedChanges)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: const Text(
                            'Unsaved Changes',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _filePath.isEmpty ? 'Loading...' : _filePath,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Form: Add new item
            Card(
              margin: const EdgeInsets.all(12),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Note Title *',
                        prefixIcon: Icon(Icons.title),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Note Description',
                        prefixIcon: Icon(Icons.notes),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Category chips
                    Row(
                      children: [
                        const Text(
                          'Category: ',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _categories.map((cat) {
                                final isSelected = _selectedCategory == cat;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: ChoiceChip(
                                    label: Text(cat, style: const TextStyle(fontSize: 11)),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() => _selectedCategory = cat);
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Action buttons: Add to List & Save to File
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _addNote,
                            icon: const Icon(Icons.add),
                            label: const Text('Add to List'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _hasUnsavedChanges
                                  ? Colors.teal
                                  : Colors.teal.shade700,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _saveNotesToFile,
                            icon: const Icon(Icons.save),
                            label: const Text('Save to File'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Notes List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Text(
                    'Stored Notes (${_notes.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: _initStorageAndLoad,
                    icon: const Icon(Icons.sync, size: 16),
                    label: const Text('Reload from Disk', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),

            // List of Stored Notes
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _notes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.note_alt_outlined, size: 48, color: Colors.grey.shade400),
                              const SizedBox(height: 8),
                              const Text(
                                'No notes in local storage.\nAdd one above and click "Save to File"!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            return Card(
                              elevation: 1,
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.teal.shade100,
                                  child: const Icon(Icons.sticky_note_2, color: Colors.teal),
                                ),
                                // Field 1: Title & Category
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        note.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.teal.shade200),
                                      ),
                                      child: Text(
                                        note.category,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.teal.shade900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Field 2: Content & Date
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note.content,
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: Colors.grey.shade500,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            note.createdAt,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  tooltip: 'Delete',
                                  onPressed: () => _deleteNote(index),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
