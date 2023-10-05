import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

import '../providers/google_sign_in.dart';
import '../widgets/Google_sign_in_button.dart';

class Get_started extends StatelessWidget {
  const Get_started({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Network Karo',
              style: TextStyle(
                  color: Color(0xFF00AF54),
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SvgPicture.asset(
              'assets/people-talking.svg',
              width: 300.0,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Image.asset(
                  'assets/linkedin_logo.png',
                  width: 24.0,
                ),
                label: const Text('Continue with LinkedIn'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0078D4),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Google_sign_in_button(),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                final googleSignInProvider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);

                // Attempt to sign in with Google
                await googleSignInProvider.signOut();
              },
              child: const Text('Already a member? Log In',
                  style: TextStyle(color: Color(0xFF00AF54))),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('When you sign up, you accept our ',
                    style: TextStyle(color: Colors.black54)),
                Text('Terms of Service',
                    style: TextStyle(color: Color(0xFF00AF54))),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(' and ', style: TextStyle(color: Colors.black54)),
                Text('Privacy Policy',
                    style: TextStyle(color: Color(0xFF00AF54))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
