import 'package:flutter/material.dart';
import 'signin.dart';
import '../main_navigator.dart';
import '../../controller/user_controller.dart';
import '../welcome/role_selection_screen.dart';

class SignUpScreen extends StatefulWidget {
  final String role;
  const SignUpScreen({super.key, required this.role});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // 1. Controllers moved INSIDE State
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // 2. Separate visibility toggles for each password field
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // FULL-SCREEN BACKGROUND IMAGE
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'lib/assets/images/LandingScreenBackground.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),

          // WHITE OVERLAY FADE
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                  Colors.white.withValues(alpha: 0.85),
                  Colors.white.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.45, 0.6, 1.0],
              ),
            ),
          ),

          // FOREGROUND CONTENT
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO & BRANDING
                    Image.asset(
                      'lib/assets/images/DormBNBLogoDark.png',
                      height: 60,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.location_on, size: 60),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Nunito',
                        ),
                        children: [
                          TextSpan(text: 'Dorm', style: TextStyle(color: Color(0xFF1A1A1A))),
                          TextSpan(text: 'BNB', style: TextStyle(color: Color(0xFF4A8BFE))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // GREY AUTH BOX
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Nunito',
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sign up an account.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // FULL NAME FIELD
                          TextField(
                            controller: fullNameController,
                            decoration: InputDecoration(
                              hintText: 'Full Name',
                              hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                              prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFAAAAAA)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // EMAIL FIELD
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                              prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFAAAAAA)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // PASSWORD FIELD
                          TextField(
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFAAAAAA)),
                              // Eye Toggle 1
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: const Color(0xFFAAAAAA),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // CONFIRM PASSWORD FIELD
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: !_isConfirmPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFAAAAAA)),
                              // Eye Toggle 2
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: const Color(0xFFAAAAAA),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // SIGN UP BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (passwordController.text != confirmPasswordController.text) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Passwords do not match!')),
                                    );
                                  }
                                  return;
                                }

                                try {
                                  List<String> nameParts = fullNameController.text.trim().split(' ');
                                  String firstName = nameParts.isNotEmpty ? nameParts.first : '';
                                  String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

                                  // Access the 'role' variable properly inside a StatefulWidget using widget.role!
                                  await UserController().signUp(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    firstName: firstName,
                                    lastName: lastName,
                                    number: "0000000000",
                                    role: widget.role,
                                  );

                                  if (context.mounted) {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                                  }
                                } catch (e) {
                                  debugPrint("Error in Sign Up: $e");
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Sign up failed: $e')),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A8BFE),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SIGN IN TEXT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const SignInScreen()),
                            );
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4A8BFE),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}