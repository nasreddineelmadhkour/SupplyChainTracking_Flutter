import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:supplychaintracking/Network/BaseURL.dart';
import 'package:supplychaintracking/ViewModel/ClaimViewModel.dart';
import 'package:supplychaintracking/ViewModel/OrderViewModel.dart';
import 'package:supplychaintracking/Views/DriverView/AddDriver.dart';
import 'package:supplychaintracking/Views/HomeView/navBar.dart';
import 'package:supplychaintracking/Views/OrderView/DetailsOrder.dart';
import 'package:supplychaintracking/Views/OrderView/TrackingOrders.dart';
import 'package:supplychaintracking/Views/OrderView/addOrder.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';
import 'package:web_socket_channel/io.dart';

class ListClaimsForDriver extends StatefulWidget {
  @override
  _ListClaimsForDriverState createState() => _ListClaimsForDriverState();
}

class _ListClaimsForDriverState extends State<ListClaimsForDriver> {
  ClaimViewModel claimViewModel = ClaimViewModel();
  TextEditingController       descriptionController = TextEditingController(text: "");


  late StompClient _stompClient; // Declare as late
  List<String> messages = [];

  late dynamic orderChangeSocket;
  int pageOrderToday = 1, pageOther = 1;

  final OrderViewModel orderViewModel = OrderViewModel();
  late Future<List<dynamic>> _futureOrders;
  late Future<List<dynamic>> _futureOrdersToday;

  late TextEditingController _searchController;
  late List<dynamic> orders; // List to store drivers
  late List<dynamic> ordersToday; // List to store drivers

  bool _isGridView = false; // Track current view type

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _futureOrders = claimViewModel.getClaimsByDriver();

    orders = []; // Initialize the list
    _fetchOrders(); // Fetch drivers when the widget initializes

  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method to fetch drivers
  Future<void> _fetchOrders() async {
    try {
      final _orders = await _futureOrders;

      setState(() {
        orders = _orders; // Update the list of drivers
      });
    } catch (error) {
      print('Error fetching drivers: $error');
      // Handle error as needed
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Text(
            "MY CLAIMS",
            style: TextStyle(color: ColorTheme.titleAppBarColor),
          ),
        ),
        centerTitle: true, // Center the title
        backgroundColor: ColorTheme.homeTopColor,
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorTheme.titleAppBarColor,
            ),
            color: ColorTheme.titleAppBarColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          /* Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              icon: Icon(Icons.search),
              color: ColorTheme.titleAppBarColor,
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: OrderSearchDelegate(orders),
                ); // Pass the list of drivers
              },
            ),
          ),*/
        ],
      ),
      body: Container(
        color: ColorTheme.backgroundNormalColor,
        child:_buildListView(),
      ),

    );
  }

  Widget _buildListView() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // Navigating back to HomePage when user tries to exit
        print("Back To Home");
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => NavBar()),
        );
        return true; // Prevents the app from being closed
      },
      child: Column(
        children: [
          SizedBox(height: 10), // Add space of height 10
          Visibility(
            child: Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return
                    Card(
                      margin: EdgeInsets.only(left: 0, right: 0, bottom: 5),
                      color: ColorTheme.colorBackgroundCard,
                      child:
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 0), // Add spacing between image and ListTile
                          Expanded(
                            child: SingleChildScrollView(
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orders[index]['productOrders'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColorTheme.smalTitleColor,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      orders[index]['dateOrders']
                                          .toString()
                                          .substring(0, 10) +
                                          " " +
                                          orders[index]['dateOrders']
                                              .toString()
                                              .substring(11, 16),
                                      style: TextStyle(
                                          color: ColorTheme.smalTitleColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(FontAwesomeIcons.arrowUp,
                                                size: 10),
                                            if (orders[index]['startingPoint']
                                                .toString()
                                                .length >
                                                18)
                                              Text(
                                                  " " +
                                                      orders[index]
                                                      ['startingPoint']
                                                          .toString()
                                                          .substring(0, 18) +
                                                      "...",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey)),
                                            if (orders[index]['startingPoint']
                                                .toString()
                                                .length <=
                                                18)
                                              Text(
                                                  " " +
                                                      orders[index]
                                                      ['startingPoint']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(FontAwesomeIcons.arrowDown,
                                                size: 10),
                                            if (orders[index]['arrivalPoint']
                                                .toString()
                                                .length >
                                                18)
                                              Text(
                                                  " " +
                                                      orders[index]
                                                      ['arrivalPoint']
                                                          .toString()
                                                          .substring(0, 18) +
                                                      "...",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey)),
                                            if (orders[index]['arrivalPoint']
                                                .toString()
                                                .length <=
                                                18)
                                              Text(
                                                  " " +
                                                      orders[index]
                                                      ['arrivalPoint']
                                                          .toString()
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          orders[index]['driver']['name'],
                                          style: TextStyle(color: Colors.teal),
                                        ),
                                        if (orders[index]['status'].toString() ==
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
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Icon(Icons.schedule_send,
                                                  color: Colors.green, size: 15),
                                            ],
                                          ),
                                        if (orders[index]['status'].toString() ==
                                            "PENDING")
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                orders[index]['status'] + " ",
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Icon(Icons.pending,
                                                  color: Colors.orange, size: 15),
                                            ],
                                          ),
                                        if (orders[index]['status'].toString() ==
                                            "COMPLETED")
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                orders[index]['status'] + " ",
                                                style: TextStyle(
                                                    color: Colors.teal,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Icon(Icons.verified,
                                                  color: Colors.teal, size: 15),
                                            ],
                                          ),
                                        if (orders[index]['status'].toString() ==
                                            "CANCELED")
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                orders[index]['status'] + " ",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Icon(Icons.cancel_rounded,
                                                  color: Colors.red, size: 15),
                                            ],
                                          ),
                                        if (orders[index]['status'].toString() ==
                                            "DELAYED")
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                orders[index]['status'] + " ",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold),
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

                                    SizedBox(height: 20,),
                                    TextFormField(
                                      readOnly: true,
                                      cursorColor: ColorTheme.principalTeal,
                                      style: TextStyle(color: ColorTheme.principalTeal),
                                      textAlignVertical: TextAlignVertical.top,
                                      decoration: InputDecoration(
                                        counterText: orders[index]['reclamation']['dateReclamation'].toString().substring(0,10) +" "+
                                            orders[index]['reclamation']['dateReclamation'].toString().substring(11,16),
                                        counterStyle: TextStyle(fontWeight: FontWeight.bold),
                                        hintText: orders[index]['reclamation']['description'],
                                        hintStyle:  TextStyle(color: ColorTheme.principalTeal , fontSize: 12),
                                        filled: false,
                                        helperText: orders[index]['reclamation']['statusReclamation'] == "NOT_RESOLVED" ? "NOT_RESOLVED":"RESOLVED",
                                        helperStyle: TextStyle(fontWeight: FontWeight.bold),
                                        fillColor: ColorTheme.colorBackgroundCard,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorTheme.smalTitleColor),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.description,
                                          color: Colors.grey,
                                          size: 25,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        contentPadding: EdgeInsets.only( top: 100.0, right: 0.0, bottom: 8.0), // Adjust padding
                                      ),
                                    ),


                                  ],
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                ),


                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                },
              ),
            ),
          ),
          // Add space of height 10
          SizedBox(height: height / 12), // Add space of height 10
        ],
      ),
    );
  }
}
