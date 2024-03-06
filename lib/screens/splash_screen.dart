

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ningal_chat/screens/home/home_page.dart';
import 'package:ningal_chat/screens/login_sign_up/login_page.dart';
import 'package:ningal_chat/services/authentication/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    goto();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircleAvatar(
          radius: 100,
          child: Icon(Icons.message_outlined),
        ),
      ),
    );
  }

  Future<void> goto() async {
    User? anUser =
        AuthFunctions(FirebaseAuth.instance).anFireBaseAuth.currentUser;
    await Future.delayed(const Duration(seconds: 5));
    anUser != null ?  Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>const HomePage(),
          )): Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    
  }
}
