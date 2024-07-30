import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'Getstarred/landing.dart';
import 'package:pwa_install/pwa_install.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PWAInstall().setup(installCallback: () {
    debugPrint('APP INSTALLED!');
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedSplashScreen(
              splash: "assets/spalshScreenGif.gif",
              splashIconSize: constraints.maxWidth * 4,
              nextScreen: AuthWrapper(),
              duration: 2950,
              splashTransition: SplashTransition.fadeTransition,
              backgroundColor: Color.fromARGB(255, 0, 0, 0),
              pageTransitionType: PageTransitionType.fade,
              animationDuration: Duration(milliseconds: 10),
            );
          },
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LandingPage();
          } else {
            return Home(); // Navigate to home if user is logged in
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}