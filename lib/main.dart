import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplychaintracking/ChatPage.dart';
import 'package:supplychaintracking/Models/StaticSettings.dart';
import 'package:supplychaintracking/ViewModel/AccountViewModel.dart';
import 'package:supplychaintracking/Views/SocketIOClient.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';
import 'package:supplychaintracking/Views/addDriver.dart';
import 'package:web_socket_channel/io.dart';
import 'Views/LoginView/login.dart';

void main() {
  /*final channel = IOWebSocketChannel.connect('ws://localhost:8080/ws');
  channel.stream.listen((message) {
    print('Received: $message');
  }); */
  //channel.sink.add('Hello, WebSocket!');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountViewModel()),
        // Add other providers if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountViewModel()),
      ],
      child: MaterialApp(
        title: 'Logo Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        routes: {
          '/login': (context) => SocketIOClient(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    Timer(Duration(seconds: 2), () {
      _animationController.forward();
      Timer(Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Login(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      });
    });
  }

  void _loadSettings() async {




    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ColorTheme.darkMode = prefs.getBool('darkMode') ?? false;
      print("_darkMode :"+ ColorTheme.darkMode.toString());


        StaticSettings.username = prefs.getString('username') ?? '';
        StaticSettings.password = prefs.getString('password') ?? '';
        print(prefs.getBool("rememberMe"));
        
        StaticSettings.rememberMe = prefs.getBool('rememberMe') ?? false;

      print("Username:"+StaticSettings.username +" | Password:"+ StaticSettings.password + " |Remember Me:"+StaticSettings.rememberMe.toString());



    });

    if(ColorTheme.darkMode)
    {
      //DarkMod

      ColorTheme.colorBackgroundCard=Color.fromRGBO(22,24, 37, 1);
      ColorTheme.backgroundNormalColor = Color.fromRGBO(13, 16, 25, 1);
      ColorTheme.colorIcon =Color.fromRGBO(49, 161, 139, 1);
      ColorTheme.homeTopColor= Color.fromRGBO(26, 27, 47, 1);
      ColorTheme.bigTitleColor = Color.fromRGBO(49, 161, 139, 1);
      ColorTheme.hintTitleColor=Color.fromRGBO(120, 118, 131, 1);
      ColorTheme.smalTitleColor = Color.fromRGBO(181, 183, 196, 1);
      ColorTheme.titleAppBarColor = Color.fromRGBO(49, 161, 139, 1);
      ColorTheme.appBarColor = Color.fromRGBO(22,24, 37, 1);
      ColorTheme.appBarBigTitleColor = Color.fromRGBO(116, 118, 131, 1);


      ColorTheme.mode=Colors.grey;
    }
    else{

      //LightMod

      ColorTheme.colorBackgroundCard=Color.fromRGBO(254, 254, 254, 1);
      ColorTheme.backgroundNormalColor = Color.fromRGBO(250, 249, 254, 1);
      ColorTheme.colorIcon = Color.fromRGBO(31, 48, 97, 1);
      ColorTheme.homeTopColor=Color.fromRGBO(49, 161, 139, 1);
      ColorTheme.bigTitleColor = Color.fromRGBO(31, 48, 97, 1);
      ColorTheme.hintTitleColor=Color.fromRGBO(49, 161, 139, 1);
      ColorTheme.smalTitleColor = Color.fromRGBO(31, 48, 97, 1);
      ColorTheme.titleAppBarColor = Color.fromRGBO(250, 249, 254, 1);
      ColorTheme.appBarColor = Color.fromRGBO(49, 161, 139, 1);
      ColorTheme.appBarBigTitleColor = Color.fromRGBO(112, 115, 124, 1);


      ColorTheme.mode=Colors.white;

    }

  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.backgroundNormalColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
