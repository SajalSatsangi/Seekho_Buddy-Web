import 'package:flutter/material.dart';
import 'package:seekhobuddy/LoginPage.dart';

void main() {
  runApp(LandingPage3());
}

class LandingPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MembershipPage(),
    );
  }
}

class MembershipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth * 0.05;
          double iconSize = constraints.maxWidth * 0.12;
          double fontSizeTitle = constraints.maxWidth * 0.06;
          double fontSizeSubtitle = constraints.maxWidth * 0.04;
          double containerPadding = constraints.maxWidth * 0.03;
          double buttonPaddingVertical = constraints.maxHeight * 0.02;
          double buttonPaddingHorizontal = constraints.maxWidth * 0.1;

          return Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Love our resources?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSizeTitle,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: padding),
                Text(
                  'Join our annual membership and enjoy a 40% discount! Plus, receive an extra study guide as a bonus. No commitments, easy cancellation.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: fontSizeSubtitle,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: padding * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildIconButton(Icons.colorize, 'Select your\nfavorite',
                        iconSize, fontSizeSubtitle, containerPadding),
                    _buildIconButton(Icons.timeline, 'Choose\nmembership',
                        iconSize, fontSizeSubtitle, containerPadding),
                    _buildIconButton(Icons.cancel, 'Cancel\nanytime', iconSize,
                        fontSizeSubtitle, containerPadding),
                  ],
                ),
                SizedBox(height: padding * 2),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800], // background
                    foregroundColor: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            LoginPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin =
                              Offset(1.0, 0.0); // Slide from right to left
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: buttonPaddingVertical,
                      horizontal: buttonPaddingHorizontal,
                    ),
                    child: Text('Join now'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, double iconSize,
      double fontSize, double padding) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(50, 50, 50, 1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon),
            color: Colors.white,
            iconSize: iconSize,
            onPressed: () {},
          ),
        ),
        SizedBox(height: padding),
        Container(
          padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
          decoration: BoxDecoration(
            color: Color.fromRGBO(50, 50, 50, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Color.fromARGB(179, 255, 255, 255),
              fontSize: fontSize,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
