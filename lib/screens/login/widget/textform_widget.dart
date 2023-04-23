import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFormWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?) validateFn;
  final bool isObscure;
  const TextFormWidget(
      {super.key,
      required this.label,
      required this.controller,
      required this.validateFn,
      this.isObscure = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      validator: validateFn,
      style: GoogleFonts.montserratAlternates(
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.none,
        decorationThickness: 0,
      ),
      controller: controller,
      decoration: InputDecoration(
        fillColor: const Color(0xFFE9F0FB),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 5,
            style: BorderStyle.solid,
          ),
        ),
        labelText: label,
      ),
    );
  }
}
