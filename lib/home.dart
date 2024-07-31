import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seekhobuddy/AdminScreens/Noticepage/Notices-Admin.dart';
import 'package:seekhobuddy/Courses.dart';
import 'package:seekhobuddy/LoginPage.dart';
import 'package:seekhobuddy/NewHelp.dart';
import 'package:seekhobuddy/donation.dart';
import 'package:seekhobuddy/AdminScreens/Profile-Admin.dart';
import 'package:seekhobuddy/ComingSoonPage.dart';
import 'package:seekhobuddy/aichat.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeekhoBuddy App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ExploreScreen(),
    AiChat(),
    ProfileScreenAdmin(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  ExploreScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error logging out: $e");
      // Handle any errors here
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Explore & Connect',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.grey,
            ),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Log Out',
            padding: const EdgeInsets.only(right: 25.0),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStudyMaterialsCard(context, isDesktop),
                      const SizedBox(height: 32),
                      _buildCardGrid(context, isDesktop),
                      const SizedBox(height: 32),
                      _buildButtonRow(context, isDesktop),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudyMaterialsCard(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color.fromARGB(87, 162, 162, 162),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(255, 107, 107, 107),
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore study Materials',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 24 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Best study materials for you',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 18 : 16,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Courses()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Start learning',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isDesktop ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          SvgPicture.asset(
            'assets/undraw_online_test_re_kyfx.svg',
            height: isDesktop ? 150 : 100,
            width: isDesktop ? 150 : 100,
          ),
        ],
      ),
    );
  }

  Widget _buildCardGrid(BuildContext context, bool isDesktop) {
    final cardWidth = isDesktop ? 250.0 : 160.0;
    final cardHeight = isDesktop ? 200.0 : 160.0;

    return Padding(
      padding: EdgeInsets.only(left: isDesktop ? 20.0 : 5.0), // Add left margin for desktop, no margin for mobile
      child: Wrap(
        spacing: isDesktop ? 30 : 15,
        runSpacing: isDesktop ? 16 : 8,
        alignment: WrapAlignment.center,
        children: [
          _buildCard(context, 'Explore More', 'assets/Resource.svg', ComingSoonScreen(), cardWidth, cardHeight),
          _buildCard(context, 'Notices', 'assets/Job.svg', NoticesAdmin(), cardWidth, cardHeight),
          _buildCard(context, 'Projects', 'assets/Professional.svg', ComingSoonScreen(), cardWidth, cardHeight),
          _buildCard(context, 'Networking', 'assets/Network.svg', ComingSoonScreen(), cardWidth, cardHeight),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String assetPath, Widget nextPage, double width, double height) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF212121),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF212121),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetPath,
              height: height * 0.4,
              width: height * 0.4,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildButtonRow(BuildContext context, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(context, 'Donate', Icons.badge, const DonationPage(), isDesktop),
        const SizedBox(width: 30),
        _buildButton(context, 'Help', Icons.help, Newhelp(), isDesktop),
        const SizedBox(width: 0), // Add spacing between the buttons
      ],
    );
  }
  Widget _buildButton(BuildContext context, String title, IconData icon, Widget nextPage, bool isDesktop) {
    return SizedBox(
      width: isDesktop ? 200 : 150,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 93, 93, 93),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: isDesktop ? 18 : 16,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
