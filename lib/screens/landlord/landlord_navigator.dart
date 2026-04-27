import 'package:flutter/material.dart';
import 'listing_screen.dart';
import 'billing_tab.dart';
import 'landlord_messages_tab.dart';
import 'landlord_profile_tab.dart';

class LandlordNavigator extends StatefulWidget {
  const LandlordNavigator({super.key});

  @override
  State<LandlordNavigator> createState() => _LandlordNavigatorState();
}

class _LandlordNavigatorState extends State<LandlordNavigator> {
  int _currentIndex = 0;

  // The 4 screens that the bottom bar will switch between
  final List<Widget> _screens = [
    const ListingScreen(),
    const BillingTab(),
    const LandlordMessagesTab(),
    const LandlordProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Shows the active tab
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: const Color(0xFF4A8BFE),
          unselectedItemColor: const Color(0xFFBDBDBD),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Changes the tab!
            });
          },
          items: [
            _buildNavItem(Icons.description_outlined, 0),
            _buildNavItem(Icons.attach_money, 1),
            _buildNavItem(Icons.mail_outline, 2),
            _buildNavItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  // Helper to draw the blue circle behind the active icon perfectly
  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: _currentIndex == index
          ? CircleAvatar(backgroundColor: const Color(0xFF4A8BFE), radius: 16, child: Icon(icon, color: Colors.white, size: 20))
          : Icon(icon, size: 28),
      label: "",
    );
  }
}