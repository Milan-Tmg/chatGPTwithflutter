// ignore_for_file: camel_case_types

import 'package:chatgpt/chat/chatscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const myapp());
}

class myapp extends StatelessWidget {
  const myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'chatGPT',
      home: const chatgpt(),
    );
  }
}

class chatgpt extends StatefulWidget {
  const chatgpt({super.key});

  @override
  State<chatgpt> createState() => _chatgptState();
}

class _chatgptState extends State<chatgpt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              height: 40,
              width: 40,
              image: AssetImage(
                'assets/chatgptlogo.png',
              ),
            ),
            Text('  ChatGPT'),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      //import chatscreen from the chatscreen class
      body: const ChatScreen(),
    );
  }
}
