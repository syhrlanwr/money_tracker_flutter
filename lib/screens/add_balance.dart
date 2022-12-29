import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:money_track/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddBalance extends StatefulWidget {
  const AddBalance({super.key});

  @override
  _AddBalanceState createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  final amount = TextEditingController();
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
                  controller: amount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Insert initial balance',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: submit,
                  child: const Text('Submit'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void submit() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Processing Data'),
      ),
    );
    int amount = int.parse(this.amount.text);
    SharedPreferences sh = await SharedPreferences.getInstance();
    String? token = sh.getString('token');

    var url = Uri.https(Constant.baseUrl, Constant.budgetEndpoint);
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'total_budget': amount,
        }));

    var map = jsonDecode(response.body);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      final snackBar = SnackBar(
        content: Text(map['message']),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
