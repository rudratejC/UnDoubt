import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:undoubt/screens/bottom_sheet_ans.dart';
import 'package:undoubt/screens/create_classroom.dart';
import 'package:undoubt/screens/img_view.dart';
import 'package:undoubt/services/database.dart';

class AnwerScreen extends StatefulWidget {
  String classCode, classRoomName, creatorName, doubtText, doubtId;
  AnwerScreen(
      {String classRoomName,
      String creatorName,
      String classCode,
      String doubtText,
      String doubtId}) {
    this.classCode = classCode;
    this.classRoomName = classRoomName;
    this.creatorName = creatorName;
    this.doubtText = doubtText;
    this.doubtId = doubtId;
  }
  @override
  _AnwerScreenState createState() => _AnwerScreenState();
}

class _AnwerScreenState extends State<AnwerScreen> {
  Stream answerStream;
  @override
  void initState() {
    super.initState();
    getdbts();
  }

  getdbts() async {
    answerStream = await DatabaseMethods()
        .getAnswers(classCode: widget.classCode, doubtId: widget.doubtId);
    setState(() {});
  }

  Widget answerList() {
    return StreamBuilder(
      stream: answerStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return ds["img"]
                      ? anserImageTile(ds["imgUrl"], ds["public"], ds["name"],
                          ds["time"], ds["addedBy"])
                      : answerListTile(
                          desc: ds["desc"],
                          time: ds["time"],
                          id: ds.id,
                          public: ds["public"],
                          name: ds["name"],
                          email: ds["addedBy"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  anserImageTile(url, public, name, time, email) {
    if (name == null) {
      name = email;
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Img(url)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(81, 152, 114, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width * 0.92,
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  url,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                )),
            SizedBox(
              height: 8,
            ),
            public
                ? Text(
                    "${time.toDate().toString().substring(0, 16)} Contributed by: $name")
                : Row(
                    children: [
                      Spacer(),
                      Text(
                        "${time.toDate().toString().substring(0, 16)}",
                        textAlign: TextAlign.right,
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Widget answerListTile({desc, time, id, public, name, email}) {
    if (name == null) {
      name = email;
    }
    return GestureDetector(
      onTap: () {
        print("\n\n$id\n\n");
        print(widget.classCode);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => AnwerScreen(
        //               classRoomName: classRoomName,
        //               classCode: classCode,
        //               creatorName: creatorName,
        //             )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(81, 152, 114, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width * 0.92,
        padding: EdgeInsets.all(6.0),
        margin: EdgeInsets.only(bottom: 12.0),
        child: Center(
          child: ListTile(
            leading: Icon(Icons.question_answer),
            title: SelectableText(desc),
            subtitle: Text(
                "${time.toDate().toString().substring(0, 16)} \n${public ? "Contributed by: $name" : ""}"),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          //color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.10),
              Container(
                width: MediaQuery.of(context).size.width * 0.92,
                padding: EdgeInsets.all(12.0),
                // height: MediaQuery.of(context).size.height*0.20,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(237, 240, 242, 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "🚀${widget.classRoomName}",
                        style: TextStyle(
                            color: Color.fromRGBO(56, 68, 160, 1),
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025),
                      ),
                      SelectableText(
                        widget.doubtText,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    color: Color.fromRGBO(56, 68, 160, 1),
                    height: 16,
                    child: Text(" "),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Answers")
                ],
              ),

              /// doubts
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        child: Column(
                          children: [answerList()],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: MyFloatingButton(
        doubtId: widget.doubtId,
        classcode: widget.classCode,
      ),
    );
  }
}

class MyFloatingButton extends StatefulWidget {
  String doubtId, classCode;
  MyFloatingButton({String doubtId, String classcode}) {
    this.doubtId = doubtId;
    this.classCode = classcode;
  }
  @override
  _MyFloatingButtonState createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  bool _show = true;
  @override
  Widget build(BuildContext context) {
    return _show
        ? FloatingActionButton(
            backgroundColor: Colors.grey,
            child: Icon(Icons.add),
            onPressed: () {
              var sheetController = showBottomSheet(
                  context: context,
                  builder: (context) => BottomSheetWidget(
                        doubtid: widget.doubtId,
                        classcode: widget.classCode,
                      ));

              _showButton(false);

              sheetController.closed.then((value) {
                _showButton(true);
              });
            },
          )
        : Container();
  }

  void _showButton(bool value) {
    setState(() {
      _show = value;
    });
  }
}
