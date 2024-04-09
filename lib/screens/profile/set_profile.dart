import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ningal_chat/bloc/profile_image/profile_image_bloc.dart';
import 'package:ningal_chat/screens/home/home_page.dart';
import 'package:ningal_chat/screens/login_sign_up/login_page.dart';

class SettingProfile extends StatelessWidget {
  SettingProfile({super.key});

  final TextEditingController anNameController = TextEditingController();
  final TextEditingController anNickNameController = TextEditingController();
  final FirebaseAuth anFireBaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await anFireBaseAuth.currentUser!.delete();
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Add your Profile"),
        ),
        body: BlocBuilder<ProfileImageBloc, ProfileImageState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case SetProfile:
                final anState = state as SetProfile;
                return Form(
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<ProfileImageBloc>(context)
                                .add(TakePhoto());
                          },
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 100,
                                backgroundImage:
                                    FileImage(File(anState.anImage!.path)),
                              ),
                              const Positioned(
                                left: 150,
                                bottom: 10,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please this field";
                            }
                            return null;
                          },
                          controller: anNameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            filled: true,
                            fillColor: Colors.grey[300],
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  25,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please this field";
                            }
                            return null;
                          },
                          controller: anNickNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[300],
                            labelText: "Nickname",
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  25,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                final anFcmToken =
                                    await FirebaseMessaging.instance.getToken();
                                if (anFcmToken != null) {
                                  uploadingData(
                                    context: context,
                                      anImage: anState.anImage!.path,
                                      anFireBaseAuth: anFireBaseAuth,
                                      anFcmToken: anFcmToken,
                                      anName: anNameController.text,
                                      nickName: anNickNameController.text);
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue[50]),
                              fixedSize: const MaterialStatePropertyAll(
                                Size(
                                  double.infinity,
                                  50,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blueAccent),
                            ))
                      ],
                    ),
                  ),
                );
              default:
                return Form(
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<ProfileImageBloc>(context)
                                .add(TakePhoto());
                          },
                          child: const Stack(
                            children: [
                              CircleAvatar(
                                radius: 100,
                              ),
                              Positioned(
                                left: 150,
                                bottom: 10,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please this field";
                            }
                            return null;
                          },
                          controller: anNameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            filled: true,
                            fillColor: Colors.grey[300],
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  25,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please this field";
                            }
                            return null;
                          },
                          controller: anNickNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[300],
                            labelText: "Nickname",
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  25,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                            onPressed: () async {},
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue[50]),
                              fixedSize: const MaterialStatePropertyAll(
                                Size(
                                  double.infinity,
                                  50,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blueAccent),
                            ))
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

Future<void> uploadingData({
  required String anImage,
  required FirebaseAuth anFireBaseAuth,
  required String anFcmToken,
  required String anName,
  required String nickName,
  required BuildContext context
}) async {
  final anUniqueName = DateTime.now();
  final file = File(anImage);
  final Reference anRef =
      FirebaseStorage.instance.ref().child("image/$anUniqueName");
  final toStorage = await anRef.putFile(file);
  final downloadUrl = await toStorage.ref.getDownloadURL();
  final String anUrl = downloadUrl;
  await FirebaseFirestore.instance
      .collection("Users")
      .doc(anFireBaseAuth.currentUser!.email)
      .set({
    "name": anName,
    "nickname": nickName,
    "image": anUrl,
    "Email": anFireBaseAuth.currentUser!.email,
    "id": anFireBaseAuth.currentUser!.uid,
    "FcmToken": anFcmToken,
  });
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
}
