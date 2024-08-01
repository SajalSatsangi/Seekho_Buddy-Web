import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seekhobuddy/AdminScreens/Profile-Admin.dart';
import 'package:seekhobuddy/AdminScreens/UserData_Edit.dart';

void main() {
  runApp(userdata());
}

class userdata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserDataPage(),
      theme: ThemeData.dark(),
    );
  }
}

class UserDataPage extends StatefulWidget {
  @override
  _UserDataPageState createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _users = [];
  List<DocumentSnapshot> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    setState(() {
      _filteredUsers = _users
          .where((user) => (user.data() as Map<String, dynamic>)['name']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Data",
          style: TextStyle(fontSize: 18), // Adjust the font size of the app bar
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreenAdmin()),
            );
          },
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: MediaQuery.of(context).size.height * 0.01),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20, // Adjust the icon size
                  ),
                  filled: true,
                  fillColor: Color(0xFF323232),
                  contentPadding: EdgeInsets.all(20), // Adjust padding
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Adjust border radius
                    borderSide: BorderSide(color: Color(0xFF323232)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  _users = snapshot.data!.docs;
                  _filteredUsers = _users
                      .where((user) =>
                          (user.data() as Map<String, dynamic>)['name']
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                      .toList();

                  return ListView(
                    children: _filteredUsers.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.01), // Increased gap between boxes
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.55, // Further decreased the width
                            padding: EdgeInsets.all(15), // Adjust padding
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(30), // Increased border radius
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: MediaQuery.of(context).size.width * 0.05, // Reduced the avatar size
                                  backgroundImage: NetworkImage(
                                    data['profile_picture'],
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.04),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${data['name']}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20, // Adjust the font size
                                        ),
                                      ),
                                      SizedBox(height: 4), // Adjust spacing
                                      Text(
                                        "${data['faculty']}",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 201, 201, 201),
                                          fontSize: 18, // Adjust the font size
                                        ),
                                      ),
                                      Text(
                                        "Branch - ${data['subfaculty']}",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 201, 201, 201),
                                          fontSize: 18, // Adjust the font size
                                        ),
                                      ),
                                      Text(
                                        "Sem - ${data['semester']}",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 201, 201, 201),
                                          fontSize: 18, // Adjust the font size
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color.fromARGB(255, 201, 201, 201)
                                        .withOpacity(0.2),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20, // Adjust icon size
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => userdata_edit(
                                                  userData: data,
                                                )),
                                      );
                                      // Add functionality for edit here
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
