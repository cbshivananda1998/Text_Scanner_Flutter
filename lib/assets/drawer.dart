import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textrec/assets/constants.dart';
class drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kPrimaryPurple,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Important: Remove any padding from the ListView.
          //  padding: EdgeInsets.zero,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Image(
                      image: AssetImage('images/whitewithblue.png'),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                height: 1.0,
                color: Colors.white,
              ),
              ListTile(
                title: Text('Extract Text',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white
                ),),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                height: 1.0,
                color: Colors.white,
              ),
              ListTile(
                title: Text('Search Text',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white
                    ),),
                onTap: () {
                  Navigator.pushNamed(context, '//');
                },
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                height: 1.0,
                color: Colors.white,
              ),
              Expanded(
                child: SizedBox(
                  height: 240.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Text('v1.0',
                  style: TextStyle(
                      color: Colors.white
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Text('Developed by C.B.Shivananda',
                style: TextStyle(
                  color: Colors.white
                ),),
              ),
              SizedBox(
                height: 5.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
