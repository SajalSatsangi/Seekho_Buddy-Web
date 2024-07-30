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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.04,
              top: screenHeight * 0.025),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: screenWidth * 0.065,
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
                      size: screenWidth * 0.06,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfile()),
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
                        size: screenWidth * 0.06,
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
                        size: screenWidth * 0.06,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => userdata()),
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
                        size: screenWidth * 0.06,
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
                  padding: EdgeInsets.all(screenWidth * 0.07),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.04),
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: screenWidth * 0.15,
                              backgroundImage:
                                  NetworkImage(userData!['profile_picture']),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Text(
                              userData!['name'],
                              style: TextStyle(
                                fontSize: screenWidth * 0.065,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              userData!['email'],
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildInfoBox(
                                  label: 'University',
                                  text: 'Dayalbagh Educational Institute',
                                  icon: Icons.location_city,
                                  screenWidth: screenWidth,
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                buildInfoBox(
                                  label: 'Roll Number',
                                  text: userData!['rollno'],
                                  icon: Icons.confirmation_number,
                                  screenWidth: screenWidth,
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                buildInfoBox(
                                  label: 'Faculty',
                                  text: userData!['faculty'],
                                  icon: Icons.account_balance,
                                  screenWidth: screenWidth,
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                buildInfoBox(
                                  label: 'Branch',
                                  text: userData!['subfaculty'],
                                  icon: Icons.category,
                                  screenWidth: screenWidth,
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                buildInfoBox(
                                  label: 'Specialization',
                                  text: userData!['subbranch'],
                                  icon: Icons.spa,
                                  screenWidth: screenWidth,
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                buildInfoBox(
                                  label: 'Semester',
                                  text: userData!['semester'],
                                  icon: Icons.timeline,
                                  screenWidth: screenWidth,
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildInfoBox({
    required String label,
    required String text,
    required IconData icon,
    required double screenWidth,
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
              size: screenWidth * 0.07,
            ),
            SizedBox(width: screenWidth * 0.04),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.035,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
