import 'package:flutter/material.dart';
const kBottomContainerHeight = 50.0;
const kPrimaryPurple=Color(0xff0a00b6);
const kTextFieldDecoration =
InputDecoration(
  hintText: 'Enter a value',
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: kPrimaryPurple, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: kPrimaryPurple, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
);

//Color(0xFFF7FAFD)