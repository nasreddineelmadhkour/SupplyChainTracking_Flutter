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

    print(usernameController.text);
    print(passwordController.text);

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


  Future<bool> SendCodeReset() async{

    final String apiUrl = BaseURL.baseURL+'/account/resetpassword/SendCodeReset/${StaticAccount.staticAccount.phoneNumber}';

    try
        {
          final response = await http.get(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
            },
          );

          if (response.statusCode == 200) {

            final responseData = json.decode(response.body);
            bool apiResult = responseData;

            if(apiResult == true){
              print("hello");
              return true;
            }
            else {
             print("hello2");
              return false;
            }


          }
          else
          {
            print(apiUrl);
            print('GET /driversByCarrier  response.status: ${response.statusCode}');
            throw Exception('Failed to load drivers');
          }




        }
        catch(error){
          print('Error send code reset : $error');
        }

        print("lastreturn");
        return false;

  }


  Future<bool> VerifyCode() async{

    final String apiUrl = BaseURL.baseURL+'/account/resetpassword/verifyCode/${StaticAccount.staticAccount.codeTel}/${StaticAccount.staticAccount.phoneNumber}';

    try
    {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        final responseData = json.decode(response.body);
        bool apiResult = responseData;

        if(apiResult == true){
          return true;
        }
        else {
          return false;
        }
      }
      else
      {
        print(apiUrl);
        print('GET /driversByCarrier  response.status: ${response.statusCode}');
        throw Exception('Failed to load drivers');
      }

    }
    catch(error){
      print('Error send code reset : $error');
    }
    print("lastreturn");
    return false;

  }

  Future<bool> ChangePasswordAfterVerification() async{

    final String apiUrl = BaseURL.baseURL+'/account/resetpassword/ChangePasswordAfterVerification/${StaticAccount.staticAccount.password}/${StaticAccount.staticAccount.phoneNumber}';

    try
    {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        final responseData = json.decode(response.body);
        bool apiResult = responseData;

        if(apiResult == true){
          return true;
        }
        else {
          return false;
        }
      }
      else
      {
        print(apiUrl);
        print('GET /driversByCarrier  response.status: ${response.statusCode}');
        throw Exception('Failed to load drivers');
      }

    }
    catch(error){
      print('Error send code reset : $error');
    }
    print("lastreturn");
    return false;

  }

}


