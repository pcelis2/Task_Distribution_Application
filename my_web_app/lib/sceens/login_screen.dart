import 'package:flutter/material.dart';
import 'package:my_web_app/components/rounded_button.dart';
import 'package:my_web_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_web_app/input_page.dart';
import 'package:my_web_app/sceens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

const String Welcome_Title_String = "Transporter App";
const String Icon_Logo_String = 'images/hospital_icon.png';

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinnder = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinnder,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "Hospital_Icon",
                  child: Container(
                    height: 200.0,
                    child: Image.asset(Icon_Logo_String),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your"
                        " email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your"
                        " password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title: "Login",
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinnder = true;
                    });
                    print(email);
                    print(password);
                    try {
                      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                      if (user != null) {
                        Navigator.pushNamed(context, InputPage.id);
                      }
                      setState(() {
                        showSpinnder = false;
                      });
                    } catch (e) {
                      setState(() {
                        showSpinnder = false;
                      });
                      print(e);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
