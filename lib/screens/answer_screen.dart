import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:undoubt/screens/bottom_sheet_ans.dart';
import 'package:undoubt/screens/create_classroom.dart';
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
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  //return classRoomsListTile(ds["lastMessage"], ds.id, myUserName);
                  // return Text(
                  //   ds.id.replaceAll(myUserName, "").replaceAll("_", ""),
                  //   style: chatTileStyle(),
                  // );

                  return answerListTile(
                      desc: ds["desc"], time: ds["time"], id: ds.id);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget answerListTile({desc, time, id}) {
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
        padding: EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: Icon(Icons.question_answer),
          title: Text(desc),
          subtitle: Text("${time.toDate().toString()}"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.doubtText,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              /// doubts
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
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
