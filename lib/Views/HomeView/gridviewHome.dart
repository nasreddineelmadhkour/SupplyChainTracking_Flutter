import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:supplychaintracking/Models/MapLeaflet.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/Models/GridOrder.dart';
import 'package:supplychaintracking/Views/DriverView/ListDrivers.dart';
import 'package:supplychaintracking/Views/OrderView/ListOrders.dart';
import 'package:supplychaintracking/Views/OrderView/ListOrdersForDriver.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class FirstGrid extends StatelessWidget {
  final List<GridOrder> gridOrders = [];

  final List<Map<String, dynamic>> gridItems = [
    {
      'icon': FontAwesomeIcons.route,
      'name': 'Orders',
      'onTap': (context) {
        if(StaticAccount.staticAccount.role=="CARRIER")
          {
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ListOrders()), // Navigate to ListDrivers screen
            );
          }
        if(StaticAccount.staticAccount.role=="DRIVER")
          {
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
    if(StaticAccount.staticAccount.role=="CARRIER")
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
      'onTap': () {
        print('Claims tapped');
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

  MapController _mapController = MapController();
  MapLeaflet _mapLeaflet = MapLeaflet();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ListView(
      padding: EdgeInsets.only(top: 30),
      children: [
        Container(
          width: width,
          height: height,
          color: ColorTheme.backgroundNormalColor,
          child: Container(

            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20 , right: 30 , bottom: 20 , top: 36),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(70),bottomLeft: Radius.circular(0)),
                    color: ColorTheme.homeTopColor,
                  ),
                  child: Row(
                    children: [
                       Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(right: width/20),
                          height: 80,
                          width: 80,
                          child: CircleAvatar(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(70), // Set the same radius as the CircleAvatar
                              child: Image.memory(
                                Uint8List.fromList(StaticAccount.staticAccount.photo),
                                //fit: BoxFit.cover,
                                width: 80, // Example width
                                height: 80, // Example height
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex:2,
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
                                    ?.copyWith(color: Colors.white54,fontSize: 15),
                              ),
                            ),
                            const SizedBox(height: 0),
                          ],
                        ),

                      ),

                      Expanded(
                        flex: 0,
                        child: IconButton(
                          icon: Icon(Icons.notifications,size: 30,color: ColorTheme.colorIcon,),
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
                            decoration:  BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),topRight: Radius.circular(0)),
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
                                if(StaticAccount.staticAccount.role=="CARRIER")
                                GridView.count(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 20),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
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
                                if(StaticAccount.staticAccount.role=="DRIVER")
                                  GridView.count(
                                    padding: EdgeInsets.only(
                                        left: width/6, right: width/6, top: 20),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
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
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Orders today",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                          color: ColorTheme.smalTitleColor),
                                    ),
                                    Text(
                                      "See All",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorTheme.hintTitleColor,
                                      ),
                                    )
                                  ],
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
                GridView.count(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio:
                      (MediaQuery.of(context).size.height - 50 - 25) /
                          (4 * 240),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: gridItems2.map((item) {
                    return GestureDetector(
                      onTap: item['onTap'],
                      child: itemOrder(
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
        )
      ],
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
