import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() {
  runApp(AiChat());
}

class AiChat extends StatelessWidget {
  AiChat({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Education App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}
