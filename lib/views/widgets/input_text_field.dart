import 'package:flutter/material.dart';

///****************************************************************************
///MATTHEW HERBERT 2023
///this code defines a reusable TextInputField widget
///that encapsulates the styling and features of a TextField
///with customizable properties like label, icon, and obscuration.
///This helps to promote code reusability by encapsulating my project's
///common UI properties.
///****************************************************************************

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText; //sometimes this widget will receive a String as a parameter
  final bool isObscure; //sometimes (eg. for a password) we want the text to be obscured
  final IconData icon; //sometimes this widget will receive an icon as a parameter
  const TextInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isObscure = false,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(
          fontSize: 20.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
      //OBSCURES THE PASSWORD TEXT
      obscureText: isObscure,
    );
  }
}