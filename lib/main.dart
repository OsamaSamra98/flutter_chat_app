import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase/fb_notifications.dart';
import 'package:flutter_chat_app/screens/auth/forget_password_screen.dart';
import 'package:flutter_chat_app/screens/auth/login_screen.dart';
import 'package:flutter_chat_app/screens/auth/register_screen.dart';
import 'package:flutter_chat_app/screens/chats_screen.dart';
import 'package:flutter_chat_app/screens/launch_screen.dart';
import 'package:flutter_chat_app/screens/users_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  FbNotifications.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/launch_screen',
      routes: {
        '/launch_screen': (context) => const LaunchScreen(),
        '/login_screen': (context) => const LoginScreen(),
        '/register_screen': (context) => const RegisterScreen(),
        '/forget_password_screen': (context) => const ForgetPasswordScreen(),
        // '/reset_password_screen': (context) => const ResetPasswordScreen(),
        '/chats_screen': (context) => const ChatsScreen(),
        '/users_screen': (context) => const UsersScreen(),
        // '/images_screen': (context) => const ImagesScreen(),
        // '/upload_image_screen': (context) => const UploadImageScreen(),
      },
    );
  }
}
