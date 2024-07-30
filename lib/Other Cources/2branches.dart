import 'package:flutter/material.dart';
import 'package:seekhobuddy/Other%20Cources/3Semesters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Branches extends StatelessWidget {
  final String facultyName;
  final Map facultyData;
  final String role;

  Branches({required this.facultyName, required this.facultyData, required this.role});

  @override
  Widget build(BuildContext context) {
    List branches = facultyData['branches'].values.toList();

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
                  _buildHeader(context, isDesktop),
                  Expanded(
                    child: _buildBranchesList(branches, context, isDesktop),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: role == "admin"
          ? FloatingActionButton(
              onPressed: () => _showAddMaterialDialog(context),
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Color(0xFF323232),
            )
          : null,
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SizedBox(width: isDesktop ? 16 : 8),
                Text(
                  facultyName,
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
    );
  }

  Widget _buildBranchesList(List branches, BuildContext context, bool isDesktop) {
    return ListView.builder(
      itemCount: branches.length,
      itemBuilder: (context, index) {
        var branch = branches[index];
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: isDesktop ? 12 : 8,
            horizontal: isDesktop ? 40 : 25,
          ),
          child: _buildBranchItem(branch, context, isDesktop),
        );
      },
    );
  }

  Widget _buildBranchItem(Map branch, BuildContext context, bool isDesktop) {
    return Container(
      height: isDesktop ? 100 : 80,
      decoration: BoxDecoration(
        color: Color.fromRGBO(50, 50, 50, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.school, color: Colors.white, size: isDesktop ? 28 : 24),
                SizedBox(width: isDesktop ? 16 : 10),
                Text(
                  branch['branchName'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 22 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _navigateToSemesters(context, branch),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 24 : 16,
                  vertical: isDesktop ? 12 : 8,
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
    );
  }

  void _navigateToSemesters(BuildContext context, Map branch) {
    Navigator.push(
      context,
      SlideRightPageRoute(
        page: Semesters(
          facultyName: facultyName,
          branchName: branch['branchName'],
          branchData: branch,
          role: role,
        ),
      ),
    );
  }

  void _showAddMaterialDialog(BuildContext context) {
    final TextEditingController _branchNameController = TextEditingController();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Branch'),
          content: TextField(
            controller: _branchNameController,
            decoration: InputDecoration(hintText: 'Enter Branch Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String branchName = _branchNameController.text;
                if (branchName.isNotEmpty) {
                  await _firestore.collection('seekhobuddydb').doc(facultyName).set({
                    'branches': {
                      branchName: {'branchName': branchName}
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