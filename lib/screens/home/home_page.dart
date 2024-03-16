

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ningal_chat/screens/chat_screen.dart/chat_page.dart';
import 'package:ningal_chat/screens/login_sign_up/login_page.dart';
import 'package:ningal_chat/services/authentication/auth_gate.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await AuthFunctions(FirebaseAuth.instance)
                      .logout(context: context);
                  Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                },
                icon: const Icon(Icons.logout_outlined)),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final anDatas = snapshot.data!.docs;

              return ListView.separated(
                  itemBuilder: (context, index) {
                      if (anDatas[index]["Email"] !=
                        FirebaseAuth.instance.currentUser!.email) {
                     
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                allowSnapshotting: false,
                                builder: (context) => ChatPage(
                                    anEmail:
                                        anDatas[index]["Email"].toString()),
                              ));
                        },
                        title: Text(anDatas[index]["Email"].toString()),
                      );
                    } else {
                      return Container();
                    }
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: anDatas.length);
            } else {
              return const Center(
                child: Text("No data"),
              );
            }
          },
        ));
  }
}
