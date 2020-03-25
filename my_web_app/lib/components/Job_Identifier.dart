import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

class JobIdentifier {
  static Future<int> getLatestJobIdentifier() async {
    int number;
    final messages = await _firestore.collection('unique_IDs').getDocuments();
    DocumentSnapshot lastMessage;
    for (var message in messages.documents) {
      number = message.data['JobID'];
      lastMessage = message;
    }
    Map<String, int>temp = {"JobID" :number+1};
    lastMessage.reference.updateData(temp);
    return number;
  }
}
