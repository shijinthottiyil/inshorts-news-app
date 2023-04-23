import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonWidget extends StatelessWidget {
  final Widget buttonChild;
  final VoidCallback buttonAction;
  const ButtonWidget({
    super.key,
    required this.buttonChild,
    required this.buttonAction,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonAction,
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
            const Size(200, 50)), // Set fixed size of button
        backgroundColor: MaterialStateProperty.all(
            Colors.blue), // Background color of button
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // Rounded corners
          ),
        ),
        elevation: MaterialStateProperty.all(5), // Shadow elevation of button
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ), // Padding inside button
        textStyle: MaterialStateProperty.all(
          GoogleFonts.montserratAlternates(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      child: buttonChild,
    );
  }
}
