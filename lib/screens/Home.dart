import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:network_karo/screens/Event_Details.dart';
import 'package:network_karo/screens/Onboarding_3.dart';
import 'package:network_karo/screens/QRScanPage.dart';

import '../Data/Events.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String qrCodeImageUrl = '';
  List<Event> events = [];
  // int _selectedIndex = 0; // Index of the selected tab

  // // Define your tab views here
  // final List<Widget> _tabs = [
  //   // Home Tab
  //   Center(
  //     child: Text('Home Tab'),
  //   ),
  //   // Network Tab
  //   Center(
  //     child: Text('Network Tab'),
  //   ),
  //   // Profile Tab
  //   Center(
  //     child: Text('Profile Tab'),
  //   ),
  // ];
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

  void createEvent() {
    // Navigate to the Create Event page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Event_Details(),
      ),
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
    getQRCodeImageUrl(); // Fetch the QR code image URL when the page loads
  }

  Future<void> refreshEvents() async {
    setState(() {
      events = []; // Clear the existing events to show a loading state
    });
    await fetchEvents(); // Fetch events again
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        leading: IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => Onboarding_3(),
            // ));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              showQRCode(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshEvents,
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      child: ListTile(
                        title: Text(event.eventName),
                        subtitle: Text(
                          'Date: ${event.eventDate.toLocal()}, Time: ${event.eventTime}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.qr_code),
                          onPressed: () {
                            print(event.documentId);
                            // Open the QR code scanning page
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => QRScanPage(
                                    eventId: event
                                        .documentId), // Pass the document ID
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // if (qrCodeImageUrl.isNotEmpty)
            //   Image.network(
            //     qrCodeImageUrl,
            //     width: 200.0,
            //     height: 200.0,
            //   ),
            // const SizedBox(height: 20.0),
            // ElevatedButton(
            //   onPressed: () {
            //     getQRCodeImageUrl();
            //   },
            //   child: Text('Reload QR Code Image'),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createEvent,
        icon: const Icon(Icons.add),
        label: const Text('Create Event'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
