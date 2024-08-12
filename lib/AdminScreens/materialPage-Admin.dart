import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Materialpage_Admin extends StatelessWidget {
  final Map material;
  final String materialName;
  final String facultyName;
  final String branchName;
  final String semesterName;
  final String subjectName;

  Materialpage_Admin({
    required this.materialName,
    required this.material,
    required this.facultyName,
    required this.branchName,
    required this.semesterName,
    required this.subjectName,
  });

  final pdfNameController = TextEditingController();
  final pdfUrlController = TextEditingController();

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    print(material);
    print(facultyName);
    print(branchName);
    print(semesterName);
    print(subjectName);
    print(materialName);
    Map AAs = Map.from(material)
      ..remove('materialName')
      ..remove('subjectName');

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
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  String newPdfName = pdfNameController.text;
                  String newPdfUrl = pdfUrlController.text;

                  if (newPdfName.isNotEmpty && newPdfUrl.isNotEmpty) {
                    Map<String, dynamic> data = {
                      'pdfName': newPdfName,
                      'link': newPdfUrl,
                    };

                    await FirebaseFirestore.instance
                        .collection('seekhobuddydb')
                        .doc(facultyName)
                        .update({
                      'branches.$branchName.$semesterName.$subjectName.$materialName.$newPdfName': data
                    });

                    pdfNameController.clear();
                    pdfUrlController.clear();
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter both PDF Name and URL'),
                      ),
                    );
                  }
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
          final double contentWidth = isDesktop ? 600 : constraints.maxWidth;

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
                                materialName,
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
                      padding: EdgeInsets.all(16),
                      itemCount: AAs.length,
                      itemBuilder: (context, index) {
                        String AAKey = AAs.keys.elementAt(index);
                        Map AA = AAs[AAKey];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8, horizontal: isDesktop ? 24 : 16),
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
                                        AA['pdfName'] ?? 'Default AA Name',
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
                                      if (AA['link'] != null) {
                                        _launchURL(AA['link']);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text('PDF URL not available')),
                                        );
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(
                                          Colors.white),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMaterialDialog,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF323232),
      ),
    );
  }
}
