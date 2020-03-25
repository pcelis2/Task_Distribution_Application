import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_web_app/ActiveTransportersOnBoardList.dart';
import 'package:my_web_app/components/Job_Identifier.dart';
import 'package:my_web_app/components/MRN_Assignment.dart';
import 'package:my_web_app/jobs_on_board.dart';
import 'package:my_web_app/sceens/chat_screen.dart';
import 'package:my_web_app/testing_components/JobCreation.dart';
import 'package:my_web_app/testing_components/PatientCreation.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'testing_components/RoomCreation.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class InputPage extends StatefulWidget {
  static const String id = "my_web_input_page";

  _InputPage createState() => _InputPage();
}

class _InputPage extends State<InputPage> {
  final messageTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  _InputPage();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.dashboard),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //TODO: Implement logout functionality
              }),
        ],
        title: Text('Job Board'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //JobsOnBoardList(),
            rowWithHeader(),
            rowWithDetails(),
          ],
        ),
      ),
      floatingActionButton: getButton(),
    );
  }

  SpeedDial getButton() {
    return SpeedDial(
      backgroundColor: Colors.redAccent,
      elevation: 20.0,
      animatedIcon: AnimatedIcons.menu_close,
      children: [
        SpeedDialChild(
          child: Icon(Icons.check),
          label: "Assign Top Most Job",
          onTap: () {
            print("Assign Top Most Job");
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.people_outline),
          backgroundColor: Colors.orange,
          label: "Chat Room",
          onTap: () {
            Navigator.pushNamed(context, ChatScreen.id);
            print("Chat Room");
          },
        ),
        SpeedDialChild(
          child: Icon(
            Icons.add,
            color: Colors.cyan,
          ),
          backgroundColor: Colors.black,
          label: "Create Random Job |NOT DONE YET",
          onTap: () {
            JobCreation.createARandomJob(loggedInUser);
            //JobCreation.CreateARandomJob(loggedInUser);
            print("Create Random Job");
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.warning),
          backgroundColor: Colors.orangeAccent,
          label: "FOR TESTING FUNCTIONS",
          onTap: () {
            print("====FOR TESTING FUNCTIONS====");
            TESTINGSTUPH();
          },
        ),
      ],
    );
  }

  void TESTINGSTUPH() async {
    //int temp = await JobIdentifier.getLatestJobIdentifier();
    //int temp = await MRN_Assignment.getMRN_ID();
    //CreateRooms.CreationOfRooms();
    //print (temp);
    //CreateRooms.isRoomAvailable('2 SOuth 5');
    //print(JobCreation.makeARandomComment());
    //PatientCreation.populateDataBaseWithPatients(60); // was commented out
    //JobCreation jb = await JobCreation.CreateARandomJob(loggedInUser);
    //print('something');
    //dummyFunction(jb.toString());
    //int value = await PatientCreation.getAPatientFromDatabase();
    //print(value);
    //JobCreation jb = await JobCreation.CreateARandomJob(loggedInUser);
    //print(jb);
  }

  Material rowWithHeader() {
    return Material(
      color: Colors.grey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Transporters",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "Jobs",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Expanded rowWithDetails() {
    return Expanded(
      child: Row(
        children: <Widget>[
          ActiveTransportersOnBoard(),
          JobsOnBoardList(),
          //JobsOnBoardList(),
        ],
      ),
    );
  }
}

Card Header(String str) {
  return Card(
    child: ListTile(
      title: Text(str),
    ),
  );
}
