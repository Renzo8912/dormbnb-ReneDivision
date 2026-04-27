import 'dart:ui';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light background to match the design
      body: Stack(
        children: [
          // 1. TOP BLURRY BACKGROUND
          SizedBox(
            height: 160,
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
              color: Colors.white.withValues(alpha: 0.8),
              height: 160,
            ),
          ),

          // 2. FOREGROUND CONTENT
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // APP BAR / BACK BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF4A8BFE), size: 20),
                    label: const Text('Back', style: TextStyle(color: Color(0xFF4A8BFE), fontSize: 16)),
                  ),
                ),

                // TITLE
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Nunito',
                        color: Color(0xFF1A1A1A)
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // NOTIFICATION LIST
                Expanded(
                  child: Container(
                    color: Colors.white, // White background for the list area
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildNotificationItem(
                          icon: Icons.check,
                          bgColor: const Color(0xFF22C55E), // Green
                          title: 'Booking Confirmed!',
                          message: 'Your booking at Marigold Blue Dormitory (DBNB-2026-04B21) has been approved by the landlord.',
                          time: '2 hours ago',
                          isUnread: true,
                        ),
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        _buildNotificationItem(
                          icon: Icons.chat_bubble_outline,
                          bgColor: const Color(0xFF8B5CF6), // Purple/Blue
                          title: 'New Message',
                          message: 'Nikki Marigold: "Okay po, pwede po kayong lumipat sa April 28."',
                          time: '2 hours ago',
                          isUnread: true,
                        ),
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
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

  // HELPER WIDGET FOR NOTIFICATION ROWS
  Widget _buildNotificationItem({
    required IconData icon,
    required Color bgColor,
    required String title,
    required String message,
    required String time,
    bool isUnread = false,
  }) {
    return Container(
      // Gives a very slight blue tint to unread messages
      color: isUnread ? const Color(0xFFF8FBFF) : Colors.white,
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON BOX
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),

          // TEXT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A1A1A))
                ),
                const SizedBox(height: 4),
                Text(
                    message,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF666666), height: 1.4)
                ),
                const SizedBox(height: 8),
                Text(
                    time,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF888888))
                ),
              ],
            ),
          ),

          // UNREAD DOT INDICATOR
          if (isUnread) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 4), // Align with the first line of text
              decoration: const BoxDecoration(
                color: Color(0xFF4A8BFE),
                shape: BoxShape.circle,
              ),
            )
          ]
        ],
      ),
    );
  }
}