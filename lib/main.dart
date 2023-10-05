import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:network_karo/providers/google_sign_in.dart';
import 'package:network_karo/screens/Event_Details.dart';
import 'package:network_karo/screens/Home.dart';
import 'package:network_karo/screens/Network.dart';
import 'package:network_karo/screens/Onboarding_1.dart';
// import 'package:network_karo/screens/Onboarding_2.dart';
import 'package:network_karo/screens/Onboarding_3.dart';
import 'package:network_karo/screens/ProfilePage.dart';
import 'package:network_karo/screens/QRScanPage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/BottomNavigationBarApp.dart';
import 'screens/Get_started.dart';
import 'screens/Opening.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyCXtnPCpJvAHKNN5kx_jghpCbMopZeYxxs",
      appId: "1:420742073318:web:dc3946b7554a5c3a772427",
      messagingSenderId: "420742073318",
      projectId: "network-karo",
      storageBucket: "network-karo.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
  }
  // await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
        // Add other providers if needed
      ],
      child: Phoenix(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set the initialRoute to '/Get_started' if you want '/Get_started' as the first screen.
      // initialRoute: '/ProfilePage',

      // Define routes
      routes: {
        '/': (context) => const Opening(),
        // '/Get_started': (context) => const Get_started(),
        '/Onboarding_1': (context) => const Onboarding_1(),
        // '/Onboarding_2': (context) => Onboarding_2( ),
        // '/Onboarding_3': (context) => Onboarding_3(),
        '/BottomNavigationBarApp': (context) => BottomNavigationBarApp(),
        '/Home': (context) => Home(),
        '/NetworkPage': (context) => NetworkPage(),
        '/ProfilePage': (context) => ProfilePage(),
        '/Event_Details': (context) => Event_Details(),
        // '/QRScanPage': (context) => QRScanPage(),
      },
    );
  }
}
