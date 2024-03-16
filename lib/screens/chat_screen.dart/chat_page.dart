import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String anEmail;
  ChatPage({super.key, required this.anEmail});

  final TextEditingController anController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> theEmails = [
      anEmail,
      FirebaseAuth.instance.currentUser!.email.toString()
    ];
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
            final theData = snapshot.data!;

            if (!theData.exists) {
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
                              await addToFirebase(
                                  theDocId,
                                  anController.text,
                                  FirebaseAuth.instance.currentUser!.email
                                      .toString());
                              anController.clear();
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              final theResults = theData.data();
              List<dynamic> wholeData = [];
              theResults!.forEach((key, value) {
                wholeData.add(value);
              });
              log(wholeData.toString());
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.74,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            Map<String, dynamic> theText = wholeData[index];

                            if (theText.keys.contains(FirebaseAuth.instance.currentUser!.email.toString())) {
                              String anString = "";
                              theText.forEach((key, value) {
                                anString = value;
                              });
                              return Text(
                                anString,
                                textAlign: TextAlign.left,
                              );
                            }
                            return Text(
                              "theResults",
                              textAlign: TextAlign.right,
                            );
                          },
                          itemCount: theData.data()!.length,
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
                              await addToFirebase(
                                  theDocId,
                                  anController.text,
                                  FirebaseAuth.instance.currentUser!.email
                                      .toString());
                              anController.clear();
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

Future<void> addToFirebase(
    String theEmails, String theMessage, String currentEmail) async {
  final anValue = await FirebaseFirestore.instance.collection("chats").get();
  if (anValue.docs.isEmpty) {
    await FirebaseFirestore.instance.collection("chats").doc(theEmails).set({
      DateTime.now().toString(): {currentEmail: theMessage}
    });
  } else {
    final theChatting = await FirebaseFirestore.instance
        .collection("chats")
        .doc(theEmails)
        .get();
    if (theChatting.exists) {
      Map<String, dynamic>? andatas = theChatting.data();
      andatas!.addAll({
        DateTime.now().toString(): {currentEmail: theMessage}
      });
      log(andatas.toString());
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(theEmails)
          .set(andatas);
    } else {
      await FirebaseFirestore.instance.collection("chats").doc(theEmails).set({
        DateTime.now().toString(): {currentEmail: theMessage}
      });
    }
  }
}
