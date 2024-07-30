import 'package:flutter/material.dart';
import 'package:seekhobuddy/Other%20Cources/3Semesters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Branches extends StatelessWidget {
  final String facultyName;
  final Map facultyData;
  final String role;

  Branches(
      {required this.facultyName,
      required this.facultyData,
      required this.role});

  @override
  Widget build(BuildContext context) {
    print(facultyData);
    print(role);
    List branches = facultyData['branches'].values.toList();

    void _showAddMaterialDialog() {
      final TextEditingController _branchNameController =
          TextEditingController();
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add New Branch'),
            content: TextField(
              controller: _branchNameController,
              decoration: InputDecoration(
                hintText: 'Enter Branch Name',
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
                  String branchhName = _branchNameController.text;
                  if (branchhName.isNotEmpty) {
                    // Update the Firebase Firestore
                    await _firestore
                        .collection('seekhobuddydb')
                        .doc(facultyName)
                        .set({
                      'branches': {
                        branchhName: {
                          'branchName': branchhName,
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
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        facultyName,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
              itemCount: branches.length,
              itemBuilder: (context, index) {
                var branch = branches[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 25.0),
                  child: GestureDetector(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(50, 50, 50, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.school,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  branch['branchName'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  SlideRightPageRoute(
                                    page: Semesters(
                                      facultyName: facultyName,
                                      branchName: branch[
                                          'branchName'], // assuming 'branchName' is the key for the branch name
                                      branchData: branch as Map,
                                      role: role,
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              child: Text(
                                'View',
                                style: TextStyle(color: Colors.black),
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
      floatingActionButton: role == "admin"
          ? FloatingActionButton(
              onPressed:
                  _showAddMaterialDialog, // Function to show popup dialog
              child: Icon(Icons.add,
                  color: Colors.white), // Set icon color to white
              backgroundColor:
                  Color(0xFF323232), // Set background color to BD-323232
            )
          : SizedBox.shrink(), // Hide the button for non-admin users
    );
  }
}

class SlideRightPageRoute extends PageRouteBuilder {
  final Widget page;

  SlideRightPageRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
