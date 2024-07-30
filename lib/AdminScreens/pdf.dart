import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewer extends StatelessWidget {
  final String pdfName;
  final String link;


  PdfViewer({required this.pdfName, required this.link});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          // Add a back button
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          pdfName, // Display aaName in the app bar
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
      ),
      body: PDF().cachedFromUrl(
        link,
        placeholder: (progress) =>
            Center(child: CircularProgressIndicator(value: progress)),
        errorWidget: (error) =>
            Center(child: Text("Error loading PDF: $error")),
      ),
    );
  }
}