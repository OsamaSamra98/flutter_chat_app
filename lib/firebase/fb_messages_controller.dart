import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/message.dart';

class FbMessagesController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> create({required Message message}) async {
    return _firestore
        .collection('Messages')
        .add(message.toMap())
        .then((DocumentReference value) {
      value.update({'id': value.id});
      return true;
    }).catchError((error) => false);
  }

  Stream<QuerySnapshot<Message>> read({required String chatId}) async* {
    yield* _firestore
        .collection('Messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('sendDate', descending: false)
        .withConverter<Message>(
            fromFirestore: (snapshot, options) =>
                Message.fromMap(snapshot.data()!),
            toFirestore: (Message message, options) => message.toMap())
        .snapshots();
  }
}
