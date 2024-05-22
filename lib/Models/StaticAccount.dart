
import 'dart:convert';
import 'dart:typed_data';

import 'package:supplychaintracking/Models/Account.dart';

class StaticAccount {
  // Static field
  static Account staticAccount = Account(userNumber: 0, name: "name", token: "token", photo: Uint8List(0), phoneNumber: "phoneNumber", codeTel: "codeTel", resetToken: "resetToken", email: "email", password: "password", role: "role", isAccountNonLocked: true, isAccountNonExpired: true, isCredentialsNonExpired: true, isEnabled: true, activateCode: "activateCode", datecreation: DateTime.now(),serialNumber: "",cardNumber:"");

  // Static method
  static void myStaticMethod() {
    print('Hello from a static method!');
  }
}

