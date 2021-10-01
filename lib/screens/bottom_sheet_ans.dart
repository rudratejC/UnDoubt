import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:undoubt/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

TextEditingController ansText = new TextEditingController();
String doubtId, classCode;
bool _switchValue = false;

class BottomSheetWidget extends StatefulWidget {
  //const BottomSheetWidget({Key key}) : super(key: key);

  BottomSheetWidget({String doubtid, classcode}) {
    doubtId = doubtid;
    classCode = classcode;
  }
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  void addImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    File image = new File(pickedFile.path);
    DatabaseMethods().addImageAns(
        image: image,
        public: _switchValue,
        classCode: classCode,
        doubtId: doubtId);
    Fluttertoast.showToast(
        msg: "✅ Image will be uploaded shortly!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      //margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 125,
            decoration: BoxDecoration(
              color: Color.fromRGBO(56, 68, 160, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: <Widget>[
                DecoratedTextField(),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: "⚠️Image Answers are not Anonymous!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          addImage();
                        },
                        child: Row(
                          children: [
                            Text("+"),
                            Icon(
                              Icons.image,
                            ),
                          ],
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Text("Answer publicly:"),
                    SizedBox(
                      width: 8,
                    ),
                    CupertinoSwitch(
                      activeColor: Colors.lightGreen[400].withOpacity(0.8),
                      value: _switchValue,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SheetButton(),
                    Spacer(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DecoratedTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: ansText,
        decoration: InputDecoration.collapsed(hintText: 'Enter your Answer'),
      ),
    );
  }
}

class SheetButton extends StatefulWidget {
  SheetButton({Key key}) : super(key: key);

  _SheetButtonState createState() => _SheetButtonState();
}

class _SheetButtonState extends State<SheetButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.black,
      onPressed: () async {
        print("this is classcode $doubtId");
        if (ansText.text != "") {
          DatabaseMethods()
              .addAns(classCode, doubtId, ansText.text, _switchValue);
          ansText.clear();
          Navigator.pop(context);
        }
      },
      child: Text(
        'Add Answer',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
