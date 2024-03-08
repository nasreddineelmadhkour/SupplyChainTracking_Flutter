import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class MapOpenStreatViewModel extends ChangeNotifier {

  TextEditingController address= TextEditingController();
  String add="";


  Future<bool> getFullAddress(String value) async {

    try {
      String url =
          'http://nominatim.openstreetmap.org/search?q=$value&format=json&addressdetails=1&countrycodes=TN&accept-language=fr';

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          Map<String, dynamic> firstElement = data.first;
          int spaceIndex1 = firstElement['address']['state_district'].toString().indexOf(' '),spaceIndex2=firstElement['address']['state'].toString().indexOf(' ');
           address.text = firstElement['address']['state_district'].toString().substring(spaceIndex1 + 1).trim()+","+firstElement['address']['state'].toString().substring(spaceIndex2 + 1).trim();


          return true;
        } else {
          notifyListeners();
          // Handle case when no results are found
          return false;
        }
      } else {
        print('Error fetching search results: ${response.statusCode}');
        // Handle other HTTP error codes if needed
      }
    } catch (e) {
      print('Error fetching search results: $e');
      // Handle other exceptions if needed
    }

    // Return null in case of errors
    return false;
  }




}
