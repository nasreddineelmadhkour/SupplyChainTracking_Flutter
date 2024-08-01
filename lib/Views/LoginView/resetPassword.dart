import 'package:flutter/material.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/ViewModel/AccountViewModel.dart';
import 'dart:async';

import 'package:supplychaintracking/Views/LoginView/codeResetPassword.dart';
class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  bool _isButtonDisabled = false;
  int _timerCountdown = 30;
  final AccountViewModel accountViewModel = AccountViewModel();


  @override
  void dispose() {
    _emailPhoneController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState?.validate() == true) {

      StaticAccount.staticAccount.phoneNumber=_emailPhoneController.text;

      // Clear the input field
      _emailPhoneController.clear();

      // Start the countdown timer
      startTimer();

      // Navigate to the codeResetPassword file after the timer stops
      Timer(Duration(seconds: 5), () async {
        bool testFunct = await accountViewModel.SendCodeReset();
        print(testFunct);
        if (testFunct) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CodeResetPassword()),
          );
        } else {
          // Show alert if accountViewModel.SendCodeReset() returns false
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Alert"),
                content: Text("No account with this identity."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }

  void startTimer() {
    setState(() {
      _isButtonDisabled = true;
      _timerCountdown = 5;
    });

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_timerCountdown == 0) {
        setState(() {
          _isButtonDisabled = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _timerCountdown--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Color(0xFF0E9695),
                  Color(0xFF44C4C3),
                  Color(0xFF88DCDA),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 85),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/logo.png',
                              height: 100,
                              width: 100,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "",
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Reset password",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 60),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: _emailPhoneController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email or phone number.';
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Phone number",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            GestureDetector(
                              onTap: _isButtonDisabled ? null : _resetPassword,
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: _isButtonDisabled ? Colors.grey : Color(0xFF0E9695),
                                ),
                                child: Center(
                                  child: Text(
                                    _isButtonDisabled ? '$_timerCountdown' : 'Send',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 200),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 70),
                              child: Text(
                                "PGS International © copyright 2024",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context); // Navigate back when back button is pressed
              },
            ),
          ),
        ],
      ),
    );
  }
}