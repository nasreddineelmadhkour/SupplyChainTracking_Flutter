import 'package:flutter/material.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class LineEdit extends StatelessWidget{
  final String title;
  final IconData icon;
  final bool readOnly;

  const LineEdit({
    super.key,
    required this.title,
    required this.icon,
    required this.readOnly

  });

  @override
  Widget build(BuildContext context) {

    return TextFormField(

      readOnly: readOnly,
      cursorColor: ColorTheme.principalTeal,
      style: TextStyle(color: ColorTheme.principalTeal),
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorTheme.colorBackgroundCard,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.circular(30),),
        label: Text(
          title,
          style: TextStyle(color: ColorTheme.smalTitleColor),
        ),
        prefixIcon: Icon(icon, color: ColorTheme.principalTeal,size: 25),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(width: 2, color: ColorTheme.principalTeal), // Bordure bleue quand en focus
        ),

      ),
    );
  }
}