import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String active_transporter_collection = "active_transporters";
const String active_transporter_assigned_job_field = "assigned_job";
const String active_transporter_employee_email_field = "employee_email";
//TODO: const String active_transporter_last_name =" last_name" ; // this has not been added since
//I have not done the proper log in stuff to associate a person with their last name

class ActiveTransportersOnBoard extends StatefulWidget {
  //TODO: try to figure out a way to use currentJObsOnBoard list in a static
  // way so that we can delete and add to the list and not have it repeat
  // objects on the list. Attempted a way to try  to call it from the main
  // once. But that was not really working.

  @override
  _ActiveTransportersOnBoard createState() => _ActiveTransportersOnBoard();
  static Future<String> getTopMostTransporter() async
  {
    final messages = await _firestore.collection(active_transporter_collection).getDocuments();
    DocumentSnapshot transporters_to_consider;
    for (var message in messages.documents) {
      String theMessage = message.data[active_transporter_assigned_job_field].toString();
      if (theMessage != null || theMessage !='') {
        transporters_to_consider = message;
        break;
      }
    }
    if(transporters_to_consider == null) {

      return null;

    }
    return transporters_to_consider.data[active_transporter_employee_email_field];
  }
}

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class _ActiveTransportersOnBoard extends State<ActiveTransportersOnBoard> {
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
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      //stream: _firestore.collection('messages').snapshots(), //version from AppBrewery
      stream: _firestore.collection(active_transporter_collection).orderBy(active_transporter_employee_email_field).snapshots(),
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
          String tempMessage = message.data[active_transporter_assigned_job_field].toString();
          if (tempMessage == null || tempMessage.toString().length == 0 || tempMessage == "0") {
            tempMessage = "No current job";
          }
          final messageText = tempMessage;
          final messageTimeStamp = message.data[active_transporter_employee_email_field];
          final messageBubble = MessageBubble(
            timeStamp: messageTimeStamp,
            text: messageText,
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
  MessageBubble({@required this.timeStamp, @required this.text});

  final String timeStamp;
  final String text;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
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
                  'User: $timeStamp',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: Text(
                  '$text',
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
