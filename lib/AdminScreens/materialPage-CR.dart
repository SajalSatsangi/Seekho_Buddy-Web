import 'package:flutter/material.dart';
import 'package:seekhobuddy/Other%20Cources/7PdfViewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Materialpage_CR extends StatefulWidget {
  final Map material;
  final String materialName;
  final String facultyName;
  final String branchName;
  final String semesterName;
  final String subjectName;

  Materialpage_CR({
    required this.materialName,
    required this.material,
    required this.facultyName,
    required this.branchName,
    required this.semesterName,
    required this.subjectName,
  });

  @override
  _Materialpage_CRState createState() => _Materialpage_CRState();
}

class _Materialpage_CRState extends State<Materialpage_CR> {
  final pdfNameController = TextEditingController();
  final pdfUrlController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userData = querySnapshot.docs.first;
        });

        print(userData!.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.material);
    print(widget.facultyName);
    print(widget.branchName);
    print(widget.semesterName);
    print(widget.subjectName);
    print(widget.materialName);
    print(userData?.data());
    Map AAs = Map.from(widget.material)
      ..remove('materialName')
      ..remove('subjectName');

    // Function to show the popup dialog
    void _showAddMaterialDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Pdf'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: pdfNameController,
                  decoration: InputDecoration(
                    hintText: "Enter Pdf Name",
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: pdfUrlController,
                  decoration: InputDecoration(
                    hintText: "Enter Pdf URL",
                  ),
                ),
              ],
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
                  String newPdfName = pdfNameController.text;
                  String newPdfUrl = pdfUrlController.text;

                  // Create the map for the Firestore document
                  Map<String, dynamic> data = {
                    'facultyName': widget.facultyName,
                    'branchName': widget.branchName,
                    'semesterName': widget.semesterName,
                    'subjectName': widget.subjectName,
                    'materialName': widget.materialName,
                    'name': userData?['name'],
                    'pdfName': newPdfName,
                    'link': newPdfUrl,
                    'verfstatus': 'pending',
                    'role': userData?['role'],
                  };

                  // Add the document to Firestore
                  await FirebaseFirestore.instance
                      .collection('materialverf')
                      .doc('${widget.subjectName},$newPdfName')
                      .set(data);

                  pdfNameController.clear();
                  pdfUrlController.clear();

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
                        width: 1.0,
                      ),
                      Text(
                        widget.materialName,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.07,
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
              itemCount: (AAs.length / 2).ceil(),
              itemBuilder: (context, index) {
                int startIndex = index * 2;
                int endIndex = startIndex + 2;
                if (endIndex > AAs.length) {
                  endIndex = AAs.length;
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7.0, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (int i = startIndex; i < endIndex; i++)
                        buildMaterialBox(context, AAs.values.elementAt(i)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMaterialDialog, // Function to show popup dialog
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF323232),
      ),
    );
  }

  Widget buildMaterialBox(BuildContext context, Map AA) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewer(AA: AA),
          ),
        );
      },
      child: Container(
        height: 130,
        width: 140,
        decoration: BoxDecoration(
          color: Color.fromRGBO(50, 50, 50, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AA['pdfName'] ?? 'Default AA Name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewer(AA: AA),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
                child: Text(
                  'View',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
