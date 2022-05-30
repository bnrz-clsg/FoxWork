import 'package:flutter/material.dart';

class FormText extends StatelessWidget {
  final String hint;
  final String hintText;
  final Icon icon;
  final onChange;
  final keyType;
  final onSave;
  final controller;
  final obscure;
  final validator;
  final sufixIcon;

  FormText({
    this.hint,
    this.hintText,
    this.icon,
    this.onChange,
    this.keyType,
    this.onSave,
    this.controller,
    this.obscure,
    this.validator,
    this.sufixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      autofocus: false,
      controller: controller,
      onSaved: onSave,
      onChanged: onChange,
      keyboardType: keyType,
      obscureText: obscure,
      style: TextStyle(height: 0.7),
      decoration: InputDecoration(
          prefixIcon: icon,
          labelText: hint,
          hintText: hintText,
          border: OutlineInputBorder(),
          suffixIcon: sufixIcon),
    );
  }
}
