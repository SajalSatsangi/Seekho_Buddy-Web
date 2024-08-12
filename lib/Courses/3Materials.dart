import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Materialpage extends StatelessWidget {
  final Map material;
  final String materialName;

  
  Materialpage({
    required this.materialName,
    required this.material,
  });

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    print(material);
    Map AAs = Map.from(material)
      ..remove('materialName')
      ..remove('subjectName');

    void _showAddMaterialDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Pdf'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Pdf Name",
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Pdf URL",
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Add'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          final contentWidth = isDesktop ? 600.0 : constraints.maxWidth;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              SizedBox(width: 10),
                              Text(
                                materialName,
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
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: AAs.length,
                      itemBuilder: (context, index) {
                        String AAKey = AAs.keys.elementAt(index);
                        Map AA = AAs[AAKey];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8, horizontal: isDesktop ? 24 : 16),
                          child: Container(
                            height: isDesktop ? 80 : 70,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(50, 50, 50, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.school, color: Colors.white),
                                      SizedBox(width: 12),
                                      Text(
                                        AA['pdfName'] ?? 'Default AA Name',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isDesktop ? 18 : 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (AA['link'] != null) {
                                        _launchURL(AA['link']);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text('PDF URL not available')),
                                        );
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(Colors.white),
                                    ),
                                    child: Text(
                                      'View',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: isDesktop ? 16 : 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
