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
      await FirebaseFirestore.instance
          .collection('donations')
          .doc(otherInfoController.text)
          .set({
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFF000000),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 32 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isDesktop ? 32 : 16),
                        decoration: BoxDecoration(
                          color: Color(0xFF323232),
                          borderRadius:
                              BorderRadius.circular(isDesktop ? 20 : 10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: isDesktop ? 24 : 16),
                            Text(
                              'You are stepping toward wellbeing, we thank you for your contribution',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 18 : 16,
                              ),
                            ),
                            SizedBox(height: isDesktop ? 32 : 24),
                            Text(
                              'Donate Methods',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 24 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: isDesktop ? 24 : 16),
                            Text(
                              'Give us a brief description of what you are donating to us so that we can put the resources in an appropriate section. We thank you for your help to your juniors.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 18 : 16,
                              ),
                            ),
                            SizedBox(height: isDesktop ? 24 : 16),
                            Text(
                              'There are two ways you can give us your resources and help:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 18 : 16,
                              ),
                            ),
                            SizedBox(height: isDesktop ? 24 : 16),
                            Text(
                              'Through Google Drive',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 18 : 16,
                              ),
                            ),
                            SizedBox(height: isDesktop ? 16 : 8),
                            Text(
                              'You can upload your material on your drive, make it public, and send us your drive link.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 18 : 16,
                              ),
                            ),
                            SizedBox(height: isDesktop ? 24 : 16),
                            Text(
                              'Through Upload',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 18 : 16,
                              ),
                            ),
                            SizedBox(height: isDesktop ? 16 : 8),
                            Text(
                              'You can upload your pdfs directly here',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 18 : 16,
                              ),
                            ),
                            SizedBox(height: isDesktop ? 48 : 32),
                            buildTextField(
                              context,
                              'Description (tell us about whatever you are donating to us in brief)',
                              isDesktop,
                              maxLines: 5,
                              controller: descriptionController,
                            ),
                            SizedBox(height: isDesktop ? 24 : 16),
                            buildTextField(
                              context,
                              'Drive Link',
                              isDesktop,
                              controller: driveLinkController,
                            ),
                            SizedBox(height: isDesktop ? 24 : 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Implement your image upload logic here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      isDesktop ? 20 : 10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isDesktop ? 32 : 16,
                                  vertical: isDesktop ? 16 : 8,
                                ),
                              ),
                              icon:
                                  Icon(Icons.file_upload, color: Colors.white),
                              label: Text(
                                'Upload Pdf',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: isDesktop ? 18 : 16,
                                ),
                              ),
                            ),
                            SizedBox(height: isDesktop ? 32 : 24),
                            buildTextField(
                              context,
                              'Tell us about the subjectname of the material and type of material',
                              isDesktop,
                              controller: otherInfoController,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: isDesktop ? 64 : 32),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: submitDonation,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 0, 0, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          isDesktop ? 20 : 10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isDesktop ? 64 : 32,
                                      vertical: isDesktop ? 24 : 16,
                                    ),
                                  ),
                                  child: Text(
                                    'Donate Now',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: isDesktop ? 20 : 18,
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
            ),
          );
        },
      ),
    );
  }

  Widget buildTextField(BuildContext context, String hintText, bool isDesktop,
      {int maxLines = 1, TextEditingController? controller}) {
    return Container(
      margin: EdgeInsets.only(bottom: isDesktop ? 32 : 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: isDesktop ? 18 : 16,
          ),
          filled: true,
          fillColor: Colors.black,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isDesktop ? 20 : 10),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: isDesktop ? 18 : 16,
        ),
      ),
    );
  }
}
