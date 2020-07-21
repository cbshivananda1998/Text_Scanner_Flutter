import 'package:flutter/material.dart';
import 'package:textrec/assets/constants.dart';

class ButtomButton extends StatelessWidget {
  ButtomButton({this.onTap, this.buttonTitle, this.martop, this.marbuttom});

  final Function onTap;
  final String buttonTitle;
  final double martop;
  final double marbuttom;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //extracted button
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            buttonTitle,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 20.0),
          ),
        ),
        width: double.infinity,
        height: kBottomContainerHeight,
        margin: EdgeInsets.fromLTRB(20.0, martop, 20.0, marbuttom),
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color:Color(0xffAEC3FF).withOpacity(0.7) ,
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0,0), // changes position of shadow
            ),
          ],
          gradient: LinearGradient(colors: [Color(0xffAEC3FF),Color(0xff0a00b6)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
      ),
    );
  }
}
