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
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine if it's a desktop layout
          bool isDesktop = constraints.maxWidth > 600;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/Get_Start.png',
                      width: isDesktop ? 400 : constraints.maxWidth * 0.8,
                      height: isDesktop ? 300 : constraints.maxWidth * 0.6,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Welcome to Our Seekho Buddy App!',
                      style: TextStyle(
                        fontSize: isDesktop ? 32 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Discover a world of study material at your fingertips connect with other students, access previous year question papers, notes and books. Join Study groups for collaborative learning experience',
                      style: TextStyle(
                        fontSize: isDesktop ? 18 : 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
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
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text('Start learning', style: TextStyle(fontSize: isDesktop ? 18 : 16)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}