import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Ensure Firebase initialization

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize Firebase in the constructor if not already done
  FirebaseService() {
    _initializeFirebase();
  }

  // Initialize Firebase only once
  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(); // Ensure Firebase is initialized
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  // Stream to fetch sentiment data in real-time for the logged-in user
  Stream<List<Map<String, dynamic>>> fetchSentimentDataStream() {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        print("No user logged in.");
        return Stream.value([]);
      }

      print('Current user: ${user.uid}');
      // Fetch the sentiments for the logged-in user
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sentiments')
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isEmpty) {
          print("No sentiment data found.");
        }
        return snapshot.docs.map((doc) {
          return {
            'text': doc['text'],
            'emotion': doc['emotion'],
            'date': doc['date'],
            'time': doc['time'],
            'containerColor': doc['containerColor'],
            'borderColor': doc['borderColor'],
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching sentiment data: $e");
      return Stream.value([]);
    }
  }

  // Function to store sentiment data in Firestore
  Future<void> storeSentimentData(
      String inputText,
      String emotion,
      String date,
      String time,
      Color containerColor,
      Color borderColor,
      ) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Add sentiment data under the logged-in user's UID
        await _firestore.collection('users').doc(user.uid).collection('sentiments').add({
          'text': inputText,
          'emotion': emotion,
          'date': date,
          'time': time,
          'containerColor': containerColor.value, // Color to int value
          'borderColor': borderColor.value, // Color to int value
        });

        print("Sentiment data stored successfully.");
      } else {
        print("User is not logged in.");
      }
    } catch (e) {
      print("Error storing sentiment data: $e");
    }
  }
}
