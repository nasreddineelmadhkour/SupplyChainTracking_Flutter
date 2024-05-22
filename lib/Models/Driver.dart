import 'dart:convert';
import 'dart:typed_data';

class Driver {
   int userNumber;
   String name;
   Uint8List photo;
   String phoneNumber;
   String email;
   String password;
   String serialNumber;
   String cardNumber;

  Driver({
    required this.userNumber,
    required this.name,
    required this.photo,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.serialNumber,
    required this.cardNumber,
  });


  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      userNumber: json['userNumber'],
      name: json['name'],
      photo: base64.decode(json['photo']), // Convert base64 string to bytes
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      password: json['password'],
      serialNumber: json['serialNumber'].toString(),
      cardNumber: json['cardNumber'].toString(),
    );
  }
}
