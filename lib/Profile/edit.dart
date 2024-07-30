import 'package:flutter/material.dart';

class EditField extends StatefulWidget {
  final String field;
  final String currentValue;

  EditField({required this.field, required this.currentValue});

  @override
  _EditFieldState createState() => _EditFieldState();
}

class _EditFieldState extends State<EditField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ), // Set back button icon color to white
        title: Text(
          'Edit ${widget.field}',
          style: TextStyle(
            color: Colors.white,
          ), // Set the title text color to white
        ),
        backgroundColor:
            Colors.black, // Set the background color of the AppBar (optional)
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ), // Change to back_arrow_ios
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.025,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF212121),
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
                child: Text(
                  widget.field,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.024),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF212121),
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.02,
                ),
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFF212121),
                  hintText: 'Enter ${widget.field}',
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  contentPadding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.08,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
