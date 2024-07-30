import 'dart:io';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> showAddPopup(BuildContext context) async {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> selectedFaculties = [];
  List<String> selectedSubfaculties = [];
  List<String> selectedSemesters = [];
  List<String> selectedSubbranches = [];

  final List<String> faculties = [
    'Faculty of Engineering',
    'Faculty of Science',
    'Faculty of Arts',
    'Faculty of Commerce',
    'Faculty of Education',
    'Faculty of Architecture',
    'DEI Technical College'
  ];
  final List<String> subfaculties = [
    "1stYear",
    "Electrical",
    "Mechanical",
    "Civil",
    "Footwear",
    "Agriculture",
  ];
  final List<String> semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8'
  ];
  final List<String> subbranches = ['Computer Science', 'Nil', ''];

  PlatformFile? selectedFile;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return AlertDialog(
            backgroundColor: Color(0xFF323232),
            title: Text(
              'Add Notice',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 150,
                  minWidth: constraints.maxWidth - 100,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      maxLines: 5,
                    ),
                    SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['png', 'jpg', 'pdf'],
                        );
                        if (result != null) {
                          selectedFile = result.files.first;
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                      ),
                      icon: Icon(Icons.file_upload),
                      label: Text(
                        'Upload Image',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    SizedBox(height: 16),
                    MultiSelectDialogField(
                      items:
                          faculties.map((e) => MultiSelectItem(e, e)).toList(),
                      title: Text("Faculties"),
                      selectedColor: Colors.blue,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      buttonText: Text(
                        "Select faculties",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      itemsTextStyle: TextStyle(color: Colors.white),
                      onConfirm: (results) {
                        selectedFaculties = results;
                      },
                    ),
                    SizedBox(height: 16),
                    MultiSelectDialogField(
                      items: subfaculties
                          .map((e) => MultiSelectItem(e, e))
                          .toList(),
                      title: Text("Branches"),
                      selectedColor: Colors.blue,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      buttonText: Text(
                        "Select Branch",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      itemsTextStyle: TextStyle(color: Colors.white),
                      onConfirm: (results) {
                        selectedSubfaculties = results;
                      },
                    ),
                    SizedBox(height: 16),
                    MultiSelectDialogField(
                      items:
                          semesters.map((e) => MultiSelectItem(e, e)).toList(),
                      title: Text("Semesters"),
                      selectedColor: Colors.blue,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      buttonText: Text(
                        "Select Semester",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      itemsTextStyle: TextStyle(color: Colors.white),
                      onConfirm: (results) {
                        selectedSemesters = results;
                      },
                    ),
                    SizedBox(height: 16),
                    MultiSelectDialogField(
                      items: subbranches
                          .map((e) => MultiSelectItem(e, e))
                          .toList(),
                      title: Text("Specilization"),
                      selectedColor: Colors.blue,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      buttonText: Text(
                        "Select Specilization",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      itemsTextStyle: TextStyle(color: Colors.white),
                      onConfirm: (results) {
                        selectedSubbranches = results;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String fileUrl = 'https://img.freepik.com/premium-vector/notice-free-vector_734448-5.jpg';
                  if (selectedFile != null) {
                    TaskSnapshot snapshot = await FirebaseStorage.instance
                        .ref('notices/${selectedFile!.name}')
                        .putFile(File(selectedFile!.path!));

                    fileUrl = await snapshot.ref.getDownloadURL();
                  }

                  final data = <String, dynamic>{
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'fileUrl': fileUrl,
                    'date': DateTime.now().toString(),
                  };

                  if (selectedFaculties.isNotEmpty) {
                    data['faculties'] = selectedFaculties;
                  }
                  if (selectedSubfaculties.isNotEmpty) {
                    data['subfaculties'] = selectedSubfaculties;
                  }
                  if (selectedSemesters.isNotEmpty) {
                    data['semesters'] = selectedSemesters;
                  }
                  if (selectedSubbranches.isNotEmpty) {
                    data['subbranches'] = selectedSubbranches;
                  }

                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                  int docCount = await firestore
                      .collection('notices')
                      .get()
                      .then((querySnapshot) => querySnapshot.docs.length);
                  int newDocId = docCount + 1;

                  firestore
                      .collection('notices')
                      .doc('Notice ' + newDocId.toString())
                      .set(data);

                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
