import 'package:flutter/material.dart';


class PostTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  late FontWeight? fontWeight = FontWeight.normal;
  late double? fontSize;
  PostTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.fontSize,
    this.fontWeight,

  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      keyboardType: TextInputType.text,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        fillColor: Colors.transparent,
        filled: false,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey, fontSize: fontSize, fontWeight: fontWeight, letterSpacing: 2),
      ) ,
      cursorColor: Colors.grey,
    );
  }
}
