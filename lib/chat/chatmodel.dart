enum ChatmessageType { bot, user }

//this is the chatmodel which is used to find wheather the messages is provided by bot or user
class Chatmessage {
  Chatmessage({
    required this.text,
    required this.chatmessageType,
  });
  final String text;
  final ChatmessageType chatmessageType;
}
