import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase/fb_auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'LOGIN',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const Text(
            'Welcome back',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const Text(
            'Enter email & password',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailTextController,
            decoration: const InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.text,
            obscureText: true,
            controller: _passwordTextController,
            decoration: const InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => await performLogin(),
            child: const Text('LOGIN'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account?'),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/register_screen'),
                child: const Text('Create Now!'),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 20,
              maxHeight: 20
            ),
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/forget_password_screen'),
              child: Text('Forget Password'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                // fixedSize: Size(20,20),
                // minimumSize: Size(20,20),
                // maximumSize: Size(30,20)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> performLogin() async {
    if (checkData()) {
      await login();
    }
  }

  bool checkData() {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Enter required data!'),
    ));
    return false;
  }

  Future<void> login() async {
    bool status = await FbAuthController().signIn(context, email: _emailTextController.text, password: _passwordTextController.text);
    if(status) Navigator.pushReplacementNamed(context, '/chats_screen');
  }
}
