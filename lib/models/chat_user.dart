class ChatUser {
  late String id;
  late String name;
  late String email;
  late String? fcmToken;

  ChatUser.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    email = map['email'];
    fcmToken = map['fcm_token'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String,dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['fcm_token'] = fcmToken;
    return map;
  }
}
