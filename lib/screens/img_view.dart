import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';

class Img extends StatefulWidget {
  final url;
  Img(this.url);

  @override
  _ImgState createState() => _ImgState();
}

class _ImgState extends State<Img> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dwnld();
        },
        backgroundColor: Colors.grey,
        child: Icon(Icons.download_rounded),
      ),
      body: Container(
          child: PhotoView(
        imageProvider: NetworkImage(widget.url),
      )),
    );
  }

  void dwnld() async {
    var tempDir = await getExternalStorageDirectory();
    String fullPath = "${tempDir.path}/${randomAlphaNumeric(8)}.jpg";
    print(fullPath);
    Dio().download(widget.url, fullPath);
    Fluttertoast.showToast(
        msg: "✅ Image will be shortly downloaded in,\n$fullPath",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}
