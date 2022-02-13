import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase/fb_auth_controller.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController _emailTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'FORGET PASSWORD',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const Text(
            'Forget password ?',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const Text(
            'Enter email to receive reset code',
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => await performForgetPassword(),
            child: const Text('REQUEST'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> performForgetPassword() async {
    if (checkData()) {
      await forgetPassword();
    }
  }

  bool checkData() {
    if (_emailTextController.text.isNotEmpty) {
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Enter required data!'),
    ));
    return false;
  }

  Future<void> forgetPassword() async {
    bool status = await FbAuthController()
        .resetPassword(context, email: _emailTextController.text);
    if (status) Navigator.pop(context);
  }
}
