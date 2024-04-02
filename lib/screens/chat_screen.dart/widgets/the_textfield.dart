
import 'package:flutter/material.dart';

class TheTextField extends StatelessWidget {
  const TheTextField({
    super.key,
    required this.anController,
  });

  final TextEditingController anController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: anController,
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
