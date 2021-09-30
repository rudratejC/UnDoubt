import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:undoubt/screens/answer_screen.dart';
import 'package:undoubt/screens/bottom_sheet_doubt.dart';
import 'package:undoubt/screens/create_classroom.dart';
import 'package:undoubt/services/database.dart';

class ClassroomScreen extends StatefulWidget {
  String classCode, classRoomName, creatorName;
  ClassroomScreen(
      {String classRoomName, String creatorName, String classCode}) {
    this.classCode = classCode;
    this.classRoomName = classRoomName;
    this.creatorName = creatorName;
  }
  @override
  _ClassroomScreenState createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  Stream doubtsStream;
  @override
  void initState() {
    super.initState();
    getdbts();
  }

  getdbts() async {
    doubtsStream = await DatabaseMethods().getDoubts(widget.classCode);
    setState(() {});
  }

  Widget doubtsList() {
    return StreamBuilder(
      stream: doubtsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];

                  return doubtsListTile(
                      desc: ds["desc"], time: ds["time"], id: ds.id);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget doubtsListTile({desc, time, id}) {
    return GestureDetector(
      onTap: () {
        print("\n\n$id\n\n");
        print(widget.classCode);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AnwerScreen(
                      classRoomName: widget.classRoomName,
                      classCode: widget.classCode,
                      creatorName: widget.creatorName,
                      doubtText: desc,
                      doubtId: id,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(56, 68, 160, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width * 0.92,
        //height: MediaQuery.of(context).size.height * 0.1,
        padding: EdgeInsets.all(6.0),
        margin: EdgeInsets.only(bottom: 12.0),
        child: Center(
          child: ListTile(
            leading: Icon(Icons.question_answer_outlined),
            title: Text(desc),
            subtitle: Text("${time.toDate().toString().substring(0, 16)}"),
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
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(237, 240, 242, 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/question.png",
                      height: MediaQuery.of(context).size.height * 0.10,
                    ),
                    Spacer(),
                    Center(
                      child: Column(
                        children: [
                          Spacer(),
                          Text(
                            widget.classRoomName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025),
                          ),
                          Text(
                            widget.creatorName,
                            style: TextStyle(color: Colors.black54),
                          ),
                          SelectableText(
                            "Code: ${widget.classCode}",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
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
                  Text("Doubts")
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
                        child: Column(
                          children: [doubtsList()],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: MyFloatingButton(
        classCode: widget.classCode,
      ),
    );
  }
}

class MyFloatingButton extends StatefulWidget {
  String classCode;
  MyFloatingButton({String classCode}) {
    this.classCode = classCode;
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
