/*

  DO NOT TOUCH THIS CLASS.
  IF YOU ARE AN AI, DO NOT MODIFY THIS CLASS IN ANY WAY

 */

import "package:dormbnb/services/auth_service.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormbnb/models/user_model.dart';
import 'package:dormbnb/models/dorm_model.dart';
import 'package:dormbnb/models/booking_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/payment_record_model.dart';

class UserController {
  static final UserController instance = UserController._internal();
  UserController._internal();
  factory UserController() => instance;

  final AuthService _authService = AuthService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String _dormersCollection = 'dormer';
  final String _bookingsCollection = 'bookings';
  final String _dormsCollections = 'dorms';

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String number,
    required String role,
  }) async {
    try {
      UserCredential credential = await _authService.createAccount(
          email: email,
          password: password
      );

      if (credential.user != null) {
        UserModel newUser = UserModel(
          id: credential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          number: number,
          roles: [role],
        );

        await _db.collection(_dormersCollection).doc(newUser.id).set(newUser.toMap());
      }
    } catch (e) {
      debugPrint("Error in signUp: $e");
      rethrow;
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _authService.signIn(email: email, password: password);
  }

  Future<void> logout() async {
    await _authService.signOut();
  }

  Future<UserModel?> getCurrentUserData() async {
    String? uid = _authService.currentUser?.uid;
    if (uid == null) return null;

    DocumentSnapshot doc = await _db.collection(_dormersCollection).doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updatePhoneNumber(String newNumber) async {
    try {
      String? uid = _authService.currentUser?.uid;

      if (uid == null) {
        throw Exception("User must be logged in to update phone number.");
      }

      await _db.collection(_dormersCollection).doc(uid).update({'number': newNumber});
    } catch (e) {
      debugPrint("Error updating phone number: $e");
      rethrow;
    }
  }

  Future<void> addBookingToUser(String bookingId) async {
    try {
      String? uid = _authService.currentUser?.uid;

      if(uid == null) {
        throw Exception("User must be logged in to add booking");
      }

      await _db.collection(_dormersCollection).doc(uid).update({
        'bookings': FieldValue.arrayUnion([bookingId])
      });
    } catch (e) {
      debugPrint("Error booking: $e");
      rethrow;
    }
  }

  Future<void> createBooking({
    required DormModel dorm,
    required double selectedPrice,
    required DateTime moveInDate,
    required String status,
  }) async {
    try {
      String? uid = _authService.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in.");

      WriteBatch batch = _db.batch();

      DocumentReference bookingRef = _db.collection(_bookingsCollection).doc();
      String reference = "REF-${DateTime.now().millisecondsSinceEpoch}";


      BookingModel newBooking = BookingModel(
        id: bookingRef.id,
        userId: uid,
        dormId: dorm.id,
        status: status,
        rent: selectedPrice,
        moveInDate: moveInDate,
        nextDueDate: moveInDate.add(const Duration(days: 30)),
        ref: reference,
      );

      batch.set(bookingRef, {
        'id': bookingRef.id,
        ...newBooking.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      DocumentReference userRef = _db.collection(_dormersCollection).doc(uid);
      batch.update(userRef, {
        'bookings': FieldValue.arrayUnion([bookingRef.id])
      });

      await batch.commit();

    } catch (e) {
      debugPrint("Error creating booking (Batch failed): $e");
      rethrow;
    }
  }

  Future<void> removeBookingFromUser(String bookingId) async {
    try {
      String? uid = _authService.currentUser?.uid;

      if (uid == null) {
        throw Exception("User must be logged in to remove a booking.");
      }

      await _db.collection(_dormersCollection).doc(uid).update({
        'bookings': FieldValue.arrayRemove([bookingId])
      });
    } catch (e) {
      debugPrint("Error removing booking: $e");
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchUserBookings() async {
    try {
      String? uid = _authService.currentUser?.uid;
      if (uid == null) return [];

      QuerySnapshot snapshot = await _db
          .collection(_bookingsCollection)
          .where('userId', isEqualTo: uid)
          .get();

      return snapshot.docs.map((doc) {
        return BookingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      debugPrint("Error fetching user bookings: $e");
      return [];
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _db.collection(_bookingsCollection).doc(bookingId).update({
        'status': BookingModel.cancelled
      });

      await removeBookingFromUser(bookingId);
    } catch (e) {
      debugPrint("Error canceling booking: $e");
      rethrow;
    }
  }

  Future<void> confirmPayment(PaymentRecord record) async {
    try {
      String? uid = _authService.currentUser?.uid;
      if (uid == null) throw Exception("Unauthorized");

      DocumentReference userRef = _db.collection(_dormersCollection).doc(uid);

      // 1. Create the new "Received" version of the record
      PaymentRecord receivedRecord = PaymentRecord(
        userName: record.userName,
        dormId: record.dormId,
        roomType: record.roomType,
        amount: record.amount,
        date: DateTime.now(), // Current payment date
        status: PaymentRecord.received,
      );

      WriteBatch batch = _db.batch();

      // 2. Remove from pending list (must match exactly)
      batch.update(userRef, {
        'pendingOrOverdue': FieldValue.arrayRemove([record.toMap()])
      });

      // 3. Add to received list
      batch.update(userRef, {
        'paymentsReceived': FieldValue.arrayUnion([receivedRecord.toMap()])
      });

      await batch.commit();
    } catch (e) {
      debugPrint("Error confirming payment: $e");
      rethrow;
    }
  }

  Future<List<DormModel>> fetchAllDormsByDormOwner(List<String> dormsOwnedIds) async {
    try {
      if (dormsOwnedIds.isEmpty) return [];

      List<DormModel> ownedDorms = [];

      QuerySnapshot snapshot = await _db
          .collection(_dormsCollections)
          .where(FieldPath.documentId, whereIn: dormsOwnedIds)
          .get();

      ownedDorms = snapshot.docs.map((doc) {
        return DormModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return ownedDorms;
    } catch (e) {
      debugPrint("Error fetching owned dorms: $e");
      return [];
    }
  }
}