import 'package:flutter/material.dart';
import 'package:seekhobuddy/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(Newhelp());
}

class Newhelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyWidget(),
      theme: ThemeData.dark(),
    );
  }
}

Future<Map<String, dynamic>> fetchUserData() async {
  Map<String, dynamic> userData = {};

  User? user = FirebaseAuth.instance.currentUser; // Get current user

  if (user != null) {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      userData = querySnapshot.docs.first.data();
    }
  }

  return userData;
}

final _formKey = GlobalKey<FormState>();

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.only(
                  top: isDesktop ? 40 : 20,
                  left: isDesktop ? 40 : 20,
                  right: isDesktop ? 40 : 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                  );
                                },
                              ),
                              SizedBox(width: isDesktop ? 20 : 10),
                              Text(
                                "Help Page",
                                style: TextStyle(
                                  fontSize: isDesktop ? 36 : 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: isDesktop ? 40 : 20),
                      Card(
                        color: Color(0xFF323232),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 52 : 26),
                        child: Padding(
                          padding: EdgeInsets.all(isDesktop ? 32 : 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'For Help, Please Contact Us',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isDesktop ? 24 : 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: isDesktop ? 20 : 10),
                              Text(
                                'Email: seekhobuddy@gmail.com',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isDesktop ? 18 : 16,
                                ),
                              ),
                              SizedBox(height: isDesktop ? 20 : 10),
                              Text(
                                'You can email us with your detailed issue, and we will get back to you as soon as possible. Thank you!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isDesktop ? 18 : 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isDesktop ? 20 : 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        },
                        child: Text(
                          'Go Back to Home',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 24 : 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF323232),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: isDesktop ? 20 : 15,
                            horizontal: isDesktop ? 80 : 60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.black87,
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isImageRight;
  final String linkedinUrl;

  ProfileCard({
    required this.name,
    required this.imageUrl,
    required this.isImageRight,
    required this.linkedinUrl,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        final imageSize = isDesktop ? 200.0 : constraints.maxWidth * 0.3;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 32 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isImageRight) ...[
                Container(
                  margin: EdgeInsets.only(left: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: isDesktop ? 40 : 20),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isDesktop ? 16 : 8),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 24 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'B.Tech 4th Year',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 20 : 16,
                    ),
                  ),
                  SizedBox(height: isDesktop ? 16 : 8),
                  InkWell(
                    onTap: () async {
                      if (await canLaunch(linkedinUrl)) {
                        await launch(linkedinUrl);
                      } else {
                        throw 'Could not launch $linkedinUrl';
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 16 : 8,
                        vertical: isDesktop ? 8 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/linkedin_icon.png',
                            width: isDesktop ? 32 : 24,
                            height: isDesktop ? 32 : 24,
                          ),
                          SizedBox(width: isDesktop ? 8 : 4),
                          Text(
                            'LinkedIn',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: isDesktop ? 18 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (isImageRight) ...[
                SizedBox(width: isDesktop ? 40 : 20),
                Container(
                  margin: EdgeInsets.only(left: isDesktop ? 40 : 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
