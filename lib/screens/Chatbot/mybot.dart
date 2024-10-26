// // import 'dart:convert';
// // import 'package:blockchain_upi/constants.dart';
// // import 'package:dash_chat_2/dash_chat_2.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:http/http.dart' as http;

// // class Chatbot extends StatefulWidget {
// //   const Chatbot({super.key});

// //   @override
// //   State<Chatbot> createState() => _ChatbotState();
// // }

// // class _ChatbotState extends State<Chatbot> {
// //   ChatUser myself = ChatUser(id: '1', firstName: 'User');
// //   ChatUser bot = ChatUser(id: '2', firstName: 'CryptoBot');

// //   List<ChatMessage> allMessages = [];
// //   List<ChatUser> typing = [];

// //   final oururl =
// //       'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDf0LZuNwY6VhMDT3d7OfP6hq_HnIIEky4';

// //   final header = {'Content-Type': 'application/json'};

// //   getdata(ChatMessage m) async {
// //     typing.add(bot);
// //     allMessages.insert(0, m);
// //     setState(() {});

// //     var filteredMessage =
// //         "${m.text} (related to cryptocurrency, also don't reccommend anyone to buy any currency)";

// //     var data = {
// //       "contents": [
// //         {
// //           "parts": [
// //             {"text": filteredMessage}
// //           ]
// //         }
// //       ]
// //     };

// //     await http
// //         .post(Uri.parse(oururl), headers: header, body: jsonEncode(data))
// //         .then((value) {
// //       if (value.statusCode == 200) {
// //         var result = jsonDecode(value.body);
// //         print(result['candidates'][0]['content']['parts'][0]['text']);

// //         ChatMessage m1 = ChatMessage(
// //             text: result['candidates'][0]['content']['parts'][0]['text'],
// //             user: bot,
// //             createdAt: DateTime.now());

// //         allMessages.insert(0, m1);
// //       } else {
// //         print("error occured");
// //       }
// //     }).catchError((e) {});

// //     typing.remove(bot);
// //     setState(() {});
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         automaticallyImplyLeading: false,
// //         elevation: 0,
// //         backgroundColor: purple2,
// //         leading: IconButton(
// //           onPressed: () {
// //             Navigator.of(context).pop();
// //           },
// //           icon: const Icon(
// //             Icons.arrow_back_rounded,
// //             size: 28,
// //             color: Colors.white,
// //           ),
// //         ),
// //         title: Text(
// //           'Accounts',
// //           style: GoogleFonts.montserrat(
// //             fontWeight: FontWeight.w700,
// //             fontSize: 20,
// //             color: Colors.white,
// //           ),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: DashChat(
// //         currentUser: myself,
// //         onSend: (ChatMessage m) {
// //           getdata(m);
// //         },
// //         messages: allMessages,
// //       ),
// //     );
// //   }
// // }

// import 'dart:convert';
// import 'package:blockchain_upi/constants.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// class Chatbot extends StatefulWidget {
//   const Chatbot({super.key});

//   @override
//   State<Chatbot> createState() => _ChatbotState();
// }

// class _ChatbotState extends State<Chatbot> {
//   ChatUser myself = ChatUser(id: '1', firstName: 'User');
//   ChatUser bot = ChatUser(id: '2', firstName: 'CryptoBot');

//   List<ChatMessage> allMessages = [];
//   List<ChatUser> typing = [];

//   final oururl =
//       'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDf0LZuNwY6VhMDT3d7OfP6hq_HnIIEky4';

//   final header = {'Content-Type': 'application/json'};

//   getdata(ChatMessage m) async {
//     typing.add(bot);
//     allMessages.insert(0, m);
//     setState(() {});

//     var filteredMessage =
//         "${m.text} (related to cryptocurrency, also don't recommend anyone to buy any currency)";

//     var data = {
//       "contents": [
//         {
//           "parts": [
//             {"text": filteredMessage}
//           ]
//         }
//       ]
//     };

//     await http
//         .post(Uri.parse(oururl), headers: header, body: jsonEncode(data))
//         .then((value) async {
//       if (value.statusCode == 200) {
//         var result = jsonDecode(value.body);
//         String fullResponse =
//             result['candidates'][0]['content']['parts'][0]['text'];

//         // Start displaying the response word by word
//         await _displayResponseWordByWord(fullResponse);
//       } else {
//         print("error occurred");
//       }
//     }).catchError((e) {});

