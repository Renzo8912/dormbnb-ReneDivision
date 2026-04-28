import 'package:flutter/material.dart';
import '../../../models/dorm_model.dart';
import 'booking_screen.dart'; // We will create this next!

class DormDetailsScreen extends StatelessWidget {
  final DormModel dorm;

  const DormDetailsScreen({super.key, required this.dorm});

  @override
  Widget build(BuildContext context) {
    // Determine display price
    double bedPrice = dorm.bedSpacePrice ?? 0.0;
    double singlePrice = dorm.singleRoomPrice ?? 0.0;
    double displayPrice = bedPrice > 0 ? bedPrice : singlePrice;

    // Dynamic Image Logic (matching your home screen)
    final List<String> stockImages = [
      'lib/assets/images/DormAlpha.png',
      'lib/assets/images/DormBeta.png',
      'lib/assets/images/DormCharlie.png',
      'lib/assets/images/DormDelta.png',
    ];
    int imageIndex = dorm.name.hashCode.abs() % stockImages.length;
    String displayImage = stockImages[imageIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. THE STICKY BOTTOM BAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price Info
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('₱ ${displayPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4A8BFE))),
                  const Text('/month · Single Room', style: TextStyle(fontSize: 10, color: Color(0xFF666666))),
                ],
              ),
              // Buttons
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {}, // TODO: Chat feature
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4A8BFE)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text('Chat', style: TextStyle(color: Color(0xFF4A8BFE), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(dorm: dorm)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A8BFE),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      elevation: 0,
                    ),
                    child: const Text('Book Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),

      // 2. THE SCROLLABLE CONTENT
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE & TOP BAR STACK
            Stack(
              children: [
                Image.asset(displayImage, width: double.infinity, height: 250, fit: BoxFit.cover),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildGlassIcon(Icons.arrow_back, () => Navigator.pop(context)),
                        Row(
                          children: [
                            _buildGlassIcon(Icons.favorite_border, () {}),
                            const SizedBox(width: 8),
                            _buildGlassIcon(Icons.share_outlined, () {}),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),

            // DORM DETAILS
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dorm.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'Nunito', color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Color(0xFF888888)),
                      const SizedBox(width: 4),
                      Expanded(child: Text(dorm.address, style: const TextStyle(fontSize: 12, color: Color(0xFF666666)))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF22C55E), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text('Verified', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // STATS ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBadge(Icons.star, '4.8', Colors.amber),
                      _buildStatBadge(Icons.people_outline, '42 Reviews', const Color(0xFF1A1A1A)),
                      _buildStatBadge(null, dorm.genderPolicy, const Color(0xFF1A1A1A)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ROOM TYPES
                  const Text('Room Types', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildRoomCard('Single Room', '1 Occupant · 12 sqm', singlePrice)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildRoomCard('Double Room', '2 Occupants · 18 sqm', bedPrice > 0 ? bedPrice * 2 : 0)), // Mock calculation
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ABOUT
                  const Text('About This Dorm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  const Text(
                    'This is a fully-furnished dorm located just 300 meters from University Gates. Secure 24/7 with a CCTV-monitored entrance. Utilities included in monthly rent. Cooking area available.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF666666), height: 1.5),
                  ),
                  const SizedBox(height: 8),
                  const Text('Read More ↓', style: TextStyle(fontSize: 12, color: Color(0xFF4A8BFE), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),

                  // AMENITIES
                  const Text('Amenities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: (dorm.amenities ?? []).map((amenity) => Chip(
                      backgroundColor: const Color(0xFFF5F5F5),
                      label: Text(amenity.toString(), style: const TextStyle(fontSize: 12, color: Color(0xFF1A1A1A))),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    )).toList(),
                  ),
                  const SizedBox(height: 32),

                  // HOUSE RULES
                  const Text('House Rules', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _buildRuleRow('Curfew', '10:00 PM'),
                        const Divider(height: 24, color: Color(0xFFE0E0E0)),
                        _buildRuleRow('Visitors', 'Common Area Only'),
                        const Divider(height: 24, color: Color(0xFFE0E0E0)),
                        _buildRuleRow('Pets', 'Not Allowed'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HELPER WIDGETS
  Widget _buildGlassIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: const Color(0xFF1A1A1A)),
      ),
    );
  }

  Widget _buildStatBadge(IconData? icon, String text, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE0E0E0)), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: iconColor), const SizedBox(width: 6)],
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        ],
      ),
    );
  }

  Widget _buildRoomCard(String title, String subtitle, double price) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE0E0E0)), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 8, color: Color(0xFF888888))),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: Color(0xFF4A8BFE), fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: '₱ ${price.toStringAsFixed(0)}'),
                const TextSpan(text: '/mo', style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFF666666))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
      ],
    );
  }
}