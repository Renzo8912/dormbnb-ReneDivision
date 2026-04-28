import 'package:flutter/material.dart';
import 'booking_tab.dart';

class BookingConfirmedScreen extends StatelessWidget {
  final String referenceNumber;

  const BookingConfirmedScreen({super.key, required this.referenceNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SUCCESS CHECKMARK CIRCLE
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF22C55E), width: 4),
                ),
                child: const Icon(Icons.check, size: 60, color: Color(0xFF22C55E)),
              ),
              const SizedBox(height: 32),

              // CONFIRMATION TEXTS
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Nunito',
                    color: Color(0xFF1A1A1A)
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your dorm reservation has been sent\nto the landlord.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF666666), height: 1.5),
              ),
              const SizedBox(height: 32),

              // BOOKING REFERENCE BOX
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FBFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text('Booking Reference', style: TextStyle(fontSize: 10, color: Color(0xFF888888))),
                    const SizedBox(height: 8),
                    Text(
                      referenceNumber,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A8BFE)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // VIEW MY BOOKING BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A8BFE),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('View My Booking', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 16),

              // BACK TO HOME BUTTON
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // This instantly destroys all open screens and drops the user right back onto the root MainNavigator!
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF4A8BFE)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Back to Home', style: TextStyle(color: Color(0xFF4A8BFE), fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}