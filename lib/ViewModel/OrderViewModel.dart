


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/Network/BaseURL.dart';

class OrderViewModel extends ChangeNotifier {

  Future<bool> addOrder() async {
    notifyListeners();
    final String apiUrl = BaseURL.baseURL+'/orders/addOrder';
    try {

      String token = StaticAccount.staticAccount.token.toString();
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
         // 'username': usernameController.text,
         // 'password': passwordController.text,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        //StaticAccount.staticAccount=Account.fromJson(json.decode(response.body));
        print('addOrder successful');
        notifyListeners();
        return true;
      } else {
        print('addOrder failed. Status code: ${response.statusCode}');
        notifyListeners();
        return false;
      }
    } catch (error) {
      print('Error during addOrder: $error');
      notifyListeners();
      return false;
    }
  }





}
