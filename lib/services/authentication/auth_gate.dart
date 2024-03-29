import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ningal_chat/screens/home/home_page.dart';
import 'package:ningal_chat/screens/login_sign_up/login_page.dart';

class AuthFunctions {
  final FirebaseAuth anFireBaseAuth;

  AuthFunctions(this.anFireBaseAuth);
  Future<void> signInWithEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await anFireBaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (context.mounted) {
        if (anFireBaseAuth.currentUser!.emailVerified) {
          final anFcmToken = await FirebaseMessaging.instance.getToken();
          if (anFcmToken!=null) {
            log(anFcmToken);
          }
          if (anFcmToken != null) {
           await FirebaseFirestore.instance.collection("Users").doc(email).set({
          "Email": anFireBaseAuth.currentUser!.email,
          "id": anFireBaseAuth.currentUser!.uid,
          "FcmToken": anFcmToken,
        });
          }

          if (context.mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Verify email")));
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  Future<void> registerAccount(
      {required String anEmail,
      required String anPassword,
      required BuildContext context}) async {
    try {
      await anFireBaseAuth.createUserWithEmailAndPassword(
          email: anEmail, password: anPassword);
      // final anFcmToken = await FirebaseMessaging.instance.getToken();
      await anFireBaseAuth.currentUser!.sendEmailVerification();
     
        await FirebaseFirestore.instance.collection("Users").doc(anEmail).set({
          "Email": anFireBaseAuth.currentUser!.email,
          "id": anFireBaseAuth.currentUser!.uid,
          // "FcmToken": anFcmToken,
        });
     

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Verify email")));

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.message}")));
    }
  }

  Future<void> logout({required BuildContext context}) async {
    try {
      await anFireBaseAuth.signOut();
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }
}
