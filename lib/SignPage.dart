import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seekhobuddy/LoginPage.dart';
import 'package:seekhobuddy/emailVerificationWaiting.dart';
import 'package:seekhobuddy/dropdown_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => SignUpPage(),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyHub',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(0, 0, 0, 1),
        hintColor: Colors.white,
      ),
      home: StudyHubLoginScreen(),
    );
  }
}

class StudyHubLoginScreen extends StatefulWidget {
  @override
  _StudyHubLoginScreenState createState() => _StudyHubLoginScreenState();
}

class _StudyHubLoginScreenState extends State<StudyHubLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollnoController = TextEditingController();


  String? _idCardUrl;  // A

  final _formKey = GlobalKey<FormState>();

  String? _selectedFaculty;
  String? _selectedSubfaculty;
  String? _selectedSemester;
  String? _selectedSubbranch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF161616),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double padding = constraints.maxWidth * 0.08;
            double iconSize = constraints.maxWidth * 0.07;
            double fontSizeTitle = constraints.maxWidth * 0.06;
            double fontSizeSubtitle = constraints.maxWidth * 0.04;
            double inputFieldHeight = constraints.maxHeight * 0.07;
            double buttonHeight = constraints.maxHeight * 0.06;
            double spacingHeight = constraints.maxHeight * 0.02;
            double inputFontSize = constraints.maxWidth * 0.035;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/loginPage.png',
                      height: constraints.maxHeight * 0.3,
                    ),
                    SizedBox(height: spacingHeight),
                    Text(
                      'Seekho Buddy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacingHeight / 2),
                    Text(
                      'Access study materials efficiently',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: fontSizeSubtitle,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacingHeight * 2),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            icon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            height: inputFieldHeight,
                            iconSize: iconSize,
                            fontSize: inputFontSize,
                          ),
                          SizedBox(height: spacingHeight),
                          _buildTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            icon: Icons.password,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            height: inputFieldHeight,
                            iconSize: iconSize,
                            fontSize: inputFontSize,
                          ),
                          SizedBox(height: spacingHeight),
                          _buildTextField(
                            controller: _nameController,
                            hintText: 'Name',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            height: inputFieldHeight,
                            iconSize: iconSize,
                            fontSize: inputFontSize,
                          ),
                          SizedBox(height: spacingHeight),
                          _buildTextField(
                            controller: _rollnoController,
                            hintText: 'Roll-No',
                            icon: Icons.numbers,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your roll Number';
                              }
                              return null;
                            },
                            height: inputFieldHeight,
                            iconSize: iconSize,
                            fontSize: inputFontSize,
                          ),
                          SizedBox(height: spacingHeight),
                          _buildDropdown(
                            value: _selectedFaculty,
                            items: faculties,
                            hintText: 'Faculty',
                            icon: Icons.school,
                            onChanged: (value) {
                              setState(() {
                                _selectedFaculty = value;
                                _selectedSubfaculty = null;
                                _selectedSemester = null;
                                _selectedSubbranch = null;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a faculty';
                              }
                              return null;
                            },
                            height: inputFieldHeight,
                            iconSize: iconSize,
                            fontSize: inputFontSize,
                          ),
                          SizedBox(height: spacingHeight),
                          _buildDropdown(
                            value: _selectedSubfaculty,
                            items: subfaculties[_selectedFaculty] ?? [],
                            hintText: 'Branch',
                            icon: Icons.new_label,
                            onChanged: (value) {
                              setState(() {
                                _selectedSubfaculty = value;
                                _selectedSemester = null;
                                _selectedSubbranch = null;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a branch';
                              }
                              return null;
                            },
                            height: inputFieldHeight,
                            iconSize: iconSize,
                            fontSize: inputFontSize,
                          ),
                          SizedBox(height: spacingHeight),
                          _buildDropdown(
                            value: _selectedSemester,
                            items: semesters[_selectedSubfaculty] ?? [],
                            hintText: 'Semester',
                            icon: Icons.calendar_month,
                            onChanged: (value) {
                              setState(() {
                                _selectedSemester = value;
                                _selectedSubbranch = null;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a semester';
                              }
                              return null;
                            },
                            height: inputFieldHeight,
                            iconSize: iconSize,
                            fontSize: inputFontSize,
                          ),
                          SizedBox(height: spacingHeight),
                          _buildDropdown(
                            value: _selectedSubbranch,
                            items: subbranches[
                                    '${_selectedFaculty}_${_selectedSubfaculty}_${_selectedSemester}'] ??
                                [],
                            hintText: 'Specialization',
                            icon: Icons.branding_watermark,
                            onChanged: (value) {
                              setState(() {
                                _selectedSubbranch = value;
                              });
                            },
                            height: inputFieldHeight,
                            iconSize: iconSize,
                            fontSize: inputFontSize,
                          ),
                          SizedBox(height: spacingHeight * 1),
                          _buildUploadField(
                            height: inputFieldHeight,
                            iconSize: iconSize,
                            fontSize: inputFontSize,
                          ),
                          SizedBox(height: spacingHeight * 2),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: padding),
                            child: ElevatedButton(
                              onPressed: _signUp,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromRGBO(66, 66, 66, 1),
                                minimumSize:
                                    Size(double.infinity, buttonHeight),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text('Sign Up'),
                            ),
                          ),
                          SizedBox(height: spacingHeight * 2.5),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade800,
                                  thickness: 1,
                                  indent: padding,
                                  endIndent: padding / 2,
                                ),
                              ),
                              Text(
                                'WELCOME BACK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSizeSubtitle,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade800,
                                  thickness: 1,
                                  indent: padding / 2,
                                  endIndent: padding,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacingHeight * 1.25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 123, 121, 121),
                                  fontSize: fontSizeSubtitle,
                                ),
                              ),
                              SizedBox(width: spacingHeight / 2),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeSubtitle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _signUp() async {
  if (_formKey.currentState!.validate()) {
    // Add this block to validate ID card upload
    if (_idCardUrl == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload your ID card')),
        );
      }
      return;  // Exit the function if ID card is not uploaded
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      String uid = userCredential.user!.uid;


      await FirebaseFirestore.instance
          .collection('users')
          .doc(_emailController.text)
          .set({
        'uid': uid,
        'email': _emailController.text,
        'name': _nameController.text,
        'faculty': _selectedFaculty,
        'subfaculty': _selectedSubfaculty,
        'semester': _selectedSemester,
        'subbranch': _selectedSubbranch,
        'rollno': _rollnoController.text,
        'profile_picture': 'https://t4.ftcdn.net/jpg/02/44/43/69/360_F_244436923_vkMe10KKKiw5bjhZeRDT05moxWcPpdmb.jpg',
        'role': 'student',
        'verifiedstatus': 'False',
        'status': '',
        'date': '',
        'idCardUrl': _idCardUrl,  // Add this line to save the ID card URL
      });

      await sendWelcomeEmail(
        _emailController.text,
        _nameController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signed up successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WaitingVerification()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: ${e.message}')),
        );
      }
    }
  }
}

  Future<void> sendWelcomeEmail(String email, String name) async {
    const url = 'https://seekhobuddy-mailer.vercel.app/api/send-emailsignup';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userEmail': email, 'userName': name}),
      );

      if (response.statusCode == 200) {
        print('Email sent successfully');
      } else {
        print('Failed to send email: ${response.body}');
      }
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    required double height,
    required double iconSize,
    required double fontSize,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: iconSize,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: height,
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize), // Responsive font size here
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                      color: Colors.white70,
                      fontSize: fontSize), // Responsive hint text size here
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  contentPadding: EdgeInsets.symmetric(vertical: 10).copyWith(
                    left: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: validator,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hintText,
    required IconData icon,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
    required double height,
    required double iconSize,
    required double fontSize,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: iconSize,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Container(
              height: height,
              child: DropdownButtonFormField<String>(
                value: value,
                onChanged: onChanged,
                items: items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      textAlign: TextAlign.center, // Center-align the text here
                      style: TextStyle(fontSize: fontSize),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                      color: Colors.white70,
                      fontSize: fontSize), // Responsive hint text size here
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: (height - 50) / 2, // Adjust vertical padding
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: validator,
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        fontSize), // Responsive selected item font size here
                iconEnabledColor: Colors.white, // Change dropdown icon color
                dropdownColor:
                    Colors.grey.shade800, // Change dropdown background color
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadField({
  required double height,
  required double iconSize,
  required double fontSize,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Row(
      children: [
        Icon(
          Icons.attach_file,
          color: Colors.white,
          size: iconSize,
        ),
        SizedBox(width: 5),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromARGB(255, 72, 72, 72),
            ),
            height: height,
            child: TextButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                );

                if (result != null) {
                  PlatformFile file = result.files.first;

                  // Get a reference to storage root
                  Reference storageReference = FirebaseStorage.instance.ref();

                  // Create a reference for the image to be stored
                  Reference imageReference = storageReference.child('idCards/${_nameController.text}_idCard.${file.extension}');

                  // Create UploadTask
                  UploadTask uploadTask = imageReference.putFile(File(file.path!));

                  // Wait for the upload to complete
                  TaskSnapshot snapshot = await uploadTask;

                  // Get the download URL
                  String downloadUrl = await snapshot.ref.getDownloadURL();

                  // Update the state with the ID card URL
                  setState(() {
                    _idCardUrl = downloadUrl;
                  });

                  // Show a success message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ID Card uploaded successfully')),
                    );
                  }
                } else {
                  // User canceled the picker
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No file selected')),
                    );
                  }
                }
              },
              child: Text(
                _idCardUrl == null ? 'Upload ID Card *' : 'ID Card Uploaded ✓',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromARGB(179, 234, 234, 234),
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}
