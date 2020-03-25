import 'dart:math';
import 'package:my_web_app/components/Job_Identifier.dart';
import 'package:my_web_app/testing_components/PatientCreation.dart';

import 'RoomCreation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
const String all_jobs_created_collection = 'all_jobs_ever_made';
const String jobs_currently_on_board_collection = 'jobs_currently_on_board';

class JobCreation {
  static List<String> comments = ['Has wheelchair', 'Vistor already waiting', 'Needs Cart', 'Bring two transports', 'Please be mindful, patient mad', 'Patient has something', 'Just an other comment'];

  static Future<JobCreation> createARandomJob(FirebaseUser loggedInUser) async {
    print('===CreateARandomJob====');
    /*
    * Try to get a real patient from our database.
    *
    * */
    int value = await PatientCreation.getAPatientFromDatabase();
    int JobID = await JobIdentifier.getLatestJobIdentifier();
    DocumentSnapshot somePatient;
    _firestore.collection(patient_path).where(MRN_field, isEqualTo: value).snapshots().listen((data) {
      for (var message in data.documents) {
        if (message.data[MRN_field] == value) {
          somePatient = message;
          break;
        }
      }
      print(somePatient.data);
      String fName = somePatient.data[FirstName_field];
      String lName = somePatient.data[LastName_field];
      String roomFrom = somePatient.data[PatientCreation.getRoom_Field()];
      int MRN = somePatient.data[MRN_field];
      String roomTo = CreateRooms.getARoom();
      while (roomFrom == roomTo) {
        roomTo = CreateRooms.getARoom();
      }
      String createdBy = loggedInUser.email.toString();
      String comment = makeARandomComment();
      /*
      * make sure to add the functionality to check if the room is available
      * make sure to get a jobID
      * then add the job on to the all jobs ever created.
      * */

      createJob(roomFrom, roomTo, createdBy, comment, MRN, JobID);
    });

    return null;
  }

  static Future<bool> createJob(String rF, String rT, String cB, String cmmt, int mrn, int JobID) async {
    bool isRoomAvailable = false;
    isRoomAvailable = await CreateRooms.isRoomAvailable(rT);
    addJobToAllJobsCreatedDataBase(null, cmmt, cB, JobID, mrn, rF, rT, null, null, null, DateTime.now().toIso8601String(), null);
    if (isRoomAvailable) {
      addJobToBoard(null, cmmt, cB, JobID, mrn, rF, rT, null, null, null, DateTime.now().toIso8601String(), null);
    } else {
      print("cannot add to the job board because the room is not available");
    }
    return isRoomAvailable;
  }

  static void addJobToBoard(String AmountDelayed, String Comments, String CreatedBy, int JobID, int MRN, String RoomFrom, String RoomTo, String TimeAcknowledged, String TimeAssigned, String TimeCompleted, String TimeCreated, String TimeInProgress) async {
    await _firestore.collection(jobs_currently_on_board_collection).add({
      'AmountDelayed': AmountDelayed,
      'Comments': Comments,
      'CreatedBy': CreatedBy,
      'JobID': JobID,
      'MRN': MRN,
      'RoomFrom': RoomFrom,
      'RoomTo': RoomTo,
      'TimeAcknowledged': TimeAcknowledged,
      'TimeAssigned': TimeAssigned,
      'TimeCompleted': TimeCompleted,
      'TimeCreated': TimeCreated,
      'TimeInProgress': TimeInProgress,
    });
  }

  static void addJobToAllJobsCreatedDataBase(String AmountDelayed, String Comments, String CreatedBy, int JobID, int MRN, String RoomFrom, String RoomTo, String TimeAcknowledged, String TimeAssigned, String TimeCompleted, String TimeCreated, String TimeInProgress) async {
    await _firestore.collection(all_jobs_created_collection).add({'AmountDelayed': AmountDelayed, 'Comments': Comments, 'CreatedBy': CreatedBy, 'JobID': JobID, 'MRN': MRN, 'RoomFrom': RoomFrom, 'RoomTo': RoomTo, 'TimeAcknowledged': TimeAcknowledged, 'TimeAssigned': TimeAssigned, 'TimeCompleted': TimeCompleted, 'TimeCreated': TimeCreated, 'TimeInProgress': TimeInProgress});
  }

  static String makeARandomComment() {
    String comment = "";
    Random randy = new Random();
    final int size = comments.length;
    int howManyComments = randy.nextInt(size);
    for (int i = 0; i < howManyComments; i++) {
      comment += comments[i];
      if (i < howManyComments - 1) {
        comment += ", ";
      }
    }
    return comment;
  }
}
