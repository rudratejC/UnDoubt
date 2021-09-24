import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:undoubt/helpers/sharedpref_helper.dart';
import 'package:undoubt/screens/classroom_screen.dart';
import 'package:undoubt/screens/create_classroom.dart';
import 'package:undoubt/screens/signIn.dart';
import 'package:undoubt/services/auth.dart';
import 'package:undoubt/services/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Stream classRoomsStream;

class _HomeState extends State<Home> {
  bool isSearching = false;

  String myName, myProfilePic, myUserName, myEmail;

  getMyInfoFromSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myUserName = prefs.getString('USERNAMEKEY');
    myEmail = prefs.getString('USEREMAILKEY');
    myName = prefs.getString('USERDISPLAYNAMEKEY');
    myProfilePic = prefs.getString('USERPROFILEPICKEY');

    setState(() {});
  }

  getChatRooms() async {
    classRoomsStream = await DatabaseMethods().getClassRooms();
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
  }

  getUserName() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    setState(() {});
  }

  @override
  void initState() {
    getUserName();
    onScreenLoaded();
    getChatRooms();
    setState(() {});
    super.initState();
  }

  callHomesInit() {
    initState();
  }

  Widget classRoomsList() {
    return StreamBuilder(
      stream: classRoomsStream,
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClassroomScreen(
                      classRoomName: classRoomName,
                      classCode: classCode,
                      creatorName: creatorName,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: Icon(Icons.group),
          title: Text(classRoomName),
          subtitle: Text("$creatorName      Code: $classCode"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: <Widget>[
                      myProfilePic != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.network(
                                myProfilePic,
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: 12,
                      ),
                      myName != null
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                "Hi, $myName!",
                              ),
                            )
                          : Container(
                              child: Text(
                                "Welcome to UnDoubt!",
                              ),
                            ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xff444446),
                            borderRadius: BorderRadius.circular(12)),
                        child: GestureDetector(
                          onTap: () {
                            AuthMethods().signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()));
                          },
                          child: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 80),

                /// classrooms
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
                            children: [classRoomsList()],
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateClassroomScreen()));
          },
          child: Icon(Icons.add),
        ));
  }
}
