import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
List<String> _allHospitalRooms = CreateRooms._allRooms();
const String hospital_room_path = 'hospital_rooms';
const String Room_field = 'Room';
const String isAvailable_field = 'isAvailable';
//class JobIdentifier {
//  static Future<int> getLatestJobIdentifier() async {
//    int number;
//    final messages = await _firestore.collection('unique_IDs').getDocuments();
//    DocumentSnapshot lastMessage;
//    for (var message in messages.documents) {
//      number = message.data['JobID'];
//      lastMessage = message;
//    }
//    Map<String, int>temp = {"JobID" :number+1};
//    lastMessage.reference.updateData(temp);
//    return number;
//  }
//}

class CreateRooms {
  static List<String> _allRooms() {
    List<String> myList = [];
    for (int i = 1; i <= 4; i++) {
      for (int j = 0; j < 2; j++) {
        for (int k = 1; k <= 24; k++) {
          String temp = i.toString();
          temp += i == 1 ? ' West ' : ' East ';
          temp += k.toString();
          myList.add(temp);
        }
      }
    }
    return myList;
  }

  //TODO: See what to do with method, may be possible to just erase this comment, but I want it here just to remember that the method is here.

  static void CreationOfRooms() async {
    for (int i = 1; i <= 4; i++) {
      for (int j = 0; j < 2; j++) {
        for (int k = 1; k <= 24; k++) {
          String temp = i.toString();
          temp += i == 1 ? ' West ' : ' East ';
          temp += k.toString();
        _firestore.collection(hospital_room_path).add({'Room':temp, 'isAvailable':true});
        }
      }
    }
  }
  static String getARoom() {
    Random randy = Random();
    int position = randy.nextInt(_allHospitalRooms.length);

    return _allHospitalRooms[position];
  }

  static Future<bool> occupyRoom(String toCheck) async {
    bool changeMade = false;
    final messages = await _firestore.collection(hospital_room_path).getDocuments();
    DocumentSnapshot roomToModify;
    for (var message in messages.documents) {
      if (message.data[Room_field] == toCheck) {
        roomToModify = message;
        break;
      }
    }
    if (roomToModify == null) {
      print('something went wrong, couldnt modify $toCheck');
      return changeMade;
    }
    if(roomToModify.data[isAvailable_field] ==false)
      {
        print("Something is wrong with the logic, the room is not available");
      }
    else
      {
        print('$toCheck has been occupied');
        Map<String, bool> temp = {isAvailable_field:false};
        roomToModify.reference.updateData(temp);
        changeMade = true;
      }
    return changeMade;
  }

  static Future<bool> isRoomAvailable(String toCheck) async {
    bool isAvail = false;
    final messages = await _firestore.collection(hospital_room_path).getDocuments();
    DocumentSnapshot roomToConsider;
    for (var message in messages.documents) {
      if (message.data[Room_field] == toCheck) {
        roomToConsider = message;
        break;
      }
    }
    if (roomToConsider != null) {
      if (roomToConsider.data[isAvailable_field] == true) {
        print('$toCheck is good');
        isAvail = true;
      } else {
        print('$toCheck is not good');
      }
    } else {
      print('$toCheck does not exist homie');
    }

    return isAvail;
  }
}
