
import 'package:cloud_firestore/cloud_firestore.dart';

class AddToFirebase {
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
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(theEmails)
            .set({
          "messages": [
            {"timeStamp": DateTime.now(), currentEmail: theMessage}
          ]
        });
      }
    }
  }
}
