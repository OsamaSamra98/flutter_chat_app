import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/firebase/fb_auth_controller.dart';
import 'package:flutter_chat_app/models/chat.dart';

class FbChatsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Chat?> create(Chat chat) async {
    Chat? createdChat = await _checkChatExistance(chat);
    if (createdChat == null) {
      return _firestore
          .collection('Chats')
          .add(chat.toMap())
          .then((value) async {
        chat.id = value.id;
        value.update({'id': value.id});
        return chat;
      }).catchError((error) => null);
    } else {
      return createdChat;
    }
  }

  Future<Chat?> _checkChatExistance(Chat chat) async {
    CollectionReference col = _firestore.collection("Chats");
    Query nameQuery = col
        .where('firstUserId', isEqualTo: FbAuthController().currentUserId)
        .where('secondUser', isEqualTo: chat.secondUserId);
    nameQuery
        .where('secondUserId', isEqualTo: FbAuthController().currentUserId)
        .where('firstUserId', isEqualTo: chat.secondUserId);

    QuerySnapshot chats = await col.get();
    if (chats.docs.isNotEmpty) {
      chat.id = chats.docs.first.id;
      return chat;
    }
  }

  Stream<QuerySnapshot<Chat>> read() async* {
    CollectionReference col = _firestore.collection("Chats");
    Query nameQuery =
        col.where('firstUserId', isEqualTo: FbAuthController().currentUserId);
    nameQuery.where('secondUserId',
        isEqualTo: FbAuthController().currentUserId);
    yield* col
        .withConverter<Chat>(
          fromFirestore: (snapshot, _) => Chat.fromMap(snapshot.data()!),
          toFirestore: (chat, _) => chat.toMap(),
        )
        .snapshots();
  }
}
