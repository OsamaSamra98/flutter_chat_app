import 'package:flutter_chat_app/firebase/fb_auth_controller.dart';

class Message {

 late String id;
 late String chatId;
 late String senderId;
 late String content;
 late String contentType;
 late String sendDate;
 late bool sender;

 Message();

 Message.fromMap(Map<String, dynamic> map) {
   id = map['id'] ?? '';
   chatId = map['chatId'];
   senderId = map['senderId'];
   content = map['content'];
   contentType = map['contentType'];
   sendDate = map['sendDate'];
   sender = FbAuthController().currentUserId == senderId;
 }

 Map<String, dynamic> toMap() {
   Map<String, dynamic> map = <String,dynamic>{};
   map['chatId'] = chatId;
   map['senderId'] = senderId;
   map['content'] = content;
   map['contentType'] = contentType;
   map['sendDate'] = sendDate;
   return map;
 }
}