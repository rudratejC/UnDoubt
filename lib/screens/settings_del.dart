import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:undoubt/screens/signIn.dart';
import 'package:undoubt/services/auth.dart';
import 'package:undoubt/services/database.dart';

class Setting extends StatefulWidget {
  String email;
  Stream classRoomStream;

  Setting(this.email);
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  QuerySnapshot user;
  @override
  void initState() {
    super.initState();
    onLoad();
    getInfo();
  }

  getInfo() async {
    user = await DatabaseMethods().getUserInfo(widget.email);
    setState(() {});
  }

  onLoad() async {
    widget.classRoomStream = await DatabaseMethods().getClassRooms();
    setState(() {});
  }

  Widget classRoomsList() {
    return StreamBuilder(
      stream: widget.classRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];

                  return classRoomsListTile(
                      classRoomName: ds["name"],
                      creatorName: ds["creator"],
                      classCode: ds.id);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget classRoomsListTile({classRoomName, creatorName, classCode}) {
    return GestureDetector(
      // onTap: () {
      //   DatabaseMethods().delete(widget.email, classCode);

      // },
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                color: Color.fromRGBO(56, 68, 160, 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text("Confirm delete $classRoomName :"),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        MaterialButton(
                          color: Colors.blueGrey,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        MaterialButton(
                          onPressed: () {
                            DatabaseMethods().delete(widget.email, classCode);
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "✅ $classRoomName deleted successfully!",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                          child: Text("Delete"),
                          color: Colors.red.withOpacity(0.6),
                        ),
                        Spacer()
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red[800].withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(6.0),
        margin: EdgeInsets.only(bottom: 12.0),
        child: Center(
          child: ListTile(
            leading: Icon(Icons.group),
            title: Text(classRoomName),
            subtitle: Text(creatorName),
            trailing: Icon(Icons.delete),
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
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              user != null
                  ? Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(56, 68, 160, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Column(
                        children: [
                          Spacer(),
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.height * 0.04,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child:
                                    Image.network(user.docs[0]["profileUrl"])),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text("Name: ${user.docs[0]["name"]}"),
                          SizedBox(
                            height: 12,
                          ),
                          Text("Email: ${user.docs[0]["email"]}"),
                          Spacer(),
                        ],
                      ))
                  : CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  AuthMethods().signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text("SignOut")),
                ),
              ),
              SizedBox(
                height: 50,
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
                  Text("Delete Classrooms")
                ],
              ),
              SizedBox(
                height: 12,
              ),
              classRoomsList(),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
