// lib/services/booking_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save booking to Firestore
  Future<bool> saveBooking({
    required String carName,
    required String carPrice,
    required String carImage,
    required String pickupLocation,
    required String dropoffLocation,
    required DateTime pickupDate,
    required TimeOfDay pickupTime,
    required DateTime dropoffDate,
    required TimeOfDay dropoffTime,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        print('❌ Error: User not logged in');
        throw Exception('User not logged in');
      }

      print('📝 Attempting to save booking...');
      print('User ID: $uid');
      print('Car: $carName');
      print('Customer: $customerName');

      final docRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookings')
          .add({
        'carName': carName,
        'carPrice': carPrice,
        'carImage': carImage,
        'pickupLocation': pickupLocation,
        'dropoffLocation': dropoffLocation,
        'pickupDate': Timestamp.fromDate(pickupDate),
        'pickupTime': '${pickupTime.hour.toString().padLeft(2, '0')}:${pickupTime.minute.toString().padLeft(2, '0')}',
        'dropoffDate': Timestamp.fromDate(dropoffDate),
        'dropoffTime': '${dropoffTime.hour.toString().padLeft(2, '0')}:${dropoffTime.minute.toString().padLeft(2, '0')}',
        'customerName': customerName,
        'customerEmail': customerEmail,
        'customerPhone': customerPhone,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('✅ Booking saved successfully!');
      print('Document ID: ${docRef.id}');
      return true;
    } catch (e) {
      print('❌ Error saving booking: $e');
      rethrow;
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not logged in');
      }

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookings')
          .doc(bookingId)
          .update({'status': 'Cancelled'});

      print('✅ Booking cancelled successfully');
    } catch (e) {
      print('❌ Error cancelling booking: $e');
      rethrow;
    }
  }

  // Get all bookings for current user
  Stream<QuerySnapshot> getBookings() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User not logged in');
    }

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}