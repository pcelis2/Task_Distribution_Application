import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Patient.dart';
import 'Room.dart';
import 'transporter_job.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class JobCard extends StatelessWidget {
  static int MRN = 1;
  static JobCard getTestCase() {
    Room testRoomFrom = new Room(roomID: '5 PACU 27');
    Patient testPatient =
        new Patient("John", "Doe", "01/01/1899", testRoomFrom, MRN++, null);
    Room testTo = new Room(roomID: '3 W 54');
    TransporterJob testJob = TransporterJob(testPatient, testTo, "This is it");
    JobCard jcTest = JobCard(
      colour: Colors.blue[100],
      onPress: null,
      job: testJob,
    );
    return jcTest;
  }

  final Color colour;
  Card cardChild;
  final Function onPress;
  final TransporterJob job;

  JobCard({@required this.colour, @required this.onPress, @required this.job}) {
    cardChild = Card(
      elevation: 5.0,
      child: ListTile(
        title: Text(job.getPatientFullName() + " | " + job.getMRN().toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Alert(
          context: context,
          title: "Transporter Job",
          desc: job.getPatientFullName() + " | " + job.getLocationOfPatient() +
              " to " + job.getWhereToTakePatient(),
          type: AlertType.warning,
          buttons: [
            DialogButton(
              child: Text('Assign Job'),
              onPressed: () {
                Navigator.pop(context);
                print("Assign Job");
              },
            ),
            DialogButton(
              child: Text('Cancel Job'),
              onPressed: () {
                Navigator.pop(context);
                print("Cancel Job");
              },
            ),
          ],
        ).show();
      },
      child: Container(
        child: cardChild,
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: colour,
        ),
      ),
    );
  }
}
