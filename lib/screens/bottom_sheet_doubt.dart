import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:undoubt/services/database.dart';

TextEditingController doubtText = new TextEditingController();
String classCode, creatorName;

class BottomSheetWidget extends StatefulWidget {
  //const BottomSheetWidget({Key key}) : super(key: key);

  BottomSheetWidget({String classcode}) {
    classCode = classcode;
  }
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      //margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
      padding: EdgeInsets.symmetric(horizontal: 12),
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
              children: <Widget>[DecoratedTextField(), SheetButton()],
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
        controller: doubtText,
        decoration: InputDecoration.collapsed(hintText: 'Enter your doubt'),
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
        print("this is classcode $classCode");
        DatabaseMethods().addDoubt(classCode, doubtText.text);
        doubtText.clear();
        Navigator.pop(context);
        // if (doubtText.text != "") {
        //   List words = doubtText.text.split(" ");
        //   bool res = false;
        //   for (int i = 0; i < words.length; i++) {
        //     res = await DatabaseMethods().checkWord(words[i]);
        //     print(words[i]);
        //     if (!res) {
        //       Fluttertoast.showToast(
        //           msg:
        //               "Can't add Doubt,It may contains some inappropriate words",
        //           toastLength: Toast.LENGTH_LONG,
        //           gravity: ToastGravity.BOTTOM,
        //           timeInSecForIosWeb: 1,
        //           backgroundColor: Colors.red,
        //           textColor: Colors.white,
        //           fontSize: 16.0);
        //       doubtText.clear();
        //       Navigator.pop(context);
        //       return;
        //     }
        //   }
        //   if (!res) {
        //     //here
        //   }
        // }
      },
      child: Text(
        'Ask',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
