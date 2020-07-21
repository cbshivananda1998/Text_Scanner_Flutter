import 'package:flutter/material.dart';

class pdf_viewer extends StatefulWidget {
  const pdf_viewer({this.text});

  final String text;

  @override
  _pdf_viewrState createState() => _pdf_viewrState();
}

class _pdf_viewrState extends State<pdf_viewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff0a00b6),
        title: Text(
          'Extract Text',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image(
              image: AssetImage('images/whitewithblue.png'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15.0),
            width: double.infinity,
            child: SelectableText(
              widget.text,
            ),
          ),
        ),
      ),
    );
  }
}
