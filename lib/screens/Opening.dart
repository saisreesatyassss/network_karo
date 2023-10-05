import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
// import 'package:network_karo/screens/Get_started.dart';
// import 'package:network_karo/screens/Home.dart';

class Opening extends StatelessWidget {
  const Opening({Key? key});

  // Method to check if the user is already signed in with Firebase Authentication
  Future<bool> isUserSignedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    // Determine the initial route based on the user's sign-in status
    return FutureBuilder<bool>(
      future: isUserSignedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state, you can show a loading indicator here
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Error state, handle the error as needed
          return Text('Error: ${snapshot.error}');
        } else {
          // User is signed in or not, navigate to the appropriate page
          final initialRoute =
              snapshot.data! ? '/BottomNavigationBarApp' : '/Get_started';
          return Scaffold(
            body: Center(
              child: GestureDetector(
                onTap: () {
                  // Navigate to the appropriate page based on the initial route
                  Navigator.pushNamed(context, initialRoute);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: SvgPicture.asset(
                    'assets/logo.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
