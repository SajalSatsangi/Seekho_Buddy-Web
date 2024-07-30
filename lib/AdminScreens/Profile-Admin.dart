import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seekhobuddy/AdminScreens/materialVerification.dart';
import 'package:seekhobuddy/AdminScreens/student_verification.dart';
import '../Profile/editprofile.dart';
import 'UsersData.dart';

class ProfileScreenAdmin extends StatelessWidget {
  ProfileScreenAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyHub',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userData = querySnapshot.docs.first;
        });

        print(userData!.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 600;

        double padding = isDesktop ? 40 : constraints.maxWidth * 0.08;
        double iconSize = isDesktop ? 30 : constraints.maxWidth * 0.07;
        double fontSizeTitle = isDesktop ? 32 : constraints.maxWidth * 0.06;
        double fontSizeSubtitle = isDesktop ? 18 : constraints.maxWidth * 0.04;
        double spacingHeight = isDesktop ? 20 : constraints.maxHeight * 0.02;
        double inputFontSize = isDesktop ? 16 : constraints.maxWidth * 0.035;

        return Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: EdgeInsets.only(
                  left: padding,
                  right: padding,
                  top: spacingHeight,
                  bottom: spacingHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: iconSize,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile()),
                          );
                        },
                      ),
                      Visibility(
                        visible: userData != null &&
                            (userData!['role'] == 'admin' ||
                                userData!['role'] == 'verificationist'),
                        child: IconButton(
                          icon: Icon(
                            Icons.request_page,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerificationApp()),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: userData != null &&
                            (userData!['role'] == 'admin' ||
                                userData!['role'] == 'dataeditor'),
                        child: IconButton(
                          icon: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => userdata()),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: userData != null &&
                            (userData!['role'] == 'admin' ||
                                userData!['role'] == 'dataeditor'),
                        child: IconButton(
                          icon: Icon(
                            Icons.book,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MaterialConfirmationScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: userData == null
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: spacingHeight),
                          Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: iconSize * 2,
                                  backgroundImage: NetworkImage(
                                      userData!['profile_picture']),
                                ),
                                SizedBox(height: spacingHeight),
                                Text(
                                  userData!['name'],
                                  style: TextStyle(
                                    fontSize: fontSizeTitle,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: spacingHeight * 0.25),
                                Text(
                                  userData!['email'],
                                  style: TextStyle(
                                    fontSize: fontSizeSubtitle,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: spacingHeight),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildInfoBox(
                                      label: 'University',
                                      text: 'Dayalbagh Educational Institute',
                                      icon: Icons.location_city,
                                      screenWidth: constraints.maxWidth,
                                      iconSize: iconSize,
                                      fontSize: inputFontSize,
                                    ),
                                    SizedBox(height: spacingHeight * 0.5),
                                    buildInfoBox(
                                      label: 'Roll Number',
                                      text: userData!['rollno'],
                                      icon: Icons.confirmation_number,
                                      screenWidth: constraints.maxWidth,
                                      iconSize: iconSize,
                                      fontSize: inputFontSize,
                                    ),
                                    SizedBox(height: spacingHeight * 0.5),
                                    buildInfoBox(
                                      label: 'Faculty',
                                      text: userData!['faculty'],
                                      icon: Icons.account_balance,
                                      screenWidth: constraints.maxWidth,
                                      iconSize: iconSize,
                                      fontSize: inputFontSize,
                                    ),
                                    SizedBox(height: spacingHeight * 0.5),
                                    buildInfoBox(
                                      label: 'Branch',
                                      text: userData!['subfaculty'],
                                      icon: Icons.category,
                                      screenWidth: constraints.maxWidth,
                                      iconSize: iconSize,
                                      fontSize: inputFontSize,
                                    ),
                                    SizedBox(height: spacingHeight * 0.5),
                                    buildInfoBox(
                                      label: 'Specialization',
                                      text: userData!['subbranch'],
                                      icon: Icons.spa,
                                      screenWidth: constraints.maxWidth,
                                      iconSize: iconSize,
                                      fontSize: inputFontSize,
                                    ),
                                    SizedBox(height: spacingHeight * 0.5),
                                    buildInfoBox(
                                      label: 'Semester',
                                      text: userData!['semester'],
                                      icon: Icons.timeline,
                                      screenWidth: constraints.maxWidth,
                                      iconSize: iconSize,
                                      fontSize: inputFontSize,
                                    ),
                                  ],
                                ),
                                SizedBox(height: spacingHeight),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget buildInfoBox({
    required String label,
    required String text,
    required IconData icon,
    required double screenWidth,
    required double iconSize,
    required double fontSize,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.005),
      child: Container(
        width: screenWidth * 0.75,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenWidth * 0.03),
        decoration: BoxDecoration(
          color: Color.fromRGBO(32, 32, 32, 1),
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          border: Border.all(color: const Color.fromARGB(255, 115, 115, 115)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Color.fromARGB(255, 255, 255, 255),
              size: iconSize,
            ),
            SizedBox(width: screenWidth * 0.04),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
