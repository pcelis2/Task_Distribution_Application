/*
* Logic is that user will login
* they will automatically be sent to unassigned job
* here we check if there is an assigned job
* if so we go to the assigned job page
* */

import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_transportation_app/utilities/log_in_out_functionality.dart';
import 'chat_screen.dart';

const String job_on_board_collection = 'jobs_currently_on_board';
const String active_transporters_collections = 'active_transporters';
const String active_transporters_status_field = 'status';
const String active_transporters_employee_email_field = 'employee_email';
const String all_jobs_ever_made_collection = 'all_jobs_ever_made';
const String all_jobs_ever_made_JobID_field = 'JobID';
const String all_jobs_ever_made_MRN = 'MRN';
const String active_transporter_assigned_job = 'assigned_job';
const String registered_patients_collection = 'registered_patients';
const String registered_patients_MRN_field = 'MRN';

enum Transporter_State { Unassigned, Assigned, Acknowledged, InProgress }

int currentJob;

class UnassignedJob extends StatefulWidget {
  static String id = 'UnassignedJob';

  @override
  _UnassignedJob createState() => _UnassignedJob();
}

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class _UnassignedJob extends State<UnassignedJob> {
  final _auth = FirebaseAuth.instance;
  Transporter_State _status = Transporter_State.Unassigned;
  String user_email = 'email not set';

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    getCurrentUser();
    getCurrentStatus();
    jobs = getJobs();
  }

  void completeJob() async {
    final setOfTransporters = await _firestore.collection(active_transporters_collections).where(active_transporters_employee_email_field, isEqualTo: loggedInUser.email).getDocuments();

    DocumentSnapshot transporter;
    print('=================');
    for (var message in setOfTransporters.documents) {
      //print(message.data[active_transporters_employee_email_field]);
      if (message.data[active_transporters_employee_email_field] == loggedInUser.email) {
        transporter = message;
      }
    }
    print('=================');

    Map<String, int> newStatus = {active_transporters_status_field: 0};
    Map<String, int> newJobID = {active_transporter_assigned_job: 0};
    transporter.reference.updateData(newJobID);
    transporter.reference.updateData(newStatus);
  }

  void acknowledgeJob() async {
    final transporters = await _firestore.collection(active_transporters_collections).where(active_transporters_employee_email_field, isEqualTo: loggedInUser.email).getDocuments();
    DocumentSnapshot myTransporter;

    for (var message in transporters.documents) {
      if (message.data[active_transporters_employee_email_field] == loggedInUser.email) {
        myTransporter = message;
      }
    }
    int JobID = int.parse(myTransporter.data['assigned_job'].toString());
    Map<String, int> TransporterNewStatus = {active_transporters_status_field: 2};
    myTransporter.reference.updateData(TransporterNewStatus);

    final getJobs = await _firestore.collection('jobs_currently_on_board').where('JobID', isEqualTo: JobID).getDocuments();
    DocumentSnapshot myJob;
    for (var messages in getJobs.documents) {
      myJob = messages;
    }
    myJob.reference.delete();
  }

  Future<List<Widget>> getJobs() async {
    print('1');
    List<Widget> myJobBubbles = [];
    await getCurrentStatus();
    if (loggedInUser == null) {
      print('==========\nThere is check getCurrentStatus, did get jobs skip this\n==========');
    }
    final transporters = await _firestore.collection(active_transporters_collections).where(employee_email_field, isEqualTo: loggedInUser.email).getDocuments();
    DocumentSnapshot myTransporter;
    for (var message in transporters.documents) {
      if (message.data[active_transporters_employee_email_field] == loggedInUser.email) {
        myTransporter = message;
        //break;
      }
    }

    int myJobID = 0;
    print('2');
    if (myTransporter.data[active_transporter_assigned_job] == null) {
      print("No job assigned");
    } else {
      print("myTransporter.data[active_transporter_assigned_job]{" + myTransporter.data[active_transporter_assigned_job] + "}");
      myJobID = int.parse(myTransporter.data[active_transporter_assigned_job]);
    }
    print('3');
    if (myJobID == 0) {
      print('myJobID is 0');
      myJobBubbles.clear();
      myJobBubbles.add(Text('JobID is 0'));
      return myJobBubbles;
    }

    //getting the job information
    int myMRN = 0;
    DocumentSnapshot myJob;
    final jobs = await _firestore.collection(all_jobs_ever_made_collection).where(all_jobs_ever_made_JobID_field, isEqualTo: myJobID).getDocuments();
    for (var message in jobs.documents) {
      if (message.data[all_jobs_ever_made_JobID_field] == myJobID) {
        myJob = message;
        break;
      }
    }
    print('4');
    if (myJob == null) {
      print('myJob is null');
    } else {
      //print("myJob.data[all_jobs_ever_made_JobID_field] {" + myJob.data[all_jobs_ever_made_JobID_field] + "}");
      myMRN = myJob.data[all_jobs_ever_made_MRN];
    }

    print('5');
    if (myMRN == 0) {
      print("myMRN is 0");
      myJobBubbles.add(Text('myMRN is 0'));
      return myJobBubbles;
    }

    //getting the patient information

    DocumentSnapshot myPatient;
    print('6');
    print(myMRN);
    final patients = await _firestore.collection(registered_patients_collection).where(registered_patients_MRN_field, isEqualTo: myMRN).getDocuments();

    for (var message in patients.documents) {
      if (message.data[registered_patients_MRN_field] == myMRN) {
        myPatient = message;
        break;
      }
    }
    print('7');
    if (myPatient == null) {
      myJobBubbles.clear();
      myJobBubbles.add(Text('myPatient is 0'));
      return myJobBubbles;
    }
    print('8');
    //print("myPatient.data[registered_patients_MRN_field]: {" + myPatient.data[registered_patients_MRN_field] + "}");

    //Getting the information from the patient
    String firstName = myPatient.data['FirstName'];
    String lastName = myPatient.data['LastName'];
    String dateOfBirth = myPatient.data['DateOfBirth'];
    String fromRoom = myPatient.data['Room'];

    //Getting the information from the job
    //Will be getting rid of most of the times
    //Except for when it was created and when it was assigned

    String comment = myJob.data['Comments'];
    String toRoom = myJob.data['RoomTo'];

    String timeCreated = myJob.data['TimeCreated'];

    int transporter_status = myTransporter.data['status'];

    myJobBubbles.clear();
    myJobBubbles.add(JobBubble(
      MRN: myMRN.toString(),
      comment: comment,
      dateOfBirth: dateOfBirth,
      name: firstName + lastName,
      frLocation: fromRoom,
      toLocation: toRoom,
      timeCreated: timeCreated,
    ));
    print('100');
    return myJobBubbles;
  }

  Future<Transporter_State> getCurrentStatus() async {
    this.getCurrentUser();

    if (loggedInUser != null) {
      final messages = await _firestore.collection(active_transporters_collections).getDocuments();
      DocumentSnapshot transporter;
      for (var message in messages.documents) {
        if (message.data[active_transporters_employee_email_field] == loggedInUser.email) {
          transporter = message;
          break;
        }
      }
      if (transporter == null) {
        _status = Transporter_State.Unassigned;
        print('dont what to do with the case in which the user is not assigned');
      } else {
        setState(() {
          currentJob = int.parse(transporter.data[active_transporter_assigned_job].toString());
          int index = int.parse(transporter.data[active_transporters_status_field].toString());
          print(index);
          _status = Transporter_State.values[index];
        });
      }
      return _status;
    }
    return _status;
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          loggedInUser = user;
          user_email = loggedInUser.email;
          print(loggedInUser.email);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: Colors.blue[200],
      leading: Icon(Icons.person_outline),
      title: Text(
        user_email,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            print('was updated');
            var _jobs = getJobs();
            setState(() {
              jobs = _jobs;
              jobs = _jobs;
            });
          },
        )
      ],
    );
    ;
  }

  SpeedDial getFloatingActionButton() {
    //TODO: try to find a more efficient way of doing this
    //getCurrentStatus();
    if (_status == Transporter_State.Unassigned) {
      return SpeedDial(backgroundColor: Colors.redAccent, elevation: 20.0, animatedIcon: AnimatedIcons.menu_close, children: [
        SpeedDialChild(
          child: Icon(Icons.check),
          backgroundColor: Colors.greenAccent,
          label: "You are unassigned",
          onTap: () {
            print("You are unassigned");
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
      ]);
    } else if (_status == Transporter_State.Assigned) {
      return SpeedDial(
        backgroundColor: Colors.redAccent,
        elevation: 20.0,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.check),
            backgroundColor: Colors.greenAccent,
            label: "Acknowledged",
            onTap: () {
              print("Acknowledged");


              setState(() {
                jobs = getJobs();
                acknowledgeJob();
                getCurrentStatus();
              });
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
    } else if (_status == Transporter_State.Acknowledged) {
      return SpeedDial(backgroundColor: Colors.redAccent, elevation: 20.0, animatedIcon: AnimatedIcons.menu_close, children: [
        SpeedDialChild(
          child: Icon(Icons.check),
          backgroundColor: Colors.green,
          label: "Complete",
          onTap: () {
            print("Complete");
            setState(() {
              jobs = getJobs();
              completeJob();
              getCurrentStatus();
            });
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
      ]);
    }
  }

  Future<List<Widget>> jobs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (_status == Transporter_State.Unassigned || _status == Transporter_State.Assigned) ? Colors.grey : Colors.blueGrey,
      appBar: getAppBar(),
      body: FutureBuilder(
        future: jobs,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            print('there are no jobs');
            return Center(
                child: Card(
              child: Text(
                'You do not have a job',
                style: TextStyle(fontSize: 24.0),
              ),
              elevation: 20.0,
            ));
          } else {
            print('should have some children here');
            var messages = snapshot.data;

            return ListView(
              reverse: false,
              children: messages,
            );
          }
        },
      ),
      floatingActionButton: getFloatingActionButton(),
    );
    //return MessageStream();
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Coming soon');
//    // TODO: implement build
//    return StreamBuilder<QuerySnapshot>(
//      //stream: _firestore.collection('messages').snapshots(), //version from AppBrewery
//      stream: _firestore.collection(active_transporters_collections).where(active_transporter_assigned_job, isEqualTo: currentJob).snapshots(),
//      builder: (context, snapshot) {
//        //this is flutters snapshot, not google, but it does contain it is not the same as method's snapshot
//        if (!snapshot.hasData) {
//          return Center(
//            child: Card(
//              child: Text(
//                'You are available :)',
//                style: TextStyle(fontSize: 25.0),
//              ),
//              elevation: 25.0,
//              //child: CircularProgressIndicator(
//              //backgroundColor: Colors.lightBlueAccent,
//            ),
//          );
//        }
//        List<Widget> messageBubbles = [];
//        final messages = snapshot.data.documents.reversed;
//        DocumentSnapshot currentJob;
//        for (var message in messages) {
//          final int jobID = int.parse(  message.data[active_transporter_assigned_job]);
//          DocumentSnapshot getPatientForCurrentJob;
//          final getPatients =  _firestore.collection('registered_patients').where('MRN', isEqualTo: jobID).getDocuments().then(getPatient()
//          {
//
//          });
//
//
//
//
//
//
//          messageBubbles.add(JobBubble());
//        }
//        return Expanded(
//          child: ListView(
//            reverse: false,
//            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//            children: messageBubbles,
//          ),
//        );
//      },
//    );
  }
}

