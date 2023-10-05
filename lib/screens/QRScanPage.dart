import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRScanPage extends StatefulWidget {
  final String eventId;

  QRScanPage({required this.eventId});

  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  late QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _showResult = false;
  late String _scanResult;
  bool _scanned = false; // Flag to track if a scan has occurred

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          // Expanded(
          //   flex: 5,
          //   child: QRView(
          //     key: _qrKey,
          //     onQRViewCreated: _onQRViewCreated,
          //   ),
          // ),
          Expanded(
            // flex: 5,
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.8, // Adjust the width as needed
              // height: MediaQuery.of(context).size.height *
              //     0.5, // Adjust the height as needed
              // height: 100,
              child: QRView(
                key: _qrKey,
                onQRViewCreated: _onQRViewCreated,
                // formatsAllowed: [BarcodeFormat.qrcode],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Center(
              child: _showResult
                  ? Text(
                      'Result: $_scanResult',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const Text(
                      'Scan a QR code',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     _controller = controller;
  //   });

  //   _controller.scannedDataStream.listen((scanData) async {
  //     if (!_scanned) {
  //       setState(() {
  //         _showResult = true;
  //         _scanResult = scanData.code!;
  //         _scanned = true; // Set the flag to true to prevent further scans
  //       });

  //       try {
  //         final user = FirebaseAuth.instance.currentUser;
  //         if (user != null) {
  //           final firestore = FirebaseFirestore.instance;
  //           final eventDocumentRef =
  //               firestore.collection('events').doc(widget.eventId);
  //           final eventMembersCollection =
  //               eventDocumentRef.collection('eventmembers');

  //           final eventMemberDocRef = eventMembersCollection.doc(user.uid);

  //           final eventMemberData = {
  //             'userId': user.uid,
  //             'scannedData': _scanResult,
  //             'timestamp': FieldValue.serverTimestamp(),
  //           };

  //           await eventMemberDocRef.set(
  //               eventMemberData, SetOptions(merge: true));

  //           print('Event member data updated/added for user: ${user.uid}');

  //           // ignore: use_build_context_synchronously
  //           Navigator.of(context).pop(); // Close the page after the scan
  //         }
  //       } catch (e) {
  //         print('Error updating scanned data: $e');
  //       }
  //     }
  //   });
  // }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });

    _controller.scannedDataStream.listen((scanData) async {
      if (!_scanned) {
        setState(() {
          _showResult = true;
          _scanResult = scanData.code!;
          _scanned = true; // Set the flag to true to prevent further scans
        });

        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final firestore = FirebaseFirestore.instance;
            final eventDocumentRef =
                firestore.collection('events').doc(widget.eventId);
            final eventMembersCollection =
                eventDocumentRef.collection('eventmembers');

            // Use 'add' instead of 'set' to add a new document for each scan
            final eventMemberData = {
              'userId': user.uid,
              'scannedData': _scanResult,
              'timestamp': FieldValue.serverTimestamp(),
            };

            await eventMembersCollection.add(eventMemberData);

            print('Event member data added for user: ${user.uid}');

            // ignore: use_build_context_synchronously
            Navigator.of(context).pop(); // Close the page after the scan
          }
        } catch (e) {
          print('Error adding scanned data: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
