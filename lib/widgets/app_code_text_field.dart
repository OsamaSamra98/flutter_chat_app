import 'package:flutter/material.dart';

class AppCodeTextField extends StatelessWidget {
  const AppCodeTextField({
    Key? key,
    required this.onChanged,
    required this.textController,
    required this.focusNode,
  }) : super(key: key);

  final TextEditingController textController;
  final FocusNode focusNode;
  final void Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      maxLength: 1,
      maxLines: 1,
      textAlign: TextAlign.center,
      onChanged: onChanged,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: Colors.blue.shade300,
          ),
        ),
      ),
    );
  }
}
