import 'package:flutter/material.dart';

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
            Image.asset(
              'assets/business_deal.png',
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
              child: ElevatedButton.icon(
                icon: Image.asset(
                  'assets/google_logo.png',
                  width: 24.0,
                ),
                onPressed: () {},
                label: const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: const Text('Already a member? Log In',
                  style: TextStyle(color: Color(0xFF00AF54))),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('When you sign up, you accept our ',
                    style: TextStyle(color: Colors.black54)),
                const Text('Terms of Service',
                    style: TextStyle(color: Color(0xFF00AF54))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(' and ', style: TextStyle(color: Colors.black54)),
                const Text('Privacy Policy',
                    style: TextStyle(color: Color(0xFF00AF54))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
