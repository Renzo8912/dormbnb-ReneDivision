import 'package:flutter/material.dart';
import '../../../models/dorm_model.dart';
import '../dorm_details_screen.dart'; // 🔥 ADDED: Import the new details screen!

class DormCard extends StatelessWidget {
  final DormModel dorm;

  const DormCard({super.key, required this.dorm});

  @override
  Widget build(BuildContext context) {
    double bedPrice = dorm.bedSpacePrice ?? 0.0;
    double singlePrice = dorm.singleRoomPrice ?? 0.0;
    double displayPrice = bedPrice > 0 ? bedPrice : singlePrice;

    // --- DYNAMIC STOCK IMAGE LOGIC ---
    final List<String> stockImages = [
      'lib/assets/images/DormAlpha.png',
      'lib/assets/images/DormBeta.png',
      'lib/assets/images/DormCharlie.png',
      'lib/assets/images/DormDelta.png',
    ];
    // This gives a consistent random image based on the dorm's name!
    int imageIndex = dorm.name.hashCode.abs() % stockImages.length;
    String displayImage = stockImages[imageIndex];

    // 🔥 ADDED: GestureDetector to make the whole card clickable
    return GestureDetector(
      onTap: () {
        // Navigates to the details page and passes this specific dorm's data!
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DormDetailsScreen(dorm: dorm),
          ),
        );
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Added to prevent bottom overflow
          children: [
            // DORM IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                displayImage,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.image_not_supported, size: 50)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dorm.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Nunito', color: Color(0xFF1A1A1A)),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Color(0xFF888888)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(dorm.address, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Color(0xFF666666))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 12, color: Color(0xFF4A8BFE), fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(text: '₱ ${displayPrice.toStringAsFixed(0)}'),
                            const TextSpan(text: '/mo', style: TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          SizedBox(width: 4),
                          Text('4.5 (12)', style: TextStyle(fontSize: 11, color: Color(0xFF666666))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6, runSpacing: 4,
                    children: (dorm.amenities ?? []).take(3).map((amenity) => Chip(
                      backgroundColor: const Color(0xFFF0F0F0),
                      label: Text(amenity.toString(), style: const TextStyle(fontSize: 10, color: Color(0xFF1A1A1A))),
                      padding: EdgeInsets.zero, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, side: BorderSide.none,
                    )).toList(),
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