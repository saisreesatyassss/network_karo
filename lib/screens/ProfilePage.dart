import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
// import 'package:network_karo/screens/Get_started.dart';
// import 'package:network_karo/screens/Onboarding_1.dart';
// import 'package:network_karo/screens/Opening.dart';
// import 'package:network_karo/screens/QRScanPage.dart';
import 'package:provider/provider.dart';

import '../providers/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 60,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const AssetImage('assets/upload.png') as ImageProvider,
              ),
              const SizedBox(height: 20),
              Text(
                "Hello, ${user?.displayName ?? 'Guest'}",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Edit Profile Page
                  // Replace with your navigation code
                },
                child: const Text('Edit Profile'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Card-related Page
                  // Replace with your navigation code
                },
                child: const Text('Card Page'),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final googleSignInProvider =
                        Provider.of<GoogleSignInProvider>(context,
                            listen: false);

                    // Show a confirmation dialog before signing out
                    bool confirmSignOut = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Sign Out'),
                          content: Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Sign Out'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmSignOut == true) {
                      // User confirmed sign-out, proceed
                      await googleSignInProvider.signOut();
                      // ignore: use_build_context_synchronously
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //   builder: (context) => const Opening(),
                      // ));
                      Phoenix.rebirth(context);
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (_) => QRScanPage()));
                },
                child: const Text('Scan QR Code'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
