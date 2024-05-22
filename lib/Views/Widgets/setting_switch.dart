import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class SettingSwitch extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final bool value;
  final Function(bool value) onTap;

  const SettingSwitch({
    Key? key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorTheme.smalTitleColor,
            ),
          ),
          const Spacer(),
          Text(
            value ? "On" : "Off", // Displaying the state visually
            style: TextStyle(
              fontSize: 16,
              color: ColorTheme.hintTitleColor,
            ),
          ),
          const SizedBox(width: 20),
          CupertinoSwitch(value: value, onChanged: _handleSwitchChange),
        ],
      ),
    );
  }

  void _handleSwitchChange(bool newValue) {
    onTap(newValue); // Call the onTap function provided by the parent widget
    // Print to terminal
    if(newValue)
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


        ColorTheme.ListOrder = Color.fromRGBO(240, 240, 240, 1.0);


        ColorTheme.mode=Colors.grey;
      }
    else{

      //LightMod
      ColorTheme.ListOrder = Colors.white;

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
    print(newValue ? 'On' : 'Off');
  }
}
