import 'package:flutter/material.dart';
import 'package:seekhobuddy/LoginPage.dart';
import 'package:pwa_install/pwa_install.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LandingPage());
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seekho Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: StudyHubScreen(),
    );
  }
}

class StudyHubScreen extends StatefulWidget {
  @override
  _StudyHubScreenState createState() => _StudyHubScreenState();
}

class _StudyHubScreenState extends State<StudyHubScreen> {
  final TextStyle appBarTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  String? error;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double imageWidth = constraints.maxWidth * 0.8;
        double imageHeight = constraints.maxHeight * 0.4;
        double padding = constraints.maxWidth * 0.06;

        return Scaffold(
          backgroundColor: Color(0xFF161616),
          appBar: AppBar(
            title: Text(
              'Seekho Buddy',
              style: appBarTextStyle,
            ),
            backgroundColor: Color(0xFF161616),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/Get_Start.png',
                  width: imageWidth,
                  height: imageHeight,
                ),
                SizedBox(height: padding / 2),
                Text(
                  'Welcome to Our Seekho Buddy App!',
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: padding / 4),
                Text(
                  'Discover a world of study material at your fingertips connect with other students, access previous year question papers, notes and books. Join Study groups for collaborative learning experience',
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.04,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: padding),
                Text('Launch Mode: ${PWAInstall().launchMode?.shortLabel}'),
                Text('Has Install Prompt: ${PWAInstall().hasPrompt}'),
                if(PWAInstall().installPromptEnabled)
                  ElevatedButton(
                    onPressed: () {
                      try {
                        PWAInstall().promptInstall_();
                      } catch (e) {
                        setState(() {
                          error = e.toString();
                        });
                      }
                    },
                    child: Text('Install as App'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                if (error != null) Text(error!, style: TextStyle(color: Colors.red)),
                SizedBox(height: padding),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            LoginPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: Text('Start learning'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}