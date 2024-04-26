import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ningal_chat/main.dart';
import 'package:ningal_chat/screens/chat_screen.dart/widgets/the_chatting.dart';
import 'package:ningal_chat/screens/chat_screen.dart/widgets/the_no_message.dart';
import 'package:ningal_chat/screens/home/home_page.dart';

class ChatPage extends StatelessWidget {
  final String anEmail;
  ChatPage({super.key, required this.anEmail});

  final TextEditingController anController = TextEditingController();
  final theCurrentUser = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  Widget build(BuildContext context) {
    final  userName = fetchUserDetails(anEmail: anEmail);
    final name = userName.toString();
    List<String> theEmails = [anEmail, theCurrentUser];
    theEmails.sort();
    final theDocId = theEmails.join("_");

    return WillPopScope(
      onWillPop: () async {
        navigatorKey.currentState!.pushReplacement(CupertinoPageRoute(
          builder: (context) => const HomePage(),
        ));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                navigatorKey.currentState!.pushReplacement(CupertinoPageRoute(
                  builder: (context) => const HomePage(),
                ));
              },
              icon: const Icon(Icons.arrow_back_rounded)),
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
                      currentUserEmail: theCurrentUser,
                      currentUserName: name,
                      anEmail: anEmail);
                } else {
                  List<dynamic> theChatList = theChats["messages"];
                  return TheChattings(
                      theResults: theChatList,
                      anEmail: anEmail,
                      theCurrentUser: theCurrentUser,
                      currentUserName: name,
                      anController: anController,
                      theDocId: theDocId);
                }
              } else {
                return TheNoMessage(
                    anController: anController,
                    theDocId: theDocId,
                    currentUserEmail: theCurrentUser,
                    currentUserName: name,
                    anEmail: anEmail);
              }
            } else {
              return TheNoMessage(
                  anController: anController,
                  theDocId: theDocId,
                  currentUserEmail: theCurrentUser,
                  currentUserName: name,
                  anEmail: anEmail);
            }
          },
        ),
      ),
    );
  }

  Future<String> fetchUserDetails({required String anEmail}) async {
    final fetchDetails =
        await FirebaseFirestore.instance.collection("Users").doc(anEmail).get();
    if (fetchDetails.exists) {
      final sender = fetchDetails.data();
      if (sender!.isNotEmpty) {
        final senderName = sender["name"];
        return senderName;
      }
    }
    return "";
  }
}
