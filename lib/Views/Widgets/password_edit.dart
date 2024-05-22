import 'package:flutter/material.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class PasswordEdit extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool readOnly;
  bool showPassword;

  PasswordEdit({
    Key? key,
    required this.title,
    required this.icon,
    required this.readOnly,
    required this.showPassword,
  }) : super(key: key);

  @override
  _PasswordEditState createState() => _PasswordEditState();
}

class _PasswordEditState extends State<PasswordEdit>
{
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _passwordController,
      readOnly: widget.readOnly,
      obscureText: !widget.showPassword,
      cursorColor: ColorTheme.principalTeal,
      style: TextStyle(color: ColorTheme.principalTeal),
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorTheme.colorBackgroundCard,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.circular(30),
        ),
        labelText: widget.title,
        labelStyle: TextStyle(color: ColorTheme.smalTitleColor),
        prefixIcon: Icon(widget.icon, color: ColorTheme.principalTeal, size: 25),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(width: 2, color: ColorTheme.principalTeal),
        ),
        suffixIcon: IconButton(padding: EdgeInsets.only(right: 30),
          icon: Icon(widget.showPassword ? Icons.visibility : Icons.visibility_off,color: ColorTheme.smalTitleColor),
          onPressed: () {
            setState(() {
              widget.showPassword = !widget.showPassword;
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
