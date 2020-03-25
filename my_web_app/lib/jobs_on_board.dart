import 'package:flutter/material.dart';
import 'package:my_web_app/ActiveTransportersOnBoardList.dart';
import 'package:my_web_app/testing_components/JobCreation.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

const String job_on_board_collection = 'jobs_currently_on_board';

class JobsOnBoardList extends StatefulWidget {
  //TODO: try to figure out a way to use currentJObsOnBoard list in a static
  // way so that we can delete and add to the list and not have it repeat
  // objects on the list. Attempted a way to try  to call it from the main
  // once. But that was not really working.

  @override
  _JobsOnBoardList createState() => _JobsOnBoardList();
}

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class _JobsOnBoardList extends State<JobsOnBoardList> {
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
    return MessageStream();
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<String> getDescriptionOfJob(int jobID, DocumentSnapshot message) async {
      final myCollection = _firestore.collection('registered_patients');
      final something = await myCollection.document('JobID').get();
      print('something = $something');
    }

    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      //stream: _firestore.collection('messages').snapshots(), //version from AppBrewery
      stream: _firestore.collection(jobs_currently_on_board_collection).orderBy('TimeCreated').snapshots(),
      builder: (context, snapshot) {
        //this is flutters snapshot, not google, but it does contain it is not the same as method's snapshot
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['JobID'];
          final messageTimeStamp = message.data['TimeCreated'];
          final description = getDescriptionOfJob(messageText, message);
          //print("=====Messages======");
          //print(messageText);
          //print(messageTimeStamp);
          final messageBubble = MessageBubble(
            timeStamp: messageTimeStamp,
            JobID: messageText,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({@required this.timeStamp, @required this.JobID, @required this.desc});

  final String timeStamp;
  final int JobID;
  final String desc;

  Future<bool> assignTopMostTransporter(int JobID) async {
    String transporterEmail = await ActiveTransportersOnBoard.getTopMostTransporter();
    print(transporterEmail);
    if (transporterEmail == null || transporterEmail == '') {

      print('here 1');
      return false;
    } else {
      bool changeMade = false;
      final messages = await _firestore.collection(active_transporter_collection).getDocuments();
      DocumentSnapshot transporterToModify;
      for (var message in messages.documents) {
        if (message.data[active_transporter_employee_email_field].toString() == transporterEmail) {
          transporterToModify = message;
          break;
        }
      }
      print(transporterToModify.data[active_transporter_employee_email_field]);
      //TODO remove the job from the board
      if (transporterToModify == null) {
        print('something went wrong with trying to modify the transporter $transporterEmail');
        return changeMade;
      }

        print('$transporterEmail has been assigned a job');
        Map<String, String> temp = {active_transporter_assigned_job_field: JobID.toString()};
        Map<String, int> temp2 = {'status':1};
        transporterToModify.reference.updateData(temp);
        transporterToModify.reference.updateData(temp2);
        changeMade = true;


      return changeMade;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        print('$JobID was pressed');
        Alert(
                type: AlertType.success,
                context: context,
                title: 'JobID: $JobID',
                //content: Expanded(child: ActiveTransportersOnBoard()),
                buttons: [
                  DialogButton(
                    child: Text('Assign'),
                    onPressed: () {
                      assignTopMostTransporter(JobID);
                      print('Assign and remove the job from the top most transporter. if they dont have a job');
                    },
                  ),
                  DialogButton(
                    child: Text('Delete'),
                    onPressed: () {
                      print('Remove the job from the active job board');
                    },
                  )
                ],
                closeFunction: () {})
            .show();
      },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Material(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(15),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Insert: $timeStamp',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: Text(
                    'JobID: $JobID',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ),
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
