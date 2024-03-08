import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:supplychaintracking/Models/MapLeaflet.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/Models/GridOrder.dart';
class GridItem {
  final IconData icon;
  final String name;
  final VoidCallback onTap;
  final Color backgroundColor; // New property to store the background color

  GridItem({
    required this.icon,
    required this.name,
    required this.onTap,
    required this.backgroundColor,
  });
}




class FirstGrid extends StatelessWidget {

   List<GridOrder> gridOrders =[];



  final List<GridItem> gridItems = [
    GridItem(
      icon: FontAwesomeIcons.route,

      name: 'Orders',
      onTap: () {
        // Handle onTap for Star
        print('Orders tapped');
      },
      backgroundColor: Colors.white, // Assign a unique color for each item
    ),
    GridItem(
      icon: FontAwesomeIcons.userGear,
      name: 'Drivers',
      onTap: () {
        // Handle onTap for Favorite
        print('Drivers tapped');
      },
      backgroundColor: Colors.white, // Assign a unique color for each item
    ),
    GridItem(
      icon: Icons.bus_alert,
      name: 'Claims',
      onTap: () {
        // Handle onTap for Favorite
        print('Claims tapped');
      },
      backgroundColor: Colors.white, // Assign a unique color for each item
    ),
    // Add more GridItems as needed
  ];

  final List<GridItem> gridItems2 = [
    GridItem(
      icon: FontAwesomeIcons.route,

      name: 'Orders',
      onTap: () {
        // Handle onTap for Star
        print('Orders tapped');
      },
      backgroundColor: Colors.white, // Assign a unique color for each item
    ),
    GridItem(
      icon: FontAwesomeIcons.userGear,
      name: 'Drivers',
      onTap: () {
        // Handle onTap for Favorite
        print('Drivers tapped');
      },
      backgroundColor: Colors.white, // Assign a unique color for each item
    ),
    GridItem(
      icon: Icons.bus_alert,
      name: 'Claims',
      onTap: () {
        // Handle onTap for Favorite
        print('Claims tapped');
      },
      backgroundColor: Colors.white, // Assign a unique color for each item
    ),
    // Add more GridItems as needed
  ];






  MapController _mapController = MapController();
  MapLeaflet _mapLeaflet = MapLeaflet();




  @override
  Widget build(BuildContext context) {


    List imgList = ['Flutter', 'Ract Native', 'Python', 'C#'];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          color: Colors.white ,
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(70)),
                    color: Colors.teal,
                  ),
                  child: Row(
                    children: [
                      // Second column for the text content, image, and subtitle
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 0),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 40),
                              title: Text(
                                'Hello !',
                                style: Theme.of(context).textTheme.headline6?.copyWith(
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
                                    ?.copyWith(color: Colors.white54),
                              ),
                            ),
                            const SizedBox(height: 0),
                          ],
                        ),
                      ),

                      // Image column
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('assets/images/img/pdp.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(),
                  child: Column(

                    children: [
                      Container(
                        child: Container(
                          color: Colors.teal,
                          child: Container(

                            padding: const EdgeInsets.only(top: 30, left: 30, right: 30,bottom: 0),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(70)),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  child:
                                  Text(
                                    'Menu', // Replace with the desired text
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(31, 48, 97, 1),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  padding: EdgeInsets.only(right: 40,left: 40),
                                  height: 1, // Add a green line of height 2 pixels
                                  color: Colors.teal,
                                ),

                                GridView.count(
                                  padding: EdgeInsets.only(left: 15,right: 15,top: 20),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 0,
                                  children: gridItems.map((item) {
                                    return GestureDetector(
                                      onTap: item.onTap,
                                      child: itemDashboard(
                                          item.name, item.icon, item.backgroundColor),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Orders today",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(31, 48, 97, 1)
                                      ),
                                    ),
                                    Text(
                                      "See All",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.teal.shade300,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                GridView.count(
                  padding: EdgeInsets.only(left: 15,right: 15,top: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio:
                  (MediaQuery.of(context).size.height - 50 - 25)/ ( 4 * 240),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: gridItems2.map((item) {
                    return GestureDetector(
                      onTap: item.onTap,
                      child: itemOrder(
                          item.name, item.icon, item.backgroundColor),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20,),
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
          color: backgroundColor,
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
              color: Color.fromRGBO(31, 48, 97, 1), // Set icon color to white
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: Color.fromRGBO(31, 48, 97, 1)),
            ),
          ],
        ),
      );


  Widget itemOrder(String title, IconData icon, Color backgroundColor) =>
      Container(

        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
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
              'assets/images/icons/mapicon.png', // Replace with the actual path to your image
              width: 50, // Set the width as per your requirement
              height: 50, // Set the height as per your requirement
             // Set image color to white
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FlutterMap(

                options: MapOptions(
                  center: LatLng(34.0812055063, 9.417373468231718),
                  zoom: 5,
                  interactionOptions: InteractionOptions(enableScrollWheel: false,enableMultiFingerGestureRace: false,debugMultiFingerGestureWinner: false,), // Disable all user interaction
                  enableMultiFingerGestureRace: false,
                  enableScrollWheel: false,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    additionalOptions: {
                      'userAgent': 'com.example.app',
                    },
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
