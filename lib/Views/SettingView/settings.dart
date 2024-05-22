import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/ViewModel/AccountViewModel.dart';
import 'package:supplychaintracking/Views/LoginView/login.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';
import 'package:supplychaintracking/Views/Widgets/logout_button.dart';
import 'package:supplychaintracking/Views/Widgets/setting_item.dart';
import 'package:supplychaintracking/Views/Widgets/setting_switch.dart';
import 'package:supplychaintracking/main.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _darkMode = false;
  bool _loading = false; // Add a loading indicator variable

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      print("_darkMode :"+ _darkMode.toString());
    });
  }

  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _darkMode);
    print("_darkMode saved :"+ _darkMode.toString());
  }



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return

      Scaffold(

          appBar: AppBar(
            automaticallyImplyLeading: false, // This hides the back button
            title: Row(
              children: [
                // Add spacer to push the title to the right
                Padding(
                  padding: const EdgeInsets.only(left:10 ,top: 10),
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: ColorTheme.appBarBigTitleColor,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: ColorTheme.backgroundNormalColor,
          ),
        body: _loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Logging out..."),
                  ],
                ),
              ) // Show loading indicator if loading is true
            : Container(
              height: height,
              width: width,
              color: ColorTheme.backgroundNormalColor,
                child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 30, left: 30, right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            "Account",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                                color: ColorTheme.bigTitleColor
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: ClipOval(
                                    child: Image.memory(
                                      Uint8List.fromList(StaticAccount.staticAccount.photo),
                                      fit: BoxFit.cover,
                                      width: 70, // Example width
                                      height: 70, // Example height
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            10), // Add some space between the icon and the column
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          StaticAccount.staticAccount.phoneNumber,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                              color: ColorTheme.smalTitleColor
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          StaticAccount
                                              .staticAccount.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                LogoutButton(
                                  onTap: () async {
                                    setState(() {
                                      _loading = true; // Show loading indicator
                                    });
                                    // Simulate a delay of 3 seconds
                                    await Future.delayed(Duration(seconds: 3));
                                    Provider.of<AccountViewModel>(context,
                                            listen: false)
                                        .logout();
                                    // Navigator.of(context).pop();
                                    Navigator.pop(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                           Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                                color: ColorTheme.bigTitleColor
                            ),
                          ),
                          const SizedBox(height: 20),
                          SettingItem(
                            title: "Language",
                            icon: Icons.language,
                            bgColor: Colors.teal.shade100,
                            iconColor: ColorTheme.principalBlue,
                            value: "English",
                            onTap: () {},
                          ),
                          const SizedBox(height: 20),
                          SettingItem(
                            title: "Notifications",
                            icon: Icons.notifications,
                            bgColor: Colors.teal.shade100,
                            iconColor: ColorTheme.principalBlue,
                            onTap: () {},
                          ),
                          const SizedBox(height: 20),
                          SettingSwitch(
                            title: "Dark Mode",
                            icon: Icons.dark_mode_rounded,
                            bgColor: Colors.teal.shade100,
                            iconColor: ColorTheme.principalBlue,
                            value: _darkMode,
                            onTap: (value) {
                              setState(() {
                                _darkMode=value;
                              });
                              _saveSettings();

                            },
                          ),
                          const SizedBox(height: 20),
                          SettingItem(
                            title: "Help",
                            icon: Icons.help,
                            bgColor: Colors.teal.shade100,
                            iconColor: ColorTheme.principalBlue,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
              ));
  }
}
