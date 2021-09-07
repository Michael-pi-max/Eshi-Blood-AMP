import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Color color;
  final String text;
  final Color textColor;
  final Function onPressed;
  final double? padding;
  final double? borderCurve;
  final double? width;
  final double? height;

  AppButton({
    required this.color,
    required this.text,
    required this.onPressed,
    required this.textColor,
    this.padding,
    this.borderCurve,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding ?? 12.0),
      child: Material(
        shadowColor: Color(0xFFD32026),
        elevation: 10.0,
        color: color,
        borderRadius: BorderRadius.circular(borderCurve ?? 30.0),
        child: MaterialButton(
          onPressed: () {},
          minWidth: width ?? 200.0,
          height: height ?? 55.0,
          child: Text(
            '$text',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
