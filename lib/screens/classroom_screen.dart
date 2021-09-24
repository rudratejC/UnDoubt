import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  //return classRoomsListTile(ds["lastMessage"], ds.id, myUserName);
                  // return Text(
                  //   ds.id.replaceAll(myUserName, "").replaceAll("_", ""),
                  //   style: chatTileStyle(),
                  // );

                  return doubtsListTile(
                    desc: ds["desc"],
                    time: ds["time"],
                  );
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget doubtsListTile({desc, time}) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ClassroomScreen(
        //               classRoomName: classRoomName,
        //               classCode: classCode,
        //               creatorName: creatorName,
        //             )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: Icon(Icons.question_answer_outlined),
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
          widget.classRoomName,
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
                          children: [doubtsList()],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('add classroom pressed');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateClassroomScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
