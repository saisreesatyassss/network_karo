import 'package:flutter/material.dart';

class Event {
   final String documentId; // Add a field to store the document ID

  final String eventName;
  final DateTime eventDate;
  final String eventTime;
  final String eventDescription;
  final List<String> tags;  final String userId; // Add a userId field


  Event({   
     required this.documentId, // Include it in the constructor

    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventDescription,
    required this.tags,    required this.userId, // Initialize userId in the constructor

  });
  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'eventName': eventName,
      'eventDate': eventDate,
      'eventTime': eventTime,
      'eventDescription': eventDescription,
      'tags': tags,
            'userId': userId, // Include userId in the map

    };
  }
}
