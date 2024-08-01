import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplychaintracking/Models/Account.dart';
import 'package:supplychaintracking/Models/ImageUpload.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/Network/BaseURL.dart';

class AccountViewModel extends ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool rememberMe = false;
  final String imageAvatar = 'iVBORw0KGgoAAAANSUhEUgAAAHcAAAB1CAIAAAD7k+nWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAFFmlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNi4wLWMwMDIgNzkuMTY0NDYwLCAyMDIwLzA1LzEyLTE2OjA0OjE3ICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgMjEuMiAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDIzLTA5LTI4VDIyOjI0OjE2KzAzOjMwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAyMy0wOS0yOFQyMjoyNzoyNCswMzozMCIgeG1wOk1ldGFkYXRhRGF0ZT0iMjAyMy0wOS0yOFQyMjoyNzoyNCswMzozMCIgZGM6Zm9ybWF0PSJpbWFnZS9wbmciIHBob3Rvc2hvcDpDb2xvck1vZGU9IjMiIHBob3Rvc2hvcDpJQ0NQcm9maWxlPSJzUkdCIElFQzYxOTY2LTIuMSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozM2I2ZTgwMy1mZmJiLTRh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';

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


  Future<int> updateProfile(ImageUpload image , String name , String phone,String password,String email

      ,bool isPhoto,bool isName,bool isPhone, bool isPassword , bool isEmail


      ) async{

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${BaseURL.baseURL}/account/updateProfile/${StaticAccount.staticAccount.userNumber}'),
      );
      if(image.image.path.toString()=="assets/images/icons/avatar.png"){
        List<int> bytes = base64.decode(imageAvatar);
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: 'avatar.png',
          contentType: MediaType('image', 'png'),
        ));

      }
      else{
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.image.path,
          ),
        );
      }


      request.fields.addAll({
        'name':name,
        'phoneNumber': phone,
        'email': email,
        'password': password,
        'isName': isName.toString(),
        'isEmail': isEmail.toString(),
        'isPhone': isPhone.toString(),
        'isPassword' : isPassword.toString(),
        'isPhoto' : isPhoto.toString()
      });

      request.headers['Authorization'] = 'Bearer ${StaticAccount.staticAccount.token}';

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
      StaticAccount.staticAccount.name=jsonResponse['name'].toString();
      StaticAccount.staticAccount.email=jsonResponse['email'].toString();
      StaticAccount.staticAccount.phoneNumber=jsonResponse['phoneNumber'].toString();
      StaticAccount.staticAccount.photo=base64.decode(jsonResponse['photo'].toString());
      return 200; // Success
      } else if (response.statusCode == 409)
      {
        return 409;
      }
      else
      {
        return 500;//Exception('Failed to update Profile');
      }
    } catch (e) {
      print('Error: $e');
      return 500;
    }


  }


}


