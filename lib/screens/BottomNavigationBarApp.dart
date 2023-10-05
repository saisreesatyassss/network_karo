import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:network_karo/screens/Get_started.dart';
import 'package:network_karo/screens/Home.dart';
import 'package:network_karo/screens/Network.dart';
import 'package:network_karo/screens/ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomNavigationBarApp extends StatefulWidget {
  @override
  _BottomNavigationBarAppState createState() => _BottomNavigationBarAppState();
}

class _BottomNavigationBarAppState extends State<BottomNavigationBarApp> {
  int _selectedIndex = 0; // Index of the selected tab
  bool _userSignedIn = false; // Track user sign-in status

  // Define your tab views here
  final List<Widget> _tabs = [
    Home(),
    NetworkPage(),
    ProfilePage(),
    // Add your other pages here
  ];

  // Function to handle tab selection
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method to check if the user is already signed in with Firebase Authentication
  Future<void> checkUserSignInStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userSignedIn = user != null;
    });
  }

  // Method to sign out the user and navigate to the GetStarted screen
  // Future<void> signOutUserAndNavigateToGetStarted() async {
  //   await FirebaseAuth.instance.signOut();
  //   setState(() {
  //     _userSignedIn = false; // User is signed out
  //   });

  //   // Navigate to the GetStarted screen
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (context) => Get_started(),
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    // Check the user's sign-in status when the widget initializes
    checkUserSignInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      // Use CupertinoTabScaffold
      tabBar: CupertinoTabBar(
        // Define your CupertinoTabBar
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home), // Use Cupertino icons
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.wifi), // Use Cupertino icons
            label: 'Network',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person), // Use Cupertino icons
            label: 'Profile',
          ),
          // Add BottomNavigationBarItems for your other pages here
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          // Use CupertinoTabView
          builder: (context) {
            if (_userSignedIn) {
              // Display the page with the bottom navigation bar for signed-in users
              return Scaffold(
                body: SafeArea(
                  child: _tabs[index],
                ),
                bottomNavigationBar: CupertinoTabBar(
                  currentIndex: _selectedIndex,
                  onTap: _onTabSelected,
                  // ignore: prefer_const_literals_to_create_immutables
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.home),
                      label: 'Home',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.wifi),
                      label: 'Network',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.person),
                      label: 'Profile',
                    ),
                    // Add BottomNavigationBarItems for your other pages here
                  ],
                ),
              );
            } else {
              // Display the page without the bottom navigation bar for signed-out users
              return SafeArea(child: _tabs[index]);
            }
          },
        );
      },
    );
  }
}
