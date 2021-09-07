import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Color? color;
  final String? text;
  final Color? textColor;
  final VoidCallback? onPressed;
  final double? padding;
  final double? borderCurve;
  final double? width;
  final double? height;

  RoundButton(
      {this.color,
      this.text,
      this.textColor,
      this.onPressed,
      this.padding,
      this.borderCurve,
      this.width,
      this.height});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 12.0),
      child: Material(
        shadowColor: Color(0xffd32026),
        elevation: 10.0,
        color: color,
        borderRadius: BorderRadius.circular(borderCurve ?? 50.0),
        child: MaterialButton(
          onPressed: onPressed,
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
