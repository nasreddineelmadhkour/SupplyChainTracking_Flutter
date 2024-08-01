

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/Network/BaseURL.dart';
import 'package:http/http.dart' as http;

class ClaimViewModel extends ChangeNotifier {

  Future<bool> addClaim(String description, int idOrder) async {

    final String apiUrl = BaseURL.baseURL+'/reclamation/addReclamation/${idOrder}';
    try {
      String token = StaticAccount.staticAccount.token.toString();
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'description': description
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        //StaticAccount.staticAccount=Account.fromJson(json.decode(response.body));
        print('200 /CLAIMS CREATED');
        notifyListeners();
        return true;
      } else {
        print('CLAIMS CREATED failed. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error during CLAIMS CREATED: $error');
      return false;
    }
  }

  Future<List<dynamic>> getClaimsByCarrier() async {
    final String apiUrl = '${BaseURL.baseURL}/reclamation/getClaimsByCarrier/${StaticAccount.staticAccount.userNumber}';

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
        print('GET /getClaimsByCarrier response.status: ${response.statusCode}');

        return jsonList;
      } else {
        print(apiUrl);
        print('GET /getClaimsByCarrier response.status: ${response.statusCode}');
        throw Exception('Failed to load claims');
      }
    } catch (error) {
      print('Error during getClaimsByCarrier: $error');
      throw Exception('Failed to load getClaimsByCarrier');
    }
  }

  Future<List<dynamic>> getClaimsByDriver() async {
    final String apiUrl = '${BaseURL.baseURL}/reclamation/getClaimsByDriver/${StaticAccount.staticAccount.userNumber}';

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
        print('GET /getClaimsByDriver response.status: ${response.statusCode}');

        return jsonList;
      } else {
        print(apiUrl);
        print('GET /getClaimsByDriver response.status: ${response.statusCode}');
        throw Exception('Failed to load claims');
      }
    } catch (error) {
      print('Error during getClaimsByDriver: $error');
      throw Exception('Failed to load getClaimsByDriver');
    }
  }

  Future<bool> resolvedClaim(int idClaim) async {

    final String apiUrl = BaseURL.baseURL+'/reclamation/resolvedClaim/${idClaim}';
    try {
      String token = StaticAccount.staticAccount.token.toString();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        //StaticAccount.staticAccount=Account.fromJson(json.decode(response.body));
        print('200 /CLAIMS RESOLVED');
        notifyListeners();
        return true;
      } else {
        print('CLAIMS RESOLVED failed. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error during CLAIMS RESOLVED: $error');
      return false;
    }
  }
}