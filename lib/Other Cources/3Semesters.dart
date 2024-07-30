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
      final TextEditingController _semesterNameController = TextEditingController();
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add New Semester'),
            content: TextField(
              controller: _semesterNameController,
              decoration: InputDecoration(
                hintText: 'Enter Semester Name',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  String semesterName = _semesterNameController.text;
                  if (semesterName.isNotEmpty) {
                    await _firestore
                        .collection('seekhobuddydb')
                        .doc(facultyName)
                        .set({
                      'branches': {
                        branchName: {
                           semesterName: {
                            'semesterName': semesterName,
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
                                branchName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isDesktop ? 36.0 : 24.0,
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
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: isDesktop ? 24 : 16),
                          child: GestureDetector(
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
                                        Icon(Icons.calendar_today, color: Colors.white),
                                        SizedBox(width: 18),
                                        Text(
                                          semester['semesterName'] ?? 'Default Semester Name',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isDesktop ? 18.0 : 16.0,
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
                                              semesterName: semester['semesterName'],
                                              semesterData: semester,
                                              role: role
                                            ),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                      ),
                                      child: Text(
                                        'View',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: isDesktop ? 16.0 : 14.0,
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
            ),
          );
        },
      ),
      floatingActionButton: role == "admin"
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