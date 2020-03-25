import 'package:flutter/material.dart';
import 'package:my_web_app/constants.dart';
import 'package:my_web_app/sceens/chat_screen.dart';
import 'welcome_screen.dart';
import 'package:my_web_app/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class RegistrationScreen extends StatefulWidget {
  static const String id = "registration_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String passsword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'Hospital_Icon',
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
                  //Do something with the user input.
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
                  //Do something with the user input.
                  passsword = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your '
                        'password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: "Register",
                colour: Colors.blueAccent,
                onPressed: () async {
                  print(email);
                  print(passsword);
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: passsword);
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
