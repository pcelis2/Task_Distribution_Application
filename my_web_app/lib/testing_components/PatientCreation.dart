import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_web_app/components/MRN_Assignment.dart';
import 'package:my_web_app/testing_components/RoomCreation.dart';

final _firestore = Firestore.instance;
const String patient_path = 'registered_patients';
const String DateOfBirth_field = 'DateOfBirth';
const String FirstName_field = 'FirstName';
const String LastName_field = 'LastName';
const String MRN_field = 'MRN';
const String Room_field = 'Room';

class PatientCreation {
  static List<String> _firstNames = ['Adam', 'Bobby', 'Cindy', 'Diana', 'Eric', 'Franky', 'George', 'Harry', 'Imelda', 'Joana', 'Karina', 'Lima', 'Moxy', 'NoMoreNames'];
  static List<String> _lastNames = ['Oralando', 'Pa', 'Qu', 'Ramos', 'Solis', 'Typo', 'Unoriginal', 'Zeta', 'Yank', 'Xu'];

  static String getARandomFirstName() {
    final int fname_size = _firstNames.length;
    Random randy = Random();
    int selection = randy.nextInt(fname_size);
    String fName = _firstNames[selection];
    return fName;
  }

  static String getARandomLastName() {
    final int lname_size = _lastNames.length;
    Random randy = Random();
    int selection = randy.nextInt(lname_size);
    String lName = _lastNames[selection];
    return lName;
  }

  static String getARandomDateOfBirth() {
    Random randy = new Random();
    int month = randy.nextInt(12) + 1;
    String sMonth;
    if (month < 10) {
      sMonth = "0" + month.toString();
    } else {
      sMonth = month.toString();
    }
    int day = randy.nextInt(30) + 1;
    String sDay;
    if (day < 10) {
      sDay = "0" + day.toString();
    } else {
      sDay = day.toString();
    }
    int year = randy.nextInt(100) + 1919;
    return sMonth + '/' + sDay + '/' + year.toString();
  }
static String getRoom_Field()
{
  return Room_field;
}

  static Future<int> getAPatientFromDatabase() async {
    List<int> setOfMRNs = [];

    final messages = await _firestore.collection(patient_path).getDocuments();
    //DocumentSnapshot somePatientInDatabase;
    for (var message in messages.documents) {
      setOfMRNs.add(message.data[MRN_field]);
    }
    Random randy = new Random();
    int selection = randy.nextInt(setOfMRNs.length);
    return setOfMRNs[selection];
  }
//
  static void populateDataBaseWithPatients(int amount) async {
    for (int i = 0; i < amount; i++) {
      String dateOfBirth = getARandomDateOfBirth();
      String firstName = getARandomFirstName();
      String lastName = getARandomLastName();
      int MRN = await MRN_Assignment.getMRN_ID();
      String room = CreateRooms.getARoom();
      if (await CreateRooms.isRoomAvailable(room) == true) {
        if (await CreateRooms.occupyRoom(room) == true) {
          _firestore.collection(patient_path).add({DateOfBirth_field: dateOfBirth, FirstName_field: firstName, LastName_field: lastName, MRN_field: MRN, Room_field: room});
        }
      }
    }
  }
}
