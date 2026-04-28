import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../models/dorm_model.dart';
import '../../controller/user_controller.dart';
import 'booking_confirmed_screen.dart';
// Note: Depending on where your BookingModel is stored, you may need to import it if createBooking requires BookingModel.pending
// import '../../../models/booking_model.dart';

class BookingScreen extends StatefulWidget {
  final DormModel dorm;

  const BookingScreen({super.key, required this.dorm});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedPayment = 'F2F Payment';
  bool agreedToTerms = false;
  bool agreedToPrivacy = false;

  @override
  Widget build(BuildContext context) {
    double price = widget.dorm.singleRoomPrice ?? widget.dorm.bedSpacePrice ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      // THE STICKY BOTTOM BAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Keep it compact
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Payment:', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                  Text('₱ ${price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A8BFE))),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (!agreedToTerms || !agreedToPrivacy) ? null : () async {
                    // 1. Show loading circle
                    showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));

                    try {
                      // Fire the exact function from the Master Guide PDF
                      await UserController().createBooking(
                        dorm: widget.dorm,
                        selectedPrice: price,
                        moveInDate: DateTime.now(),
                        status: 'pending',
                      );

                      if (!context.mounted) return;
                      Navigator.pop(context); // Close loading circle

                      // 1. Generate a realistic-looking fake booking reference (e.g., DBNB-2026-84732)
                      String refNumber = 'DBNB-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

                      // 2. Push to the Success Screen!
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingConfirmedScreen(referenceNumber: refNumber),
                        ),
                      );

                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A8BFE),
                    disabledBackgroundColor: const Color(0xFFA5C0FF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Confirm and Book', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),

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

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF4A8BFE), size: 16),
                    label: Text(widget.dorm.name, style: const TextStyle(color: Color(0xFF4A8BFE), fontSize: 12)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text('Confirm Booking', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'Nunito', color: Color(0xFF1A1A1A))),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // DATES SECTION
                        _buildSectionCard(
                          icon: Icons.calendar_today_outlined,
                          title: 'Move-in Date',
                          child: Row(
                            children: [
                              Expanded(child: _buildDateBox('MOVE-IN', 'April 28, 2026', 'Sunday')),
                              const SizedBox(width: 12),
                              Expanded(child: _buildDateBox('DURATION', '1 Month', 'Until May 28, 2026')),
                            ],
                          ),
                        ),

                        // ROOM DETAILS SECTION
                        _buildSectionCard(
                          icon: Icons.home_outlined,
                          title: 'Room Details',
                          child: Column(
                            children: [
                              _buildDetailRow('Dorm', widget.dorm.name),
                              const Divider(height: 24, color: Color(0xFFE0E0E0)),
                              _buildDetailRow('Room Type', 'Single Room'),
                              const Divider(height: 24, color: Color(0xFFE0E0E0)),
                              _buildDetailRow('Occupancy', widget.dorm.genderPolicy),
                            ],
                          ),
                        ),

                        // BILLING SUMMARY SECTION
                        _buildSectionCard(
                          icon: Icons.attach_money,
                          title: 'Billing Summary',
                          child: Column(
                            children: [
                              _buildDetailRow('Rent Cost', '₱ ${price.toStringAsFixed(0)}'),
                              const SizedBox(height: 12),
                              _buildDetailRow('Duration', 'x 1 Month'),
                              const Divider(height: 24, color: Color(0xFFE0E0E0)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Due Today', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                                  Text('₱ ${price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF4A8BFE))),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // PAYMENT METHOD SECTION
                        _buildSectionCard(
                          icon: Icons.credit_card,
                          title: 'Payment Method',
                          child: Column(
                            children: [
                              _buildPaymentOption('F2F Payment', 'Viable Method'),
                              const SizedBox(height: 8),
                              _buildPaymentOption('GCash', 'Instant Transfer'),
                              const SizedBox(height: 8),
                              _buildPaymentOption('Bank Transfer', 'BDO, BPI, Metrobank, PNB'),
                            ],
                          ),
                        ),

                        // AGREEMENTS SECTION
                        _buildSectionCard(
                          icon: Icons.handshake_outlined,
                          title: 'Agreements',
                          child: Column(
                            children: [
                              _buildCheckboxRow(agreedToTerms, 'I agree to the Lease Terms & Conditions of ${widget.dorm.name}', (val) => setState(() => agreedToTerms = val!)),
                              const SizedBox(height: 8),
                              _buildCheckboxRow(agreedToPrivacy, 'I agree to DormBNB\'s Privacy Policy & Terms', (val) => setState(() => agreedToPrivacy = val!)),
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
  Widget _buildSectionCard({required IconData icon, required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF1A1A1A)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDateBox(String label, String value, String sub) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF8FBFF), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF4A8BFE))),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          Text(sub, style: const TextStyle(fontSize: 8, color: Color(0xFF888888))),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
      ],
    );
  }

  Widget _buildPaymentOption(String title, String subtitle) {
    bool isSelected = selectedPayment == title;
    return GestureDetector(
      onTap: () => setState(() => selectedPayment = title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFF666666))),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF888888))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxRow(bool value, String text, Function(bool?) onChanged) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24, height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4A8BFE),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(text, style: const TextStyle(fontSize: 10, color: Color(0xFF666666))),
          ),
        ),
      ],
    );
  }
}