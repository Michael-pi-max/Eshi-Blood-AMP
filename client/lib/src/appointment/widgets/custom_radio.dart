import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomRadio extends StatefulWidget {
  final List conditions;

  const CustomRadio({
    Key? key,
    required this.conditions,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new CustomRadioState();
  }
}

class CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            splashColor: Color(0xffd32026),
            onTap: () {
              widget.conditions[index].onClicked();
              setState(() {
                widget.conditions
                    .forEach((element) => element.isSelected = false);
                widget.conditions[index].isSelected = true;
              });
            },
            child: RadioItem(widget.conditions[index]),
          );
        },
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 50.0,
            width: 50.0,
            child: Center(
              child: Text(
                _item.buttonText,
                style: TextStyle(
                    color: _item.isSelected ? Colors.white : Colors.black,
                    //fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
            decoration: BoxDecoration(
              color: _item.isSelected ? Colors.redAccent : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.redAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  VoidCallback? onClicked;

  RadioModel(
      {required this.isSelected, required this.buttonText, this.onClicked});
}
