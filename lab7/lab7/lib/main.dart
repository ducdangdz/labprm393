import 'package:flutter/material.dart';

void main() {
  runApp(const SignupApp());
}

// =====================
// APP
// =====================

class SignupApp extends StatelessWidget {
  const SignupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Signup Form',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}

// =====================
// SIGNUP SCREEN
// =====================

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState
    extends State<SignupScreen> {
  // Form Key
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmController =
      TextEditingController();

  // Focus Nodes
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmFocus = FocusNode();

  // State
  bool isCheckingEmail = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();

    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmFocus.dispose();

    super.dispose();
  }

  // =====================
  // VALIDATE NAME
  // =====================

  String? validateName(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Name is required';
    }

    return null;
  }

  // =====================
  // VALIDATE EMAIL
  // =====================

  String? validateEmail(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!value.contains('@') ||
        !value.contains('.')) {
      return 'Enter a valid email';
    }

    return null;
  }

  // =====================
  // VALIDATE PASSWORD
  // =====================

  String? validatePassword(String? value) {
    if (value == null ||
        value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must have at least 8 characters';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }

    return null;
  }

  // =====================
  // VALIDATE CONFIRM
  // =====================

  String? validateConfirmPassword(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // =====================
  // SUBMIT
  // =====================

  Future<void> submit() async {
    FocusScope.of(context).unfocus();

    final isValid =
        formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      isCheckingEmail = true;
    });

    // Giả lập API check email
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    final email =
        emailController.text.trim();

    // Email bắt đầu bằng "taken"
    // được xem là đã tồn tại
    if (email.toLowerCase().startsWith('taken')) {
      setState(() {
        isCheckingEmail = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'This email is already taken',
          ),
        ),
      );

      return;
    }

    setState(() {
      isCheckingEmail = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Signup successful!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Signup'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Form(
            key: formKey,
            autovalidateMode:
                AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Icon(
                  Icons.person_add,
                  size: 80,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Please enter your information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                // =====================
                // FULL NAME
                // =====================

                TextFormField(
                  controller: nameController,
                  focusNode: nameFocus,
                  textInputAction:
                      TextInputAction.next,
                  onFieldSubmitted: (_) {
                    emailFocus.requestFocus();
                  },
                  validator: validateName,
                  decoration:
                      const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon:
                        Icon(Icons.person),
                    border:
                        OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                // =====================
                // EMAIL
                // =====================

                TextFormField(
                  controller: emailController,
                  focusNode: emailFocus,
                  keyboardType:
                      TextInputType.emailAddress,
                  textInputAction:
                      TextInputAction.next,
                  onFieldSubmitted: (_) {
                    passwordFocus.requestFocus();
                  },
                  validator: validateEmail,
                  decoration:
                      const InputDecoration(
                    labelText: 'Email',
                    hintText:
                        'example@gmail.com',
                    prefixIcon:
                        Icon(Icons.email),
                    border:
                        OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                // =====================
                // PASSWORD
                // =====================

                TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocus,
                  obscureText: hidePassword,
                  textInputAction:
                      TextInputAction.next,
                  onFieldSubmitted: (_) {
                    confirmFocus.requestFocus();
                  },
                  validator: validatePassword,
                  decoration:
                      InputDecoration(
                    labelText: 'Password',
                    hintText:
                        'Minimum 8 characters + 1 digit',
                    prefixIcon:
                        const Icon(Icons.lock),
                    border:
                        const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword =
                              !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =====================
                // CONFIRM PASSWORD
                // =====================

                TextFormField(
                  controller: confirmController,
                  focusNode: confirmFocus,
                  obscureText:
                      hideConfirmPassword,
                  textInputAction:
                      TextInputAction.done,
                  onFieldSubmitted: (_) {
                    submit();
                  },
                  validator:
                      validateConfirmPassword,
                  decoration:
                      InputDecoration(
                    labelText:
                        'Confirm Password',
                    hintText:
                        'Enter password again',
                    prefixIcon:
                        const Icon(Icons.lock),
                    border:
                        const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hideConfirmPassword =
                              !hideConfirmPassword;
                        });
                      },
                      icon: Icon(
                        hideConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // =====================
                // SUBMIT BUTTON
                // =====================

                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed:
                        isCheckingEmail
                            ? null
                            : submit,
                    child: isCheckingEmail
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Password requirements:\n'
                  '• At least 8 characters\n'
                  '• At least 1 digit\n'
                  '• Confirm password must match',
                  style: TextStyle(
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}