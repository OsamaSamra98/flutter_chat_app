import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase/fb_auth_controller.dart';
import 'package:flutter_chat_app/firebase/fb_messages_controller.dart';
import 'package:flutter_chat_app/firebase/fb_storage_controller.dart';
import 'package:flutter_chat_app/firebase/fb_user_controller.dart';
import 'package:flutter_chat_app/models/chat.dart';
import 'package:flutter_chat_app/models/chat_user.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.chat}) : super(key: key);

  final Chat chat;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageTextController;
  late ScrollController _scrollController;

  late ChatUser peerUser;

  XFile? _pickedImage;
  late ImagePicker _imagePicker;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _scrollController = ScrollController();
    _messageTextController = TextEditingController();
    FbUserController().getUser(id: widget.chat.getPeerId()).then((value) {
      peerUser = value;
    });
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.chat.getName()),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Message>>(
                stream: FbMessagesController().read(chatId: widget.chat.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    List<QueryDocumentSnapshot<Message>> messages =
                        snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: messages.length,
                      controller: _scrollController,
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      // itemExtent: 50,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsetsDirectional.only(end: 30),
                          alignment: messages[index].data().sender
                              ? AlignmentDirectional.topStart
                              : AlignmentDirectional.topEnd,
                          child: Chip(
                            labelPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            label: Text(
                              messages[index].data().content,
                              softWrap: true,
                              maxLines: 10,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Send your first Message'),
                    );
                  }
                }),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  offset: Offset(0, -5), blurRadius: 6, color: Colors.black12)
            ]),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _messageTextController,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Enter Message',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async => await _performSendMessage(),
                  icon: const Icon(Icons.send),
                ),
                IconButton(
                  onPressed: () async => await pickImage(),
                  icon: const Icon(
                    Icons.image,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performSendMessage() async {
    if (checkData()) {
      var newMessage =
          getMessage(content: _messageTextController.text, contentType: 'Text');
      await _sendMessage(newMessage: newMessage);
    }
  }

  bool checkData() {
    return _messageTextController.text.isNotEmpty;
  }

  Future<void> _sendMessage({required Message newMessage}) async {
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    // var newMessage = getMessage(content: _messageTextController.text, contentType: 'Text');
    bool sent = await FbMessagesController().create(message: newMessage);
    if (sent) {
      if (peerUser.fcmToken != null) await sendPushMessage(message: newMessage);
      clear();
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    }
  }

  void clear() => _messageTextController.text = '';

  Message getMessage({required String content, required String contentType}) {
    Message message = Message();
    message.chatId = widget.chat.id;
    message.senderId = FbAuthController().currentUserId;
    message.content = content;
    message.contentType = contentType;
    message.sendDate = DateTime.now().toString();
    return message;
  }

  Future<void> sendPushMessage({required Message message}) async {
    try {
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAA1vxXkoA:APA91bEVCUkWUo9BSuOnwfymP8I8DiTe_aKSPURKerxQjh0BN5ELV6y6x8GaZPgMrc3dBXz1-k40kCBl5g6pGY7ZKopVpfGCPeVOo9kEuxO8G5fzR465kkJeLtyWTxLB4EweFr6o4aUr',
        },
        body: constructFCMPayload(message: message),
      );
      print('FCM request for device sent! :: Code: ${response.statusCode}');
    } catch (e) {
      print(e);
    }
  }

  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  String constructFCMPayload({required Message message}) {
    return jsonEncode({
      'registration_ids': [peerUser.fcmToken],
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': '1',
      },
      'notification': {
        'title':
            'New ${message.contentType} Message From: ${FirebaseAuth.instance.currentUser!.displayName ?? 'UserName'}',
        'body': message.contentType == 'Text' ? message.content : 'Show Image',
      },
    });
  }

  Future<void> pickImage() async {
    XFile? pickedImageFile = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    if (pickedImageFile != null) {
      _pickedImage = pickedImageFile;
      await uploadImage();
    }
  }

  Future<void> uploadImage() async {
    FbStorageController().uploadImage(
      file: File(_pickedImage!.path),
      chatId: widget.chat.id,
      callback: ({reference, required bool status}) async {
        if (status) {
          var url = await reference!.getDownloadURL();
          var newMessage = getMessage(content: url, contentType: 'Image');
          _sendMessage(newMessage: newMessage);
          print('Uploaded & Sent');
        } else {
          print('Failed');
        }
      },
    );
  }
}
