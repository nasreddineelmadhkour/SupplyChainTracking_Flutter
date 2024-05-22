


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:supplychaintracking/Models/Order.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/Models/StaticMethode.dart';
import 'package:supplychaintracking/Network/BaseURL.dart';

class OrderViewModel extends ChangeNotifier {

  Future<bool> addOrder() async {
    notifyListeners();
    final String apiUrl = BaseURL.baseURL+'/orders/addOrder/${StaticAccount.staticAccount.userNumber}/${StaticMethode.staticOrder.driverNumber}';
    try {

      String dateOrder = StaticMethode.staticOrder.dateOrders.toString();
      String updatedDateOrder = dateOrder.replaceFirst(" ", "T");
      print(updatedDateOrder);
      String token = StaticAccount.staticAccount.token.toString();
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
         'dateOrders': updatedDateOrder,
          'productOrders': StaticMethode.staticOrder.productOrders,
          'weightOrders': StaticMethode.staticOrder.weightOrders,
          'startingPoint': StaticMethode.staticOrder.startingPoint,
          'arrivalPoint': StaticMethode.staticOrder.arrivalPoint,
          'startingLong': StaticMethode.staticOrder.startingLong,
          'unitProduct': StaticMethode.staticOrder.unitProduct,
          'startingLat': StaticMethode.staticOrder.startingLat,
          'arrivalLong': StaticMethode.staticOrder.arrivalLong,
          'arrivalLat': StaticMethode.staticOrder.arrivalLat,
          'estimation': StaticMethode.staticOrder.estimation,
          'distance': StaticMethode.staticOrder.distance,
          'status': "PENDING",


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


  Future<List<dynamic>> getOrderByCarrier() async {
    final String apiUrl = BaseURL.baseURL + '/orders/ordersByCarrier/${StaticAccount.staticAccount.userNumber}';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${StaticAccount.staticAccount.token}',
        },
      );

      if (response.statusCode == 200) {

        List<dynamic> jsonList = jsonDecode(response.body);
        //List<Order> drivers = jsonList.map((json) => Order.fromJson(json)).toList();
        print('GET /driversByCarrier  response.status:${response.statusCode}');

        return jsonList;
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

  Future<List<dynamic>> getOrderByCarrierToday() async {
    final String apiUrl = BaseURL.baseURL + '/orders/orderTodayByCarrier/${StaticAccount.staticAccount.userNumber}';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${StaticAccount.staticAccount.token}',
        },
      );

      if (response.statusCode == 200) {

        List<dynamic> jsonList = jsonDecode(response.body);
        //List<Order> drivers = jsonList.map((json) => Order.fromJson(json)).toList();
        print('GET /driversByCarrier  response.status:${response.statusCode}');

        return jsonList;
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

  Future<List<dynamic>> getOrderByDriverToday() async {
    final String apiUrl = BaseURL.baseURL + '/orders/orderTodayByDriver/${StaticAccount.staticAccount.userNumber}';
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
        //List<Order> drivers = jsonList.map((json) => Order.fromJson(json)).toList();
        print('GET /driversByCarrier  response.status:${response.statusCode}');

        return jsonList;
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


  Future<List<dynamic>> getOrderByDriver() async {
    final String apiUrl = BaseURL.baseURL + '/orders/ordersByDriver/${StaticAccount.staticAccount.userNumber}';
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
        //List<Order> drivers = jsonList.map((json) => Order.fromJson(json)).toList();
        print('GET /driversByCarrier  response.status:${response.statusCode}');

        return jsonList;
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
