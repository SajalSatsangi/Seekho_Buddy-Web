import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit.dart';
import 'edit_profile_picture.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot<Map<String, dynamic>>? userData;

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

  Future<void> navigateToEditProfilePicture() async {
    if (userData != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfilePicture(
            currentImageUrl: userData!.data()!['profile_picture'],
            userName: userData!.data()!['name'],
          ),
        ),
      );
      if (result == true) {
        await fetchUserData();
      }
    }
  }

  Future<void> navigateToEditField(String field, String currentValue) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditField(field: field, currentValue: currentValue),
      ),
    );
    if (result != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData!.id)
          .update({field: result});
      fetchUserData();
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          final contentWidth = isDesktop ? 600.0 : constraints.maxWidth;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: userData == null
                  ? CircularProgressIndicator()
                  : ListView(
                      padding: EdgeInsets.all(16),
                      children: [
                        GestureDetector(
                          onTap: navigateToEditProfilePicture,
                          child: CircleAvatar(
                            radius: isDesktop ? 80 : constraints.maxWidth * 0.15,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: userData!.data()!['profile_picture'],
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) {
                                  print('Error loading image: $error');
                                  return Icon(Icons.error);
                                },
                                fit: BoxFit.cover,
                                width: (isDesktop ? 80 : constraints.maxWidth * 0.15) * 2,
                                height: (isDesktop ? 80 : constraints.maxWidth * 0.15) * 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildInfoContainer('name', userData!.data()!['name'], isDesktop, isHeader: true),
                        _buildInfoContainer('email', userData!.data()!['email'], isDesktop),
                        SizedBox(height: 24),
                        Center(
                          child: Text(
                            'Academic Information',
                            style: TextStyle(
                              fontSize: isDesktop ? 22 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildInfoContainer('rollno', 'Roll Number: ${userData!.data()!['rollno']}', isDesktop),
                        _buildInfoContainer('faculty', 'Faculty: ${userData!.data()!['faculty']}', isDesktop),
                        _buildInfoContainer('subfaculty', 'Branch: ${userData!.data()!['subfaculty']}', isDesktop),
                        _buildInfoContainer('subbranch', 'Sub-Branch: ${userData!.data()!['subbranch']}', isDesktop),
                        _buildInfoContainer('semester', 'Semester: ${userData!.data()!['semester']}', isDesktop),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoContainer(String field, String value, bool isDesktop, {bool isHeader = false}) {
    return GestureDetector(
      onTap: () => navigateToEditField(field, value),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFF292929),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(
              fontSize: isDesktop ? (isHeader ? 24 : 16) : (isHeader ? 20 : 14),
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Color.fromARGB(255, 185, 185, 185),
            ),
          ),
        ),
      ),
    );
  }
}