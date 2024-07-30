import 'package:flutter/material.dart';

class useredit extends StatefulWidget {
  final String field;
  final String currentValue;

  useredit({required this.field, required this.currentValue});

  @override
  _EditFieldState createState() => _EditFieldState();
}

class _EditFieldState extends State<useredit> {
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
            color: Colors.white), // Set back button icon color to white
        title: Text(
          'Edit ${widget.field}',
          style: TextStyle(
              color: Colors.white), // Set the title text color to white
        ),
        backgroundColor:
            Colors.black, // Set the background color of the AppBar (optional)
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.white), // Change to back_arrow_ios
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
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                decoration: BoxDecoration(
                  color: Color(
                      0xFF212121), // Set the background color of the box to gray
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width *
                          0.1), // Set border radius
                ),
                child: Text(
                  widget.field,
                  style: TextStyle(
                      color: const Color.fromARGB(
                          255, 255, 255, 255)), // Set text color to white
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              decoration: BoxDecoration(
                color: Color(
                    0xFF212121), // Set the background color of the box to gray
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width *
                        0.1), // Set border radius
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(
                    color: const Color.fromARGB(
                        255, 255, 255, 255)), // Set the text color to white
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none, // Remove border
                  ),
                  filled: true,
                  fillColor: Color(
                      0xFF212121), // Set the background color of the TextField
                  hintText: 'Enter ${widget.field}', // Set placeholder text
                  hintStyle: TextStyle(
                      color: const Color.fromARGB(
                          255, 255, 255, 255)), // Set placeholder text color
                  contentPadding: EdgeInsets.all(
                      MediaQuery.of(context).size.width *
                          0.03), // Set content padding
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Set button color to white
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width *
                          0.1), // Set border radius
                ),
              ),
              onPressed: () {
                // Save the changes
                Navigator.pop(context, _controller.text);
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.black, // Set text color to black
                  fontWeight: FontWeight.bold, // Make text bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
