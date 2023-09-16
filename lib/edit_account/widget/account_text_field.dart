import 'package:flutter/material.dart';

class AccountTextField extends StatelessWidget {
  const AccountTextField(
      {required this.controller,
      this.onChanged,
      required this.labelText,
      required this.validator,
      required this.hintText,
      required this.textFieldKey,
      super.key});

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? Function(String)? onChanged;
  final String labelText;
  final String hintText;
  final Key textFieldKey;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextFormField(
          key: textFieldKey,
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.next,
          validator: validator,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: labelText,
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}
