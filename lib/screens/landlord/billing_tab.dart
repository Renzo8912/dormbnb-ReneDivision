import 'dart:ui';
import 'package:flutter/material.dart';

class BillingTab extends StatelessWidget {
  const BillingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: Stack(
        children: [
          // HEADER BACKGROUND
          SizedBox(
            height: 140,
            width: double.infinity,
            child: Image.asset('lib/assets/images/LandingScreenBackground.png', fit: BoxFit.cover, alignment: Alignment.bottomCenter),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withValues(alpha: 0.7), height: 140),
          ),

          // CONTENT
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Text('Billing & Payments', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Nunito', color: Color(0xFF1A1A1A))),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // REVENUE CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF4A8BFE), Color(0xFF3366FF)]),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: const Color(0xFF4A8BFE).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Total Revenue', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  const Text('₱ 63,500', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 4),
                                  Text('As of: April 28, 2026', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10)),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                                    child: const Text('Transaction History', style: TextStyle(color: Colors.white, fontSize: 10)),
                                  )
                                ],
                              ),
                              const Icon(Icons.maps_home_work_outlined, color: Colors.white, size: 48),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // PAYOUT ACCOUNT CARD
                        _buildSectionCard(
                          title: 'Payout Account',
                          child: Column(
                            children: [
                              _buildPayoutRow(Icons.phone_android, 'GCash', '0912 XXX 6789 · Nikki Marigold'),
                              const Divider(color: Color(0xFFE0E0E0), height: 24),
                              _buildPayoutRow(Icons.credit_card, 'BDO Savings Account', 'XXXX-XXXX-1234 · Nikki Marigold'),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF4A8BFE)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    minimumSize: const Size(double.infinity, 40)
                                ),
                                child: const Text('+ Add Payout Account', style: TextStyle(color: Color(0xFF4A8BFE), fontSize: 12)),
                              )
                            ],
                          ),
                        ),

                        // RECENT PAYMENTS CARD
                        _buildSectionCard(
                          title: 'Recent Payments Received',
                          child: Column(
                            children: [
                              _buildTransactionRow('Juan Dela Cruz', 'Single Room', '₱ 3,500', 'April 27, 2026', true),
                              const Divider(color: Color(0xFFE0E0E0), height: 24),
                              _buildTransactionRow('Lena Cruz', 'Single Room', '₱ 3,500', 'April 27, 2026', true),
                              const Divider(color: Color(0xFFE0E0E0), height: 24),
                              _buildTransactionRow('Joy Dela Rosa', 'Double Room', '₱ 6,000', 'April 27, 2026', true),
                            ],
                          ),
                        ),

                        // PENDING / OVERDUE CARD
                        _buildSectionCard(
                          title: 'Pending / Overdue',
                          child: Column(
                            children: [
                              _buildTransactionRow('Juan Dela Cruz', 'Single Room', '₱ 3,500', 'Due April 29, 2026', false, isOverdue: false),
                              const Divider(color: Color(0xFFE0E0E0), height: 24),
                              _buildTransactionRow('Lena Cruz', 'Single Room', '₱ 3,500', '5 Days Late', false, isOverdue: true),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF4A8BFE)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    minimumSize: const Size(double.infinity, 40)
                                ),
                                child: const Text('Send Payment Reminders', style: TextStyle(color: Color(0xFF4A8BFE), fontSize: 12)),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
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

  // HELPER WIDGETS
  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildPayoutRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1A1A1A), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
              Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF888888))),
            ],
          ),
        ),
        const Text('Edit', style: TextStyle(fontSize: 12, color: Color(0xFF4A8BFE))),
      ],
    );
  }

  Widget _buildTransactionRow(String name, String room, String amount, String dateOrStatus, bool isReceived, {bool isOverdue = false}) {
    Color badgeColor = isReceived ? const Color(0xFF22C55E) : (isOverdue ? const Color(0xFFFF6B6B) : const Color(0xFFFCD34D));
    Color badgeTextColor = isOverdue ? Colors.white : const Color(0xFF1A1A1A);
    Color amountColor = isReceived ? const Color(0xFF22C55E) : const Color(0xFF1A1A1A);

    return Row(
      children: [
        const Icon(Icons.account_box_outlined, size: 28, color: Color(0xFF1A1A1A)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
              Text('Marigold Blue Dormitory · $room', style: const TextStyle(fontSize: 10, color: Color(0xFF888888))),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: amountColor)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: badgeColor.withValues(alpha: isOverdue ? 1.0 : 0.2), borderRadius: BorderRadius.circular(10)),
              child: Text(dateOrStatus, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: isOverdue ? Colors.white : (isReceived ? const Color(0xFF15803D) : const Color(0xFFB45309)))),
            )
          ],
        )
      ],
    );
  }
}