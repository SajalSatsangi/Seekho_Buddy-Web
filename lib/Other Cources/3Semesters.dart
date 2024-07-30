import 'package:flutter/material.dart';
import 'package:seekhobuddy/Other%20Cources/4subjects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Semesters extends StatelessWidget {
  final String branchName;
  final Map branchData;
  final String facultyName;
  final String role;

  Semesters({
    required this.facultyName,
    required this.branchName,
    required this.branchData, 
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    print(role);
    Map semesters = Map.from(branchData)..remove('branchName');


    void _showAddMaterialDialog() {
      final TextEditingController _semesterNameController =
          TextEditingController();
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add New Semseter'),
            content: TextField(
              controller: _semesterNameController,
              decoration: InputDecoration(
                hintText: 'Enter Semester Name',
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
                  String semesterrName = _semesterNameController.text;
                  if (semesterrName.isNotEmpty) {

                    // Update the Firebase Firestore
                    await _firestore
                        .collection('seekhobuddydb')
                        .doc(facultyName)
                        .set({
                      'branches': {
                        branchName: {
                           semesterrName: {
                            'semesterName': semesterrName,
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
                        branchName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
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
              itemCount: semesters.length,
              itemBuilder: (context, index) {
                String semesterKey = semesters.keys.elementAt(index);
                if (semesters[semesterKey] is! Map) {
                  throw 'Expected a Map, but got ${semesters[semesterKey].runtimeType}';
                }
                Map semester = semesters[semesterKey];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 7.0, horizontal: 34.0),
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
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 18),
                                Text(
                                  semester['semesterName'] ??
                                      'Default Semester Name',
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
                                Navigator.push(
                                  context,
                                  SlideLeftPageRoute(
                                    page: Subjects(
                                      facultyName: facultyName,
                                      branchName: branchName,
                                      semesterName: semester[
                                          'semesterName'], // assuming 'semesterName' is the key for the semester name
                                      semesterData:
                                          semester,
                                          role: role // Pass the entire semester map
                                    ),
                                  ),
                                );
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
      floatingActionButton: role == "admin"
          ? FloatingActionButton(
              onPressed:
                  _showAddMaterialDialog, // Function to show popup dialog
              child: Icon(Icons.add,
                  color: Colors.white), // Set icon color to white
              backgroundColor:
                  Color(0xFF323232), // Set background color to BD-323232
            )
          : SizedBox.shrink(), 
    );
  }
}

class SlideLeftPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideLeftPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
