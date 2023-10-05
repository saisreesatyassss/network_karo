import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:network_karo/screens/Event_Details.dart';
// import 'package:network_karo/screens/Onboarding_3.dart';
// import 'package:network_karo/screens/QRScanPage.dart';

import '../Data/Events.dart';
import 'Network2.dart';

class NetworkPage extends StatefulWidget {
  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  String qrCodeImageUrl = '';
  List<Event> events = [];

  Future<void> getQRCodeImageUrl() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final storage = FirebaseStorage.instance;
        final ref = storage.ref().child('qrcodes').child('${user.uid}.png');
        final downloadURL = await ref.getDownloadURL();

        setState(() {
          qrCodeImageUrl = downloadURL;
        });
      }
    } catch (e) {
      print('Error fetching QR code image URL: $e');
    }
  }

  // Function to show the QR code dialog or bottom sheet
  void showQRCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(
                qrCodeImageUrl,
                width: 200.0,
                height: 200.0,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to fetch events from Firestore
  Future<void> fetchEvents() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User is not authenticated.');
        return;
      }
      print('User UID: ${user.uid}');
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final eventsQuery =
            firestore.collection('events').where('userId', isEqualTo: user.uid);

        final querySnapshot = await eventsQuery.get();

        final List<Event> fetchedEvents = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          // Print the data for debugging
          print('Fetched Event Data: $data');
          return Event(
            documentId: data['documentId'],
            eventName: data['eventName'],
            eventDate: data['eventDate'].toDate(),
            eventTime: data['eventTime'],
            eventDescription: data['eventDescription'],
            tags: List<String>.from(data['tags']),
            userId: data['userId'],
          );
        }).toList();
        print(events.length);
        setState(() {
          events = fetchedEvents;
        });
      }
    } catch (e) {
      print('Error fetching events: $e');
    }
  } // Function to handle tab selection

  // void _onTabSelected(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
  @override
  void initState() {
    super.initState();
    fetchEvents();
    getQRCodeImageUrl();
  }

  Future<void> refreshEvents() async {
    setState(() {
      events = []; // Clear the existing events to show a loading state
    });
    await fetchEvents(); // Fetch events again
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchEvents(); // Refresh events when the screen is opened
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NetworkPage Page'),
        // ...
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshEvents,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('events')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading indicator while data is being fetched
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    // Process the data from Firestore and build your UI here
                    final List<Event> events = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Event(
                        documentId: data['documentId'],
                        eventName: data['eventName'],
                        eventDate: data['eventDate'].toDate(),
                        eventTime: data['eventTime'],
                        eventDescription: data['eventDescription'],
                        tags: List<String>.from(data['tags']),
                        userId: data['userId'],
                      );
                    }).toList();

                    return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    Network2(event: events[index]),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(event.eventName),
                              subtitle: Text(
                                'Date: ${event.eventDate.toLocal()}, Time: ${event.eventTime}',
                              ),
                            ),
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
    );
  }
}
