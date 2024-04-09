import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ningal_chat/services/authentication/auth_gate.dart';

class VerifyPage extends StatelessWidget {
  final String anEmail;
  final String anPassword;

  const VerifyPage({
    super.key,
    required this.anEmail,
    required this.anPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Verify Your E-mail", style: TextStyle(fontSize: 40)),
              const SizedBox(height: 30),
              const Text(
                  "Please verify the email we have sent to you to Continue",
                  style: TextStyle(fontSize: 20)),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  final anAuth = AuthFunctions(FirebaseAuth.instance);
                  anAuth.isVerified(
                    context: context,
                    anEmail: anEmail,
                    anPassword: anPassword,
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.purple[50]),
                  fixedSize: const MaterialStatePropertyAll(
                    Size(
                      double.infinity,
                      50,
                    ),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.purple,fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
