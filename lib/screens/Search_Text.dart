import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:textrec/assets/buttomButton.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:textrec/assets/constants.dart';
import 'package:textrec/assets/dialog_box.dart';
import 'package:textrec/assets/drawer.dart';

class SearchText extends StatefulWidget {
  @override
  _SearchTextState createState() => _SearchTextState();
}

class _SearchTextState extends State<SearchText> {
  File selectedImage;
  bool imageLoaded = false;
  var extractedText = '';
  var textToSearch = '';
  var resultOfSearch = 'not found';
  var statusOfSearch = 'Not complete';
  var searchResult = '';
  var searchResultIcon;
  var searchTextClicked = false;
  final picker = ImagePicker();
  List<pw.Widget> lists = [];
  bool showProgressBar = false;
  var _controller = TextEditingController();

  decider() {
    if (resultOfSearch == 'not found') {
      setState(() {
        searchResult = "Not Found";
        searchResultIcon = Icons.close;
      });
    }
    if (resultOfSearch == 'found') {
      setState(() {
        searchResult = "Found";
        searchResultIcon = Icons.check;
      });
    }
  }

  reset() {
    setState(() {
      imageLoaded = false;
      lists = [];
      extractedText = '';
      searchResult = '';
      statusOfSearch = 'Not complete';
      textToSearch = '';
      showProgressBar = false;
      _controller.clear();
      searchTextClicked = false;
    });
  }

  Future pickImageFromGallery() async {
    var galleryImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(galleryImage.path);
      imageLoaded = true;
    });
  }

  Future pickImageFromCamera() async {
    var awaitImage = await picker.getImage(source: ImageSource.camera);

    setState(() {
      selectedImage = File(awaitImage.path);
      imageLoaded = true;
    });
  }

  Future searchText() async {
    setState(() {
      showProgressBar = true;
    });
    FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(selectedImage);
    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(visionImage);

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          setState(() {
            extractedText = extractedText + word.text.toLowerCase() + ' ';
            if (extractedText.contains(textToSearch)) {
              resultOfSearch = 'found';
            }
          });
        }
        extractedText = extractedText + '\n';
      }
    }
    textRecognizer.close();
    setState(() {
      statusOfSearch = 'complete';
    });
    decider();
    setState(() {
      showProgressBar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xff0a00b6),
          title: Text(
            'Search Text',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            // action button
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(
                image: AssetImage('images/whitewithblue.png'),
              ),
            ),
          ],
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
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
                              color: Colors.red,
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
                SizedBox(height: 5.0),
                Container(
                  height: 140.0,
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        textToSearch = value;
                      });
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter Text To Search'),
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                    child: Text(
                      '*Only english alphabets can be searched.',
                      style: TextStyle(fontSize: 10.0),
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                    child: Text(
                      '*Search is case insensitive.',
                      style: TextStyle(fontSize: 10.0),
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                    child: Text(
                      '*Careful about whitespaces.',
                      style: TextStyle(fontSize: 10.0),
                    )),

                showProgressBar
                    ? Container(
                        margin: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: LinearProgressIndicator(
                          backgroundColor: Color(0xff0a00b6),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff8282FF)),
                        ),
                      )
                    : SizedBox(
                        height: 6.0,
                      ),
                SizedBox(
                  height: 8.0,
                ),

                Container(
                  child: Column(
                    children: <Widget>[
                      statusOfSearch == 'Not complete'
                          ? Icon(
                              Icons.search,
                              size: 130.0,
                              color: kPrimaryPurple,
                            )
                          : Icon(
                              searchResultIcon,
                              size: 130.0,
                              color: kPrimaryPurple,
                            ),
                      Center(
                        child: Text(
                          statusOfSearch == 'Not complete'
                              ? 'Search'
                              : searchResult,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: kPrimaryPurple,
                              fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 160.0,
                  margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 0)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                ButtomButton(
                  buttonTitle: 'Search Text',
                  onTap: () {
                    if (searchTextClicked) {
                      showDialog(
                          context: context,
                          builder: (_) => dialog_Box(
                                description: 'Please reset and search.',
                              ));
                    } else if (!imageLoaded &&
                        textToSearch == '' &&
                        !searchTextClicked) {
                      showDialog(
                          context: context,
                          builder: (_) => dialog_Box(
                                description:
                                    'Please select an image and enter text to search.',
                              ));
                    } else if (imageLoaded &&
                        textToSearch == '' &&
                        !searchTextClicked) {
                      showDialog(
                          context: context,
                          builder: (_) => dialog_Box(
                                description: 'Please enter text to search.',
                              ));
                    } else if (!imageLoaded &&
                        textToSearch != '' &&
                        !searchTextClicked) {
                      showDialog(
                          context: context,
                          builder: (_) => dialog_Box(
                                description: 'Please select an image.',
                              ));
                    } else {
                      searchTextClicked = true;
                      searchText();
                    }
                  },
                  marbuttom: 10.0,
                  martop: 0.0,
                ),
                ButtomButton(
                  buttonTitle: 'Reset',
                  onTap: () {
                    reset();
                  },
                  marbuttom: 10.0,
                  martop: 10.0,
                ),
                //SizedBox(
                //height: 10.0,
                //)
              ],
            ),
          ),
        ),
        drawer: drawer(),
      ),
    );
  }
}
