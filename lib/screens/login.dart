import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:money_track/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();

  // void isLoggedIn() async {
  //   if (await storage.read(key: 'token') != null) {
  //     Navigator.pushNamed(context, '/home');
  //   }
  // }

  void isLoggedIn() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    if (sh.getString('token') != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();

    isLoggedIn();
  }

  void processLogin() async {
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
        Text('Logging in...'),
      ],
    ));

    ScaffoldMessenger.of(context).showSnackBar(progress);

    var url = Uri.https(Constant.baseUrl, Constant.loginEndpoint);

    var response = await http.post(url, body: {
      'email': email.text,
      'password': password.text,
    }, headers: {
      'Accept': 'application/json',
    });

    var map = jsonDecode(response.body);

    if (response.statusCode == 201) {
      var token = map['token'];
      SharedPreferences sh = await SharedPreferences.getInstance();
      sh.setString('token', token);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pushReplacementNamed(context, '/home');
    }

    final snackBar = SnackBar(
      content: Text(map['message']),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListView(
              shrinkWrap: true,
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
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: processLogin,
                  child: const Text('Login'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    SizedBox(
                      width: 10.0,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
