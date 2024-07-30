import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'edit.dart'; // Import the EditField screen
import 'package:flutter_image_compress/flutter_image_compress.dart';

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

  Future<void> updateProfilePicture() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    try {
      // Retrieve the user's name
      String userName = userData!.data()!['name'];
      // Construct the file path using the user's name
      String filePath = 'profile_pictures/${userName}.png';
      Reference ref = FirebaseStorage.instance.ref(filePath);
      UploadTask uploadTask;

      if (kIsWeb) {
        // For web platform
        final bytes = await pickedFile.readAsBytes();
        uploadTask = ref.putData(bytes);
      } else {
        // For native platforms
        Uint8List imageData = await pickedFile.readAsBytes();
        
        // Compress the image (only for native platforms)
        Uint8List? compressedData = await FlutterImageCompress.compressWithList(
          imageData,
          minWidth: 1024,
          minHeight: 768,
          quality: 88,
        );

        uploadTask = ref.putData(compressedData);
      }

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData!.id)
          .update({'profile_picture': downloadURL});

      // Fetch updated user data from Firestore
      await fetchUserData();
    } catch (e) {
      print(e);
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload profile picture. Please try again.'),
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
            EditField(field: field, currentValue: currentValue),
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
                          onTap: updateProfilePicture,
                          child: CircleAvatar(
                            radius: isDesktop ? 80 : constraints.maxWidth * 0.15,
                            backgroundImage: NetworkImage(userData!.data()!['profile_picture']),
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
      onTap: isHeader ? () => navigateToEditField(field, value) : null,
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
              fontSize: isDesktop
                  ? (isHeader ? 24 : 16)
                  : (isHeader ? 20 : 14),
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Color.fromARGB(255, 185, 185, 185),
            ),
          ),
        ),
      ),
    );
  }
}
