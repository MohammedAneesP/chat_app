import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
            .collection("messages")
            .orderBy("timeStamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final theData = snapshot.data!;

            if (theData.docs.isEmpty) {
              return TheNoMessage(
                  anEmail: anEmail,
                  anController: anController,
                  theDocId: theDocId,
                  theCurrentUser: theCurrentUser);
            } else {
              final theResults = theData.docs;

              return TheChattings(
                  theResults: theResults,
                  anEmail: anEmail,
                  theCurrentUser: theCurrentUser,
                  anController: anController,
                  theDocId: theDocId);
            }
          } else {
            return const Center(
              child: Text("Start chat now"),
            );
          }
        },
      ),
    );
  }
}

class TheNoMessage extends StatelessWidget {
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
                    controller: anController,
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
                        .doc(anEmail)
                        .get();
                    String? token = anData["FcmToken"].toString();

                    if (token.isNotEmpty) {
                      sendNotification(token, "title", "body");
                      await addToFirebase(
                          theDocId, anController.text, theCurrentUser);
                      anController.clear();
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

class TheChattings extends StatelessWidget {
  const TheChattings({
    super.key,
    required this.theResults,
    required this.anEmail,
    required this.theCurrentUser,
    required this.anController,
    required this.theDocId,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> theResults;
  final String anEmail;
  final String theCurrentUser;
  final TextEditingController anController;
  final String theDocId;

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
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final fetchedMessage = theResults.elementAt(index).data();
                    if (fetchedMessage.containsKey(anEmail)) {
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
                              fetchedMessage[anEmail],
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
                              fetchedMessage[theCurrentUser],
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  itemCount: theResults.length,
                ),
              )),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: anController,
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
                        .doc(anEmail)
                        .get();
                    String? token = anData["FcmToken"].toString();
                    log(token.toString());
                    if (token.isNotEmpty) {
                      await sendNotification(token, "title", "nobody");
                      await addToFirebase(
                          theDocId, anController.text, theCurrentUser);
                      anController.clear();
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
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(theEmails)
        .collection("messages")
        .add({"timeStamp": DateTime.now(), currentEmail: theMessage});
  } else {
    final theChatting = await FirebaseFirestore.instance
        .collection("chats")
        .doc(theEmails)
        .collection("messages")
        .get();
    if (theChatting.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(theEmails)
          .collection("messages")
          .add({"timeStamp": DateTime.now(), currentEmail: theMessage});
    } else {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(theEmails)
          .collection("messages")
          .add({"timeStamp": DateTime.now(), currentEmail: theMessage});
    }
  }
}
