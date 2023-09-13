import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:network_karo/screens/Get_started.dart';

class Opening extends StatelessWidget {
  const Opening({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate to the next page when the container is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Get_started()),
            );
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
}
