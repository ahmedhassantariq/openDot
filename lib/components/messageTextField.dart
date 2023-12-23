import 'package:flutter/material.dart';

class MessageTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String e) onSubmitted;
  final Function() onIconPress;
  final Icon icon;
  const MessageTextField({
    super.key,
    required this.focusNode,
    required this.onSubmitted,
    required this.onIconPress,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      controller: controller,
      focusNode: focusNode,
      cursorColor: Colors.grey.shade500,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),

          hintText: "Type Message",
          suffixIcon: IconButton(onPressed: (){
            onIconPress();
            focusNode.requestFocus();
          }, icon: icon
          )
      ),
    );
  }
}