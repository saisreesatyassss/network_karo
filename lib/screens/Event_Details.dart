import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:network_karo/screens/Home.dart';

import '../Data/Events.dart';

class Event_Details extends StatefulWidget {
  const Event_Details({Key? key}) : super(key: key);

  @override
  _Event_DetailsState createState() => _Event_DetailsState();
}

class _Event_DetailsState extends State<Event_Details> {
  // Define variables to store form values
  String eventName = '';
  DateTime? eventDate;
  TimeOfDay? eventTime;
  String eventDescription = '';
  List<String> selectedTags = [];

  // Define a list of available tags
  final List<String> availableTags = [
    'Tag 1',
    'Tag 2',
    'Tag 3',
    'Tag 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Event Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Event Name *'),
              onChanged: (value) {
                setState(() {
                  eventName = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: const Text('Date *'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );

                if (selectedDate != null) {
                  setState(() {
                    eventDate = selectedDate;
                  });
                }
              },
              subtitle: Text(
                eventDate != null
                    ? '${eventDate!.toLocal()}'.split(' ')[0]
                    : 'Select a date',
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: const Text('Time *'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (selectedTime != null) {
                  setState(() {
                    eventTime = selectedTime;
                  });
                }
              },
              subtitle: Text(
                eventTime != null
                    ? '${eventTime!.hour}:${eventTime!.minute}'
                    : 'Select a time',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Event Description'),
              onChanged: (value) {
                setState(() {
                  eventDescription = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              'What is the event about?',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              children: availableTags.map((tag) {
                return ChoiceChip(
                  label: Text(tag),
                  selected: selectedTags.contains(tag),
                  onSelected: (selected) {
                    setState(() {
                      if (selectedTags.contains(tag)) {
                        selectedTags.remove(tag);
                      } else {
                        if (selectedTags.length < 4) {
                          selectedTags.add(tag);
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save the event details and create a card in the home page
                saveEvent();
              },
              child: const Text('Save Event'),
            ),
          ],
        ),
      ),
    );
  }

//   void saveEvent() {
//     final user = FirebaseAuth.instance.currentUser;

//     // Ensure that all required fields are filled before saving
//     if (eventName.isNotEmpty &&
//         eventDate != null &&
//         eventTime != null &&
//         user != null) {
//       final eventTimeAsString = '${eventTime?.hour}:${eventTime?.minute}';
//       final event = Event(
//         // documentId: event.documentId, // Use the custom document ID here

//         eventName: eventName,
//         eventDate: eventDate!,
//         eventTime: eventTimeAsString,
//         eventDescription: eventDescription,
//         tags: selectedTags,
//         userId: user.uid,
//         // documentId: '',
//       );

//       // Get a reference to the Firestore collection
//       final CollectionReference eventsCollection =
//           FirebaseFirestore.instance.collection('events');

//       // Add the event to Firestore
//       eventsCollection.add(event.toMap()).then((eventDoc) {
//         // Event successfully added to Firestore
//         print('Event added with ID: ${eventDoc.id}');
// //here store in fire base eventDoc.id
//         // Navigator.of(context).pop();
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => Home(),
//           ),
//         );
//       }).catchError((error) {
//         // Handle any errors that occur during the Firestore operation
//         print('Error adding event: $error');
//       });
//     } else {
//       // Show an error message to the user if required fields are missing
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Error'),
//             content: const Text('Please fill in all required fields.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
  void saveEvent() {
    final user = FirebaseAuth.instance.currentUser;

    // Ensure that all required fields are filled before saving
    if (eventName.isNotEmpty &&
        eventDate != null &&
        eventTime != null &&
        user != null) {
      final eventTimeAsString = '${eventTime?.hour}:${eventTime?.minute}';
      final event = Event(
        eventName: eventName,
        eventDate: eventDate!,
        eventTime: eventTimeAsString,
        eventDescription: eventDescription,
        tags: selectedTags,
        userId: user.uid, documentId: '',
      );

      // Get a reference to the Firestore collection
      final CollectionReference eventsCollection =
          FirebaseFirestore.instance.collection('events');

      // Add the event to Firestore
      eventsCollection.add(event.toMap()).then((eventDoc) {
        // Event successfully added to Firestore
        print('Event added with ID: ${eventDoc.id}');

        // Update the event document to include the eventDoc.id as a field
        eventDoc.update({'documentId': eventDoc.id}).then((_) {
          print('Event ID stored in Firestore document');
        }).catchError((error) {
          print('Error storing Event ID in Firestore document: $error');
        });

        // Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      }).catchError((error) {
        // Handle any errors that occur during the Firestore operation
        print('Error adding event: $error');
      });
    } else {
      // Show an error message to the user if required fields are missing
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all required fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
