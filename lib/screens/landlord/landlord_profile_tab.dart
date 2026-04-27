import 'package:flutter/material.dart';
import '../../controller/user_controller.dart';
import '../auth/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandlordProfileTab extends StatelessWidget {
  const LandlordProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LandingScreen()));
            }
          },
          child: const Text("Log Out"),
        ),
      ),
    );
  }
}