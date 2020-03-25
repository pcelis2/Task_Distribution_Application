import 'package:flutter/cupertino.dart';
import 'TransporterJob.dart';
import 'Room.dart';
import 'Patient.dart';
import 'TransporterJob.dart';

const int MAX_STRING_LENGTH_FOR_COMMENT = 60;

class TransportationDriver {
  //This is for testing purposes
  //TODO: Delete this after the testing is done and you have a more verstile code that grabs from a database or something
  static TransportationDriver getTestingCase() {
    Room from = Room(5, "PACU", 89);
    Room to = Room(8, "5", 10);
    Patient toDeliver = Patient("John", "Doe", "01/01/1899", from, 123456789,
        AssetImage('images/iconfinder_28-man_4715002.png'));
    TransporterJob assignedJob = TransporterJob(toDeliver, to,
        "Please bring two transporters. Patient has a lot of stuff. Please bring an orthowheel chair, and a rolling cart for their belongings");

    TransportationDriver driver =
        TransportationDriver("Pedro Celis", assignedJob);

    return driver;
  }

  bool _byPassCommentLimit = false;
  TransporterJob _currentJob;
  List<TransporterJob> _piggyBackedJobs;
  String _transporterName;

  TransportationDriver(String trnsptrName, TransporterJob job) {
    _transporterName = trnsptrName;
    _piggyBackedJobs = [];
    _piggyBackedJobs.add(job);
    _currentJob = job;
  }

  void assignJob(TransporterJob newJob) {
    //TODO: add, transition such that we check if the list is full
    //this maybe handled by what is displayed on the GUI, probably have a main function
    //that handles the main page
    //a function that returns a scaffold, that is, a assigned, acknowledged, inProgress, and completed scaffold
    _piggyBackedJobs.add(newJob);
  }

  void acknowledgeJob() {
    /*TODO: update, remove
    *update the current job to the first of the list
    * remove the first from the list
    */
    _currentJob.setAcknowledgeTime();
    print('acknowledgeJob');
  }

  void inProgress() {
    /*TODO: update
    *update the status of the transporter
    * */
    _currentJob.setInProgressTime();
  }

  void completeJob() {
    print('completeJob');
    if (_currentJob != null) {
      _currentJob.setTimeCompleted();
      //TODO: remember to add the completed jobs on to a database that holds all this information
      //TODO: then decide how we will handle the job list to be assigned to the currentJob
      _currentJob = null;
    } else {
      print("BRO WHATS WITH THE SAFEGUARDS");
    }
  }

  String getDelayTime() {
    return _currentJob.getDelayTime();
  }

  String getAssignedTIme() {
    return _currentJob.getAssignedTime();
  }

  String getAckowledgedTime() {
    return _currentJob.getAckowledgedTime();
  }

  String getInProgressTime() {
    return _currentJob.getInProgressTime();
  }

  String getTransporterName() {
    return _transporterName;
  }

  String getPatientName() {
    return _currentJob.getPatientFullName();
  }

  String getPatientDateOfBirth() {
    return _currentJob.getDateOfBirth();
  }

  int getPatientMRN() {
    return _currentJob.getMRN();
  }

  String getPatientLocation() {
    return _currentJob.getLocationOfPatient();
  }

  String getWhereToTakePatient() {
    return _currentJob.getWhereToTakePatient();
  }

  String toggleCommentSize() {
    _byPassCommentLimit = !_byPassCommentLimit;
    return getComment();
  }

  String getComment() {
    String str = _currentJob.getCommentsAboutJob();
    if (!_byPassCommentLimit) {
      if (str.length > MAX_STRING_LENGTH_FOR_COMMENT) {
        return str.substring(0, MAX_STRING_LENGTH_FOR_COMMENT) + "...+";
      } else {
        return str;
      }
    } else {
      return str;
    }
  }
  //acknowledge
  //inprogress
  //complete
  //cancel
  //break
  //end shift
/*



 */
}
