import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildCard(
    BuildContext context, String title, String assetPath, Widget nextPage) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
    },
    child: Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          color: Color(0xFF212121),
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
          border: Border.all(
            color: Color(0xFF212121),
            width: MediaQuery.of(context).size.width * 0.01,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetPath,
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildButton(
    BuildContext context, String text, Widget nextPage, IconData icon) {
  return Padding(
    padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.02,
        top: MediaQuery.of(context).size.height * 0.025),
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.055,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Color.fromARGB(255, 93, 93, 93),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Color.fromARGB(255, 252, 251, 251),
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            Icon(
              icon,
              color: Color.fromARGB(255, 252, 251, 251),
            ),
          ],
        ),
      ),
    ),
  );
}
