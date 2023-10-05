import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:network_karo/screens/Onboarding_3.dart';
import 'package:provider/provider.dart';

import '../providers/google_sign_in.dart';

class Onboarding_2 extends StatefulWidget {
  final User? user;
  final TextEditingController fullNameController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController companyNameController;
  final TextEditingController titleController;
  final TextEditingController emailController;
  final TextEditingController cityController;
  final TextEditingController phoneNumberController;
  final TextEditingController websiteController;
  final TextEditingController githubController;
  final TextEditingController linkedinController;

  // Constructor to receive the controllers
  Onboarding_2({
    required this.user,
    required this.fullNameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.companyNameController,
    required this.titleController,
    required this.emailController,
    required this.cityController,
    required this.phoneNumberController,
    required this.websiteController,
    required this.githubController,
    required this.linkedinController,
  });

  @override
  State<Onboarding_2> createState() => _Onboarding_2State();
}

class _Onboarding_2State extends State<Onboarding_2> {
  // final TextEditingController websiteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding - Step 2'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Additional Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            // Text form fields for website, GitHub, and LinkedIn
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: widget.websiteController,
                    decoration: const InputDecoration(labelText: 'Website'),
                  ),
                  TextFormField(
                    controller: widget.githubController,
                    decoration: const InputDecoration(labelText: 'GitHub'),
                  ),
                  TextFormField(
                    controller: widget.linkedinController,
                    decoration: const InputDecoration(labelText: 'LinkedIn'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final googleSignInProvider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);

                googleSignInProvider.saveProfileData(
                  fullNameController: widget.fullNameController,
                  firstNameController: widget.firstNameController,
                  lastNameController: widget.lastNameController,
                  companyNameController: widget.companyNameController,
                  titleController: widget.titleController,
                  emailController: widget.emailController,
                  cityController: widget.cityController,
                  phoneNumberController: widget.phoneNumberController,
                  websiteController: widget.websiteController,
                  githubController: widget.githubController,
                  linkedinController: widget.linkedinController,
                  profileImageUrl: user?.photoURL,
                );

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        Onboarding_3(), // Pass the 'user' argument here
                  ),
                );
              },
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
