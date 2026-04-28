import 'package:flutter/material.dart';
import 'signup.dart';
import '../main_navigator.dart';
import '../../controller/user_controller.dart';
import '../welcome/role_selection_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // 1. Controllers moved INSIDE so they clear automatically when leaving the screen!
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 2. State variable for the eye icon
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Clean up controllers when screen is closed to free up memory
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. FULL-SCREEN BACKGROUND IMAGE
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'lib/assets/images/LandingScreenBackground.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),

          // 2. WHITE OVERLAY FADE
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

          // 3. FOREGROUND CONTENT
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
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Nunito',
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sign in to your account.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(height: 24),

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
                            obscureText: !_isPasswordVisible, // 3. Toggles based on the boolean!
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFAAAAAA)),
                              // 4. Interactive Eye Icon
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: const Color(0xFFAAAAAA),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible; // Flips the switch!
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

                          // SIGN IN BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  await UserController().signIn(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );

                                  if (context.mounted) {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RoleSelectionScreen(isSignUpFlow: false)));
                                  }
                                } catch (e) {
                                  debugPrint("Error in Sign In: $e");
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Sign in failed: $e')),
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
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SIGN UP TEXT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const RoleSelectionScreen(isSignUpFlow: true)),
                            );
                          },
                          child: const Text(
                            "Sign Up",
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

          // BACK BUTTON (Top Left)
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