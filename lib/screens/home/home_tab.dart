import 'dart:ui';
import 'package:flutter/material.dart';
import '../../controller/dorm_controller.dart';
import '../../models/dorm_model.dart';
import 'widgets/dorm_card.dart';
import 'browse_tab.dart';
import 'notification_screen.dart';
import '../../../models/dorm_model.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // This variable holds the database request
  late Future<List<DormModel>> _dormsFuture;

  @override
  void initState() {
    super.initState();
    // Fire the database request as soon as the screen loads
    _dormsFuture = DormController().getAllDorms();
  }

  // Pull-to-refresh functionality just in case!
  Future<void> _refreshDorms() async {
    setState(() {
      _dormsFuture = DormController().getAllDorms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. TOP BLURRY BACKGROUND STACK
        SizedBox(
          height: 150,
          width: double.infinity,
          child: Image.asset(
            'lib/assets/images/LandingScreenBackground.png',
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),

        // 2. BLUR OVERLAY
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withValues(alpha: 0.5),
            height: 150,
          ),
        ),

        // 3. SAFE CONTENT COLUMN
        SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshDorms,
            color: const Color(0xFF4A8BFE),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // Allows pull-to-refresh even if list is short
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER SECTION
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Nunito',
                                ),
                                children: [
                                  TextSpan(text: 'Dorm', style: TextStyle(color: Color(0xFF1A1A1A))),
                                  TextSpan(text: 'BNB', style: TextStyle(color: Color(0xFF4A8BFE))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Good morning!', // Generic greeting for now
                              style: TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.search, size: 24, color: Color(0xFF1A1A1A)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const BrowseScreen()),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications_none, size: 24, color: Color(0xFF1A1A1A)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // THE DATABASE CONNECTION
                  FutureBuilder<List<DormModel>>(
                    future: _dormsFuture,
                    builder: (context, snapshot) {
                      // STATE 1: Still loading from Firebase
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator(color: Color(0xFF4A8BFE))),
                        );
                      }

                      // STATE 2: Firebase threw an error
                      if (snapshot.hasError) {
                        return SizedBox(
                          height: 300,
                          child: Center(child: Text("Error loading dorms: ${snapshot.error}")),
                        );
                      }

                      // STATE 3: Success! No dorms in database yet
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: Text("No dorms available yet. Be the first to list one!")),
                        );
                      }

                      // STATE 4: Success with data! Let's filter them.
                      List<DormModel> allDorms = snapshot.data!;

                      // Featured Dorms (Just taking the first half of the DB for now)
                      List<DormModel> featuredDorms = allDorms.take(5).toList();

                      // Budget Friendly (Sorting by the lowest price)
                      List<DormModel> budgetFriendlyDorms = List<DormModel>.from(allDorms)..sort((a, b) {
                        // The '?' protects the receiver from crashing if a dorm object is missing data
                        double aBed = a?.bedSpacePrice ?? 0.0;
                        double aSingle = a?.singleRoomPrice ?? 0.0;

                        double bBed = b?.bedSpacePrice ?? 0.0;
                        double bSingle = b?.singleRoomPrice ?? 0.0;

                        // Find the valid price for A
                        double priceA = aBed > 0 ? aBed : aSingle;
                        // Find the valid price for B
                        double priceB = bBed > 0 ? bBed : bSingle;

                        return priceA.compareTo(priceB);
                      });

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // FEATURED DORMS SECTION
                          const SectionHeader(title: 'Featured Dorms'),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 310,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              itemCount: featuredDorms.length,
                              itemBuilder: (context, index) {
                                return DormCard(dorm: featuredDorms[index]);
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // BUDGET FRIENDLY SECTION
                          const SectionHeader(title: 'Budget Friendly'),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 310,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              itemCount: budgetFriendlyDorms.length,
                              itemBuilder: (context, index) {
                                return DormCard(dorm: budgetFriendlyDorms[index]);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Keep your SectionHeader exactly the same
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'Nunito',
              color: Color(0xFF1A1A1A),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'See all →',
              style: TextStyle(fontSize: 12, color: Color(0xFF4A8BFE)),
            ),
          ),
        ],
      ),
    );
  }
}