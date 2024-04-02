import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ningal_chat/repository/add_to_firebase.dart';
import 'package:ningal_chat/screens/chat_screen.dart/widgets/the_textfield.dart';
import 'package:ningal_chat/services/api/to_notification.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollTobottom());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                  controller: _scrollController,
                  itemCount: widget.theResults.length,
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
                ),
              )),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TheTextField(anController: widget.anController),
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
                      await AddToFirebase().addToFirebase(widget.theDocId,
                          widget.anController.text, widget.theCurrentUser);
                      await sendNotification(token, widget.anController.text,
                          widget.theCurrentUser);
                      widget.anController.clear();
                      scrollTobottom();
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

  void scrollTobottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}
