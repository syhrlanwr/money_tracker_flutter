import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:money_track/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  void processSignup() async {
    final progress = SnackBar(
        content: Row(
      children: const [
        SizedBox(
          child: CircularProgressIndicator(),
          height: 20.0,
          width: 20.0,
        ),
        SizedBox(
          width: 20.0,
        ),
        Text('Processing...'),
      ],
    ));

    ScaffoldMessenger.of(context).showSnackBar(progress);

    var url = Uri.http(Constant.baseUrl, Constant.registerEndpoint);
    var response = await http.post(url, body: {
      'name': name.text,
      'email': email.text,
      'password': password.text,
      'password_confirmation': confirmPassword.text,
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 201) {
      var map = jsonDecode(response.body);
      SharedPreferences sh = await SharedPreferences.getInstance();
      sh.setString('token', map['token']);
      Navigator.pushNamedAndRemoveUntil(
          context, '/add-balance', (route) => false);
    }

    var map = jsonDecode(response.body);

    final snackBar = SnackBar(
      content: Text(map['message']),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.account_balance_wallet,
                  size: 50.0,
                  color: Colors.green,
                ),
                Text(
                  'MoneyTracker',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            TextField(
              controller: name,
              decoration: const InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: email,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: confirmPassword,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: processSignup,
              child: const Text('Signup'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Already have an account?'),
              SizedBox(
                width: 10.0,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('Login'))
            ]),
          ],
        ),
      ),
    );
  }
}
