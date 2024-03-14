import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String anEmail;
  const ChatPage({super.key,required this.anEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Chhat"),),
    );
  }
}
