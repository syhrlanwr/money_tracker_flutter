import 'package:flutter/material.dart';
import 'package:money_track/api_service.dart';
import 'package:money_track/screens/add_balance.dart';
import 'package:money_track/screens/add_transaction.dart';
import 'package:money_track/screens/signup.dart';
import 'package:money_track/screens/splash.dart';
import 'package:money_track/screens/login.dart';
import 'package:money_track/screens/home.dart';
import 'package:money_track/screens/transaction.dart';

// make login page

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MoneyTracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routes: {
          '/': (_) => const Splash(),
          '/login': (_) => const Login(),
          '/signup': (_) => const Signup(),
          '/home': (_) => const Home(),
          '/add-transaction': (_) => const AddTransaction(),
          '/transaction': (_) => const Transaction(),
          '/add-balance': (_) => const AddBalance(),
        },
        initialRoute: '/');
  }
}
