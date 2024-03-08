import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/Views/HomeView/gridviewHome.dart';
import 'package:supplychaintracking/Views/OrderView/addOrder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  DateTime? currentBackPressTime;

  final List<Widget> _pages = [
    FirstGrid(),
    AddOrder(), // Replace with your Livraison content
    Center(
      child: Text('Profile Content'),
    ),
    Center(
      child: Text('Settings Content'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Minimize the app instead of going back
        if (currentBackPressTime == null ||
            DateTime.now().difference(currentBackPressTime!) >
                Duration(seconds: 2)) {
          currentBackPressTime = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Appuyez de nouveau pour quitter"),
            ),
          );
          return false;
        }
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        /*
        appBar: AppBar(

          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              onPressed: () {
                // Provider.of<AccountViewModel>(context, listen: false).logout();
                Navigator.of(context).pop();
                //Navigator.pop(
                //  context, MaterialPageRoute(builder: (context) => Login()));
              },
              icon: Icon(Icons.logout),
              iconSize: 30,
              color: Color.fromRGBO(31, 48, 97, 1),
              padding: EdgeInsets.symmetric(horizontal: 25),
            ),
          ],
        ),*/
        body:


        _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_sharp),
              label: 'Livraison',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromRGBO(31, 48, 97, 1),
          unselectedItemColor: Colors.teal,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
