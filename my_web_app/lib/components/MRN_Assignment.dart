import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

class MRN_Assignment {
  static Future<int> getMRN_ID() async {
    int number;
    final messages = await _firestore.collection('unique_IDs').getDocuments();
    DocumentSnapshot lastMessage;
    for (var message in messages.documents) {
      number = message.data['MRN'];
      lastMessage = message;
    }
    Map<String, int>temp = {"MRN" :number+1};
    lastMessage.reference.updateData(temp);
    return number;
  }
}
