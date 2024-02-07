import 'package:flutter/material.dart';
import 'addDriver.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    ),
  );
}

class Login extends StatelessWidget {
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
                    Center( // Center the "Bienvenue" text
                      child: Text(
                        "Bienvenue",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center( // Center the "PGS Tracking" text
                      child: Text(
                        "PGS Tracking",
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "E-mail ou Téléphone",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 20), // Added space
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Mot de passe",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Mot de passe oubliée ?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddDriverForm(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xFF0E9695),
                          ),
                          child: Center(
                            child: Text(
                              "Se connecter",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          "PGS International © copyright 2023",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
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