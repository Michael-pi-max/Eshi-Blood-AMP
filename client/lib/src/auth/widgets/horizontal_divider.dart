import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  final String? label;
  final double? height;

  HorizontalDivider({this.label, this.height});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 15.0),
          child: Divider(
            color: Color(0xffd32026),
            height: height,
          ),
        ),
      ),
      Text(
        label ?? '',
        style: TextStyle(color: Color(0xffd32026)),
      ),
      Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 15.0, right: 10.0),
          child: Divider(
            color: Color(0xffd32026),
            height: height,
          ),
        ),
      )
    ]);
  }
}
