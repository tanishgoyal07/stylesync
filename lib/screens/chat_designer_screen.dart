import 'package:flutter/material.dart';

class ChatDesignerScreen extends StatelessWidget {
  final String name;
  const ChatDesignerScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Chat with $name',
          style: const TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color(0xFF8D6E63),
      ),
      body: const Center(
        child: Text(
          "Will be launched soon!",
        ),
      ),
    );
  }
}