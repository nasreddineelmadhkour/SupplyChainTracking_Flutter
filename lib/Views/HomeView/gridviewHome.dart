import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:supplychaintracking/Models/MapLeaflet.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/Models/GridOrder.dart';
import 'package:supplychaintracking/ViewModel/OrderViewModel.dart';
import 'package:supplychaintracking/Views/ClaimView/listClaims.dart';
import 'package:supplychaintracking/Views/ClaimView/listClaimsForDriver.dart';
import 'package:supplychaintracking/Views/DriverView/ListDrivers.dart';
import 'package:supplychaintracking/Views/OrderView/DetailsOrder.dart';
import 'package:supplychaintracking/Views/OrderView/ListOrders.dart';
import 'package:supplychaintracking/Views/OrderView/ListOrdersForDriver.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<GridOrder> gridOrders = [];
  final List<Map<String, dynamic>> gridItems = [
    {
      'icon': FontAwesomeIcons.route,
      'name': 'Orders',
      'onTap': (context) {
        if (StaticAccount.staticAccount.role == "CARRIER") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ListOrders()), // Navigate to ListDrivers screen
          );
        }
        if (StaticAccount.staticAccount.role == "DRIVER") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ListOrdersForDriver()), // Navigate to ListDrivers screen
          );
        }
      },
      'backgroundColor': ColorTheme.backgroundNormalColor,
    },
    if (StaticAccount.staticAccount.role == "CARRIER")
      {
        'icon': FontAwesomeIcons.userGear,
        'name': 'Drivers',
        'onTap': (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ListDrivers()), // Navigate to ListDrivers screen
          );
        },
        'backgroundColor': ColorTheme.backgroundNormalColor,
      },
    {
      'icon': Icons.bus_alert,
      'name': 'Claims',
      'onTap': (context) {
        if (StaticAccount.staticAccount.role == "CARRIER") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ListClaims()), // Navigate to ListDrivers screen
          );
        }
        if (StaticAccount.staticAccount.role == "DRIVER") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ListClaimsForDriver()), // Navigate to ListDrivers screen
          );
        }
      },
      'backgroundColor': ColorTheme.backgroundNormalColor,
    },
    // Add more items as needed
  ];

  final List<Map<String, dynamic>> gridItems2 = [
    {
      'icon': FontAwesomeIcons.route,
      'name': 'Orders',
      'onTap': () {
        print('Orders tapped');
      },
      'backgroundColor': ColorTheme.backgroundNormalColor,
    },
    // Add more items as needed
  ];

  int pageOrderToday = 1, pageOther = 1;
  final OrderViewModel orderViewModel = OrderViewModel();
  late Future<List<dynamic>> _futureOrders;
  late Future<List<dynamic>> _futureOrdersToday;
  late List<dynamic> ordersToday; // List to store drivers

  MapController _mapController = MapController();
  MapLeaflet _mapLeaflet = MapLeaflet();

  void changeVisibilityOrdersToday() {
    setState(() {
      if (pageOrderToday == 0) {
        pageOrderToday = 1;
      } else {
        pageOrderToday = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    ordersToday = [];
    if (StaticAccount.staticAccount.role == "CARRIER") {
      _futureOrdersToday = orderViewModel.getOrderByCarrierToday();
    } else {
      _futureOrdersToday = orderViewModel.getOrderByDriverToday();
    }

    _fetchOrdersToday();
  }

  Future<void> _fetchOrdersToday() async {
    try {
      final _ordersToday = await _futureOrdersToday;

      setState(() {
        ordersToday = _ordersToday;
      });
    } catch (error) {
      print('Error fetching drivers: $error');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
          width: width,
          height: height + 452,
          color: ColorTheme.backgroundNormalColor,
          child: Container(
            margin: EdgeInsets.only(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                Container(
                  height: 15,
                  color: ColorTheme.homeTopColor,
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 30, bottom: 20, top: 36),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(70),
                        bottomLeft: Radius.circular(0)),
                    color: ColorTheme.homeTopColor,
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(right: width / 20),
                          height: 80,
                          width: 80,
                          child: CircleAvatar(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  70), // Set the same radius as the CircleAvatar
                              child: Image.memory(
                                Uint8List.fromList(
                                    StaticAccount.staticAccount.photo),
                                //fit: BoxFit.cover,
                                width: 80, // Example width
                                height: 80, // Example height
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 0),
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 0),
                              title: Text(
                                'Hello !',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              subtitle: Text(
                                '${StaticAccount.staticAccount.name}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                        color: Colors.white54, fontSize: 15),
                              ),
                            ),
                            const SizedBox(height: 0),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.notifications,
                            size: 30,
                            color: ColorTheme.colorIcon,
                          ),
                          onPressed: () => print("hello"),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(),
                  child: Column(
                    children: [
                      Container(
                        child: Container(
                          color: Colors.white,
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 20, left: 30, right: 30, bottom: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0)),
                              color: ColorTheme.backgroundNormalColor,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  child: Text(
                                    'Menu',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: ColorTheme.bigTitleColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 40, left: 40),
                                  height: 1,
                                  color: ColorTheme.bigTitleColor,
                                ),
                                if (StaticAccount.staticAccount.role ==
                                    "CARRIER")
                                  GridView.count(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15, top: 20),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 0,
                                    children: gridItems.map((item) {
                                      return GestureDetector(
                                        onTap: () => item['onTap'](context),
                                        child: itemDashboard(
                                          item['name'],
                                          item['icon'],
                                          item['backgroundColor'],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                if (StaticAccount.staticAccount.role ==
                                    "DRIVER")
                                  GridView.count(
                                    padding: EdgeInsets.only(
                                        left: width / 6,
                                        right: width / 6,
                                        top: 20),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 30,
                                    mainAxisSpacing: 0,
                                    children: gridItems.map((item) {
                                      return GestureDetector(
                                        onTap: () => item['onTap'](context),
                                        child: itemDashboard(
                                          item['name'],
                                          item['icon'],
                                          item['backgroundColor'],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Column(
                  children: [
                    Container(
                      width: width / 1.05,
                      margin: EdgeInsets.only(right: 15, left: 15),
                      decoration: BoxDecoration(
                        color: ColorTheme
                            .bigTitleColor, // Set the background color to red
                        border: Border.all(
                            color: Colors.teal,
                            width: 1.0), // Set border color and width
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(
                                30)), // Set border radius for circular border
                      ),
                      child: Container(
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () => changeVisibilityOrdersToday(),
                          child: Padding(
                            // Add padding to prevent text from touching the border
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Text(
                              "Orders today",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: ColorTheme.ListOrder,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (ordersToday.isNotEmpty)
                      Visibility(
                        visible: pageOrderToday != 0,
                        child: Container(
                          height: height / 2.3,
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 0),
                            itemCount: ordersToday.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.only(
                                    left: 20, right: 15, bottom: 10),
                                color: ColorTheme.colorBackgroundCard,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              ordersToday[index]
                                                  ['productOrders'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      ColorTheme.smalTitleColor,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              ordersToday[index]['dateOrders']
                                                      .toString()
                                                      .substring(0, 10) +
                                                  " " +
                                                  ordersToday[index]
                                                          ['dateOrders']
                                                      .toString()
                                                      .substring(12, 16),
                                              style: TextStyle(
                                                  color:
                                                      ColorTheme.smalTitleColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        subtitle: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                        FontAwesomeIcons
                                                            .arrowUp,
                                                        size: 10),
                                                    if (ordersToday[index][
                                                                'startingPoint']
                                                            .toString()
                                                            .length >
                                                        18)
                                                      Text(
                                                          " " +
                                                              ordersToday[index]
                                                                      [
                                                                      'startingPoint']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 18) +
                                                              "...",
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey)),
                                                    if (ordersToday[index][
                                                                'startingPoint']
                                                            .toString()
                                                            .length <=
                                                        18)
                                                      Text(
                                                          " " +
                                                              ordersToday[index]
                                                                      [
                                                                      'startingPoint']
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        FontAwesomeIcons
                                                            .arrowDown,
                                                        size: 10),
                                                    if (ordersToday[index]
                                                                ['arrivalPoint']
                                                            .toString()
                                                            .length >
                                                        18)
                                                      Text(
                                                          " " +
                                                              ordersToday[index]
                                                                      [
                                                                      'arrivalPoint']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 18) +
                                                              "...",
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey)),
                                                    if (ordersToday[index]
                                                                ['arrivalPoint']
                                                            .toString()
                                                            .length <=
                                                        18)
                                                      Text(
                                                          " " +
                                                              ordersToday[index]
                                                                      [
                                                                      'arrivalPoint']
                                                                  .toString()
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  StaticAccount.staticAccount
                                                              .role ==
                                                          "CARRIER"
                                                      ? ordersToday[index]
                                                          ['driver']['name']
                                                      : " ",
                                                  style: TextStyle(
                                                      color: Colors.teal),
                                                ),
                                                if (ordersToday[index]['status']
                                                        .toString() ==
                                                    "IN_PROGRESS")
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "IN PROGRESS" + " ",
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Icon(Icons.schedule_send,
                                                          color: Colors.green,
                                                          size: 15),
                                                    ],
                                                  ),
                                                if (ordersToday[index]['status']
                                                        .toString() ==
                                                    "PENDING")
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        ordersToday[index]
                                                                ['status'] +
                                                            " ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.orange,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Icon(Icons.pending,
                                                          color: Colors.orange,
                                                          size: 15),
                                                    ],
                                                  ),
                                                if (ordersToday[index]['status']
                                                        .toString() ==
                                                    "COMPLETED")
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        ordersToday[index]
                                                                ['status'] +
                                                            " ",
                                                        style: TextStyle(
                                                            color: Colors.teal,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Icon(Icons.verified,
                                                          color: Colors.teal,
                                                          size: 15),
                                                    ],
                                                  ),
                                                if (ordersToday[index]['status']
                                                        .toString() ==
                                                    "CANCELED")
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        ordersToday[index]
                                                                ['status'] +
                                                            " ",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Icon(Icons.cancel_rounded,
                                                          color: Colors.red,
                                                          size: 15),
                                                    ],
                                                  ),
                                                if (ordersToday[index]['status']
                                                        .toString() ==
                                                    "DELAYED")
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        ordersToday[index]
                                                                ['status'] +
                                                            " ",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Icon(
                                                          Icons
                                                              .replay_circle_filled_sharp,
                                                          color: Colors.grey,
                                                          size: 15),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            if (ordersToday[index]['status'] ==
                                                    "IN_PROGRESS" &&
                                                StaticAccount
                                                        .staticAccount.role ==
                                                    "CARRIER")
                                              SizedBox(
                                                height: 10,
                                              ),
                                            if (ordersToday[index]['status'] ==
                                                    "IN_PROGRESS" &&
                                                StaticAccount
                                                        .staticAccount.role ==
                                                    "CARRIER")
                                              GestureDetector(
                                                onTap: () => print("hello"),
                                                child: Container(
                                                  width: width / 1.4,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                                  decoration: BoxDecoration(
                                                    color: ColorTheme
                                                        .bigTitleColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Tracking now",
                                                        style: TextStyle(
                                                          color: ColorTheme
                                                              .ListOrder,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              8.0), // Add some space between text and icon
                                                      Icon(
                                                        Icons
                                                            .emergency_share_sharp,
                                                        color: ColorTheme
                                                            .ListOrder,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            if (ordersToday[index]['status'] ==
                                                "IN_PROGRESS")
                                              SizedBox(
                                                height: 10,
                                              ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                        leading: Icon(
                                          Icons.arrow_forward_ios,
                                          color: ColorTheme.smalTitleColor,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsOrder(
                                                        ordersToday[index])),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    if (ordersToday.isEmpty)
                      Visibility(
                        visible: pageOrderToday != 0,
                        child: Container(
                          height: height / 5,
                          child: Card(
                            margin:
                                EdgeInsets.only(left: 20, right: 15, bottom: 5),
                            color: ColorTheme.colorBackgroundCard,
                            child: Center(
                              child: ListTile(
                                title: Center(
                                  child: Text(
                                    "NO ORDERS TODAY",
                                    style: TextStyle(
                                      color: ColorTheme.smalTitleColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Add space of height 10
                    SizedBox(height: height / 12), // Add space of height 10
                  ],
                ),
              ],
            ),
          ),
        ),
  ])),
    );
  }

  Widget itemDashboard(String title, IconData icon, Color backgroundColor) =>
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: ColorTheme.colorBackgroundCard,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Color.fromRGBO(31, 48, 97, .3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: ColorTheme.colorIcon,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: ColorTheme.colorIcon),
            ),
          ],
        ),
      );

  Widget itemOrder(String title, IconData icon, Color backgroundColor) =>
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: ColorTheme.colorBackgroundCard,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Color.fromRGBO(31, 48, 97, .3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icons/mapicon.png',
              width: 50,
              height: 50,
              //color: Colors.white,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(34.0812055063, 9.417373468231718),
                  zoom: 5,
                  interactionOptions: InteractionOptions(
                    enableScrollWheel: false,
                    enableMultiFingerGestureRace: false,
                    debugMultiFingerGestureWinner: false,
                  ),
                  enableMultiFingerGestureRace: false,
                  enableScrollWheel: false,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    additionalOptions: {'userAgent': 'com.example.app'},
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _mapLeaflet.routeCoordinates,
                        color: Colors.blue,
                        strokeWidth: 3.0,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: _buildMarkers(),
                  ),
                ],
              ),
            ),
            Text(
              title,
              style: TextStyle(color: Color.fromRGBO(97, 31, 74, 1.0)),
            ),
          ],
        ),
      );

  List<Marker> _buildMarkers() {
    return [
      Marker(
        point: LatLng(37.7749, -122.4194),
        width: 10,
        height: 10,
        child: Image.asset("assets/images/maps/myposition.png"),
      ),
      // Add more markers as needed
    ];
  }
}
