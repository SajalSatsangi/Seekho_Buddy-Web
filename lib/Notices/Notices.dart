import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notice_popup.dart';
import 'package:seekhobuddy/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(NoticesAdmin());
}

class NoticesAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyWidget(),
      theme: ThemeData.dark(),
    );
  }
}

class Notice {
  final String title;
  final String description;
  final String date;
  final String fileUrl;

  Notice({
    required this.title,
    required this.description,
    required this.date,
    required this.fileUrl,
  });
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('notices');
  DocumentSnapshot? userData;
  late SharedPreferences prefs;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Set<String> clickedNotices = Set<String>();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    listenForNewNotices();
    loadClickedNotices();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }



  Future<void> fetchUserData() async {
    prefs = await SharedPreferences.getInstance();
    DateTime lastFetchTime =
        DateTime.parse(prefs.getString('lastFetchTime') ?? '2000-01-01');
    DateTime now = DateTime.now();

    final User? user = FirebaseAuth.instance.currentUser;

    if (now.difference(lastFetchTime).inDays >= 1 || userData == null) {
      if (user != null) {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            userData = querySnapshot.docs.first;
            saveUserDataLocally(); // Save data locally when fetched
            prefs.setString('lastFetchTime', now.toIso8601String());
          });
        }
      }
    }
  }

  void listenForNewNotices() {
    collectionRef.snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          // A new document was added
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          if (shouldRenderNotice(data)) {
            // If the notice is relevant to the user, display a notification
            _showNotification(data['title'], data['description']);
          }
        }
      });
    });
  }

  Future<void> _showNotification(String title, String description) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'new_notice_channel', 'New Notice Notifications',
        importance: Importance.max, priority: Priority.high, showWhen: false);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    try {
      await flutterLocalNotificationsPlugin.show(
          0, title, description, platformChannelSpecifics);
    } catch (e) {
      print('Failed to show notification: $e');
    }
  }

  void saveUserDataLocally() {
    // Implement saving user data locally if necessary
  }

  Future<void> loadClickedNotices() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      clickedNotices =
          prefs.getStringList('clickedNotices')?.toSet() ?? <String>{};
    });
  }

  Future<void> saveClickedNotices() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('clickedNotices', clickedNotices.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 28.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Row(
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
                      SizedBox(width: 10.0),
                      Text(
                        "Notices",
                        style: TextStyle(
                          fontSize: 28,
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
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Color(0xFF323232),
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFF323232)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: collectionRef.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  if (userData == null) {
                    return Text("Loading user data...");
                  }

                  return new ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      if (shouldRenderNotice(data)) {
                        return new GestureDetector(
                          onTap: () {
                            setState(() {
                              clickedNotices.add(document.id);
                              saveClickedNotices();
                            });
                            showMaintenanceNotice(context, data['title'],
                                data['description'], data['fileUrl']);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Stack(
                              children: [
                                Container(
                                  width: 500,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF323232).withOpacity(
                                        clickedNotices.contains(document.id)
                                            ? 0.6
                                            : 1.0),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['title'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white.withOpacity(
                                              clickedNotices
                                                      .contains(document.id)
                                                  ? 0.6
                                                  : 1.0),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        data['description'],
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(
                                              clickedNotices
                                                      .contains(document.id)
                                                  ? 0.6
                                                  : 1.0),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Posted on: ${data['date']}",
                                        style: TextStyle(
                                          color: Colors.grey.withOpacity(
                                              clickedNotices
                                                      .contains(document.id)
                                                  ? 0.6
                                                  : 1.0),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!clickedNotices.contains(
                                    document.id)) // Only show if not clicked
                                  Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: Container(
                                      width: 17,
                                      height: 17,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 230, 61, 27),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xDD000000),
    );
  }

  bool shouldRenderNotice(Map<String, dynamic> noticeData) {
    print('Notice data: $noticeData');
    if (userData == null) return false;

    var userFaculty = userData!['faculty'];
    var userSubFaculty = userData!['subfaculty'];
    var userSemester = userData!['semester'];
    var userSubBranch = userData!['subbranch'];

    var noticeFaculties = noticeData['faculties'];
    var noticeSubFaculties = noticeData['subfaculties'];
    var noticeSemesters = noticeData['semesters'];
    var noticeSubBranches = noticeData['subbranches'];

    if (noticeFaculties != null) {
      if (!noticeFaculties.contains(userFaculty)) {
        return false;
      } else {
        if (noticeSubFaculties != null) {
          if (!noticeSubFaculties.contains(userSubFaculty)) {
            return false;
          } else {
            if (noticeSemesters != null) {
              if (!noticeSemesters.contains(userSemester)) {
                return false;
              } else {
                if (noticeSubBranches != null &&
                    !noticeSubBranches.contains(userSubBranch)) {
                  return false;
                }
              }
            }
          }
        }
      }
    }

    return true;
  }
}
