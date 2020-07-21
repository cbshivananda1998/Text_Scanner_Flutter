import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:textrec/assets/buttomButton.dart';
import 'package:textrec/assets/drawer.dart';
import 'package:textrec/assets/dialog_box.dart';
import 'package:textrec/screens/Pdf_Viewer.dart';

class ExtractText extends StatefulWidget {
  @override
  _ExtractTextState createState() => _ExtractTextState();
}

class _ExtractTextState extends State<ExtractText> {
  File selectedImage;
  var extractedText = '';
  bool imageLoaded = false;
  final pdf = pw.Document();
  final picker = ImagePicker();
  List<pw.Widget> lists = [];
  String status = "false";
  bool showProgressBar = false;

  reset() {
    setState(() {
      selectedImage = null;
      imageLoaded = false;
      lists = [];
      extractedText = '';
      showProgressBar = false;
    });
  }

  Future pickImageFromCamera() async {
    var awaitImage = await picker.getImage(source: ImageSource.camera);

    setState(() {
      selectedImage = File(awaitImage.path);
      imageLoaded = true;
    });
  }

  Future extractText() async {
    setState(() {
      showProgressBar = true;
    });
    FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(selectedImage);
    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(visionImage);

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        setState(() {
          extractedText = extractedText + line.text + ' ';
          lists.add(
            pw.Paragraph(
                text: line.text,
                style: pw.TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: pw.TextAlign.center),
          );
        });
      }
      extractedText = extractedText + '\n' + '\n';
    }
    textRecognizer.close();
    setState(() {
      showProgressBar = false;
    });
    if (extractedText == '') {
      showDialog(
          context: context,
          builder: (_) => dialog_Box(
                description:
                    'No text can be extracted.Please click on reset and choose another image.',
              ));
    }
  }

  Future pickImageFromGallery() async {
    var galleryImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(galleryImage.path);
      imageLoaded = true;
    });
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: imageLoaded
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(blurRadius: 20),
                          ],
                        ),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                        height: 100,
                        child: Image.file(
                          selectedImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton.icon(
                          icon: Icon(
                            Icons.photo_camera,
                            color: Colors.white70,
                            size: 100,
                          ),
                          label: Text(''),
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () async {
                            pickImageFromCamera();
                          },
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        FlatButton.icon(
                          icon: Icon(
                            Icons.photo,
                            color: Colors.white70,
                            size: 100,
                          ),
                          label: Text(''),
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () async {
                            pickImageFromGallery();
                          },
                        ),
                      ],
                    ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.indigo,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(1, 1))
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                color: Color(0xff0a00b6),
              ),
              height: 120.0,
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.2,
                      blurRadius: 5,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: extractedText == ''
                          ? Text(
                              'Extracted Text will display here.',
                              style: TextStyle(fontSize: 15.0),
                            )
                          : Container(
                              child: SelectableText(
                                extractedText,
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                child: Text(
                  '*Only english alphabets can be extracted.',
                  style: TextStyle(fontSize: 10.0),
                )),
            showProgressBar
                ? Container(
                    margin: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: LinearProgressIndicator(
                      backgroundColor: Color(0xffAEC3FF),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xff8282FF)),
                    ),
                  )
                : SizedBox(
                    height: 6.0,
                  ),
            SizedBox(
              height: 2.5,
            ),
            ButtomButton(
              marbuttom: 5.0,
              martop: 10.0,
              buttonTitle: 'Extract Text',
              onTap: () {
                if (!imageLoaded) {
                  showDialog(
                      context: context,
                      builder: (_) => dialog_Box(
                            description: 'Please select an image.',
                          ));
                } else if (extractedText != '') {
                  showDialog(
                      context: context,
                      builder: (_) => dialog_Box(
                            description: 'Please reset.',
                          ));
                } else {
                  extractText();
                }
              },
            ),
            ButtomButton(
              buttonTitle: 'View as PDF',
              onTap: () async {
                if (extractedText == '') {
                  showDialog(
                      context: context,
                      builder: (_) => dialog_Box(
                            description: 'Please extract text first.',
                          ));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => pdf_viewer(
                              text: extractedText,
                            )),
                  );
                }
              },
              marbuttom: 5.0,
              martop: 10.0,
            ),
            ButtomButton(
              buttonTitle: 'Reset',
              onTap: () {
                reset();
              },
              marbuttom: 10.0,
              martop: 10.0,
            ),
            SizedBox(
              height: 5.0,
            )
          ],
        ),
      ),
      drawer: drawer(),
    );
  }
}
