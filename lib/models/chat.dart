import 'package:flutter_chat_app/firebase/fb_auth_controller.dart';

class Chat {
  late String id;
  late String firstUserName;
  late String firstUserId;
  late String secondUserName;
  late String secondUserId;

  late String date;

  Chat();

  Chat.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? '';
    firstUserId = map['firstUserId'];
    firstUserName = map['firstUserName'];
    secondUserId = map['secondUserId'];
    secondUserName = map['secondUserName'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['firstUserId'] = firstUserId;
    map['firstUserName'] = firstUserName;
    map['secondUserId'] = secondUserId;
    map['secondUserName'] = secondUserName;
    map['date'] = DateTime.now();
    return map;
  }

  String getName() {
    return FbAuthController().currentUserId == firstUserId
        ? secondUserName
        : firstUserName;
  }

  String getPeerId() {
    return FbAuthController().currentUserId == firstUserId
        ? secondUserId
        : firstUserId;
  }
}
