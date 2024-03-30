import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ningal_chat/services/api/to_notification.dart';

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

class TheNoMessage extends StatefulWidget {
  const TheNoMessage({
    super.key,
    required this.anController,
    required this.theDocId,
    required this.theCurrentUser,
    required this.anEmail,
  });

  final TextEditingController anController;
  final String theDocId;
  final String theCurrentUser;
  final String anEmail;

  @override
  State<TheNoMessage> createState() => _TheNoMessageState();
}

class _TheNoMessageState extends State<TheNoMessage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.74,
            child: const Center(
              child: Text("Start chat now"),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: widget.anController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final anData = await FirebaseFirestore.instance
                        .collection("Users")
                        .doc(widget.anEmail)
                        .get();
                    String? token = anData["FcmToken"].toString();

                    if (token.isNotEmpty) {
                      await addToFirebase(widget.theDocId,
                          widget.anController.text, widget.theCurrentUser);
                      sendNotification(token, widget.anController.text,
                          widget.theCurrentUser);
                      widget.anController.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TheChattings extends StatefulWidget {
  const TheChattings({
    super.key,
    required this.theResults,
    required this.anEmail,
    required this.theCurrentUser,
    required this.anController,
    required this.theDocId,
  });

  final List<dynamic> theResults;
  final String anEmail;
  final String theCurrentUser;
  final TextEditingController anController;
  final String theDocId;

  @override
  State<TheChattings> createState() => _TheChattingsState();
}

class _TheChattingsState extends State<TheChattings> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.74,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.transparent),
                  itemBuilder: (context, index) {
                    final fetchedMessage = widget.theResults.elementAt(index);
                    if (fetchedMessage.containsKey(widget.anEmail)) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.05,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              fetchedMessage[widget.anEmail],
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              fetchedMessage[widget.theCurrentUser],
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  itemCount: widget.theResults.length,
                ),
              )),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: widget.anController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final anData = await FirebaseFirestore.instance
                        .collection("Users")
                        .doc(widget.anEmail)
                        .get();
                    String? token = anData["FcmToken"].toString();
                    log(token.toString());
                    if (token.isNotEmpty &&
                        widget.anController.text.isNotEmpty) {
                      await addToFirebase(widget.theDocId,
                          widget.anController.text, widget.theCurrentUser);
                      await sendNotification(token, widget.anController.text,
                          widget.theCurrentUser);
                      widget.anController.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<void> addToFirebase(
    String theEmails, String theMessage, String currentEmail) async {
  final anValue = await FirebaseFirestore.instance.collection("chats").get();
  if (anValue.docs.isEmpty) {
    await FirebaseFirestore.instance.collection("chats").doc(theEmails).set({
      "messages": [
        {"timeStamp": DateTime.now(), currentEmail: theMessage}
      ]
    });
  } else {
    final theChatting = await FirebaseFirestore.instance
        .collection("chats")
        .doc(theEmails)
        .get();
    if (theChatting.exists) {
      final anVallue = theChatting.data();
      if (anVallue!.isEmpty) {
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(theEmails)
            .set({
          "messages": [
            {"timeStamp": DateTime.now(), currentEmail: theMessage}
          ]
        });
      } else {
        List<dynamic> chats = anVallue["messages"];
        chats.add({"timeStamp": DateTime.now(), currentEmail: theMessage});
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(theEmails)
            .set({"messages": chats});
      }
    } else {
      await FirebaseFirestore.instance.collection("chats").doc(theEmails).set({
        "messages": [
          {"timeStamp": DateTime.now(), currentEmail: theMessage}
        ]
      });
    }
  }
}
