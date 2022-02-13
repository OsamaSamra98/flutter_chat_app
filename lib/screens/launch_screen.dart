import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase/fb_auth_controller.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      streamSubscription = FbAuthController().checkUserStatus(
        authListener: ({required bool loggedIn}) {
          String routeName = loggedIn ? '/chats_screen' : '/login_screen';
          Navigator.pushReplacementNamed(context, routeName);
        },
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'API APP',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
