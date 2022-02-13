import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase/fb_auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _nameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameTextController.dispose();
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
          'REGISTER',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const Text(
            'Create new account...',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const Text(
            'Enter new account info',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.name,
            controller: _nameTextController,
            decoration: const InputDecoration(
              hintText: 'Name',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailTextController,
            decoration: const InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 10),
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
            onPressed: () async => await performRegister(),
            child: const Text('REGSITER'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> performRegister() async {
    if (checkData()) {
      await register();
    }
  }

  bool checkData() {
    if (_nameTextController.text.isNotEmpty &&
        _emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Enter required data!'),
    ));
    return false;
  }

  Future<void> register() async {
    bool status = await FbAuthController().createAccount(
      context,
      name: _nameTextController.text,
      email: _emailTextController.text,
      password: _passwordTextController.text,
    );
    if (status) Navigator.pop(context);
  }
}
