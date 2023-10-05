import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:network_karo/screens/BottomNavigationBarApp.dart';
import 'package:network_karo/screens/Onboarding_1.dart';
import 'package:screenshot/screenshot.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';

// import 'Home.dart';

class Onboarding_3 extends StatefulWidget {
  @override
  State<Onboarding_3> createState() => _Onboarding_3State();
}

class _Onboarding_3State extends State<Onboarding_3> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<Map<String, dynamic>> fetchProfileData(User? user) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final document =
          await firestore.collection('profiles').doc(user?.uid).get();
      if (document.exists) {
        // Convert the Firestore document data to a Map
        return document.data() as Map<String, dynamic>;
      }
    } catch (error) {
      // Handle any errors that occur during data retrieval
      print('Error fetching profile data: $error');
    }

    return {}; // Return an empty map if data retrieval fails
  }

  Future<String> createJsonFromData(User? user) async {
    final profileData = await fetchProfileData(user);
    final json = jsonEncode(profileData);
    return json;
  }

  Future<void> uploadQRCodeToStorage(Uint8List imgBytes) async {
    final user = FirebaseAuth.instance.currentUser;
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('qrcodes').child('${user?.uid}.png');

    try {
      // Upload the QR code image to Firebase Storage
      await ref.putData(imgBytes);

      // Get the download URL of the uploaded image
      final downloadURL = await ref.getDownloadURL();
      print('QR Code URL: $downloadURL');
    } catch (e) {
      print('Error uploading QR code image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding - Step 3'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Onboarding_1(),
              ),
            );
          },
        ),
      ),
      body: FutureBuilder<User?>(
        future: getCurrentUser(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (userSnapshot.hasError || !userSnapshot.hasData) {
            return const Center(
                child: Text('Error: Unable to retrieve user data.'));
          }

          final user = userSnapshot.data;

          return FutureBuilder<String>(
            future: createJsonFromData(user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final qrData = snapshot.data!;
                print('QR Data from Firebase: $qrData');

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Screenshot(
                        controller: screenshotController,
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final imgBytes = await screenshotController.capture();

                          if (imgBytes != null) {
                            // Upload the QR code image to Firebase Storage
                            uploadQRCodeToStorage(imgBytes);
                          }

                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  BottomNavigationBarApp(), // Replace with your new page widget
                            ),
                          );
                        },
                        child: const Text('Capture and Upload'),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No data available.'));
              }
            },
          );
        },
      ),
    );
  }
}
