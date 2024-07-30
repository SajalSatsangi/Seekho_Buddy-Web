import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seekhobuddy/AdminScreens/materialVerification.dart';
import 'package:seekhobuddy/AdminScreens/student_verification.dart';
import '../Profile/editprofile.dart';
import 'UsersData.dart';

class ProfileScreenAdmin extends StatelessWidget {
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return Scaffold(
          appBar: _buildAppBar(isDesktop, screenWidth, screenHeight),
          body: userData == null
              ? Center(child: CircularProgressIndicator())
              : _buildProfileContent(isDesktop, screenWidth, screenHeight),
        );
      },
    );
  }

  AppBar _buildAppBar(bool isDesktop, double screenWidth, double screenHeight) {
    double padding = isDesktop ? 40 : screenWidth * 0.05;
    double iconSize = isDesktop ? 30 : screenWidth * 0.06;
    double fontSizeTitle = isDesktop ? 32 : screenWidth * 0.06;

    return AppBar(
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: screenHeight * 0.02),
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
                _buildIconButton(Icons.edit, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                }, iconSize),
                if (userData != null && (userData!['role'] == 'admin' || userData!['role'] == 'verificationist'))
                  _buildIconButton(Icons.request_page, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationApp()));
                  }, iconSize),
                if (userData != null && (userData!['role'] == 'admin' || userData!['role'] == 'dataeditor'))
                  _buildIconButton(Icons.person, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => userdata()));
                  }, iconSize),
                if (userData != null && (userData!['role'] == 'admin' || userData!['role'] == 'dataeditor'))
                  _buildIconButton(Icons.book, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MaterialConfirmationScreen()));
                  }, iconSize),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed, double size) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: size),
      onPressed: onPressed,
    );
  }

  Widget _buildProfileContent(bool isDesktop, double screenWidth, double screenHeight) {
    double padding = isDesktop ? 40 : screenWidth * 0.05;
    double iconSize = isDesktop ? 60 : screenWidth * 0.15;
    double fontSizeTitle = isDesktop ? 32 : screenWidth * 0.06;
    double fontSizeSubtitle = isDesktop ? 18 : screenWidth * 0.04;
    double spacingHeight = isDesktop ? 20 : screenHeight * 0.02;
    double inputFontSize = isDesktop ? 16 : screenWidth * 0.035;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: iconSize,
                  backgroundImage: NetworkImage(userData!['profile_picture']),
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
                _buildInfoBoxes(isDesktop, screenWidth, iconSize, inputFontSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBoxes(bool isDesktop, double screenWidth, double iconSize, double fontSize) {
    List<Map<String, dynamic>> infoItems = [
      {'label': 'University', 'text': 'Dayalbagh Educational Institute', 'icon': Icons.location_city},
      {'label': 'Roll Number', 'text': userData!['rollno'], 'icon': Icons.confirmation_number},
      {'label': 'Faculty', 'text': userData!['faculty'], 'icon': Icons.account_balance},
      {'label': 'Branch', 'text': userData!['subfaculty'], 'icon': Icons.category},
      {'label': 'Specialization', 'text': userData!['subbranch'], 'icon': Icons.spa},
      {'label': 'Semester', 'text': userData!['semester'], 'icon': Icons.timeline},
    ];

    return Column(
      children: infoItems.map((item) => Column(
        children: [
          buildInfoBox(
            label: item['label'],
            text: item['text'],
            icon: item['icon'],
            screenWidth: screenWidth,
            iconSize: iconSize * 0.5,
            fontSize: fontSize,
          ),
          SizedBox(height: isDesktop ? 20 : screenWidth * 0.03),
        ],
      )).toList(),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.03,
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(32, 32, 32, 1),
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
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
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}