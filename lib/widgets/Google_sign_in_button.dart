import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:network_karo/screens/Onboarding_1.dart';
import 'package:provider/provider.dart';

import '../providers/google_sign_in.dart';




class Google_sign_in_button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);

    return ElevatedButton.icon(
      icon: Image.asset(
        'assets/google_logo.png',
        width: 24.0,
      ),
      onPressed: () async {
        final user = await googleSignInProvider.signInWithGoogle();

        if (user != null) {
          // User is signed in, navigate to the destination screen
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Onboarding_1(),
            ),
          );
        } else {
          // Handle sign-in error, if any 
        }
      },
      label: const Text('Continue with Google'),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}
