import 'package:flutter/material.dart';
import 'package:undoubt/services/database.dart';

TextEditingController ansText = new TextEditingController();
String doubtId, classCode;

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
                color:  Color.fromRGBO(56, 68, 160, 1),
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
        if(ansText.text!=""){
          DatabaseMethods().addAns(classCode, doubtId, ansText.text);
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
