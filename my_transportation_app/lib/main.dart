import 'package:flutter/material.dart';
import 'package:my_transportation_app/input_page.dart';
import 'package:my_transportation_app/screens/chat_screen.dart';
import 'package:my_transportation_app/screens/login_screen.dart';
import 'package:my_transportation_app/screens/registration_screen.dart';
import 'package:my_transportation_app/screens/unassigned_job.dart';
import 'package:my_transportation_app/screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          //textTheme: TextTheme(
          //body1: TextStyle(color: Colors.black54),
          //),
          ),
      home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        InputPage.id: (context) => InputPage(),
        UnassignedJob.id: (context) =>UnassignedJob(),
      },
    );
  }
}
