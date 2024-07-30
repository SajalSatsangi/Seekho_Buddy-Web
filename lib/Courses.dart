import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seekhobuddy/Courses/1Subjects.dart';
import 'package:seekhobuddy/Other%20Cources/1facultyData.dart';
import 'package:seekhobuddy/home.dart';

void main() {
  runApp(Courses());
}

class Courses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyWidget(),
      theme: ThemeData.dark(),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20.0,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    _buildHeader(context, isDesktop),
                    SizedBox(height: 40),
                    _buildCourseBox(
                      context,
                      isDesktop,
                      'Your Courses',
                      'assets/YC.svg',
                      SubjectsPage(),
                    ),
                    SizedBox(height: 20),
                    _buildCourseBox(
                      context,
                      isDesktop,
                      'Other Courses',
                      'assets/OC.svg',
                      Faculties(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.black87,
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
            SizedBox(width: 10),
            Text(
              "Courses",
              style: TextStyle(
                fontSize: isDesktop ? 32 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildCourseBox(BuildContext context, bool isDesktop, String title,
      String assetPath, Widget destination) {
    return Container(
      width: double.infinity,
      height: isDesktop ? 200 : 160,
      decoration: BoxDecoration(
        color: Color(0xFF323232),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          SvgPicture.asset(
            assetPath,
            width: isDesktop ? 150 : 100,
            height: isDesktop ? 150 : 100,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 28 : 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => destination),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 30 : 20,
                      vertical: isDesktop ? 15 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'View',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isDesktop ? 18 : 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
