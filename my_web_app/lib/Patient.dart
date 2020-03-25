import 'Room.dart';
import 'package:flutter/material.dart';

class Patient {
  String _firstName;
  String _lastName;
  String _dateOfBirth;
  Room _locationOfPatient;
  int _medicalRecordNumber;
  AssetImage _pictureOfPatient;
  Patient(
      String fn, String ln, String dob, Room rm, int mrn, AssetImage picture) {
    _firstName = fn;
    _lastName = ln;
    _dateOfBirth = dob;
    _locationOfPatient = rm;
    _medicalRecordNumber = mrn;
    _pictureOfPatient = picture;
  }
  AssetImage getPatientPicture() {
    return _pictureOfPatient;
  }

  String getFirstName() {
    return _firstName;
  }

  String getLastName() {
    return _lastName;
  }

  String getDateOfBirth() {
    return _dateOfBirth;
  }

  Room getLocationOfPatient() {
    return _locationOfPatient;
  }

  int getMRN() {
    return _medicalRecordNumber;
  }

  void movePatient(Room movedLocation) {
    _locationOfPatient = movedLocation;
  }
}
