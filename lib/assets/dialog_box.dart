
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:textrec/assets/constants.dart';

class dialog_Box extends StatelessWidget {
  dialog_Box({this.description});
  var description;

  @override
  Widget build(BuildContext context) {
    return AssetGiffyDialog(
      buttonOkColor: kPrimaryPurple,
      image: Image.asset('images/alert.gif'),
      title: Text(
        'Alert!!',
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        description,
        textAlign: TextAlign.center,
      ),
      entryAnimation: EntryAnimation.TOP_LEFT,
      onlyOkButton: true,
      onOkButtonPressed: (){
        Navigator.pop(context);
      },
    );
  }
}
