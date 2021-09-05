import 'package:flutter/material.dart';

class UpdateRoleButton extends StatelessWidget {
  final String buttonName;

  UpdateRoleButton({required this.buttonName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: InkWell(
          onTap: () {
            print("clicked");
          },
          child: Container(
            width: 300,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(25)),
            child: Center(
              child: Text(
                "${buttonName}",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
