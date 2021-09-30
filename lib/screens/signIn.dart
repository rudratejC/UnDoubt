import 'package:flutter/material.dart';
import 'package:undoubt/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset("assets/girl.png")),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300],
              ),
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Image.asset("assets/logo.png"),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
            setState(() {});
            AuthMethods().SignInWithGoogle(context);
          },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromRGBO(56, 68, 160, 1),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Continue with"),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        height: 30, child: Image.asset("assets/google.png")),
                  ],
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
