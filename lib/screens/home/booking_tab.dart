import 'dart:ui';
import 'package:flutter/material.dart';
import 'billing_screen.dart';

class BookingTab extends StatefulWidget {
  const BookingTab({super.key});

  @override
  State<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  // State for the interactive filter chips!
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Active', 'Pending', 'Complete'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 🔥 Added dark background to match Figma
      body: Stack(
        children: [
          // 1. TOP BACKGROUND IMAGE & BLUR
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
              color: Colors.white.withValues(alpha: 0.85),
              height: 180,
            ),
          ),

          // 2. FOREGROUND CONTENT
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Text(
                      'My Bookings',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Nunito', color: Color(0xFF1A1A1A)),
                    ),
                  ),

                  // INTERACTIVE FILTER CHIPS
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: filters.map((filter) {
                        bool isActive = selectedFilter == filter;
                        return GestureDetector(
                          onTap: () => setState(() => selectedFilter = filter),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isActive ? const Color(0xFF4A8BFE) : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isActive ? const Color(0xFF4A8BFE) : const Color(0xFFE0E0E0)),
                            ),
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isActive ? Colors.white : const Color(0xFF888888),
                                fontSize: 12,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // BOOKING CARDS
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // ACTIVE BOOKING CARD
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Column(
                            children: [
                              // BLUE HEADER
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4A8BFE),
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('ACTIVE BOOKING', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                                          child: const Row(
                                            children: [
                                              Icon(Icons.check, size: 10, color: Colors.white),
                                              SizedBox(width: 4),
                                              Text('Confirmed', style: TextStyle(color: Colors.white, fontSize: 10)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text('Marigold Blue Dormitory', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Nunito', decoration: TextDecoration.underline, decorationColor: Colors.white)),
                                    const Text('Single Room · 2nd Floor', style: TextStyle(color: Colors.white70, fontSize: 12, decoration: TextDecoration.underline, decorationColor: Colors.white70)),
                                  ],
                                ),
                              ),
                              // WHITE BODY
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    _buildInfoRow('Move-in', 'April 28, 2026'),
                                    const SizedBox(height: 12),
                                    _buildInfoRow('Monthly Rent', '₱ 3,500', isBlue: true),
                                    const SizedBox(height: 12),
                                    _buildInfoRow('Next Due', 'May, 28, 2026', isRed: true),
                                    const SizedBox(height: 12),
                                    _buildInfoRow('Ref', 'DBNB-2026-04821'),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16.0),
                                      child: Divider(color: Color(0xFFE0E0E0), height: 1),
                                    ),
                                    Row(
                                      children: [
                                        // YOUR ORIGINAL BOTTOM SHEET CALL
                                        Expanded(child: _buildActionButton('Contract', isPrimary: true, onTap: () => _showContractBottomSheet(context))),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildActionButton('Billing', onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const BillingScreen()));
                                        })),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildActionButton('Chat', onTap: () {})),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // PENDING BOOKING CARD
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Azure Heights Dormitory', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Nunito', color: Color(0xFF1A1A1A))),
                                      Text('Double Room · Ref: DBNB-2026-04819', style: TextStyle(fontSize: 10, color: Color(0xFF888888))),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(12)),
                                    child: const Text('Pending', style: TextStyle(color: Color(0xFFD97706), fontSize: 9, fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Requested', 'April 26, 2026'),
                              const SizedBox(height: 12),
                              _buildInfoRow('Monthly', '₱ 2,100/person'),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Divider(color: Color(0xFFE0E0E0), height: 1),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Center(
                                  child: Text('Cancel Request', style: TextStyle(color: Color(0xFFDC2626), fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 100), // Padding for scrolling
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI HELPERS ---
  Widget _buildInfoRow(String label, String value, {bool isBlue = false, bool isRed = false}) {
    Color valueColor = const Color(0xFF1A1A1A);
    if (isBlue) valueColor = const Color(0xFF4A8BFE);
    if (isRed) valueColor = const Color(0xFFDC2626);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF666666), fontSize: 12)),
        Text(value, style: TextStyle(color: valueColor, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionButton(String label, {bool isPrimary = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF4A8BFE) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF4A8BFE)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isPrimary ? Colors.white : const Color(0xFF4A8BFE),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // --- YOUR CUSTOM SLIDING BOTTOM SHEET ---
  void _showContractBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 40.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.handshake_outlined, size: 28),
                    SizedBox(width: 8),
                    Text('Lease Contract', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Nunito')),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      _buildDialogRow('Ref No.', 'DBNB-2026-04B21'),
                      const SizedBox(height: 8),
                      _buildDialogRow('Tenant', 'Juan Dela Cruz'),
                      const SizedBox(height: 8),
                      _buildDialogRow('Dorm', 'Marigold Blue Dormitory'),
                      const SizedBox(height: 8),
                      _buildDialogRow('Room', 'Single Room - 2F'),
                      const SizedBox(height: 8),
                      _buildDialogRow('Lease Start', 'April 28, 2026'),
                      const SizedBox(height: 8),
                      _buildDialogRow('Lease End', 'May 28, 2026'),
                      const SizedBox(height: 8),
                      _buildDialogRow('Monthly Rent', '₱ 3,500'),
                      const SizedBox(height: 8),
                      _buildDialogRow('Deposit', '₱ 3,500'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This lease agreement is digitally executed through DormBNB and is legally binding. Both parties have agreed to the terms and conditions of DormBNB and the specific house rules of Marigold Blue Dormitory.',
                  style: TextStyle(fontSize: 10, color: Color(0xFF888888), height: 1.4),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(color: const Color(0xFF86EFAC), borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_box, color: Color(0xFF166534), size: 16),
                      SizedBox(width: 8),
                      Text('Digitally signed by both parties on April 28, 2026', style: TextStyle(color: Color(0xFF166534), fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.download, color: Colors.white, size: 18),
                    label: const Text('Download PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A8BFE),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF666666))),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
      ],
    );
  }
}