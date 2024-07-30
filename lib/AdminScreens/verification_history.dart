import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_verification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HistoryApp());
}

class HistoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HistoryScreen(),
      theme: ThemeData.dark(),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.03,
            horizontal: MediaQuery.of(context).size.width *
                0.04), // Adjusted padding using MediaQuery
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerificationApp()),
                        );
                      },
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.02), // Adjusted width using MediaQuery
                    Text(
                      "History",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width *
                            0.06, // Adjusted font size using MediaQuery
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.02), // Adjusted height using MediaQuery
            Text(
              "Student Verification History",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width *
                    0.06, // Adjusted font size using MediaQuery
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.01), // Adjusted height using MediaQuery
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width *
                        0.04), // Adjusted padding using MediaQuery
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('verifiedstatus', isEqualTo: 'True')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var documents = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var data =
                            documents[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height *
                                  0.02), // Adjusted padding using MediaQuery
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width *
                                    0.04), // Adjusted padding using MediaQuery
                            decoration: BoxDecoration(
                              color: Color(0xFF323232),
                              borderRadius: BorderRadius.circular(MediaQuery.of(
                                          context)
                                      .size
                                      .width *
                                  0.04), // Adjusted border radius using MediaQuery
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['name'] ?? 'No Name',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.04, // Adjusted font size using MediaQuery
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.01), // Adjusted height using MediaQuery
                                    Text(
                                      "Date: ${data['date'] ?? 'No Date'}",
                                      style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  data['status'] ?? 'No Status',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
