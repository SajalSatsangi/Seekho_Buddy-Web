import 'package:flutter/material.dart';
import 'package:seekhobuddy/Courses/4PdfViewer.dart';

class Materialpage extends StatelessWidget {
  final Map material;
  final String materialName;

  Materialpage({
    required this.materialName,
    required this.material,
  });

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
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 32 : 16,
                        vertical: isDesktop ? 20 : 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              SizedBox(width: isDesktop ? 20 : 10),
                              Text(
                                materialName,
                                style: TextStyle(
                                  fontSize: isDesktop ? 36 : 28,
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
                            vertical: isDesktop ? 10 : 7,
                            horizontal: isDesktop ? 40 : 27,
                          ),
                          child: GestureDetector(
                            child: Container(
                              height: isDesktop ? 90 : 70,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(50, 50, 50, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(isDesktop ? 20 : 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.folder,
                                          color: Colors.white,
                                          size: isDesktop ? 28 : 24,
                                        ),
                                        SizedBox(width: isDesktop ? 16 : 8),
                                        Text(
                                          AA['pdfName'] ?? 'Default AA Name',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isDesktop ? 20 : 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PdfViewer(AA: AA),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsets>(
                                          EdgeInsets.symmetric(
                                            horizontal: isDesktop ? 24 : 16,
                                            vertical: isDesktop ? 12 : 8,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'View',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: isDesktop ? 18 : 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
