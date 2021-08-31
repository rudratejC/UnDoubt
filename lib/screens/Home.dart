import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:undoubt/helpers/sharedpref_helper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name, email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onLoad();
  }

  onLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString("USERDISPLAYNAMEKEY");
    email = prefs.getString("USEREMAILKEY");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Namaste $name \n your email is $email"),
      ),
    );
  }
}
