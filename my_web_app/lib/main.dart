import 'package:flutter/material.dart';
import 'package:my_web_app/input_page.dart';
import 'package:my_web_app/sceens/welcome_screen.dart';
import 'JobListDriver.dart';
import 'package:my_web_app/sceens/login_screen.dart';
import 'package:my_web_app/sceens/registration_screen.dart';
import 'package:my_web_app/sceens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static JobListDriver myJobListDriver = new JobListDriver();

  MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(),
      home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        InputPage.id: (context) => InputPage(),
      },
    );
  }
}
