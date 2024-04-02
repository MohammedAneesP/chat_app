import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ningal_chat/repository/add_to_firebase.dart';
import 'package:ningal_chat/screens/chat_screen.dart/widgets/the_textfield.dart';
import 'package:ningal_chat/services/api/to_notification.dart';

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
                TheTextField(anController: anController),
                IconButton(
                  onPressed: () async {
                    final anData = await FirebaseFirestore.instance
                        .collection("Users")
                        .doc(anEmail)
                        .get();
                    String? token = anData["FcmToken"].toString();

                    if (token.isNotEmpty) {
                      await AddToFirebase().addToFirebase(
                          theDocId, anController.text, theCurrentUser);
                      sendNotification(
                          token, anController.text, theCurrentUser);
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
