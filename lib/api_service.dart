import 'dart:convert';

import 'package:money_track/model/budget.dart';
import 'package:money_track/model/income.dart';
import 'package:money_track/model/outcome.dart';
import 'package:money_track/model/recent.dart';

import 'constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'model/user.dart';

class ApiService {
  static final url = Uri.https(Constant.baseUrl, Constant.userEndpoint);

  static Future<User> getUser() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    var token = sh.getString('token');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future<Budget> getBudget() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    var token = sh.getString('token');

    var url = Uri.https(Constant.baseUrl, Constant.budgetEndpoint);

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['budget'];
      return Budget.fromJson(data[0]);
    } else {
      throw Exception('Failed to load budget');
    }
  }

  static Future<Income> getIncome() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    var token = sh.getString('token');

    var url = Uri.https(Constant.baseUrl, Constant.incomeEndpoint);

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Income.fromJson(data);
    } else {
      throw Exception('Failed to load income');
    }
  }

  static Future<Outcome> getOutcome() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    var token = sh.getString('token');

    var url = Uri.https(Constant.baseUrl, Constant.outcomeEndpoint);

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Outcome.fromJson(data);
    } else {
      throw Exception('Failed to load outcome');
    }
  }

  static Future<List<Recent>> getRecent() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    var token = sh.getString('token');

    var url = Uri.https(Constant.baseUrl, Constant.recentEndpoint);

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['activity'];
      List<Recent> recent = [];
      for (var item in data) {
        recent.add(Recent.fromJson(item));
      }
      return recent;
    } else {
      throw Exception('Failed to load recent');
    }
  }

  // static Future<void> login(String email, String password) async {
  //   var url = Uri.https(Constant.baseUrl, Constant.loginEndpoint);

  //   var response = await http.post(url, body: {
  //     'email': email,
  //     'password': password,
  //   });

  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     SharedPreferences sh = await SharedPreferences.getInstance();
  //     sh.setString('token', data['token']);
  //   } else {
  //     throw Exception('Failed to login');
  //   }
  // }

  static Future<void> register(String name, String email, String password,
      String confirmPassword) async {
    var url = Uri.https(Constant.baseUrl, Constant.registerEndpoint);

    var response = await http.post(url, body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      SharedPreferences sh = await SharedPreferences.getInstance();
      sh.setString('token', data['token']);
    } else {
      throw Exception('Failed to register');
    }
  }

  static Future<void> logout() async {
    var url = Uri.https(Constant.baseUrl, Constant.logoutEndpoint);

    SharedPreferences sh = await SharedPreferences.getInstance();
    var token = sh.getString('token');

    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      sh.remove('token');
    } else {
      throw Exception('Failed to logout');
    }
  }
}
