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
        "creator": name,
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
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          validator: (val) {
                            return val.isEmpty || val.length < 3
                                ? "Enter name 3+ characters"
                                : null;
                          },
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
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC)
                            ],
                          )),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Create classroom",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  //this is not for this screen, It's part of enrolling in new classroom
                  GestureDetector(
                    onTap: () {
                      DatabaseMethods().add(email, nameController.text);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC)
                            ],
                          )),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Add",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  //
                ],
              ),
            ),
    );
  }
}
