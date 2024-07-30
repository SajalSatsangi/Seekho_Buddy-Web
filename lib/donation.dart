import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  DocumentSnapshot? userData;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController driveLinkController = TextEditingController();
  final TextEditingController otherInfoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
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

  Future<void> submitDonation() async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('donations').doc(otherInfoController.text).set({
        'user_id': user!.uid,
        'description': descriptionController.text,
        'drive_link': driveLinkController.text,
        'about_material': otherInfoController.text,
        'user_data': userData!.data(),
      }).then((value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Submission Successful'),
            content: Text('Your donation has been submitted successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: screenWidth * 0.05,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor:
            const Color(0xFF000000), // Set the background color to black
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding:
                    EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                decoration: BoxDecoration(
                  color: Color(0xFF323232),
                  borderRadius: BorderRadius.circular(
                      screenWidth * 0.05), // Responsive rounded corners
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight * 0.015), // Responsive height
                    Text(
                      'You are stepping toward wellbeing, we thank you for your contribution',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Responsive height
                    Text(
                      'Donate Methods',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold, // Responsive font size
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015), // Responsive height
                    Text(
                      'Give us a brief description of what you are donating to us so that we can put the resources in an appropriate section. We thank you for your help to your juniors.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015), // Responsive height
                    Text(
                      'There are two ways you can give us your resources and help:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015), // Responsive height
                    Text(
                      'Through Google Drive',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015), // Responsive height
                    Text(
                      'You can upload your material on your drive, make it public, and send us your drive link.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015), // Responsive height
                    Text(
                      'Through Upload',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015), // Responsive height
                    Text(
                      'You can upload your pdfs directly here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // Responsive height
                    buildTextField(
                      context,
                      'Description (tell us about whatever you are donating to us in brief)',
                      screenWidth,
                      screenHeight,
                      maxLines: 5,
                      controller: descriptionController,
                    ),
                    SizedBox(height: screenHeight * 0.001), // Responsive height
                    buildTextField(
                      context,
                      'Drive Link',
                      screenWidth,
                      screenHeight,
                      controller: driveLinkController,
                    ),
                    SizedBox(height: screenHeight * 0), // Responsive height
                    ElevatedButton.icon(
                      onPressed: () {
                        // Implement your image upload logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                        ),
                      ),
                      icon: Icon(Icons.file_upload, color: Colors.white),
                      label: Text(
                        'Upload Pdf',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    buildTextField(
                      context,
                      'Tell us about the subjectname of the material and type of material',
                      screenWidth,
                      screenHeight,
                      controller: otherInfoController,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight * 0.04), // Responsive padding
                      child: Center(
                        child: ElevatedButton(
                          onPressed: submitDonation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 0, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth *
                                  0.05), // Responsive rounded corners
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  screenWidth * 0.1, // Responsive padding
                              vertical:
                                  screenHeight * 0.02, // Responsive padding
                            ),
                          ),
                          child: Text(
                            'Donate Now',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize:
                                  screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context, String hintText,
      double screenWidth, double screenHeight,
      {int maxLines = 1, TextEditingController? controller}) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02), // Responsive margin
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: screenWidth * 0.04, // Responsive font size
          ),
          filled: true,
          fillColor: Colors.black,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                screenWidth * 0.05), // Responsive rounded corners
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.04, // Responsive font size
        ),
      ),
    );
  }
}