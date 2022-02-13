import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase/fb_auth_controller.dart';
import 'package:flutter_chat_app/firebase/fb_chats_controller.dart';
import 'package:flutter_chat_app/firebase/fb_notifications.dart';
import 'package:flutter_chat_app/firebase/fb_user_controller.dart';
import 'package:flutter_chat_app/models/chat.dart';
import 'package:flutter_chat_app/screens/chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> with FbNotifications {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestNotificationPermissions();
    initializeForegroundNotificationForAndroid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            onPressed: () async {
              var currentUserId = FbAuthController().currentUserId;
              bool status = await FbAuthController().signOut();
              if (status) {
                await FbUserController().updateFcmToken(
                    currentUserId: currentUserId, removeToken: true);
                Navigator.pushReplacementNamed(context, '/login_screen');
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Chat>>(
          stream: FbChatsController().read(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              List<QueryDocumentSnapshot<Chat>> chats = snapshot.data!.docs;
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.chat),
                    title: Text(chats[index].data().getName()),
                    onTap: () => openChat(chats[index].data()),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/users_screen'),
        child: const Icon(Icons.chat_bubble),
      ),
    );
  }

  Future<void> openChat(Chat chat) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chat: chat,
        ),
      ),
    );
  }
}
