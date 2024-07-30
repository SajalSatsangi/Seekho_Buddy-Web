import 'package:flutter/material.dart';
import 'package:seekhobuddy/Courses/3Materials.dart';

class Materialsectionpage extends StatelessWidget {
  final Map<String, dynamic> subjectData;
  final Map<String, dynamic> allData;
  final String subjectName;

  Materialsectionpage({
    required this.subjectData,
    required this.allData,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    Map materials = Map.from(subjectData)..remove('subjectName');

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
                                subjectName,
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
                      itemCount: materials.length,
                      itemBuilder: (context, index) {
                        String materialKey = materials.keys.elementAt(index);
                        Map material = materials[materialKey];

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
                                          Icons.book_sharp,
                                          color: Colors.white,
                                          size: isDesktop ? 28 : 24,
                                        ),
                                        SizedBox(width: isDesktop ? 16 : 8),
                                        Text(
                                          material['materialName'] ??
                                              'Default Material Name',
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
                                          SlideRightPageRoute(
                                            page: Materialpage(
                                              materialName:
                                                  material['materialName'],
                                              material: material,
                                            ),
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

class SlideRightPageRoute extends PageRouteBuilder {
  final Widget page;

  SlideRightPageRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
