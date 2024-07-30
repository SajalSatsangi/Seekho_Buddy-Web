import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'add_notice_popup.dart';
import 'notice_popup.dart';
import 'package:seekhobuddy/home.dart';

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
  Set<String> clickedNotices = Set<String>();
  String? _playerId;

  @override
  void initState() {
    super.initState();
    _initializeOneSignal();
    fetchUserData();
    listenForNewNotices();
    loadClickedNotices();
  }

  Future<void> _initializeOneSignal() async {
    OneSignal.shared.setAppId('1cc7933a-5d5d-470b-88fb-451a842f03bf');

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoticesAdmin()),
      );
    });

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print('Accepted permission: $accepted');
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print(
          'Notification received with data: ${event.notification.additionalData}');
      event.complete(event.notification);
    });

    var deviceState = await OneSignal.shared.getDeviceState();
    if (deviceState != null) {
      setState(() {
        _playerId = deviceState.userId;
        print('OneSignal Player ID: $_playerId');
      });
    }
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
            print('User role: ${userData!['role']}');
            saveUserDataLocally();
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
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          if (shouldRenderNotice(data)) {
            _showNotification(data['title'], data['description']);
          }
        }
      });
    });
  }

  Future<void> _showNotification(String title, String description) async {
    if (_playerId == null) {
      print('Player ID not available');
      return;
    }

    OneSignal.shared.postNotification(OSCreateNotification(
      playerIds: [_playerId!],
      content: description,
      heading: title,
    ));
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          final contentWidth = isDesktop ? 600.0 : constraints.maxWidth;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: EdgeInsets.only(top: isDesktop ? 40 : 20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: isDesktop ? 28 : 24),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                  );
                                },
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Notices",
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: isDesktop ? 20 : 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 18 : 16),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: isDesktop ? 28 : 24,
                          ),
                          filled: true,
                          fillColor: Color(0xFF323232),
                          contentPadding: EdgeInsets.all(12),
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

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading");
                          }

                          if (userData == null) {
                            return Text("Loading user data...");
                          }

                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              if (shouldRenderNotice(data)) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      clickedNotices.add(document.id);
                                      saveClickedNotices();
                                    });
                                    showMaintenanceNotice(
                                        context,
                                        data['title'],
                                        data['description'],
                                        data['fileUrl']);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: isDesktop ? 12 : 8),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: contentWidth,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF323232)
                                                .withOpacity(clickedNotices
                                                        .contains(document.id)
                                                    ? 0.6
                                                    : 1.0),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['title'],
                                                style: TextStyle(
                                                  fontSize: isDesktop ? 20 : 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white
                                                      .withOpacity(
                                                          clickedNotices
                                                                  .contains(
                                                                      document
                                                                          .id)
                                                              ? 0.6
                                                              : 1.0),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                data['description'],
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(
                                                          clickedNotices
                                                                  .contains(
                                                                      document
                                                                          .id)
                                                              ? 0.6
                                                              : 1.0),
                                                  fontSize: isDesktop ? 16 : 14,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Posted on: ${data['date']}",
                                                style: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                          clickedNotices
                                                                  .contains(
                                                                      document
                                                                          .id)
                                                              ? 0.6
                                                              : 1.0),
                                                  fontSize: isDesktop ? 14 : 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (!clickedNotices
                                            .contains(document.id))
                                          Positioned(
                                            bottom: 16,
                                            right: 16,
                                            child: Container(
                                              width: isDesktop ? 16 : 12,
                                              height: isDesktop ? 16 : 12,
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 230, 61, 27),
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
            ),
          );
        },
      ),
      backgroundColor: Color(0xDD000000),
      floatingActionButton: (userData != null &&
              (userData!['role'] == 'admin' ||
                  userData!['role'] == 'CR' ||
                  userData!['role'] == 'dataeditor'))
          ? Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                onPressed: () {
                  showAddPopup(context);
                },
                backgroundColor: Color(0xFF323232),
                child: Icon(Icons.add, size: 24),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
