import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:network_karo/screens/Get_started.dart';
import 'package:network_karo/screens/Onboarding_2.dart';
import 'package:provider/provider.dart';

import '../providers/google_sign_in.dart';

class Onboarding_1 extends StatefulWidget {
  const Onboarding_1({Key? key});

  @override
  State<Onboarding_1> createState() => _Onboarding_1State();
}

class _Onboarding_1State extends State<Onboarding_1> {
  @override
  Widget build(BuildContext context) {
    // TextEditingController fullNameController = TextEditingController();

    final user = FirebaseAuth.instance.currentUser;
    TextEditingController fullNameController = TextEditingController(
      text: user?.displayName ?? '',
    );
    TextEditingController emailController = TextEditingController(
      text: user?.email ?? '',
    );

    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController companyNameController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();

    // Define the controllers for website, GitHub, and LinkedIn here
    TextEditingController websiteController = TextEditingController();
    TextEditingController githubController = TextEditingController();
    TextEditingController linkedinController = TextEditingController();

    @override
    void dispose() {
      // Dispose of your controllers when the widget is disposed
      fullNameController.dispose();
      firstNameController.dispose();
      lastNameController.dispose();
      companyNameController.dispose();
      titleController.dispose();
      emailController.dispose();
      cityController.dispose();
      phoneNumberController.dispose();

      // Dispose of the website, GitHub, and LinkedIn controllers
      websiteController.dispose();
      githubController.dispose();
      linkedinController.dispose();

      super.dispose();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),

            // Display the profile picture
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage('assets/upload.png') as ImageProvider,
            ),
            Text(
              "Hello, ${user?.displayName ?? 'Guest'}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Create Your Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This will help us to generate your card, please fill reliable information.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Text form fields for name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: fullNameController,
                    // initialValue: user?.displayName ?? '',
                    decoration: const InputDecoration(labelText: 'Full Name'),
                  ),
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Text form fields for company info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: companyNameController,
                    decoration:
                        const InputDecoration(labelText: 'Company Name'),
                  ),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email ID'),
                  ),
                  TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () async {
            //     final googleSignInProvider =
            //         Provider.of<GoogleSignInProvider>(context, listen: false);

            //     googleSignInProvider.saveProfileData(
            //       fullNameController: fullNameController,
            //       firstNameController: firstNameController,
            //       lastNameController: lastNameController,
            //       companyNameController: companyNameController,
            //       titleController: titleController,
            //       emailController: emailController,
            //       cityController: cityController,
            //       phoneNumberController: phoneNumberController,
            //     );
            //   },
            //   child: const Text('Save Profile'),
            // ),
            ElevatedButton(
              onPressed: () async {
                final googleSignInProvider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);

                googleSignInProvider.saveProfileData(
                  fullNameController: fullNameController,
                  firstNameController: firstNameController,
                  lastNameController: lastNameController,
                  companyNameController: companyNameController,
                  titleController: titleController,
                  emailController: emailController,
                  cityController: cityController,
                  phoneNumberController: phoneNumberController,
                  websiteController: websiteController,
                  githubController: githubController,
                  linkedinController: linkedinController,
                  profileImageUrl: user?.photoURL,
                );

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Onboarding_2(
                      user: user,
                      fullNameController: fullNameController,
                      firstNameController: firstNameController,
                      lastNameController: lastNameController,
                      companyNameController: companyNameController,
                      titleController: titleController,
                      emailController: emailController,
                      cityController: cityController,
                      phoneNumberController: phoneNumberController,
                      websiteController:
                          websiteController, // Pass the website controller
                      githubController:
                          githubController, // Pass the GitHub controller
                      linkedinController:
                          linkedinController, // Pass the LinkedIn controller
                    ),
                  ),
                );
              },
              child: const Text('Continue'),
            ),

            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                final googleSignInProvider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                await googleSignInProvider.signOut();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Get_started(),
                  ),
                );
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Color(0xFF00AF54)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
