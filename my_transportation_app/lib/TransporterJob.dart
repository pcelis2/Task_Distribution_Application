import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Patient.dart';
import 'Room.dart';

class TransporterJob {
  Patient _patientToMove;
  Room _whereToTakePatient;
  String _commmentsAboutJob;
  String _timeAssigned;
  String _timeAcknowledged;
  String _timeInProgress;
  String _timeCompleted;
  String _delayTime;
  TransporterJob(Patient patient, Room to, String comment) {
    _patientToMove = patient;
    _whereToTakePatient = to;
    _commmentsAboutJob = "";
    addCommentary(comment);
    _timeAssigned = getTimeStamp();
    _timeAcknowledged = "N/A";
    _timeInProgress = "N/A";
    _timeCompleted = "N/A";
    _delayTime = "0";
  }
  String getTimeStamp() {
    int hour = TimeOfDay.now().hour;
    int minute = TimeOfDay.now().minute;
    String sHour = hour.toString();
    String sMinute = minute.toString();
    String time;
    if (hour < 10) {
      sHour = "0" + hour.toString();
    }
    if (minute < 10) {
      sMinute = "0" + minute.toString();
    }
    time = "[" + sHour + "" + sMinute + "]";
    return time;
  }

  void setAcknowledgeTime() {
    _timeAcknowledged = getTimeStamp();
  }

  void setInProgressTime() {
    _timeInProgress = getTimeStamp();
  }

  void setTimeCompleted() {
    _timeCompleted = getTimeStamp();
  }

  String getDelayTime() {
    return _delayTime;
  }

  String getCommentsAboutJob() {
    return _commmentsAboutJob;
  }

  String getAssignedTime() {
    return _timeAssigned;
  }

  String getAckowledgedTime() {
    return _timeAcknowledged;
  }

  String getInProgressTime() {
    return _timeInProgress;
  }

  String getTimeCompleted() {
    return _timeCompleted;
  }

  void addCommentary(String str) {
    _commmentsAboutJob += str + "\n";
  }

  String getPatientFullName() {
    return _patientToMove.getFirstName() + " " + _patientToMove.getLastName();
  }

  String getDateOfBirth() {
    return _patientToMove.getDateOfBirth();
  }

  int getMRN() {
    return _patientToMove.getMRN();
  }

  String getLocationOfPatient() {
    return _patientToMove.getLocationOfPatient().toString();
  }

  String getWhereToTakePatient() {
    return _whereToTakePatient.toString();
  }

  AssetImage getPatientImage() {
    return _patientToMove.getPatientPicture();
  }
}
