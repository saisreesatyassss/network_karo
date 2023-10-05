import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  User? _user;
  User? get user => _user;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // Exit if sign-in was canceled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = authResult.user;

      if (user != null) {
        _user = user;
        notifyListeners();
        return user; // Return the signed-in user
      } else {
        print('Google Sign-In failed');
        return null;
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
      return null;
    }
  }
void saveProfileData({
  required TextEditingController fullNameController,
  required TextEditingController firstNameController,
  required TextEditingController lastNameController,
  required TextEditingController companyNameController,
  required TextEditingController titleController,
  required TextEditingController emailController,
  required TextEditingController cityController,
  required TextEditingController phoneNumberController,
  required TextEditingController websiteController,  
  required TextEditingController githubController,   
  required TextEditingController linkedinController, 
    String? profileImageUrl,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('profiles').doc(user?.uid).set({
      'full_name': fullNameController.text,
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'company_name': companyNameController.text,
      'title': titleController.text,
      'email': emailController.text,
      'city': cityController.text,
      'phone_number': phoneNumberController.text,
      'website': websiteController.text,  
      'github': githubController.text,    
      'linkedin': linkedinController.text,       
         'profileImageUrl': profileImageUrl, // Set the profile image URL

    });

    // Profile data successfully saved
  } catch (error) {
    // Handle any errors that occur during the save process
    print('Error saving profile data: $error');
  }
}


  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }
}