//     typing.remove(bot);
//     setState(() {});
//   }

//   Future<void> _displayResponseWordByWord(String response) async {
//     List<String> words = response
//         .replaceAll("**", "*")
//         .split(' '); // Split the response into words
//     String displayedText = '';

//     ChatMessage tempMessage = ChatMessage(
//       text: displayedText,
//       user: bot,
//       createdAt: DateTime.now(),
//     );

//     allMessages.insert(0, tempMessage);
//     setState(() {});

//     for (var word in words) {
//       displayedText += '$word ';

//       // Update the message with the current state of the displayed text
//       setState(() {
//         allMessages[0] = ChatMessage(
//           text: displayedText,
//           user: bot,
//           createdAt: DateTime.now(),
//         );
//       });

//       // Wait for a short duration before adding the next word
//       await Future.delayed(const Duration(milliseconds: 100));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         backgroundColor: purple2,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(
//             Icons.arrow_back_rounded,
//             size: 28,
//             color: Colors.white,
//           ),
//         ),
//         title: Text(
//           'Accounts',
//           style: GoogleFonts.montserrat(
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: DashChat(
//         currentUser: myself,
//         onSend: (ChatMessage m) {
//           getdata(m);
//         },
//         messages: allMessages,
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:blockchain_upi/constants.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  ChatUser myself = ChatUser(id: '1', firstName: 'User');
  ChatUser bot = ChatUser(id: '2', firstName: 'CryptoBot');

  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];

  final oururl = "http://10.1.210.213:5000/chatbot";
  final header = {'Content-Type': 'application/json'};

  getdata(ChatMessage m) async {
    typing.add(bot);
    allMessages.insert(0, m);
    setState(() {});

    var filteredMessage = m.text;

    // Prepare the multipart request
    var request = http.MultipartRequest('POST', Uri.parse(oururl));

    request.fields['user_query'] =
        filteredMessage; // Add the user query to the request fields

    // Send the request
    var response = await request.send();

    // Listen for the response
    response.stream.transform(utf8.decoder).listen((value) async {
      var result = jsonDecode(value);
      String fullResponse = result['message'];

      // Start displaying the response word by word
      await _displayResponseWordByWord(fullResponse);
    }).onError((error) {
      print("Error occurred: $error");
    });

    typing.remove(bot);
    setState(() {});
  }

  Future<void> _displayResponseWordByWord(String response) async {
    List<String> words = response.split(' '); // Split the response into words
    String displayedText = '';

    ChatMessage tempMessage = ChatMessage(
      text: displayedText,
      user: bot,
      createdAt: DateTime.now(),
    );

    allMessages.insert(0, tempMessage);
    setState(() {});

    for (var word in words) {
      displayedText += '$word ';

      // Update the message with the current state of the displayed text
      setState(() {
        allMessages[0] = ChatMessage(
          text: displayedText,
          user: bot,
          createdAt: DateTime.now(),
        );
      });

      // Wait for a short duration before adding the next word
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  TextSpan _parseTextWithBold(String text, ChatUser user) {
    List<TextSpan> spans = [];
    RegExp exp = RegExp(r"\*(.*?)\*"); // Pattern to detect **bold** text
    int start = 0;

    text.splitMapJoin(exp, onMatch: (Match match) {
      // Add the text before the bold part
      if (match.start > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, match.start),
            style: TextStyle(
              color: user.id == myself.id ? Colors.white : Colors.black,
            ),
          ),
        );
      }

      // Add the bold text
      spans.add(
        TextSpan(
          text: match.group(1),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: user.id == myself.id ? Colors.white : Colors.black,
          ),
        ),
      );

      start = match.end;
      return '';
    }, onNonMatch: (String nonMatch) {
      // Add remaining part of the text after the last bold match
      spans.add(
        TextSpan(
          text: nonMatch,
          style: TextStyle(
            color: user.id == myself.id ? Colors.white : Colors.black,
          ),
        ),
      );
      return '';
    });

    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: purple2,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 28,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Chatbot',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: DashChat(
        currentUser: myself,
        onSend: (ChatMessage m) {
          getdata(m);
        },
        messages: allMessages,
        messageOptions: MessageOptions(
          messageTextBuilder: (ChatMessage currentMessage,
              ChatMessage? previousMessage, ChatMessage? nextMessage) {
            return RichText(
              text:
                  _parseTextWithBold(currentMessage.text, currentMessage.user),
            );
          },
        ),
      ),
    );
  }
}
