import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

typedef UploadImageCallback = void Function({required bool status, Reference? reference});
class FbStorageController {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadImage({required File file, required String chatId, required UploadImageCallback callback}) async {
     _firebaseStorage
        .ref('$chatId/images/image_${DateTime.now().millisecondsSinceEpoch}')
        .putFile(file).snapshotEvents.listen((event) {
          if(event.state == TaskState.success){
            callback(status: true, reference: event.ref);
          }else if(event.state == TaskState.error){
            callback(status: false);
          }
     });
  }

  Future<bool> delete({required String reference}) async {
    return await _firebaseStorage
        .ref(reference)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }
}
