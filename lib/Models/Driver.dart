class Driver {
  final int userNumber;
  final String name;
  final String photo;
  final String phoneNumber;
  final String email;
  final String password;
  final String serialNumber;
  final String cardNumber;

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
      photo: json['photo'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      password: json['password'],
      serialNumber: json['serialNumber'].toString(),
      cardNumber: json['cardNumber'].toString(),
    );
  }
}
