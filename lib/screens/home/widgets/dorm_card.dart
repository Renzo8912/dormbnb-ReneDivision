import 'package:flutter/material.dart';
import '../../../models/dorm_model.dart';

class DormCard extends StatelessWidget {
  final DormModel dorm;

  const DormCard({super.key, required this.dorm});

  @override
  Widget build(BuildContext context) {
    // 1. Safely calculate the best price to show from the real database
    double bedPrice = dorm.bedSpacePrice ?? 0.0;
    double singlePrice = dorm.singleRoomPrice ?? 0.0;
    double displayPrice = bedPrice > 0 ? bedPrice : singlePrice;

    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // FIXED: Deprecation warning solved using .withValues
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DORM IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              // FIXED: Temporary placeholder until the backend adds Firebase Storage support
              'lib/assets/images/DormAlpha.png',
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
                // DORM NAME
                Text(
                  dorm.name, // Real DB property
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // LOCATION
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Color(0xFF888888)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        dorm.address, // FIXED: Mapped from 'location' to 'address'
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // PRICE AND RATING
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // PRICE
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 12, color: Color(0xFF4A8BFE), fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: '₱ ${displayPrice.toStringAsFixed(0)}'), // FIXED: Using calculated DB price
                          const TextSpan(text: '/mo', style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),

                    // RATING
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        const Text(
                          '4.5 (12)', // FIXED: Placeholder since DB doesn't have reviewCount yet
                          style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // AMENITY TAGS
                Wrap(
                  spacing: 6,
                  runSpacing: 4, // Added so tags don't cramp vertically
                  // FIXED: Added .take(3) so dorms with 10 amenities don't break the UI card!
                  children: (dorm.amenities ?? []).take(3).map((amenity) => Chip(
                    backgroundColor: const Color(0xFFF0F0F0),
                    label: Text(
                      amenity.toString(),
                      style: const TextStyle(fontSize: 10, color: Color(0xFF1A1A1A)),
                    ),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide.none,
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}