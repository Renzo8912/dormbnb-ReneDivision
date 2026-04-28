import 'dart:ui';
import 'package:flutter/material.dart';
import 'add_listing_screen.dart';
import '../../controller/user_controller.dart';
import '../../models/user_model.dart';
import '../../models/dorm_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  late Future<List<DormModel>> _myDormsFuture;
  String _firstName = "Landlord";

  @override
  void initState() {
    super.initState();
    _fetchLandlordData();
  }

  Future<void> _refreshListings() async {
    setState(() {
      _fetchLandlordData();
    });
  }

  void _fetchLandlordData() {
    _myDormsFuture = _loadMyDorms();
  }

  Future<List<DormModel>> _loadMyDorms() async {
    try {
      // 1. Get the current user's ID
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return [];

      // 2. 🔥 BYPASS CACHE: Force a fresh, live read directly from Firestore!
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        // Update the greeting name
        if (mounted) {
          setState(() {
            _firstName = data['firstName'] != null && data['firstName'].toString().isNotEmpty
                ? data['firstName']
                : "Landlord";
          });
        }

        // 3. Grab the absolute newest dormsOwned array directly from the database
        List<dynamic> rawDormsOwned = data['dormsOwned'] ?? [];

        if (rawDormsOwned.isNotEmpty) {
          // Convert the dynamic list to a List of Strings and fetch them!
          List<String> freshDormIds = rawDormsOwned.map((e) => e.toString()).toList();
          return await UserController().fetchAllDormsByDormOwner(freshDormIds);
        }
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching landlord dorms: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: Stack(
        children: [
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
              color: Colors.white.withValues(alpha: 0.7),
              height: 180,
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Nunito'),
                              children: [
                                TextSpan(text: 'Dorm', style: TextStyle(color: Color(0xFF1A1A1A))),
                                TextSpan(text: 'BNB', style: TextStyle(color: Color(0xFF4A8BFE))),
                              ],
                            ),
                          ),
                          Text('Good morning, $_firstName!', style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E5E5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Color(0xFF1A1A1A)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              // Open Add mode (Null existingDorm)
                              MaterialPageRoute(builder: (context) => const AddListingScreen()),
                            ).then((_) => _refreshListings());
                          },
                        ),
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshListings,
                    color: const Color(0xFF4A8BFE),
                    child: FutureBuilder<List<DormModel>>(
                      future: _myDormsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Color(0xFF4A8BFE)));
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text("Error loading your properties: ${snapshot.error}"));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: 400,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.home_work_outlined, size: 64, color: Color(0xFFBDBDBD)),
                                    const SizedBox(height: 16),
                                    const Text("You haven't listed any dorms yet.", style: TextStyle(color: Color(0xFF666666))),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddListingScreen())).then((_) => _refreshListings());
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A8BFE)),
                                      child: const Text("Create your first listing", style: TextStyle(color: Colors.white)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        List<DormModel> myDorms = snapshot.data!;

                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          itemCount: myDorms.length,
                          itemBuilder: (context, index) {
                            DormModel dorm = myDorms[index];

                            double bedPrice = dorm.bedSpacePrice ?? 0.0;
                            double singlePrice = dorm.singleRoomPrice ?? 0.0;
                            double displayPrice = bedPrice > 0 ? bedPrice : singlePrice;

                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0) ...[
                                    const Text('My Listings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                                    const SizedBox(height: 16),
                                  ],
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                          child: Image.asset(
                                            // Fallback to stock Alpha if the backend hasn't saved an image array yet
                                            'lib/assets/images/DormAlpha.png',
                                            height: 160,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image_not_supported, size: 50)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(dorm.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),

                                                  // EDIT BUTTON
                                                  GestureDetector(
                                                    onTap: () {
                                                      // Passes the specific dorm data to pre-fill the form!
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => AddListingScreen(existingDorm: dorm)),
                                                      ).then((_) => _refreshListings());
                                                    },
                                                    child: const Text("Edit", style: TextStyle(color: Color(0xFF4A8BFE), fontWeight: FontWeight.bold, fontSize: 12)),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(dorm.address, style: const TextStyle(fontSize: 10, color: Color(0xFF888888))),
                                              const SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  _buildBadge('Available', const Color(0xFFA5C0FF)),
                                                  const SizedBox(width: 8),
                                                  _buildBadge('${dorm.amenities?.length ?? 0} Amenities', const Color(0xFFA5C0FF), icon: Icons.star_border),
                                                  const SizedBox(width: 8),
                                                  _buildBadge('₱ ${displayPrice.toStringAsFixed(0)}/mo', const Color(0xFFA5C0FF), icon: Icons.attach_money),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
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

  Widget _buildBadge(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 10, color: const Color(0xFF1A1A1A)), const SizedBox(width: 4)],
          Text(text, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        ],
      ),
    );
  }
}