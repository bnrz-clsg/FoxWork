import 'package:flutter/material.dart';

class FormTextInput extends StatelessWidget {
  final String hint;
  final Icon icon;
  final onChange;
  final keebsType;
  final readOnly;
  final onSave;
  final String hintText;
  final controller;

  FormTextInput(
      {this.hint,
      this.onChange,
      this.hintText,
      this.icon,
      this.keebsType,
      this.readOnly,
      this.onSave,
      this.controller});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        onSaved: onSave,
        readOnly: readOnly,
        onChanged: onChange,
        validator: (value) {
          if (value.isEmpty || value.length < 2) {
            return 'Please provide valid input';
          }
          return null;
        },
        textCapitalization: TextCapitalization.words,
        keyboardType: keebsType,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: hint,
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
