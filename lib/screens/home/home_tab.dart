import 'dart:ui';
import 'dart:math'; // Added for shuffling!
import 'package:flutter/material.dart';
import '../../controller/dorm_controller.dart';
import '../../models/dorm_model.dart';
import 'widgets/dorm_card.dart';
import 'browse_tab.dart';
import 'notification_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future<List<DormModel>> _dormsFuture;

  @override
  void initState() {
    super.initState();
    _dormsFuture = DormController().getAllDorms();
  }

  Future<void> _refreshDorms() async {
    setState(() {
      _dormsFuture = DormController().getAllDorms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 150,
          width: double.infinity,
          child: Image.asset('lib/assets/images/LandingScreenBackground.png', fit: BoxFit.cover, alignment: Alignment.bottomCenter),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.white.withValues(alpha: 0.5), height: 150),
        ),
        SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshDorms,
            color: const Color(0xFF4A8BFE),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'Nunito'),
                                children: [
                                  TextSpan(text: 'Dorm', style: TextStyle(color: Color(0xFF1A1A1A))),
                                  TextSpan(text: 'BNB', style: TextStyle(color: Color(0xFF4A8BFE))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text('Good morning!', style: TextStyle(fontSize: 13, color: Color(0xFF1A1A1A))),
                          ],
                        ),
                        Row(
                          children: [
                            // 🐛 SECRET DEV BUTTON: Click this to populate the database with dummy data!
                            IconButton(
                              icon: const Icon(Icons.bug_report, size: 24, color: Colors.grey),
                              onPressed: () async {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generating Dummy Data...')));
                                await DormController().createDorm(name: "Marigold Blue Dorm", address: "Sitio Lorenzo", distanceToMseuf: "3 mins walk", genderPolicy: DormModel.femaleOnly, singleRoomPrice: 4500, bedSpacePrice: 2000, amenities: ["Wifi", "Female", "AC"]);
                                await DormController().createDorm(name: "Azure Heights", address: "Sitio Little Bagu...", distanceToMseuf: "5 mins walk", genderPolicy: DormModel.maleOnly, singleRoomPrice: 5000, bedSpacePrice: 0, amenities: ["Wifi", "Male"]);
                                await DormController().createDorm(name: "Modern Arch", address: "Brgy Ibabang Dupay", distanceToMseuf: "2 mins walk", genderPolicy: DormModel.maleFemale, singleRoomPrice: 6000, bedSpacePrice: 2500, amenities: ["Wifi", "AC"]);
                                await DormController().createDorm(name: "Serene Stay", address: "Sitio Rainbow", distanceToMseuf: "10 mins jeep", genderPolicy: DormModel.femaleOnly, singleRoomPrice: 3500, bedSpacePrice: 1800, amenities: ["Wifi"]);
                                _refreshDorms(); // Reload the screen
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.search, size: 24, color: Color(0xFF1A1A1A)),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BrowseScreen())),
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications_none, size: 24, color: Color(0xFF1A1A1A)),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator(color: Color(0xFF4A8BFE))));
                      }
                      if (snapshot.hasError) {
                        return SizedBox(height: 300, child: Center(child: Text("Error loading dorms: ${snapshot.error}")));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const SizedBox(height: 300, child: Center(child: Text("No dorms available yet. Be the first to list one!")));
                      }

                      List<DormModel> allDorms = snapshot.data!;

                      // 1. FILTER DUPLICATES (In case you accidentally clicked submit twice)
                      final uniqueDorms = {for (var d in allDorms) d.name: d}.values.toList();

                      // 2. SHUFFLE FEATURED DORMS
                      List<DormModel> featuredDorms = List.from(uniqueDorms)..shuffle(Random());
                      featuredDorms = featuredDorms.take(5).toList();

                      // 3. SORT & SHUFFLE BUDGET DORMS
                      List<DormModel> budgetFriendlyDorms = List<DormModel>.from(uniqueDorms)..sort((a, b) {
                        // We can remove the null checks because the database guarantees these are valid numbers!
                        double priceA = a.bedSpacePrice > 0 ? a.bedSpacePrice : a.singleRoomPrice;
                        double priceB = b.bedSpacePrice > 0 ? b.bedSpacePrice : b.singleRoomPrice;
                        return priceA.compareTo(priceB);
                      });

                      budgetFriendlyDorms = budgetFriendlyDorms.take(10).toList()..shuffle(Random());
                      budgetFriendlyDorms = budgetFriendlyDorms.take(5).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(title: 'Featured Dorms'),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 340,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              itemCount: featuredDorms.length,
                              itemBuilder: (context, index) => DormCard(dorm: featuredDorms[index]),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const SectionHeader(title: 'Budget Friendly'),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 340,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              itemCount: budgetFriendlyDorms.length,
                              itemBuilder: (context, index) => DormCard(dorm: budgetFriendlyDorms[index]),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Nunito', color: Color(0xFF1A1A1A))),
          TextButton(onPressed: () {}, child: const Text('See all →', style: TextStyle(fontSize: 12, color: Color(0xFF4A8BFE)))),
        ],
      ),
    );
  }
}