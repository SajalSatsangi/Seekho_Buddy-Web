import 'package:flutter/material.dart';
import 'package:seekhobuddy/Courses/2MateiralSection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MaterialApp(
    home: SubjectsPage(),
  ));
}

class SubjectsPage extends StatefulWidget {
  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  Map<String, dynamic> subjects = {};
  DocumentSnapshot? userData;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

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

        fetchSubjects();
      }
    }
  }

  Future<void> fetchSubjects() async {
    if (userData != null) {
      String faculty = userData!['faculty'];
      String subfaculty = userData!['subfaculty'];
      String semester = userData!['semester'];

      var docSnapshot = await FirebaseFirestore.instance
          .collection('seekhobuddydb')
          .doc(faculty)
          .get();

      if (docSnapshot.exists) {
        var facultyData = docSnapshot.data() as Map<String, dynamic>;
        var branches = facultyData['branches'] as Map<String, dynamic>;
        var subfacultyData = branches[subfaculty] as Map<String, dynamic>;
        var semesterData = subfacultyData[semester] as Map<String, dynamic>;

        // Remove the 'semesterName' key-value pair from the map
        semesterData.remove('semesterName');

        setState(() {
          subjects = semesterData;
        });
        print(subjects);
      } else {
        print('Document does not exist on the database');
      }
    }
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  List<String> _filterSubjects() {
    return subjects.entries
        .where((entry) =>
            entry.value is Map<String, dynamic> &&
            entry.value.containsKey('subjectName'))
        .map((entry) => entry.key)
        .where((subjectName) =>
            subjectName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 32 : 16,
                        vertical: isDesktop ? 20 : 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              SizedBox(width: isDesktop ? 20 : 10),
                              Text(
                                "Subjects",
                                style: TextStyle(
                                  fontSize: isDesktop ? 36 : 28,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 32 : 14,
                      vertical: isDesktop ? 20 : 14,
                    ),
                    child: TextField(
                      onChanged: _updateSearchQuery,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: isDesktop ? 24 : 20,
                        ),
                        filled: true,
                        fillColor: Color(0xFF323232),
                        contentPadding: EdgeInsets.all(isDesktop ? 16 : 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Color(0xFF323232)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(isDesktop ? 30 : 15),
                      child: ListView.builder(
                        itemCount: _filterSubjects().length,
                        itemBuilder: (context, index) {
                          String subjectName = _filterSubjects()[index];
                          return Padding(
                            padding:
                                EdgeInsets.only(bottom: isDesktop ? 30 : 20),
                            child: _buildBox(
                              icon: Icons.notes_rounded,
                              title: subjectName,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  _createRoute(Materialsectionpage(
                                    subjectData: subjects[subjectName]
                                        as Map<String, dynamic>,
                                    allData: subjects,
                                    subjectName: subjectName,
                                  )),
                                );
                              },
                              isDesktop: isDesktop,
                            ),
                          );
                        },
                      ),
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

  Widget _buildBox({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDesktop,
  }) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: isDesktop ? 100 : 80,
        decoration: BoxDecoration(
          color: Color.fromRGBO(50, 50, 50, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 30 : 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: isDesktop ? 28 : 24,
                  ),
                  SizedBox(width: isDesktop ? 16 : 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 20 : 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: onTap,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(
                      horizontal: isDesktop ? 24 : 16,
                      vertical: isDesktop ? 12 : 8,
                    ),
                  ),
                ),
                child: Text(
                  'View',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: isDesktop ? 18 : 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
