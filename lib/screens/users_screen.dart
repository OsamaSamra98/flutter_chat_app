import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase/fb_auth_controller.dart';
import 'package:flutter_chat_app/firebase/fb_chats_controller.dart';
import 'package:flutter_chat_app/firebase/fb_user_controller.dart';
import 'package:flutter_chat_app/models/chat.dart';
import 'package:flutter_chat_app/models/chat_user.dart';
import 'package:flutter_chat_app/screens/chat_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: StreamBuilder<QuerySnapshot<ChatUser>>(
          stream: FbUserController().read(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              List<QueryDocumentSnapshot<ChatUser>> users = snapshot.data!.docs;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.person),
                    title: Text(users[index].data().name),
                    subtitle: Text(users[index].data().email),
                    onTap: () async => await openOrCreateChat(users[index].data()),
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'No Data',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          }),
    );
  }

  Future<void> openOrCreateChat(ChatUser chatUser) async {
    Chat? chat = await FbChatsController().create(getChat(chatUser));
    if(chat != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chat: chat,
          ),
        ),
      );
    }
  }

  Chat getChat(ChatUser chatUser) {
    Chat chat = Chat();
    chat.firstUserName = FbAuthController().name;
    chat.firstUserId = FbAuthController().currentUserId;
    chat.secondUserName = chatUser.name;
    chat.secondUserId = chatUser.id;
    print(chat.toMap());
    return chat;
  }
}
