import 'package:flutter/material.dart';
import 'package:seekhobuddy/AdminScreens/pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04,
                top: MediaQuery.of(context).size.height * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Text(
                        "Material Confirmation",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.width * 0.06,
                bottom: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Material Confirmation Requests",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('materialverf')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView(
                    children: snapshot.data?.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;

                          if (data['verfstatus'] == 'pending') {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width * 0.03,
                                      0,
                                      MediaQuery.of(context).size.width * 0.03,
                                      0),
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.04),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF323232),
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.03),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 16),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PdfViewer(
                                                      pdfName: data['pdfName'],
                                                      link: data['link'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.black,
                                              ),
                                              child: Text(
                                                "View Material",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "${data['role']}: ${data['name']}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.5,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "${data['facultyName']}->${data['branchName']}->${data['semesterName']}",
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                              overflow: TextOverflow.visible,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.check,
                                                  color: Colors.green),
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Confirm Material Verification'),
                                                      content: Text(
                                                        'Are You Sure That You Want To Verify this Material?',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('No'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('Yes'),
                                                          onPressed: () async {
                                                           // Create the map for the Firestore document
                                                Map<String, dynamic> newData = {
                                                  'pdfName': data['pdfName'],
                                                  'link': data['link'],
                                                };
                                                // Update the 'verfstatus' field in the userData document
                                                await FirebaseFirestore.instance
                                                    .collection('materialverf')
                                                    .doc(
                                                        '${data['subjectName']},${data['pdfName']}')
                                                    .update({
                                                  'verfstatus': 'completed'
                                                });

                                                // The existing function for updating the document in 'seekhobuddydb' collection
                                                await FirebaseFirestore.instance
                                                    .collection('seekhobuddydb')
                                                    .doc(data['facultyName'])
                                                    .update({
                                                  'branches.${data['branchName']}.${data['semesterName']}.${data['subjectName']}.${data['materialName']}.${data['pdfName']}':
                                                      newData
                                                });

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02),
                                            IconButton(
                                              icon: Icon(Icons.close,
                                                  color: Colors.red),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Confirm Delete'),
                                                      content: Text(
                                                        'Are you sure that you want to delete?',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('No'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('Yes'),
                                                          onPressed: () async {
                                                            // Delete the document from the 'materialverf' collection
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'materialverf')
                                                                .doc(
                                                                    '${data['subjectName']},${data['pdfName']}')
                                                                .delete();

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.03), // Adjust the height as needed
                              ],
                            );
                          } else {
                            return Container(); // Return an empty container if 'verfstatus' is not 'pending'
                          }
                        }).toList() ??
                        [],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MaterialConfirmationScreen(),
    theme: ThemeData.dark(),
  ));
}
