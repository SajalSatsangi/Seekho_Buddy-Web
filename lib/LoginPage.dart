import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'SignPage.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyHub',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        hintColor: Colors.white,
      ),
      home: StudyHubLoginScreen(),
    );
  }
}

class StudyHubLoginScreen extends StatefulWidget {
  @override
  _StudyHubLoginScreenState createState() => _StudyHubLoginScreenState();
}

class _StudyHubLoginScreenState extends State<StudyHubLoginScreen> {
  final TextEditingController _rollNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signInWithRollNumber() async {
    try {
      final rollNumber = _rollNumberController.text.trim();

      // Query Firestore to get user document based on roll number
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('rollno', isEqualTo: rollNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document
        final userDoc = querySnapshot.docs.first;

        // Get the user data
        final userData = userDoc.data();

        // Check if userData is not null and contains email field
        if (userData != null &&
            (userData as Map<String, dynamic>)['email'] != null) {
          // Sign in with email and password
          final email = (userData as Map<String, dynamic>)['email'] as String;
          final password = _passwordController.text.trim();
          final UserCredential userCredential =
              await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          // If login successful, navigate to Home screen
          if (userCredential.user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          }
        } else {
          throw 'User data or email is null';
        }
      } else {
        // Roll number not found
        throw 'Invalid roll number';
      }
    } catch (e) {
      // Handle login errors
      print("Failed to sign in with roll number: $e");
      // Show error dialog or message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "Failed to sign in. Please check your roll number and password."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
  
  
  Future<void> _resetPassword() async {
    try {
      final rollNumber = _rollNumberController.text.trim();

      // Check if roll number field is empty
    if (rollNumber.isEmpty) {
      // Show dialog with message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("ERROR!"),
            content: Text(
                "Please enter your roll number and then click on Forgot Password for resetting your Password."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

      // Query Firestore to get user document based on roll number
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('rollno', isEqualTo: rollNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document
        final userDoc = querySnapshot.docs.first;

        // Get the user data
        final userData = userDoc.data();

        // Check if userData is not null and contains email field
        if (userData != null &&
            (userData as Map<String, dynamic>)['email'] != null) {
          // Send password reset email
          final email = (userData as Map<String, dynamic>)['email'] as String;
          await _auth.sendPasswordResetEmail(email: email);

          // Show success dialog or message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Success"),
                content:
                    Text("Password reset email sent. Please check your email."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          throw 'User data or email is null';
        }
      } else {
        // Roll number not found
        throw 'Invalid roll number';
      }
    } catch (e) {
      // Handle errors
      print("Failed to reset password: $e");
      // Show error dialog or message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "Failed to reset password. Please check your roll number."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF161616),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double padding = constraints.maxWidth * 0.08;
            double iconSize = constraints.maxWidth * 0.1;
            double fontSizeTitle = constraints.maxWidth * 0.06;
            double fontSizeSubtitle = constraints.maxWidth * 0.04;
            double inputFieldHeight = constraints.maxHeight * 0.04;
            double buttonHeight = constraints.maxHeight * 0.06;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/loginPage.png',
                      height: constraints.maxHeight * 0.3,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Text(
                      'Seekho Buddy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.01),
                    Text(
                      'Access study materials efficiently',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: fontSizeSubtitle,
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.03),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Row(
                        children: [
                          Icon(
                            Icons.menu_book_sharp,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          SizedBox(width: padding / 2),
                          Expanded(
                            child: TextField(
                              controller: _rollNumberController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Roll Number',
                                hintStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.grey.shade800,
                                contentPadding: EdgeInsets.symmetric(
                                        vertical: inputFieldHeight / 2)
                                    .copyWith(
                                  left: 20,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.03),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          SizedBox(width: padding / 2),
                          Expanded(
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.grey.shade800,
                                contentPadding: EdgeInsets.symmetric(
                                        vertical: inputFieldHeight / 2)
                                    .copyWith(
                                  left: 20,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                    onPressed: _resetPassword,
                        child: Text(
                          'Forgot your password',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: fontSizeSubtitle,
                          ),
                            ),
                        ),
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.04),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: ElevatedButton(
                        onPressed: _signInWithRollNumber,
                        child: Text('Sign In'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.grey.shade800,
                          minimumSize: Size(double.infinity, buttonHeight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.04),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade800,
                            thickness: 1,
                            indent: padding,
                            endIndent: padding / 3,
                          ),
                        ),
                        Text(
                          'OR JOIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSizeSubtitle,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade800,
                            thickness: 1,
                            indent: padding / 3,
                            endIndent: padding,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create an account',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 157, 157, 157),
                            fontSize: fontSizeSubtitle,
                          ),
                        ),
                        SizedBox(width: padding / 3),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeSubtitle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}