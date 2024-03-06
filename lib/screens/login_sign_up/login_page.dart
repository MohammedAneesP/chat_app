import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ningal_chat/screens/login_sign_up/sign_up.dart';
import 'package:ningal_chat/services/authentication/auth_gate.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController anEmailController = TextEditingController();
  TextEditingController anPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Hello..!",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  "You've been missed",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.blue),
                ),
                const SizedBox(height: 70),
                LogTextfield(
                    anEmailController: anEmailController,
                    anLabelText: 'Email',
                    anPrefixIcon: const Icon(Icons.email)),
                const SizedBox(height: 20),
                LogTextfield(
                  anEmailController: anPasswordController,
                  anLabelText: "Password",
                  anPrefixIcon: const Icon(
                    Icons.key,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: const Text("Forgot Password ?"))
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await AuthFunctions(FirebaseAuth.instance)
                        .signInWithEmailPassword(
                            email: anEmailController.text,
                            password: anPasswordController.text,
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
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Dont you have an account"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ));
                        },
                        child: const Text("Register"))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogTextfield extends StatelessWidget {
  const LogTextfield({
    super.key,
    required this.anEmailController,
    required this.anLabelText,
    required this.anPrefixIcon,
  });

  final TextEditingController anEmailController;
  final String anLabelText;
  final Icon anPrefixIcon;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: anEmailController,
      decoration: InputDecoration(
        labelText: anLabelText,
        prefixIcon: anPrefixIcon,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              25,
            ),
          ),
        ),
      ),
    );
  }
}
