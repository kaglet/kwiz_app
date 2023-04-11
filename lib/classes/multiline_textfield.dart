// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class MultiLineTextField extends StatefulWidget {
  final int minLines;
  final int maxLines;
  final String hintText;
  final String labelText;
  final Color labelTextcolor;
  final TextEditingController controller;
  const MultiLineTextField(
      {Key? key,
      required this.minLines,
      required this.maxLines,
      required this.hintText,
      required this.labelText,
      required this.controller,
      this.labelTextcolor = Colors.grey})
      : super(key: key);

  @override
  State<MultiLineTextField> createState() => _MultiLineTextFieldState();
}

class _MultiLineTextFieldState extends State<MultiLineTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: widget.labelTextcolor,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(5),
          ))),
    );
  }
}
