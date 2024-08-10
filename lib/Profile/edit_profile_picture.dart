import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfilePicture extends StatefulWidget {
  final String currentImageUrl;
  final String userName;

  EditProfilePicture({required this.currentImageUrl, required this.userName});

  @override
  _EditProfilePictureState createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  XFile? pickedFile;
  bool isLoading = false;
  DocumentSnapshot? userData;

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userData = querySnapshot.docs.first;
        });
      }
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        await pickedFile.readAsBytes();
        setState(() {
          this.pickedFile = pickedFile;
        });
      } catch (e) {
        print('Error reading file: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to read the selected image. Please try another.')),
        );
      }
    }
  }

  Future<void> saveProfilePicture() async {
    if (pickedFile == null) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Fetch user data to get document ID
      await fetchUserData();
      if (userData == null) {
        throw Exception('User data not found');
      }

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      String userName = widget.userName;
      String filePath = 'profile_pictures/${userName}_${DateTime.now().millisecondsSinceEpoch}.png';
      Reference ref = FirebaseStorage.instance.ref(filePath);

      Uint8List imageData = await pickedFile!.readAsBytes();

      if (!kIsWeb) {
        // Compress the image for native platforms
        imageData = await FlutterImageCompress.compressWithList(
          imageData,
          minWidth: 512,
          minHeight: 512,
          quality: 90,
        );
      }

      final metadata = SettableMetadata(
        contentType: 'image/png',
        customMetadata: {'picked-file-path': pickedFile!.path},
      );

      UploadTask uploadTask = ref.putData(imageData, metadata);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Update the Firestore document with the new profile picture URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData!.id)
          .update({'profile_picture': downloadURL});

      await CachedNetworkImage.evictFromCache(downloadURL);

      Navigator.pop(context, true);
    } catch (e) {
      String errorMessage = 'Failed to save profile picture. ';
      if (e is FirebaseException) {
        errorMessage += e.message ?? 'Unknown Firebase error.';
      } else {
        errorMessage += 'Please try again later.';
      }
      print('Error saving profile picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile Picture', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: pickedFile != null 
                ? FileImage(File(pickedFile!.path)) as ImageProvider
                : CachedNetworkImageProvider(widget.currentImageUrl),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Select New Picture'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : saveProfilePicture,
              child: isLoading 
                ? CircularProgressIndicator()
                : Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
