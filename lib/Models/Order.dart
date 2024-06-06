import 'package:supplychaintracking/Models/StaticMethode.dart';

class Order {

  late int ordersNumber;
  late int carrierNumber;
  late int driverNumber;
  late int reclamationNumber;
  late DateTime dateOrders;
  late String productOrders;
  late int weightOrders;
  late String startingPoint;
  late String arrivalPoint;
  late double startingLong;
  late double startingLat;
  late double arrivalLong;
  late double arrivalLat;
  late String estimation;
  late String distance;
  late String unitProduct;
  late String status;

  late double ordersNowLat;
  late double ordersNowLong;
  Order({
    required this.ordersNumber,
    required this.dateOrders,
    required this.arrivalLat,
    required this.arrivalLong,
    required this.arrivalPoint,
    required this.distance,
    required this.estimation,
    required this.startingLat,
    required this.startingLong,
    required this.driverNumber,
    required this.weightOrders,
    required this.startingPoint,
    required this.productOrders,
    required this.carrierNumber,
    required this.reclamationNumber,
    required this.unitProduct,
    required this.status,
    required this.ordersNowLat,
    required this.ordersNowLong

});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      ordersNumber: json['ordersNumber'],
      carrierNumber: json['carrierNumber'],
      driverNumber: json['driverNumber'],
      reclamationNumber: json['reclamationNumber'],
      dateOrders: StaticMethode.parseDateString(json['dateOrders'] ?? ''),
      productOrders: json['productOrders'],
      weightOrders: json['weightOrders'],
      arrivalLat: json['arrivalLat'],
      arrivalLong: json['arrivalLong'],
      arrivalPoint: json['arrivalPoint'],
      distance: json['distance'],
      estimation: json['estimation'],
      startingLat: json['startingLat'],
      startingLong: json['startingLong'],
      startingPoint: json['startingPoint'],
      unitProduct : json['unitProduct'],
      status: json['status'],
      ordersNowLat: json['ordersNowLat'],
      ordersNowLong: json['ordersNowLong'],

    );
  }



}