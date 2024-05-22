import 'package:supplychaintracking/Models/Order.dart';

class StaticMethode
{
  var addOrder = false;

static DateTime parseDateString(String dateString) {
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    print('Error parsing date: $e');
    return DateTime.now();
  }
}


static Order staticOrder= Order(ordersNumber: 0, dateOrders: DateTime.now(), arrivalLat: 0.0, arrivalLong: 0.0, arrivalPoint: "", distance: "", estimation: "", startingLat: 0.0, startingLong: 0.0, driverNumber: 0, weightOrders: 0, startingPoint: "", productOrders: "", carrierNumber: 0, reclamationNumber: 0,unitProduct: "",status: "");


}