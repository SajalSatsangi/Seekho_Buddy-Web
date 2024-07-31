import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
    FirebaseAnalytics.instance.logEvent(name: 'app_installed');
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
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
            FirebaseAnalytics.instance.logEvent(name: 'login_page_view');
            return LandingPage();
          } else {
            _logUserProperties(user);
            return Home();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _logUserProperties(User user) async {
    await FirebaseAnalytics.instance.setUserId(id: user.uid);
    await FirebaseAnalytics.instance.setUserProperty(
      name: 'last_login',
      value: DateTime.now().toIso8601String(),
    );
    await FirebaseAnalytics.instance.setUserProperty(
      name: 'account_created',
      value: user.metadata.creationTime?.toIso8601String() ?? 'unknown',
    );
    await FirebaseAnalytics.instance.logEvent(
      name: 'user_login',
      parameters: {
        'user_id': user.uid,
        'email_verified': user.emailVerified.toString(),
      },
    );
    await FirebaseAnalytics.instance.logEvent(name: 'home_page_view');
  }
}