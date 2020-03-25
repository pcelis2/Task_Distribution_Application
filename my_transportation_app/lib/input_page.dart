import 'package:flutter/material.dart';
import 'package:my_transportation_app/screens/chat_screen.dart';
import 'transportationDriver.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class InputPage extends StatefulWidget {
  static const String id = "input_page";

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState

    getCurrentUser();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    AppBar getAppBar(TransportationDriver driver) {
      return AppBar(
        backgroundColor: Colors.blue[200],
        leading: Icon(Icons.person_outline),
        title: Text(
          loggedInUser.email,
        ),
      );
      ;
    }

    Padding getPatientPicture(TransportationDriver driver) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: CircleAvatar(
          radius: 50.0,
          backgroundImage: AssetImage('images/iconfinder_28-man_4715002.png'),
        ),
      );
    }

    Card patientInformationBlock(TransportationDriver driver) {
      String name = driver.getPatientName();
      String dateOfBirth = driver.getPatientDateOfBirth();
      int MRN = driver.getPatientMRN();
      String frLocation = driver.getPatientLocation();
      String toLocation = driver.getWhereToTakePatient();

      return Card(
        elevation: 20.0,
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            Icons.person_outline,
            color: Colors.grey.shade500,
          ),
          title: Text(
            'Name: $name\nDOB:    $dateOfBirth',
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
          subtitle: Text('MRN: $MRN\nFROM:  $frLocation  |  TO: $toLocation '),
        ),
      );
    }

    FlatButton commentSection(TransportationDriver driver) {
      String comment = driver.getComment();
      return FlatButton(
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 21.0),
        onPressed: () {
          setState(() {
            driver.toggleCommentSize();
            comment = driver.getComment();
          });
        },
        child: Card(
          elevation: 20.0,
          //margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
          child: ListTile(
            leading: Icon(
              Icons.note,
              color: Colors.orange.shade500,
            ),
            title: Text('Comments: '),
            //will try to add a logic that if the comments extend then i will try to a hold and it will show the entire comment
            subtitle: Text('$comment'),
          ),
        ),
      );
    }

    Card transporterTimes(TransportationDriver driver) {
      String assignedTime = driver.getAssignedTIme();
      String acknowledgedTime = driver.getAckowledgedTime();
      String inProgress = driver.getInProgressTime();
      String delayTime = driver.getDelayTime();
      return Card(
        elevation: 20.0,
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            Icons.timelapse,
            color: Colors.red.shade500,
          ),
          subtitle: Text('Assigned: $assignedTime\nAcknowledged: $acknowledgedTime\nIn-Progress: $inProgress\nDelay: $delayTime'),
        ),
      );
    }

    SpeedDial jobRelatedButton() {
      return SpeedDial(
        backgroundColor: Colors.redAccent,
        elevation: 20.0,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.check),
            backgroundColor: Colors.greenAccent,
            label: "Acknowledge",
            onTap: () {
              print("Acknowledged");
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.people_outline),
            label: "Chat Room",
            onTap: () {
              Navigator.pushNamed(context, ChatScreen.id);
              print("Chat Room");
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.access_time),
            backgroundColor: Colors.orangeAccent,
            label: "Break",
            onTap: () {
              print("Break'd");
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.directions_run),
            backgroundColor: Colors.redAccent,
            label: "End Shift",
            onTap: () {
              print("End Shift'd");
            },
          ),
        ],
      );
    }

    SizedBox getDivider() {
      return SizedBox(
        height: 20,
        width: 150.0,
        child: Divider(color: Colors.grey.shade800),
      );
    }

    return Scaffold(
      //TODO: Need to make sure that when the phone is tilted it looks nice, maybe add something like scroll? I thought it was embedded apparently not
      backgroundColor: Colors.blue[100],
      appBar: getAppBar(TransportationDriver.getTestingCase()),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            getPatientPicture(TransportationDriver.getTestingCase()),
            getDivider(),
            patientInformationBlock(TransportationDriver.getTestingCase()),
            commentSection(TransportationDriver.getTestingCase()),
            transporterTimes(TransportationDriver.getTestingCase()),
          ],
        ),
      ),
      floatingActionButton: jobRelatedButton(),
    );
  }
}
