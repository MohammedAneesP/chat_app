import 'package:flutter/material.dart';
import 'package:ningal_chat/screens/chat_screen.dart/widgets/the_textfield.dart';

class SettingProfile extends StatelessWidget {
  SettingProfile({super.key});

  final TextEditingController anNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile"),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: const Stack(
              children: [
                CircleAvatar(
                  radius: 100,
                ),
                Icon(
                  Icons.camera_alt,
                  size: 35,
                )
              ],
            ),
          ),
          TheTextField(anController: anNameController),
          
        ],
      ),
    );
  }
}
