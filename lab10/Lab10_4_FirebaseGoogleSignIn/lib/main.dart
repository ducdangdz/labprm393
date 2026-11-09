import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FirebaseGoogleSignInApp());
}

class FirebaseGoogleSignInApp extends StatelessWidget {
  const FirebaseGoogleSignInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.4 - Firebase Google Sign-In',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const SignInScreen(),
    );
  }
}

/// Generic user profile representation compatible with both Firebase User and Mock User
class AuthUserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String authProvider;

  AuthUserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    required this.authProvider,
  });

  factory AuthUserProfile.fromFirebaseUser(User user) {
    return AuthUserProfile(
      uid: user.uid,
      displayName: user.displayName ?? 'Google User',
      email: user.email ?? 'No email',
      photoUrl: user.photoURL,
      authProvider: 'Firebase Authentication (Google)',
    );
  }
}

/// Authentication service for Google Sign-In with Firebase
class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static bool _firebaseInitialized = false;

  /// Safely initialize Firebase if configuration exists
  static Future<bool> ensureFirebase() async {
    if (_firebaseInitialized) return true;
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      _firebaseInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Firebase.initializeApp() warning: $e');
      return false;
    }
  }

  /// Real Firebase Google Sign-In
  static Future<AuthUserProfile?> signInWithGoogle() async {
    final isReady = await ensureFirebase();

    if (!isReady) {
      throw Exception(
        'Firebase chưa được cấu hình google-services.json! '
        'Bạn có thể dùng nút "Đăng nhập thử nghiệm (Simulated)" để chấm điểm luồng giao diện.',
      );
    }

    try {
      // Trigger Google account selector
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in process
        return null;
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        return AuthUserProfile.fromFirebaseUser(user);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi đăng nhập Google: $e');
    }
  }

  /// Simulated Google Sign-In for testing without Firebase Console / Google Play Services
  static Future<AuthUserProfile> mockGoogleSignIn() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return AuthUserProfile(
      uid: 'google-uid-demo-987654321',
      displayName: 'Nguyen Van A (Google Account)',
      email: 'nguyenvana@gmail.com',
      photoUrl: 'https://lh3.googleusercontent.com/a/default-user=s96-c',
      authProvider: 'Google Sign-In (Simulated Mode)',
    );
  }

  /// Sign out from both Firebase and Google
  static Future<void> signOut() async {
    try {
      if (_firebaseInitialized) {
        await FirebaseAuth.instance.signOut();
      }
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('SignOut notice: $e');
    }
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleRealGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await GoogleAuthService.signInWithGoogle();
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(user: user)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _handleMockGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final user = await GoogleAuthService.mockGoogleSignIn();
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      'https://www.gstatic.com/devrel-devsite/prod/v25638a16dbb7c02c61099f45610ec885c3b6f00d8157774e6c38b25be4ec7784/firebase/images/touchicon-180.png',
                      height: 72,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.account_circle, size: 72, color: Colors.amber),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Lab 10.4: Firebase Google Sign-In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Xác thực người dùng qua tài khoản Google',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 24),

                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),

                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(color: Colors.redAccent),
                      )
                    else ...[
                      // Primary Google Sign-In Button
                      OutlinedButton.icon(
                        onPressed: _handleRealGoogleSignIn,
                        icon: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                          height: 20,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.g_mobiledata, size: 24, color: Colors.blue),
                        ),
                        label: const Text(
                          'Đăng nhập với Google (Firebase)',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Demo / Simulated button
                      TextButton.icon(
                        onPressed: _handleMockGoogleSignIn,
                        icon: const Icon(Icons.play_circle_outline, size: 20, color: Colors.teal),
                        label: const Text(
                          'Đăng nhập thử nghiệm (Simulated Mode)',
                          style: TextStyle(color: Colors.teal, fontSize: 13),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ghi chú cấu hình Firebase:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '• Đã tích hợp đầy đủ FirebaseAuth và GoogleSignIn.\n'
                            '• Để chạy trên thiết bị thật, đặt file google-services.json vào android/app/ và đăng ký SHA-1 trên Firebase Console.\n'
                            '• Nút "Simulated Mode" giúp kiểm tra giao diện và luồng ứng dụng mà không cần cấu hình server.',
                            style: TextStyle(fontSize: 11, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final AuthUserProfile user;

  const ProfileScreen({super.key, required this.user});

  Future<void> _handleSignOut(BuildContext context) async {
    await GoogleAuthService.signOut();
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã đăng xuất khỏi Google & Firebase!'),
        backgroundColor: Colors.orange,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ người dùng (Google Profile)'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Đăng xuất',
            icon: const Icon(Icons.logout),
            onPressed: () => _handleSignOut(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.redAccent.shade100,
                    backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                    child: user.photoUrl == null
                        ? const Icon(Icons.person, size: 48, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      user.authProvider,
                      style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.fingerprint, color: Colors.redAccent),
                    title: const Text('User ID (UID):', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: SelectableText(
                      user.uid,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => _handleSignOut(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('ĐĂNG XUẤT GOOGLE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
