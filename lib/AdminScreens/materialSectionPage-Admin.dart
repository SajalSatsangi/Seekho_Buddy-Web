import 'package:flutter/material.dart';
import 'package:seekhobuddy/AdminScreens/materialPage-Admin.dart';
import 'package:seekhobuddy/AdminScreens/materialPage-CR.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Materialsectionpage_Admin extends StatelessWidget {
  final String subjectName;
  final Map subject;
  final String facultyName;
  final String branchName;
  final String semesterName;
  final String role;

  Materialsectionpage_Admin({
    required this.subjectName,
    required this.subject,
    required this.facultyName,
    required this.branchName,
    required this.semesterName,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    print(subject);
    Map materials = Map.from(subject)..remove('subjectName');

    // Function to show the popup dialog
    void _showAddMaterialDialog() {
      final TextEditingController _folderNameController =
          TextEditingController();
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add New Material'),
            content: TextField(
              controller: _folderNameController,
              decoration: InputDecoration(
                hintText: 'Enter Material Name',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Handle the action when "Add" is pressed
                  String folderName = _folderNameController.text;
                  if (folderName.isNotEmpty) {
                    Map<String, dynamic> newMaterial = {
                      'materialName': folderName,
                    };

                    // Update the Firebase Firestore
                    await _firestore
                        .collection('seekhobuddydb')
                        .doc(facultyName)
                        .set({
                      'branches': {
                        branchName: {
                          semesterName: {
                            subjectName: {folderName: newMaterial}
                          }
                        }
                      }
                    }, SetOptions(merge: true));
                  }
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Add'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop(); // Navigate back
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        subjectName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text color
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: materials.length,
              itemBuilder: (context, index) {
                String materialKey = materials.keys.elementAt(index);
                Map material = materials[materialKey];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 7.0, horizontal: 27.0),
                  child: GestureDetector(
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(50, 50, 50, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.book_sharp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  material['materialName'] ??
                                      'Default Material Name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (role == 'admin' || role == 'dataeditor') {
                                  Navigator.push(
                                    context,
                                    SlideRightPageRoute(
                                      page: Materialpage_Admin(
                                        materialName: material['materialName'],
                                        material: material,
                                        facultyName: facultyName,
                                        branchName: branchName,
                                        semesterName: semesterName,
                                        subjectName: subjectName,
                                      ),
                                    ),
                                  );
                                } else if (role == 'CR') {
                                  Navigator.push(
                                    context,
                                    SlideRightPageRoute(
                                      page: Materialpage_CR(
                                        materialName: material['materialName'],
                                        material: material,
                                        facultyName: facultyName,
                                        branchName: branchName,
                                        semesterName: semesterName,
                                        subjectName: subjectName,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.white,
                                ),
                              ),
                              child: Text(
                                'View',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMaterialDialog, // Function to show popup dialog
        child: Icon(Icons.add, color: Colors.white), // Set icon color to white
        backgroundColor: Color(0xFF323232), // Set background color to BD-323232
      ),
    );
  }
}

// Custom page route for slide animation
class SlideRightPageRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}
