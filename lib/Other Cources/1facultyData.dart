import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '2branches.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Faculties extends StatelessWidget {
  Future<List<QueryDocumentSnapshot>> fetchData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('seekhobuddydb').get();
    return querySnapshot.docs;
  }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // Set to 0 to remove the AppBar space
      ),
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          return Stack(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: isDesktop ? 80.0 : 60.0, // Increased top padding to make room for the custom header
                      left: isDesktop ? 50.0 : 20.0,
                      right: isDesktop ? 50.0 : 20.0,
                    ),
                    child: FutureBuilder<List<QueryDocumentSnapshot>>(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.white)),
                          );
                        }
                        final documents = snapshot.data;
                        return ListView.builder(
                          itemCount: documents?.length,
                          itemBuilder: (context, index) {
                            final document = documents?[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: _buildFacultyItem(context, document, index, isDesktop),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: isDesktop ? 20.0 : 10.0,
                left: isDesktop ? 240.0 : 20.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Faculties",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FutureBuilder<String>(
        future: getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data == "admin") {
            return FloatingActionButton(
              onPressed: () => _showAddMaterialDialog(context),
              child: const Icon(Icons.add, color: Colors.white),
              backgroundColor: const Color(0xFF323232),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFacultyItem(BuildContext context, QueryDocumentSnapshot? document, int index, bool isDesktop) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: isDesktop ? 160 : 120,
        decoration: BoxDecoration(
          color: const Color(0xFF323232),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              child: Image.asset(
                _getFacultyImage(index),
                width: isDesktop ? 160 : 120,
                height: isDesktop ? 160 : 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: isDesktop ? 20 : 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    document?.id ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 24 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isDesktop ? 16 : 8),
                  ElevatedButton(
                    onPressed: () async {
                      String role = await getUserRole();
                      Navigator.push(
                        context,
                        SlideRightPageRoute(
                          page: Branches(
                            facultyName: document?.id ?? '',
                            facultyData: document?.data() as Map<String, dynamic>,
                            role: role,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 30 : 20,
                        vertical: isDesktop ? 15 : 10,
                      ),
                    ),
                    child: Text(
                      'View',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: isDesktop ? 18 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFacultyImage(int index) {
    switch (index) {
      case 0: return 'assets/eng.png';
      case 1: return 'assets/edu.png';
      case 2: return 'assets/art.png';
      case 3: return 'assets/comm.png';
      case 4: return 'assets/eng.png';
      case 5: return 'assets/sci.png';
      case 6: return 'assets/tec.png';
      default: return 'assets/search_result.png';
    }
  }

  void _showAddMaterialDialog(BuildContext context) {
    final TextEditingController _facultyNameController = TextEditingController();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Faculty'),
          content: TextField(
            controller: _facultyNameController,
            decoration: const InputDecoration(
              hintText: 'Enter Faculty Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String facultyName = _facultyNameController.text;
                if (facultyName.isNotEmpty) {
                  await _firestore
                      .collection('seekhobuddydb')
                      .doc(facultyName)
                      .set({'facultyName': facultyName, 'branches': {}},
                          SetOptions(merge: true));
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class SlideRightPageRoute extends PageRouteBuilder {
  final Widget page;

  SlideRightPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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