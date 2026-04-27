import 'dart:ui';
import 'package:flutter/material.dart';
import 'add_listing_screen.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF), // Light greyish-blue background
      body: Stack(
        children: [
          // 1. TOP BLURRY BACKGROUND
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.asset(
              'lib/assets/images/LandingScreenBackground.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withValues(alpha: 0.7),
              height: 180,
            ),
          ),

          // 2. FOREGROUND CONTENT
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER AREA
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Nunito'),
                              children: [
                                TextSpan(text: 'Dorm', style: TextStyle(color: Color(0xFF1A1A1A))),
                                TextSpan(text: 'BNB', style: TextStyle(color: Color(0xFF4A8BFE))),
                              ],
                            ),
                          ),
                          const Text('Goodmorning, Juan!', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                        ],
                      ),
                      // ADD LISTING BUTTON
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E5E5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Color(0xFF1A1A1A)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddListingScreen()),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),

                // BODY CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'My Listings',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                        ),
                        const SizedBox(height: 16),

                        // PROPERTY CARD
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // PROPERTY IMAGE
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.asset(
                                  'lib/assets/images/DormAlpha.png', // Using the dorm image from earlier
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // PROPERTY DETAILS
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Marigold Blue Dormitory', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                                    const SizedBox(height: 4),
                                    const Text('Sitio Lorenzo, Brgy Ibabang Dupay, Lucena City', style: TextStyle(fontSize: 10, color: Color(0xFF888888))),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}