
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ==========================================
// LAB 8.2 - MODEL CLASS
// ==========================================

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}

// ==========================================
// LAB 8.1 + 8.4 - API SERVICE
// ==========================================

class ApiService {
  final http.Client client;

  ApiService({http.Client? client})
      : client = client ?? http.Client();

  final String baseUrl =
      'https://jsonplaceholder.typicode.com';

  // GET REQUEST
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await client
          .get(Uri.parse('$baseUrl/posts'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        // Print raw JSON for Lab 8.1
        debugPrint(response.body);

        final List<dynamic> jsonData =
            json.decode(response.body);

        return jsonData.map((item) {
          return Post.fromJson(
            item as Map<String, dynamic>,
          );
        }).toList();
      } else {
        throw Exception(
          'Failed to load posts: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }

  // BONUS - POST REQUEST
  Future<Post> createPost(
    String title,
    String body,
  ) async {
    final response = await client
        .post(
          Uri.parse('$baseUrl/posts'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'userId': 1,
            'title': title,
            'body': body,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 201) {
      return Post.fromJson(
        json.decode(response.body)
            as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to create post');
    }
  }

  void dispose() {
    client.close();
  }
}

// ==========================================
// MAIN APPLICATION
// ==========================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 8 - REST API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const PostScreen(),
    );
  }
}

// ==========================================
// LAB 8.2 + 8.3 - POST SCREEN
// ==========================================

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ApiService apiService = ApiService();

  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  void loadPosts() {
    futurePosts = apiService.fetchPosts();
  }

  void refreshPosts() {
    setState(() {
      loadPosts();
    });
  }

  @override
  void dispose() {
    apiService.dispose();
    super.dispose();
  }

  // ========================================
  // BONUS - CREATE NEW POST
  // ========================================

  Future<void> showAddPostDialog() async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    bool isSubmitting = false;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Create New Post'),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: bodyController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Body',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                        },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final title =
                              titleController.text.trim();

                          final body =
                              bodyController.text.trim();

                          if (title.isEmpty || body.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter title and body',
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(() {
                            isSubmitting = true;
                          });

                          try {
                            final newPost =
                                await apiService.createPost(
                              title,
                              body,
                            );

                            if (!mounted ||
                                !dialogContext.mounted) {
                              return;
                            }

                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  'POST successful! ID: ${newPost.id}',
                                ),
                              ),
                            );
                          } catch (e) {
                            if (!mounted ||
                                !dialogContext.mounted) {
                              return;
                            }

                            setDialogState(() {
                              isSubmitting = false;
                            });

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                              ),
                            );
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    bodyController.dispose();
  }

  // ========================================
  // MAIN UI
  // ========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Lab 8 - API Posts'),

        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: refreshPosts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddPostDialog,
        tooltip: 'Create Post',
        child: const Icon(Icons.add),
      ),

      // FUTURE BUILDER
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {

          // LAB 8.3 - LOADING STATE
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),

                  SizedBox(height: 20),

                  Text(
                    'Loading posts...',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          // LAB 8.3 - ERROR STATE
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 70,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Something went wrong!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: refreshPosts,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // EMPTY STATE
          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No posts available'),
            );
          }

          // LAB 8.2 - DISPLAY LIST
          final List<Post> posts = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              refreshPosts();

              try {
                await futurePosts;
              } catch (_) {
                // Error is displayed by FutureBuilder.
              }
            },

            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: posts.length,

              itemBuilder: (context, index) {
                final post = posts[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 10),

                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      child: Text('${post.id}'),
                    ),

                    title: Text(
                      post.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),

                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(post.title),

                            content: Text(
                              'Post ID: ${post.id}\n\n'
                              'User ID: ${post.userId}\n\n'
                              '${post.body}',
                            ),

                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
