import 'package:flutter/material.dart';


class CommentTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final onTap;
  bool readOnly = false;
  CommentTextField({
    super.key,
    required this.readOnly,
    required this.controller,
    required this.hintText, this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        fillColor: Colors.grey[200],
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),

      ) ,
    );
  }
}
