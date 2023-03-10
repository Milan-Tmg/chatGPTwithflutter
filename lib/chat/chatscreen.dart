import 'dart:convert';

import 'package:chatgpt/chat/chatmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:chatgpt/apikey.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //Textediting controller is used to track the input given by user
  final TextEditingController _chatController = TextEditingController();
  final List<Chatmessage> messages = [];

  //fetching the data from the chatgpt api
  //apikey is provides freely by openAI
  Future<String> getresponse(String prompt) async {
    const apikey = apiKey;
    var url = Uri.https('api.openai.com', '/v1/completions');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'Application/json',
          'Authorization': 'Bearer $apikey'
        },
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": prompt,
          "max_tokens": 3000,
          "temperature": 0,
          "top_p": 1,
        }));
    Map<String, dynamic> newresponse = jsonDecode(response.body);
    return newresponse['choices'][0]['text'];
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Drawer has only one options to clear the coversation
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                //conditional statement is used to check there is a conversion available or not
                //if there is coversation then when user click on delete bottom then conversation will delete
                //if not the snackbar is shown
                if (messages.isNotEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure want to clear all messages'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('No')),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (messages.isNotEmpty) {
                                      messages.clear();
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                                child: const Text('yes'),
                              ),
                            ],
                          ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'There is no conversation yet',
                        style: TextStyle(fontSize: 20),
                      )));
                }
              },
              title: const Text('Clear Conversation'),
              leading: const Icon(Icons.delete_outline_outlined),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index];
                  return ChatDisplay(
                    text: message.text,
                    chatmessageType: message.chatmessageType,
                  );
                },
              ),
            ),
            Flexible(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  controller: _chatController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (_chatController.text.isNotEmpty &&
                              _chatController.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                            messages.add(Chatmessage(
                                text: _chatController.text,
                                chatmessageType: ChatmessageType.user));
                            isLoading = true;
                          }
                          var input = _chatController.text;
                          _chatController.clear();
                          getresponse(input).then((value) => {
                                setState(() {
                                  messages.add(Chatmessage(
                                      text: value,
                                      chatmessageType: ChatmessageType.bot));
                                  isLoading = false;
                                })
                              });
                        });
                      },
                      icon: isLoading
                          ? const SpinKitThreeBounce(
                              color: Colors.white,
                              size: 20,
                            )
                          : const Icon(Icons.send_outlined),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'Send a message',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
//Building the chatUI
class ChatDisplay extends StatelessWidget {
  String text;
  final ChatmessageType chatmessageType;
  ChatDisplay({super.key, required this.text, required this.chatmessageType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Container(
            color: chatmessageType == ChatmessageType.bot
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.background,
            child: Text(
              text.trim(),
              style: TextStyle(
                fontSize: 22,
                color: chatmessageType == ChatmessageType.bot
                    ? const Color.fromARGB(255, 114, 190, 179)
                    : Colors.white,
              ),
            ),
          ),
          leading: chatmessageType == ChatmessageType.bot
              ? Image.asset(
                  'assets/chatgptlogo.png',
                  height: 40,
                  width: 40,
                )
              : const Icon(
                  Icons.person,
                  size: 40,
                ),
        ),
        const Divider(
          color: Colors.black,
          thickness: .1,
        )
      ],
    );
  }
}
