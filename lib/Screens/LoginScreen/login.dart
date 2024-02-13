import 'package:flutter/material.dart';
import 'package:supplychaintracking/Screens/MapScreen/mapLeaflet.dart';
import 'resetPassword.dart';
import '../addDriver.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    ),
  );
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  void _goToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapLeafletWidget(),
      ),
    );
  }


  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapLeafletWidget(),
        ),
      );
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
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
                SizedBox(height: 100),
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
                          "Bienvenue",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          "TRACKING",
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
                                        return 'Veuillez saisir votre email ou téléphone.';
                                      }
                                      if (value.length < 8) {
                                        return 'L\'email ou le téléphone doit contenir au moins 8 caractères.';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "E-mail ou Téléphone",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_showPassword,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez saisir votre mot de passe.';
                                      }
                                      if (value.length < 6) {
                                        return 'Le mot de passe doit contenir au moins 6 caractères.';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Mot de passe",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showPassword = !_showPassword;
                                          });
                                        },
                                        child: Icon(
                                          _showPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),

                          GestureDetector(
                            onTap: _goToResetPassword, // Navigate to ResetPassword screen
                            child: Text(
                              "Mot de passe oubliée ?",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 40),
                          GestureDetector(
                            onTap: _login,
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xFF0E9695),
                              ),
                              child: Center(
                                child: Text(
                                  "Connexion",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
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
      );
    }
}