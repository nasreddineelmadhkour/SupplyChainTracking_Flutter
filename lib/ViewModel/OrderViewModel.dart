import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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
    final String apiUrl = '${BaseURL.baseURL}/orders/ordersByCarrier/${StaticAccount.staticAccount.userNumber}';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${StaticAccount.staticAccount.token}',
        },
      );

      if (response.statusCode == 200) {
        // Decode the response body as UTF-8
        List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        print('GET /ordersByCarrier response.status: ${response.statusCode}');

        return jsonList;
      } else {
        print(apiUrl);
        print('GET /ordersByCarrier response.status: ${response.statusCode}');
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      print('Error during getOrderByCarrier: $error');
      throw Exception('Failed to load orders');
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

        List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
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

        List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
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

        List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
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


  Future<bool> startingOrders(int idOrders)async{

    final String apiUrl = BaseURL.baseURL + '/orders/startingOrders/${idOrders}';

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${StaticAccount.staticAccount.token}',
        },
      );
      if (response.statusCode == 200) {
        print('POST /startingOrders  response.status:${response.statusCode}');

        return true;
      } else {
        print(apiUrl);
        print('POST /startingOrders  response.status: ${response.statusCode}');
        return false;
      }

    }
    catch(error){
      print("Error startingOrders Orders $error");
      throw Exception('Failed startingOrders Orders');

    }

  }

  Future<bool> completedOrders(int idOrders)async{

    final String apiUrl = BaseURL.baseURL + '/orders/completedOrders/${idOrders}';

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${StaticAccount.staticAccount.token}',
        },
      );
      if (response.statusCode == 200) {
        print('POST /startingOrders  response.status:${response.statusCode}');

        return true;
      } else {
        print(apiUrl);
        print('POST /startingOrders  response.status: ${response.statusCode}');
        return false;
      }

    }
    catch(error){
      print("Error startingOrders Orders $error");
      throw Exception('Failed startingOrders Orders');

    }

  }


  Future<bool> deleteOrder(int idOrder)async{

    final String apiUrl = BaseURL.baseURL + '/orders/deleteOrder/${idOrder}';

    try{

      print(StaticAccount.staticAccount.token);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${StaticAccount.staticAccount.token}',
        },
      );
      if (response.statusCode == 200) {
        print('DELETE /deleteOrder  response.status:${response.statusCode}');

        return true;
      } else {
        print(apiUrl);
        print('DELETE /deleteOrder  response.status: ${response.statusCode}');
        return false;
      }

    }
    catch(error){
      print("Error deleteOrder $error");
      throw Exception('Failed delete order');

    }

  }











  Future<bool> updateOrder(int idOrder,int isS , int isA) async {
    notifyListeners();
    final String apiUrl = BaseURL.baseURL+'/orders/updateOrders/${idOrder}/${StaticMethode.staticOrder.driverNumber}/${isS}/${isA}';
    try {

      String dateOrder = StaticMethode.staticOrder.dateOrders.toString();
      String updatedDateOrder = dateOrder.replaceFirst(" ", "T");
      print(updatedDateOrder);
      String token = StaticAccount.staticAccount.token.toString();
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'dateOrders': updatedDateOrder,
          'distance': StaticMethode.staticOrder.distance,
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
          'status': "DELAYED",


        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        //StaticAccount.staticAccount=Account.fromJson(json.decode(response.body));
        print('updateOrder successful');
        notifyListeners();
        return true;
      } else {
        print('updateOrder failed. Status code: ${response.statusCode}');
        notifyListeners();
        return false;
      }
    } catch (error) {
      print('Error during updateOrder: $error');
      notifyListeners();
      return false;
    }
  }






}
