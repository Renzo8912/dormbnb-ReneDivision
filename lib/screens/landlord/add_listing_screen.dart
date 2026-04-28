import 'dart:ui';
import 'package:flutter/material.dart';
import '../../controller/dorm_controller.dart';
import '../../models/dorm_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddListingScreen extends StatefulWidget {
  // Pass an existing dorm to trigger "Edit Mode"
  final DormModel? existingDorm;

  const AddListingScreen({super.key, this.existingDorm});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController singleRoomPriceController = TextEditingController();
  final TextEditingController bedSpacePriceController = TextEditingController();

  String selectedGenderPolicy = 'Female Only';
  List<String> selectedAmenities = [];

  // UI States for simulated document uploads
  bool isTitleUploaded = false;
  bool isFireCertUploaded = false;
  bool isPermitUploaded = false;

  final List<String> availableAmenities = [
    DormModel.wifi, DormModel.aircon, 'Private CR', 'Shared Kitchen',
    DormModel.cctv, DormModel.hotShower, DormModel.securedGate, DormModel.parking
  ];

  @override
  void initState() {
    super.initState();
    // If we are editing, pre-fill all the text boxes!
    if (widget.existingDorm != null) {
      nameController.text = widget.existingDorm!.name;
      addressController.text = widget.existingDorm!.address;
      singleRoomPriceController.text = widget.existingDorm!.singleRoomPrice.toString();
      bedSpacePriceController.text = widget.existingDorm!.bedSpacePrice.toString();

      if (widget.existingDorm!.genderPolicy == DormModel.maleOnly) selectedGenderPolicy = 'Male Only';
      if (widget.existingDorm!.genderPolicy == DormModel.maleFemale) selectedGenderPolicy = 'Male & Female';

      if (widget.existingDorm!.amenities != null) {
        selectedAmenities = widget.existingDorm!.amenities!.cast<String>();
      }

      // Simulate that documents were already uploaded for existing dorms
      isTitleUploaded = true;
      isFireCertUploaded = true;
      isPermitUploaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditMode = widget.existingDorm != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
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
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF4A8BFE), size: 20),
                    label: const Text('Dashboard', style: TextStyle(color: Color(0xFF4A8BFE), fontSize: 16)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    isEditMode ? 'Edit Listing' : 'Add New Listing',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Nunito', color: Color(0xFF1A1A1A)),
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PHOTO UPLOAD BOX
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          decoration: BoxDecoration(color: const Color(0xFFA5C0FF), borderRadius: BorderRadius.circular(16)),
                          child: const Column(
                            children: [
                              Icon(Icons.camera_alt_outlined, size: 32, color: Color(0xFF1A1A1A)),
                              SizedBox(height: 8),
                              Text('Upload Dorm Photos (max: 10)', style: TextStyle(fontSize: 12, color: Color(0xFF1A1A1A))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // BASIC INFO SECTION
                        _buildSectionCard(
                          title: 'Basic Info',
                          icon: Icons.article_outlined,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextField('Dorm Name', 'e.g., Marigold Blue Dormitory', nameController),
                              _buildTextField('Address', 'e.g., Street, Baranggay, City', addressController),

                              const Text('Gender Policy', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFE0E0E0)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedGenderPolicy,
                                    isExpanded: true,
                                    items: ['Female Only', 'Male Only', 'Male & Female'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                                    onChanged: (newValue) => setState(() => selectedGenderPolicy = newValue!),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              const Text('Description', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                              const SizedBox(height: 8),
                              TextField(
                                controller: descriptionController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: 'Describe your dorm - amenities, location, rules, etc.',
                                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
                                  filled: true, fillColor: const Color(0xFFF5F5F5),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // PRICING SECTION
                        _buildSectionCard(
                          title: 'Room Types & Pricing',
                          icon: Icons.bed_outlined,
                          child: Column(
                            children: [
                              _buildTextField('Single Bedroom Price (₱)', 'e.g., 3500', singleRoomPriceController, isNumber: true),
                              _buildTextField('Bed Space Price (₱)', 'e.g., 2000', bedSpacePriceController, isNumber: true),
                            ],
                          ),
                        ),

                        // AMENITIES SECTION
                        _buildSectionCard(
                          title: 'Amenities',
                          icon: Icons.check_box_outlined,
                          child: Wrap(
                            spacing: 8, runSpacing: 8,
                            children: availableAmenities.map((amenity) {
                              bool isSelected = selectedAmenities.contains(amenity);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSelected ? selectedAmenities.remove(amenity) : selectedAmenities.add(amenity);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF4A8BFE) : const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: isSelected ? const Color(0xFF4A8BFE) : const Color(0xFFE0E0E0)),
                                  ),
                                  child: Text(amenity, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF1A1A1A), fontSize: 12)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        // NEW: REQUIRED DOCUMENTS SECTION
                        _buildSectionCard(
                          title: 'Required Documents',
                          icon: Icons.assignment_outlined,
                          child: Column(
                            children: [
                              _buildDocumentUploadBox(
                                  title: 'Property Title / Lease Authority',
                                  subtitle: 'Proof of ownership or authority to operate',
                                  icon: Icons.home_outlined,
                                  isUploaded: isTitleUploaded,
                                  onTap: () {
                                    setState(() => isTitleUploaded = true);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulated: Title Uploaded!')));
                                  }
                              ),
                              _buildDocumentUploadBox(
                                  title: 'Fire Safety Certificate',
                                  subtitle: 'BFP-issued fire safety inspection cert',
                                  icon: Icons.local_fire_department_outlined,
                                  isUploaded: isFireCertUploaded,
                                  onTap: () {
                                    setState(() => isFireCertUploaded = true);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulated: Fire Cert Uploaded!')));
                                  }
                              ),
                              _buildDocumentUploadBox(
                                  title: 'Business Permit / Mayor\'s Permit',
                                  subtitle: 'City hall-issued business registration',
                                  icon: Icons.badge_outlined,
                                  isUploaded: isPermitUploaded,
                                  onTap: () {
                                    setState(() => isPermitUploaded = true);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulated: Permit Uploaded!')));
                                  }
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // SUBMIT BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(child: CircularProgressIndicator()),
                                );

                                String policyFormat = DormModel.femaleOnly;
                                if (selectedGenderPolicy == 'Male Only') policyFormat = DormModel.maleOnly;
                                if (selectedGenderPolicy == 'Male & Female') policyFormat = DormModel.maleFemale;

                                if (isEditMode) {
                                  // We simulate the delay here so the presentation looks good
                                  await Future.delayed(const Duration(seconds: 1));
                                  debugPrint("Updating Dorm ID: ${widget.existingDorm!.id}");
                                } else {
                                  // 1. Create the dorm and save the ID it gives back!
                                  String newDormId = await DormController().createDorm(
                                    name: nameController.text.trim(),
                                    address: addressController.text.trim(),
                                    distanceToMseuf: "TBD",
                                    genderPolicy: policyFormat,
                                    singleRoomPrice: double.tryParse(singleRoomPriceController.text) ?? 0.0,
                                    bedSpacePrice: double.tryParse(bedSpacePriceController.text) ?? 0.0,
                                    amenities: selectedAmenities,
                                  );
                                  String? uid = FirebaseAuth.instance.currentUser?.uid;
                                  if (uid != null) {
                                    await FirebaseFirestore.instance.collection('users').doc(uid).set({
                                      'dormsOwned': FieldValue.arrayUnion([newDormId])
                                    }, SetOptions(merge: true));
                                  }
                                }

                                if (!context.mounted) return;
                                Navigator.pop(context);
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEditMode ? 'Listing Updated Successfully!' : 'Listing Submitted!')));
                              } catch (e) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A8BFE),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(isEditMode ? 'Save Changes' : 'Submit Listing for Review', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
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

  Widget _buildTextField(String label, String hint, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
              filled: true, fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  // The custom dashed-look UI for the documents
  Widget _buildDocumentUploadBox({required String title, required String subtitle, required IconData icon, required bool isUploaded, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: isUploaded ? const Color(0xFFE6F0FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded ? const Color(0xFF4A8BFE) : const Color(0xFFBDBDBD),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
                isUploaded ? Icons.check_circle : icon,
                size: 32,
                color: isUploaded ? const Color(0xFF4A8BFE) : const Color(0xFF1A1A1A)
            ),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isUploaded ? const Color(0xFF4A8BFE) : const Color(0xFF1A1A1A))),
            const SizedBox(height: 4),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Color(0xFF888888))),
          ],
        ),
      ),
    );
  }
}