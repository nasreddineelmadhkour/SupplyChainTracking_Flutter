import 'package:flutter/material.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class LineEditdiv2 extends StatelessWidget{
  final String title;
  final IconData icon;
  final bool readOnly;
  final String title2;
  final IconData icon2;
  final bool readOnly2;


  const LineEditdiv2({
    super.key,
    required this.title,
    required this.icon,
    required this.readOnly,
    required this.title2,
    required this.icon2,
    required this.readOnly2

  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height+40;
    double width = MediaQuery.of(context).size.width/2;
    return

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: width/1.2, // set your desired width
            child: TextFormField(
              readOnly: readOnly,
              cursorColor: ColorTheme.principalTeal,
              style: TextStyle(color: ColorTheme.principalTeal),
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorTheme.colorBackgroundCard,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.circular(30),
                ),
                label: Text(
                  title,
                  style: TextStyle(color: ColorTheme.smalTitleColor),
                ),
                prefixIcon: Icon(icon, color: ColorTheme.principalTeal, size: 25),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 2, color: ColorTheme.principalTeal),
                ),
              ),
            ),
          ),
          SizedBox(height: 16), // for spacing between fields
          Container(
            width: width/1.2, // set your desired width
            child: TextFormField(
              readOnly: readOnly2,
              cursorColor: ColorTheme.principalTeal,
              style: TextStyle(color: ColorTheme.principalTeal),
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorTheme.colorBackgroundCard,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.circular(30),
                ),
                label: Text(
                  title2,
                  style: TextStyle(color: ColorTheme.smalTitleColor),
                ),
                prefixIcon: Icon(icon2, color: ColorTheme.principalTeal, size: 25),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 2, color: ColorTheme.principalTeal),
                ),
              ),
            ),
          ),

        ],
      )
      ;
  }
}