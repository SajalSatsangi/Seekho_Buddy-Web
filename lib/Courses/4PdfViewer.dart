import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewer extends StatelessWidget {
  final Map AA; // The data you want to pass

  PdfViewer({required this.AA});

  @override
  Widget build(BuildContext context) {
    print(AA);
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
          AA['pdfName'], // Display aaName in the app bar
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
      ),
      body: PDF().cachedFromUrl(
        AA['link'],
        placeholder: (progress) =>
            Center(child: CircularProgressIndicator(value: progress)),
        errorWidget: (error) =>
            Center(child: Text("Error loading PDF: $error")),
      ),
    );
  }
}