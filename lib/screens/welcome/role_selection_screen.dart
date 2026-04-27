import 'package:flutter/material.dart';
import '../auth/signup.dart';
import '../main_navigator.dart';
import '../../controller/user_controller.dart';
import '../../models/user_model.dart';
import '../landlord/landlord_navigator.dart';

class RoleSelectionScreen extends StatelessWidget {
  final bool isSignUpFlow;

  const RoleSelectionScreen({super.key, this.isSignUpFlow = false});

  // --- THE NEW DATABASE CHECKER ---
  Future<void> _verifyAndNavigate(BuildContext context, String selectedRole) async {
    if (isSignUpFlow) {
      // MODE 1: Sign Up -> Go to Registration Form
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen(role: selectedRole)),
      );
    } else {
      // MODE 2: Sign In -> Check Database for Permissions
      try {
        // Show a quick loading circle while we talk to Firebase
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF4A8BFE))),
        );

        // Fetch their actual data from the database
        UserModel? user = await UserController.instance.getCurrentUserData();

        if (!context.mounted) return;
        Navigator.pop(context); // Close loading circle

        // THE FIX: Check the roles ignoring uppercase/lowercase differences!
        bool hasRole = user != null && user.roles.any((r) => r.toLowerCase() == selectedRole.toLowerCase());

        if (hasRole) {
          // AUTHORIZED! Send them to the correct dashboard
          if (selectedRole.toLowerCase() == 'dormer') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigator()));
          } else if (selectedRole.toLowerCase() == 'landlord') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LandlordNavigator())
            );
          }
        } else {
          // REJECTED! Pop-out error
          _showErrorDialog(context, selectedRole);
        }
      } catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error verifying role: $e")));
      }
    }
  }

  void _showErrorDialog(BuildContext context, String role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Access Denied", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        content: Text("Your account does not have $role privileges. Please log in with a registered $role account."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Okay", style: TextStyle(color: Color(0xFF4A8BFE))),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'lib/assets/images/LandingScreenBackground.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
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
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/images/DormBNBLogoDark.png',
                      height: 80,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.location_on, size: 80),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Nunito',
                        ),
                        children: [
                          TextSpan(text: 'Dorm', style: TextStyle(color: Color(0xFF1A1A1A))),
                          TextSpan(text: 'BNB', style: TextStyle(color: Color(0xFF4A8BFE))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Welcome to DormBNB',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Nunito',
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isSignUpFlow ? 'Who are you? Pick a role to register.' : 'Where would you like to go?',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          RoleCard(
                            title: 'Dormer',
                            description: 'Find & book verified dorms near you.',
                            icon: Icons.person_outline,
                            iconBackgroundColor: const Color(0xFF4A8BFE),
                            onTap: () => _verifyAndNavigate(context, 'Dormer'),
                          ),
                          const SizedBox(height: 12),
                          RoleCard(
                            title: 'Dorm Owner',
                            description: 'List your property and manage tenants.',
                            icon: Icons.home_outlined,
                            iconBackgroundColor: const Color(0xFFFF6B6B),
                            onTap: () => _verifyAndNavigate(context, 'Landlord'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Back button to abort
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

class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconBackgroundColor;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBackgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: iconBackgroundColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconBackgroundColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Nunito',
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}