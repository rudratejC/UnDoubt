import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:undoubt/helpers/sharedpref_helper.dart';
import 'package:undoubt/screens/Home.dart';
import 'package:undoubt/services/auth.dart';
import 'package:undoubt/services/database.dart';

class CreateClassroomScreen extends StatefulWidget {
  @override
  _CreateClassroomScreenState createState() => _CreateClassroomScreenState();
}

class _CreateClassroomScreenState extends State<CreateClassroomScreen> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController creatorNameController = new TextEditingController();
  AuthMethods authService = new AuthMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String classCode, name, email;

  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    name = await SharedPreferenceHelper().getDisplayName();
    email = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  create() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      var time = DateTime.now();
      classCode = randomAlphaNumeric(6);
      Map<String, dynamic> classroomInfoMap = {
        "name": nameController.text,
        "creator": creatorNameController.text,
        "creatorEmail": email,
        "classCode": classCode,
        "ts": time,
        "users": [email]
      };
      DatabaseMethods().createClassRoom(classCode, classroomInfoMap);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                //padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Image.asset(
                      "assets/logo.png",
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width * 0.92,
                      height: MediaQuery.of(context).size.height * 0.1,
                      padding: EdgeInsets.all(6.0),
                      margin: EdgeInsets.only(bottom: 12.0),
                      child: Center(
                        child: Text(
                          "Create a Classroom",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(56, 68, 160, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: 'Enter Classroom Name',
                              ),
                              controller: nameController,
                              validator: (val) {
                                return val.isEmpty || val.length < 3
                                    ? "Enter name 3+ characters"
                                    : null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 80,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(56, 68, 160, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: 'Enter Creator Name',
                              ),
                              controller: creatorNameController,
                              validator: (val) {
                                return val.isEmpty || val.length < 3
                                    ? "Enter name 3+ characters"
                                    : null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        create();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Center(
                          child: Text(
                            "Create",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    //this is not for this screen, It's part of enrolling in new classroom
                    // GestureDetector(
                    //   onTap: () {
                    //     DatabaseMethods().add(email, nameController.text);
                    //     Navigator.pushReplacement(context,
                    //         MaterialPageRoute(builder: (context) => Home()));
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(vertical: 16),
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(30),
                    //         gradient: LinearGradient(
                    //           colors: [
                    //             const Color(0xff007EF4),
                    //             const Color(0xff2A75BC)
                    //           ],
                    //         )),
                    //     width: MediaQuery.of(context).size.width,
                    //     child: Text(
                    //       "Add",
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // ),
                    //
                  ],
                ),
              ),
            ),
    );
  }
}
