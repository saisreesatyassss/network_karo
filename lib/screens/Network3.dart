import 'dart:convert';

import 'package:flutter/material.dart';

class Network3 extends StatelessWidget {
  final Map<String, dynamic> scannedData;

  Network3({required this.scannedData});

  @override
  Widget build(BuildContext context) {
    final scannedDataJsonString = scannedData['scannedData'] as String;
    final scannedDataMap = jsonDecode(scannedDataJsonString);
    final fullName = scannedDataMap['full_name'] as String;
    final github = scannedDataMap['github'] as String;
    final linkedin = scannedDataMap['linkedin'] as String;
    final email = scannedDataMap['email'] as String;
    final profileImageURL = scannedDataMap['profileImageUrl'] as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profileImageURL),
              radius: 60,
            ),
            SizedBox(height: 20),
            Text(
              'Full Name: $fullName',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'GitHub: $github',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'LinkedIn: $linkedin',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
