// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../Data/Events.dart';

// class Network2 extends StatelessWidget {
//   final Event event;

//   Network2({required this.event});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(event.eventName),
//       ),
//       body: FutureBuilder(
//         future: fetchScannedData(event.documentId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             final scannedDataList = snapshot.data as List<Map<String, dynamic>>;

//             if (scannedDataList.isEmpty) {
//               return const Text('No scanned data available');
//             }

//             return Padding(
//               padding: const EdgeInsets.all(28.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   for (Map<String, dynamic> scannedData in scannedDataList)
//                     _buildScannedDataCard(scannedData),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildScannedDataCard(Map<String, dynamic> scannedData) {
//     final scannedDataJsonString = scannedData['scannedData'] as String;
//     final scannedDataMap = jsonDecode(scannedDataJsonString);
//     print(' $scannedDataJsonString');
//     final fullName = scannedDataMap['full_name'] as String;
//     final github = scannedDataMap['github'] as String;
//     final linkedin = scannedDataMap['linkedin'] as String;
//     final email = scannedDataMap['email'] as String;
//     // final profileImageURL = scannedDataMap['profileImageUrl'] as String;

//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.all(8),
//       child: ListTile(
//         // leading: CircleAvatar(
//         //   backgroundImage:
//         //       NetworkImage(profileImageURL), // Load profile image from URL
//         //   radius: 30,
//         // ),
//         title: Text(
//           'Full Name: $fullName',
//           style: const TextStyle(fontSize: 18),
//         ),
//         subtitle: Row(
//           children: [
//             GestureDetector(
//               onTap: () async {
//                 if (await canLaunch(github)) {
//                   await launch(github);
//                 } else {
//                   print('Could not launch GitHub URL');
//                 }
//               },
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Icon(Icons.link,
//                     color: Colors.blue, size: 24), // Smaller icon
//               ),
//             ),
//             GestureDetector(
//               onTap: () async {
//                 if (await canLaunch(linkedin)) {
//                   await launch(linkedin);
//                 } else {
//                   print('Could not launch LinkedIn URL');
//                 }
//               },
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Icon(Icons.link,
//                     color: Colors.blue, size: 24), // Smaller icon
//               ),
//             ),
//             GestureDetector(
//               onTap: () async {
//                 // ignore: deprecated_member_use
//                 if (await canLaunch('mailto:$email')) {
//                   await launch('mailto:$email');
//                 } else {
//                   print('Could not send email');
//                 }
//               },
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Icon(Icons.email,
//                     color: Colors.blue, size: 24), // Smaller icon
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<List<Map<String, dynamic>>> fetchScannedData(String eventId) async {
//     try {
//       final firestore = FirebaseFirestore.instance;
//       final eventDocumentRef = firestore.collection('events').doc(eventId);
//       final eventMembersCollection =
//           eventDocumentRef.collection('eventmembers');
//       final querySnapshot = await eventMembersCollection.get();

//       final List<Map<String, dynamic>> scannedDataList = [];

//       querySnapshot.docs.forEach((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         scannedDataList.add(data);
//       });

//       return scannedDataList;
//     } catch (e) {
//       print('Error fetching scanned data: $e');
//       return []; // Return an empty list in case of an error.
//     }
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:network_karo/screens/Network3.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Data/Events.dart';
import 'Network.dart';

class Network2 extends StatelessWidget {
  final Event event;

  Network2({required this.event});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Handle the back button press
      onWillPop: () async {
        // Navigate back to the previous page or pop the current page
        // Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NetworkPage(),
          ),
        );
        return true; // Allow the back button press
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(event.eventName),
        ),
        body: FutureBuilder(
          future: fetchScannedData(event.documentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final scannedDataList =
                  snapshot.data as List<Map<String, dynamic>>;

              if (scannedDataList.isEmpty) {
                return const Text('No scanned data available');
              }

              return ListView.builder(
                itemCount: scannedDataList.length,
                itemBuilder: (context, index) {
                  final scannedData = scannedDataList[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Network3 and pass the scannedData to it
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              Network3(scannedData: scannedData),
                        ),
                      );
                    },
                    child: _buildScannedDataCard(scannedData),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildScannedDataCard(Map<String, dynamic> scannedData) {
    final scannedDataJsonString = scannedData['scannedData'] as String;
    final scannedDataMap = jsonDecode(scannedDataJsonString);
    final fullName = scannedDataMap['full_name'] as String;
    final github = scannedDataMap['github'] as String;
    final linkedin = scannedDataMap['linkedin'] as String;
    final email = scannedDataMap['email'] as String;
    final profileImageURL = scannedDataMap['profileImageUrl'] as String;

//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.all(8),
//       child: ListTile(
//         // leading: CircleAvatar(
//         //   backgroundImage:
//         //       NetworkImage(profileImageURL), // Load profile image from URL
//         //   radius: 30,
//         // ),
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              NetworkImage(profileImageURL), // Load profile image from URL
          radius: 30,
        ),
        title: Text(
          'Full Name: $fullName',
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Row(
          children: [
            GestureDetector(
              onTap: () async {
                if (await canLaunch(github)) {
                  await launch(github);
                } else {
                  print('Could not launch GitHub URL');
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.link,
                    color: Colors.blue, size: 24), // Smaller icon
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (await canLaunch(linkedin)) {
                  await launch(linkedin);
                } else {
                  print('Could not launch LinkedIn URL');
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.link,
                    color: Colors.blue, size: 24), // Smaller icon
              ),
            ),
            GestureDetector(
              onTap: () async {
                // ignore: deprecated_member_use
                if (await canLaunch('mailto:$email')) {
                  await launch('mailto:$email');
                } else {
                  print('Could not send email');
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.email,
                    color: Colors.blue, size: 24), // Smaller icon
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchScannedData(String eventId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final eventDocumentRef = firestore.collection('events').doc(eventId);
      final eventMembersCollection =
          eventDocumentRef.collection('eventmembers');
      final querySnapshot = await eventMembersCollection.get();

      final List<Map<String, dynamic>> scannedDataList = [];

      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;
        scannedDataList.add(data);
      });

      return scannedDataList;
    } catch (e) {
      print('Error fetching scanned data: $e');
      return []; // Return an empty list in case of an error.
    }
  }
}
