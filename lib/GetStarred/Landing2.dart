import 'package:flutter/material.dart';
import 'package:seekhobuddy/GetStarred/Landing3.dart';

void main() {
  runApp(LandingPage2());
}

class LandingPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = constraints.maxWidth * 0.05;
        double containerWidth = constraints.maxWidth * 0.8;
        double fontSizeTitle = constraints.maxWidth * 0.08;
        double fontSizeSubtitle = constraints.maxWidth * 0.04;
        double imageSize = constraints.maxWidth * 0.5;

        return Scaffold(
          body: Column(
            children: [
              // Header content
              Container(
                color: Colors.black,
                height: kToolbarHeight, // Same height as the AppBar
              ),
              // Remaining content with background image
              Expanded(
                child: Stack(
                  children: [
                    // Background image with specific size
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft, // Shift image to left
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: Image.asset(
                            'assets/Landing2_BackGroud.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Overlay content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New Arrivals!',
                            style: TextStyle(
                              fontSize: fontSizeTitle, // Responsive font size
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: padding),
                          Container(
                            width: containerWidth,
                            padding: EdgeInsets.all(padding),
                            decoration: BoxDecoration(
                              color: Color(0xFF323232).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [],
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/Landing2_Book.png',
                                      width: imageSize, // Responsive image size
                                      height:
                                          imageSize, // Responsive image size
                                    ),
                                  ),
                                ),
                                SizedBox(height: padding),
                                Text(
                                  'Mathematics Guide',
                                  style: TextStyle(
                                    fontSize:
                                        fontSizeSubtitle, // Responsive font size
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: padding / 2),
                                Text(
                                  'This comprehensive guide covers key math concepts and problem-solving techniques to help you excel in your studies.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: fontSizeSubtitle *
                                        0.8, // Responsive font size
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: padding),
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigate to LandingPage3 with slide animation
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            LandingPage3(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          var offsetAnimation =
                                              animation.drive(tween);

                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                        transitionDuration: Duration(
                                            milliseconds:
                                                500), // Set transition duration to 500ms
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.black, // Background color
                                  ),
                                  child: Text(
                                    'Get now',
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
