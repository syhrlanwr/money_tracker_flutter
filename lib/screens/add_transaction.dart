// create page for adding transaction

import 'package:flutter/material.dart';
import 'package:money_track/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormState>();

  final _amount = TextEditingController();
  final _description = TextEditingController();

  bool _isExpense = false;

  void _submit() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              child: CircularProgressIndicator(),
              height: 20.0,
              width: 20.0,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text('Adding transaction...'),
          ],
        ),
      ),
    );
    SharedPreferences sh = await SharedPreferences.getInstance();
    var token = sh.getString('token');
    if (_formKey.currentState!.validate()) {
      var amount = _amount.text;
      var description = _description.text;
      var url = Uri.https(Constant.baseUrl, Constant.incomeEndpoint);

      if (_isExpense) {
        url = Uri.https(Constant.baseUrl, Constant.outcomeEndpoint);
      }

      var response = await http.post(url, body: {
        'amount': amount,
        'description': description,
      }, headers: {
        'Authorization': 'Bearer $token',
      });

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Transaction added'),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add transaction'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  const Text('Expense'),
                  Switch(
                    value: _isExpense,
                    onChanged: (value) {
                      setState(() {
                        _isExpense = value;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submit();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
