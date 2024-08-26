import 'package:explension/constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final String labelText;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        // labelText: labelText,
        label: Text(labelText),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 10.0,
        ),
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
      ),
    );
  }
}
