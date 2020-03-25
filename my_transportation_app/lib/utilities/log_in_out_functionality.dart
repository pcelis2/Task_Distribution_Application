import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

const String active_transporter_collection = "active_transporters";
const String employee_email_field = "employee_email";

class FunctionLogInOut {
  static void login(String email) async {
    final messages = await _firestore.collection(active_transporter_collection).getDocuments();
    DocumentSnapshot transporterToConsider;
    for (var message in messages.documents) {
      if (message.data[employee_email_field] == email) {
        transporterToConsider = message;
        break;
      }
    }
    if (transporterToConsider == null) {
      _firestore.collection(active_transporter_collection).add({employee_email_field: email});
    } else {
      print('$email was not added to the database of transporters active, since they are already in the system');
    }
  }

  static void logout(FirebaseAuth auth, String Employee_Email) async {
    final messages = await _firestore.collection(active_transporter_collection).getDocuments();
    DocumentSnapshot transporterToConsider;
    for (var message in messages.documents) {
      if (message.data[employee_email_field] == Employee_Email) {
        transporterToConsider = message;
        break;
      }
    }
    if (transporterToConsider != null) {
      transporterToConsider.reference.delete();
    } else {
      print("Transporter was not signed out");
    }
    auth.signOut();
  }
}
