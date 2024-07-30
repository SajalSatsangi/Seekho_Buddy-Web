import 'package:flutter/material.dart';
import 'package:seekhobuddy/Other%20Cources/6materialPage.dart';

class Materialsectionpage extends StatelessWidget {
  final String subjectName;
  final Map subject;
  final String facultyName;
  final String branchName;
  final String semesterName;
  final String role;

  Materialsectionpage({
    required this.subjectName,
    required this.subject,
    required this.facultyName,
    required this.branchName,
    required this.semesterName,
    required this.role, 
  });

  @override
  Widget build(BuildContext context) {
    Map materials = Map.from(subject)..remove('subjectName');

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
                                subjectName,
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: materials.length,
                      itemBuilder: (context, index) {
                        String materialKey = materials.keys.elementAt(index);
                        Map material = materials[materialKey];

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
                                      Icon(Icons.school, color: Colors.white),
                                      SizedBox(width: 12),
                                      Text(
                                        material['materialName'] ?? 'Default Material Name',
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
                                      Navigator.push(
                                        context,
                                        SlideRightPageRoute(
                                          page: Materialpage(
                                            materialName: material['materialName'],
                                            material: material,
                                            facultyName: facultyName,
                                            branchName: branchName,
                                            semesterName: semesterName,
                                            subjectName: subjectName,
                                          ),
                                        ),
                                      );
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
                                  ),
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