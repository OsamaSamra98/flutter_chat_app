import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_chat_app/firebase/fb_auth_controller.dart';
import 'package:flutter_chat_app/models/chat_user.dart';

class FbUserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> create(User user, String name) async {
    var fcmToken = await FirebaseMessaging.instance.getToken();
    return _firestore
        .collection('Users')
        .doc(user.uid)
        .set({
          'id': user.uid,
          'name': name,
          'email': user.email,
          'fcm_token': fcmToken,
        })
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> updateFcmToken({String? currentUserId, bool removeToken = false}) async {
    var fcmToken = await FirebaseMessaging.instance.getToken();
    return await _firestore
        .collection('Users')
        .doc(currentUserId ?? FbAuthController().currentUserId)
        .update({'fcm_token': !removeToken ? fcmToken : null})
        .then((value) => true)
        .catchError((error) {
          return false;
    });
  }

  Stream<QuerySnapshot<ChatUser>> read() async* {
    yield* _firestore
        .collection('Users')
        .where('id', isNotEqualTo: FbAuthController().currentUserId)
        .withConverter<ChatUser>(
            fromFirestore: (snapshot, options) => ChatUser.fromMap(snapshot.data()!),
            toFirestore: (chatUser, options) => chatUser.toMap())
        .snapshots();
  }

  Future<ChatUser> getUser({required String id}) async {
    QuerySnapshot<ChatUser> chatUserSnapshot = await _firestore
        .collection('Users')
        .where('id', isEqualTo: id)
        .withConverter<ChatUser>(
          fromFirestore: (snapshot, options) => ChatUser.fromMap(snapshot.data()!),
          toFirestore: (ChatUser value, options) => value.toMap(),
        )
        .get();
    return chatUserSnapshot.docs.first.data();
  }
}
