import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:undoubt/helpers/sharedpref_helper.dart';
import 'package:undoubt/screens/classroom_screen.dart';
import 'package:undoubt/screens/create_classroom.dart';
import 'package:undoubt/screens/enroll.dart';
import 'package:undoubt/screens/settings_del.dart';
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
        decoration: BoxDecoration(
          color: Color.fromRGBO(56, 68, 160, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width * 0.92,
        height: MediaQuery.of(context).size.height * 0.1,
        padding: EdgeInsets.all(6.0),
        margin: EdgeInsets.only(bottom: 12.0),
        child: Center(
          child: ListTile(
            leading: Icon(Icons.group),
            title: Text(classRoomName),
            subtitle: Text(creatorName),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            //color: Colors.white,
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
                                "Hi, $myName !",
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
                            borderRadius: BorderRadius.circular(40)),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Setting(myEmail)));
                          },
                          child: Icon(
                            Icons.settings,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 26,
                ),
                Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        "assets/homepageBanner.png",
                        width: MediaQuery.of(context).size.width * 0.92,
                      )),
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
                    Text("My Classrooms")
                  ],
                ),

                /// classrooms
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    width: MediaQuery.of(context).size.width,
                    // decoration: BoxDecoration(
                    //     //color: Colors.white,
                    //     borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(30),
                    //         topRight: Radius.circular(30))),
                    child: Column(
                      children: <Widget>[
                        Container(
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
          backgroundColor: Colors.grey,
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    color: Color.fromRGBO(56, 68, 160, 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: new Icon(Icons.add),
                          title: new Text('Create a Classroom'),
                          onTap: () {
                            print('add classroom pressed');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateClassroomScreen()));
                          },
                        ),
                        ListTile(
                          leading: new Icon(Icons.add),
                          title: new Text('Enroll in a Classroom'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EnrollClassroomScreen()));
                          },
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Icon(Icons.add),
        ));
  }
}
