import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final Function() onTap;
  const LogoutButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.logout,color: Colors.red),
      ),
    );
  }
}