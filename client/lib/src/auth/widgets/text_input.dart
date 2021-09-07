import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final IconData? prefixIcon;
  final IconButton? suffixIcon;
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool? obsecureText;
  final Function(String)? onChanged;
  final int? maxLines;
  final String? Function(String?)? onValidate;

  TextInput(
      {this.maxLines,
      this.prefixIcon,
      this.suffixIcon,
      this.labelText,
      this.hintText,
      this.keyboardType,
      this.obsecureText,
      this.onChanged,
      this.onValidate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              width: 0.8,
            ),
          ),
          fillColor: Colors.white,
          filled: true,
          labelText: '$labelText',
          hintText: '$hintText',
          hintStyle: TextStyle(
            color: Color(0xFF707070),
          ),
          prefixIcon: Icon(prefixIcon, color: Color(0xFFD32026)),
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFD32026), width: 1.0),
            borderRadius: BorderRadius.circular(30.0),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD32026), width: 2.0),
              borderRadius: BorderRadius.circular(30.0)),
        ),
        cursorColor: Color(0xFFD32026),
        onChanged: onChanged,
        validator: onValidate,
        keyboardType: keyboardType,
        obscureText: obsecureText ?? false,
      ),
    );
  }
}
