import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                },
                icon: const Icon(Icons.logout_outlined)),
          ],
        ),
        body: StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final anDatas = snapshot.data!.docs;

              return ListView.separated(
                  itemBuilder: (context, index) {
                    log(FirebaseAuth.instance.currentUser!.email.toString());


                    if (anDatas[index]["Email"] !=
                        FirebaseAuth.instance.currentUser!.email) {
                      return ListTile(
                        onTap: () {},
                        title: Text(anDatas[index]["Email"].toString()),
                      );
                    } else {
                      return Container();
                    }
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: anDatas.length);
            } else {
              return Center(
                child: Text("No data"),
              );
            }
          },
          stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        ));
  }
}
