import 'package:flutter/material.dart';
import 'package:seekhobuddy/AdminScreens/materialSectionPage-Admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seekhobuddy/Other%20Cources/5materialSectionPage.dart';

class Subjects extends StatefulWidget {
  final String semesterName;
  final Map semesterData;
  final String facultyName;
  final String branchName;
  final String role;

  Subjects({
    required this.semesterName,
    required this.semesterData,
    required this.facultyName,
    required this.branchName,
    required this.role,
  });

  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  String searchQuery = '';

  Future<String> getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['role'];
      } else {
        throw Exception('No user document found');
      }
    } else {
      throw Exception('No user logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map subjects = Map.from(widget.semesterData)..remove('semesterName');
    Map filteredSubjects = {};
    for (var key in subjects.keys) {
      if (key.toString().toLowerCase().contains(searchQuery.toLowerCase())) {
        filteredSubjects[key] = subjects[key];
      }
    }

    void _showAddMaterialDialog() {
      final TextEditingController _subjectNameController = TextEditingController();
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add New Subject'),
            content: TextField(
              controller: _subjectNameController,
              decoration: InputDecoration(
                hintText: 'Enter Semester Subject',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  String subjectName = _subjectNameController.text;
                  if (subjectName.isNotEmpty) {
                    await _firestore
                        .collection('seekhobuddydb')
                        .doc(widget.facultyName)
                        .set({
                      'branches': {
                        widget.branchName: {
                           widget.semesterName: {
                            subjectName: {
                              'subjectName': subjectName,
                            }                         
                          }
                        }
                      }
                    }, SetOptions(merge: true));
                  }
                  Navigator.of(context).pop();
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          final contentWidth = isDesktop ? 600.0 : constraints.maxWidth;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              SizedBox(width: 10),
                              Text(
                                widget.semesterName,
                                style: TextStyle(
                                  fontSize: isDesktop ? 32 : 24,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      onChanged: (value) => setState(() => searchQuery = value),
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.white60),
                        prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
                        filled: true,
                        fillColor: Color(0xFF323232),
                        contentPadding: EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Color(0xFF323232)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredSubjects.length,
                      itemBuilder: (context, index) {
                        String subjectKey = filteredSubjects.keys.elementAt(index);
                        Map subject = filteredSubjects[subjectKey];

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: isDesktop ? 24 : 16),
                          child: Container(
                            height: isDesktop ? 80 : 70,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(50, 50, 50, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.subject, color: Colors.white),
                                      SizedBox(width: 12),
                                      Text(
                                        subject['subjectName'] ?? 'Default Subject Name',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isDesktop ? 18 : 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      getUserRole().then((role) {
                                        if (role == 'student' || role == 'verificationist') {
                                          Navigator.push(
                                            context,
                                            SlideLeftPageRoute(
                                              page: Materialsectionpage(
                                                subjectName: subject['subjectName'],
                                                subject: subject,
                                                facultyName: widget.facultyName,
                                                branchName: widget.branchName,
                                                semesterName: widget.semesterName,
                                                role: role,
                                              ),
                                            ),
                                          );
                                        } else if (role == 'admin' || role == 'CR' || role == 'dataeditor') {
                                          Navigator.push(
                                            context,
                                            SlideLeftPageRoute(
                                              page: Materialsectionpage_Admin(
                                                subjectName: subject['subjectName'],
                                                subject: subject,
                                                facultyName: widget.facultyName,
                                                branchName: widget.branchName,
                                                semesterName: widget.semesterName,
                                                role: role,
                                              ),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    ),
                                    child: Text(
                                      'View',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: isDesktop ? 16 : 14,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: widget.role == "admin"
          ? FloatingActionButton(
              onPressed: _showAddMaterialDialog,
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Color(0xFF323232),
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

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}