class JobBubble extends StatelessWidget {
  JobBubble({@required this.MRN, @required this.comment, @required this.dateOfBirth, @required this.name, @required this.timeCreated, @required this.assignedTime, @required this.frLocation, @required this.toLocation});

  //Things needed to fill out the information of the job
  final String name;
  final String dateOfBirth;
  final String MRN;
  final String frLocation;
  final String toLocation;

  final String timeCreated;
  final String assignedTime;

  final String comment;

  SizedBox getDivider() {
    return SizedBox(
      height: 20,
      width: 150.0,
      child: Divider(color: Colors.grey.shade800),
    );
  }

  Padding getPatientPicture() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: CircleAvatar(
        radius: 50.0,
        backgroundImage: AssetImage('images/iconfinder_28-man_4715002.png'),
      ),
    );
  }

  Card patientInformationBlock() {
    //TODO: going to update after getRealJobDocument
//    String name = this.patientDocument.data['FirstName'];
//    String dateOfBirth = patientDocument.data['LastName'];
//    int MRN = jobDocument.data['MRN'];
//    String frLocation = jobDocument.data['RoomFrom'];
//    String toLocation = jobDocument.data['RoomTo'];

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

  Card transporterTimes() {
//    String assignedTime = jobDocument.data['TimeAssigned'];
//    String acknowledgedTime = jobDocument.data['TimeAcknowledged'];
//    String inProgress = jobDocument.data['TimeInProgress'];
//    String delayTime = jobDocument.data['AmountDelayed'];
    return Card(
      elevation: 20.0,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
      child: ListTile(
        leading: Icon(
          Icons.timelapse,
          color: Colors.red.shade500,
        ),
        subtitle: Text('Created:$timeCreated \nAssigned: $assignedTime\n'),
      ),
    );
  }

  Card commentSection() {
    //String comment = jobDocument.data['Comments'];
    return Card(
      elevation: 20.0,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
      child: ListTile(
        leading: Icon(
          Icons.note,
          color: Colors.orange.shade500,
        ),
        title: Text('Comments: '),
        //will try to add a logic that if the comments extend then i will try to a hold and it will show the entire comment
        subtitle: Text('$comment\n'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        getPatientPicture(),
        getDivider(),
        patientInformationBlock(),
        commentSection(),
        transporterTimes(),
      ],
    );
  }
}
