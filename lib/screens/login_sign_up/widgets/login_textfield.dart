
import 'package:flutter/material.dart';

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
