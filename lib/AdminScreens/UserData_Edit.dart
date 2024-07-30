import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:seekhobuddy/AdminScreens/useredit.dart';

class userdata_edit extends StatefulWidget {
  final Map<String, dynamic> userData;

  userdata_edit({required this.userData});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<userdata_edit> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  void setUserData() {
    setState(() {
      userData = widget.userData;
    });
  }

  Future<void> updateProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);

      try {
        String userName = userData!['name'];
        String filePath = 'profile_pictures/${userName}.png';
        UploadTask uploadTask =
            FirebaseStorage.instance.ref(filePath).putFile(file);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userData!['email'])
            .update({'profile_picture': downloadURL});

        setState(() {
          userData!['profile_picture'] = downloadURL;
        });
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to upload profile picture. Please try again.'),
          ),
        );
      }
    }
  }

  Future<void> navigateToEditField(String field, String currentValue) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            useredit(field: field, currentValue: currentValue),
      ),
    );
    if (result != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData!['email'])
          .update({field: result});

      setState(() {
        userData![field] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                  0.04), // Responsive padding
              children: [
                GestureDetector(
                  onTap: () => updateProfilePicture(),
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.15,
                    backgroundImage: NetworkImage(userData!['profile_picture']),
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.02), // Responsive height
                buildEditableField('name', userData!['name']),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                buildEditableField('email', userData!['email']),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Center(
                  child: Text(
                    'Academic Information',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width *
                          0.045, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                buildEditableField('rollno', userData!['rollno']),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                buildEditableField('faculty', userData!['faculty']),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                buildEditableField('subfaculty', userData!['subfaculty']),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                buildEditableField('subbranch', userData!['subbranch']),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                buildEditableField('semester', userData!['semester']),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                buildEditableField('status', userData!['status']),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height *
                          0.005), // Responsive margin
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                      0.03), // Responsive padding
                  decoration: BoxDecoration(
                    color: Color(0xFF292929),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'UID: ${userData!['uid']}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Color.fromARGB(255, 185, 185, 185),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                buildEditableField(
                    'verifiedstatus', userData!['verifiedstatus']),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                buildEditableField('date', userData!['date']),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                buildEditableField('role', userData!['role']),
              ],
            ),
    );
  }

  Widget buildEditableField(String label, String value) {
  return GestureDetector(
    onTap: (label.toLowerCase() != 'email')
        ? () => navigateToEditField(label.toLowerCase(), value)
        : null,
    child: Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.003),
      padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * 0.03), // Responsive padding
      decoration: BoxDecoration(
        color: Color(0xFF292929),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          value,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
}
