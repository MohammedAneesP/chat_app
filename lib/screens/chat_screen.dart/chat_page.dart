import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ningal_chat/screens/chat_screen.dart/widgets/the_chatting.dart';
import 'package:ningal_chat/screens/chat_screen.dart/widgets/the_no_message.dart';

class ChatPage extends StatelessWidget {
  final String anEmail;
  ChatPage({super.key, required this.anEmail});

  final TextEditingController anController = TextEditingController();
  final theCurrentUser = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  Widget build(BuildContext context) {
    List<String> theEmails = [anEmail, theCurrentUser];
    theEmails.sort();
    final theDocId = theEmails.join("_");

    return Scaffold(
      appBar: AppBar(
        title: Text(anEmail),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(theDocId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final theDatas = snapshot.data;
            if (theDatas!.exists) {
              final theChats = theDatas.data();
              if (theChats!.isEmpty) {
                return TheNoMessage(
                    anController: anController,
                    theDocId: theDocId,
                    theCurrentUser: theCurrentUser,
                    anEmail: anEmail);
              } else {
                List<dynamic> theChatList = theChats["messages"];
                return TheChattings(
                    theResults: theChatList,
                    anEmail: anEmail,
                    theCurrentUser: theCurrentUser,
                    anController: anController,
                    theDocId: theDocId);
              }
            } else {
              return TheNoMessage(
                  anController: anController,
                  theDocId: theDocId,
                  theCurrentUser: theCurrentUser,
                  anEmail: anEmail);
            }
          } else {
            return TheNoMessage(
                anController: anController,
                theDocId: theDocId,
                theCurrentUser: theCurrentUser,
                anEmail: anEmail);
          }
        },
      ),
    );
  }
}
