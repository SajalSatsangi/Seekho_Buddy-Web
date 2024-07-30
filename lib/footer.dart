import 'package:flutter/material.dart';

class CustomFooter extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomFooter({required this.selectedIndex, required this.onItemTapped});

  @override
  _CustomFooterState createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Set background color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust alignment
        children: [
          Expanded(
            child: IconButton(
              icon: Icon(Icons.home),
              color: widget.selectedIndex == 0 ? Colors.white : Colors.grey,
              onPressed: () => widget.onItemTapped(0),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.chat),
              color: widget.selectedIndex == 1 ? Colors.white : Colors.grey,
              onPressed: () => widget.onItemTapped(1),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.person),
              color: widget.selectedIndex == 2 ? Colors.white : Colors.grey,
              onPressed: () => widget.onItemTapped(2),
            ),
          ),
        ],
      ),
    );
  }
}
