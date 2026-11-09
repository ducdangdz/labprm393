import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/student_model.dart';

// =============================================================================
// LAB 9.1 – READ JSON FROM ASSETS (LOCAL EMBEDDED FILE)
// =============================================================================

class Lab91Screen extends StatefulWidget {
  const Lab91Screen({super.key});

  @override
  State<Lab91Screen> createState() => _Lab91ScreenState();
}

class _Lab91ScreenState extends State<Lab91Screen> {
  static const String assetPath = 'assets/data/students.json';

  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _rawJson = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJsonFromAssets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Step 3 & 4: Load and decode JSON from assets using rootBundle.loadString
  Future<void> _loadJsonFromAssets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Step 3: Use rootBundle.loadString() to load local asset file
      final String jsonString = await rootBundle.loadString(assetPath);
      _rawJson = jsonString;

      // Step 4: Decode JSON string into Dart List using dart:convert jsonDecode
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is List) {
        final List<Student> loadedList = decoded
            .map((item) => Student.fromJson(item as Map<String, dynamic>))
            .toList();

        setState(() {
          _allStudents = loadedList;
          _filteredStudents = loadedList;
          _isLoading = false;
        });
      } else {
        throw const FormatException('Expected JSON array at root');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load JSON from asset: $e';
        _isLoading = false;
      });
    }
  }

  void _filterStudents(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredStudents = _allStudents;
      } else {
        _filteredStudents = _allStudents.where((s) {
          return s.name.toLowerCase().contains(q) ||
              s.email.toLowerCase().contains(q) ||
              s.major.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  void _showRawJsonDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.code, color: Colors.indigo),
            SizedBox(width: 8),
            Text('Raw JSON (Asset)'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _rawJson,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.greenAccent,
                ),
              ),
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
  }

  void _showStudentDetail(Student student) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.indigo.shade100,
                  child: Text(
                    student.name.isNotEmpty ? student.name[0] : 'S',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade800,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Student ID: #${student.id}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildDetailRow(Icons.email_outlined, 'Email', student.email),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.school_outlined, 'Major', student.major),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.phone_outlined, 'Phone', student.phone),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.star_outline,
              'GPA',
              '${student.gpa.toStringAsFixed(2)} / 4.00',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.indigo),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.grey.shade800),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.1: Read Asset JSON'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'View Raw JSON',
            onPressed: _showRawJsonDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: _loadJsonFromAssets,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadJsonFromAssets,
        child: Column(
          children: [
            // Header Info Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.indigo.shade50,
              child: Row(
                children: [
                  const Icon(Icons.folder_zip, color: Colors.indigo, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Source: $assetPath (${_allStudents.length} items)',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.indigo.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search filter field
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: _filterStudents,
                decoration: InputDecoration(
                  hintText: 'Filter by name, email, or major...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterStudents('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Main Content: ListView of students
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                                const SizedBox(height: 12),
                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: _loadJsonFromAssets,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Try Again'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _filteredStudents.isEmpty
                          ? const Center(
                              child: Text(
                                'No matching students found',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: _filteredStudents.length,
                              itemBuilder: (context, index) {
                                final student = _filteredStudents[index];
                                final isHighGpa = student.gpa >= 3.6;

                                return Card(
                                  elevation: 1,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    onTap: () => _showStudentDetail(student),
                                    leading: CircleAvatar(
                                      backgroundColor: isHighGpa
                                          ? Colors.green.shade100
                                          : Colors.blue.shade100,
                                      child: Text(
                                        student.name.isNotEmpty ? student.name[0] : 'S',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isHighGpa
                                              ? Colors.green.shade900
                                              : Colors.blue.shade900,
                                        ),
                                      ),
                                    ),
                                    // Field 1: Name
                                    title: Text(
                                      student.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    // Field 2: Email & Major
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student.email,
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Major: ${student.major}',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isHighGpa
                                            ? Colors.green.shade50
                                            : Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isHighGpa
                                              ? Colors.green.shade300
                                              : Colors.blue.shade300,
                                        ),
                                      ),
                                      child: Text(
                                        'GPA ${student.gpa.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isHighGpa
                                              ? Colors.green.shade800
                                              : Colors.blue.shade800,
                                        ),
                                      ),
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
