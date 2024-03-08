import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplychaintracking/Models/Account.dart';
import 'package:supplychaintracking/Models/Driver.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/Network/BaseURL.dart';
import 'package:supplychaintracking/Views/LoginView/login.dart';

class AccountViewModel extends ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool rememberMe = false;

  Future<bool> login() async {
    isLoading = true;
    notifyListeners();

    final String apiUrl = BaseURL.baseURL+'/account/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        StaticAccount.staticAccount=Account.fromJson(json.decode(response.body));

        print(StaticAccount.staticAccount.name);
        print(StaticAccount.staticAccount.token);

        print('Login successful');
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        print('Login failed. Status code: ${response.statusCode}');
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      print('Error during login: $error');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  bool _isLoggedIn = true;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> logout() async {
    if (rememberMe == false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('username');
      prefs.remove('password');
      prefs.setBool("rememberMe", false);
    }

    _isLoggedIn = false;
    notifyListeners();
  }


  Future<List<Driver>> getDriverByCarrier() async {
    final String apiUrl = BaseURL.baseURL + '/account/driversByCarrier/${StaticAccount.staticAccount.userNumber}';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${StaticAccount.staticAccount.token}',
        },
      );

      if (response.statusCode == 200) {

        List<dynamic> jsonList = jsonDecode(response.body);
        List<Driver> drivers = jsonList.map((json) => Driver.fromJson(json)).toList();



        //print(response.body);
        /*for (Driver driver in drivers) {
          print(driver.name);
        }*/

        print('GET /driversByCarrier  response.status:${response.statusCode}');

        return drivers;
      } else {
        print(apiUrl);
        print('GET /driversByCarrier  response.status: ${response.statusCode}');
        throw Exception('Failed to load drivers');
      }
    } catch (error) {
      print('Error during getDriverByCarrier: $error');
      throw Exception('Failed to load drivers');
    }
  }
    }


