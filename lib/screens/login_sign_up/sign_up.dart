import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ningal_chat/screens/login_sign_up/login_page.dart';
import 'package:ningal_chat/services/authentication/auth_gate.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  TextEditingController anEmailController = TextEditingController();
  TextEditingController anPasswordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            const SizedBox(height: 40),
            const Text(
              "Create Account",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Lets Create an Account",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.blue),
            ),
            const SizedBox(height: 70),
            LogTextfield(
                anEmailController: anEmailController,
                anLabelText: "Email",
                anPrefixIcon: const Icon(Icons.email)),
            const SizedBox(height: 20),
            LogTextfield(
                anEmailController: anPasswordController,
                anLabelText: "Password",
                anPrefixIcon: const Icon(Icons.key)),
            const SizedBox(height: 20),
            LogTextfield(
                anEmailController: confirmPassController,
                anLabelText: "Password",
                anPrefixIcon: const Icon(Icons.key)),
            const SizedBox(height: 70),
            ElevatedButton(
              onPressed: () async {
                final anAuthenticating = AuthFunctions(FirebaseAuth.instance);
                anAuthenticating.registerAccount(
                    anEmail: anEmailController.text,
                    anPassword: anPasswordController.text,
                    context: context);
              },
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(StadiumBorder()),
                minimumSize: MaterialStatePropertyAll(
                  Size(
                    double.infinity,
                    50,
                  ),
                ),
              ),
              child: const Text(
                "Sign In",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ]),
        ),
      )),
    );
  }
}
