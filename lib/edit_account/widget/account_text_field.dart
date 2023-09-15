import 'package:flutter/material.dart';

class AccountTextField extends StatelessWidget {
  const AccountTextField(
      {required this.controller, this.onChanged, required this.labelText, required this.validator, required this.hintText, super.key});

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? Function(String)? onChanged;
  final String labelText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextFormField(
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
