import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:supplychaintracking/Network/BaseURL.dart';
import 'package:supplychaintracking/ViewModel/OrderViewModel.dart';
import 'package:supplychaintracking/Views/DriverView/AddDriver.dart';
import 'package:supplychaintracking/Views/HomeView/navBar.dart';
import 'package:supplychaintracking/Views/OrderView/DetailsOrder.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';
import 'package:web_socket_channel/io.dart';

class ListOrders extends StatefulWidget {
  @override
  _ListOrdersState createState() => _ListOrdersState();
}

class _ListOrdersState extends State<ListOrders> {

  late StompClient _stompClient;  // Declare as late
  List<String> messages = [];

  late dynamic orderChangeSocket;



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
    _futureOrders = orderViewModel.getOrderByCarrier();
    _futureOrdersToday = orderViewModel.getOrderByCarrierToday();
    orders = []; // Initialize the list
    _fetchOrders(); // Fetch drivers when the widget initializes
    _fetchOrdersToday();
    _connectToWebSocket();
  }


  void _connectToWebSocket() {
    _stompClient =
        StompClient(
          config: StompConfig(
            url: BaseURL.baseURL_WS,
            onConnect: _onConnect,
            onStompError: (error) {
              print('STOMP Error occurred: $error');
            },
            onWebSocketError: (error) {
              print('WebSocket Error occurred: $error');
            },
          ),
        );

    _stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    _stompClient.subscribe(
      destination: '/orderStatus/1', // Update with your subscription topic
      callback: (frame) {
        Map<String, dynamic> result = json.decode(frame.body!);  // Add null check with '!'
        setState(() {

          orderChangeSocket= json.decode(frame.body!);
          for (int i = 0; i < orders.length; i++) {
            if(orders[i]['ordersNumber']==orderChangeSocket['ordersNumber'])
              {
                orders[i]['status']=orderChangeSocket['status'];
              }

          }
        });
      },
    );
  }

  /*
  void _sendMessage(String message) {
    if (_stompClient.connected) {
      if (message.isNotEmpty) {
        _stompClient.send(
          destination: '/app/chat/1', // Update with your destination
          body: json.encode({'message': message, 'user': 'User'}),
        );
        _controller.clear();
      }
    } else {
      print('WebSocket connection is not established.');
      // You can attempt to reconnect here or display an error message to the user.
    }
  }*/


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

  // Method to toggle between grid and list view
  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Text(
            "LIST ORDERS",
            style: TextStyle(color: ColorTheme.titleAppBarColor),
          ),
        ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_on),
            onPressed: _toggleView,
            color: ColorTheme.titleAppBarColor,
          ),
        ],
      ),
      body: Container(
        color: ColorTheme.backgroundNormalColor,
        child: _isGridView ? _buildGridView() : _buildListView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen to add a new driver
          // Replace `AddDriverScreen` with the screen where you add a new driver
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddDriver()));
        },
        child: Icon(Icons.add, color: ColorTheme.backgroundNormalColor),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildListView() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return
      WillPopScope(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.only(right: width/3),
                  child: Text(
                    "Orders today",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: ColorTheme.smalTitleColor),
                  ),
                )
                ,
                Container(

                  child: Text(
                  "",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: ColorTheme.smalTitleColor),
                ),)

              ],
            ),

            SizedBox(height: 10), // Add space of height 10
            Container(
              width: width-width/11,
              height: 2, // Adjust the height of the line as needed
              color: ColorTheme.colorIconNav, // Set the color to red
            ),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(left:20,right : 15,bottom: 5),
                    color: ColorTheme.colorBackgroundCard,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 0), // Add spacing between image and ListTile
                        Expanded(
                          child: SingleChildScrollView(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    orders[index]['productOrders'],
                                    style: TextStyle(fontWeight: FontWeight.bold, color: ColorTheme.smalTitleColor,fontSize: 20),
                                  ),
                                  Text(
                                    orders[index]['dateOrders'].toString().substring(0, 10) +
                                        " " +
                                        orders[index]['dateOrders'].toString().substring(12, 16),
                                    style: TextStyle(color: ColorTheme.smalTitleColor, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(FontAwesomeIcons.arrowUp, size: 10),
                                          if(orders[index]['startingPoint'].toString().length>18)
                                            Text(" " + orders[index]['startingPoint'].toString().substring(0,18)+"...", style: TextStyle(fontSize: 11,color: Colors.grey)),
                                          if(orders[index]['startingPoint'].toString().length<=18)
                                            Text(" " + orders[index]['startingPoint'].toString(), style: TextStyle(fontSize: 11,color: Colors.grey)),


                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(FontAwesomeIcons.arrowDown, size: 10),
                                          if(orders[index]['arrivalPoint'].toString().length>18)
                                            Text(" " + orders[index]['arrivalPoint'].toString().substring(0,18)+"...", style: TextStyle(fontSize: 11,color: Colors.grey)),
                                          if(orders[index]['arrivalPoint'].toString().length<=18)
                                            Text(" " + orders[index]['arrivalPoint'].toString().toString(), style: TextStyle(fontSize: 11,color: Colors.grey)),


                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(orders[index]['driver']['name'],style: TextStyle(color: Colors.teal),),
                                      if (orders[index]['status'].toString() == "IN_PROGRESS")
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "IN PROGRESS" + " ",
                                              style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.schedule_send, color: Colors.green, size: 15),
                                          ],
                                        ),
                                      if (orders[index]['status'].toString() == "PENDING")
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              orders[index]['status'] + " ",
                                              style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.pending, color: Colors.orange, size: 15),
                                          ],
                                        ),
                                      if (orders[index]['status'].toString() == "COMPLETED")
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              orders[index]['status'] + " ",
                                              style: TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.verified, color: Colors.teal, size: 15),
                                          ],
                                        ),
                                      if (orders[index]['status'].toString() == "CANCELED")
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              orders[index]['status'] + " ",
                                              style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.cancel_rounded, color: Colors.red, size: 15),
                                          ],
                                        ),
                                      if (orders[index]['status'].toString() == "DELAYED")
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              orders[index]['status'] + " ",
                                              style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.replay_circle_filled_sharp, color: Colors.grey, size: 15),
                                          ],
                                        ),
                                    ],
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                              leading: Icon(
                                Icons.arrow_forward_ios,
                                color: ColorTheme.smalTitleColor,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DetailsOrder(orders[index])),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20), // Add space of height 10

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.only(right: width/3),
                  child:
                Text(
                  "Other       ",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: ColorTheme.smalTitleColor),
                ),
                ),
                Container(

                  child: Text(
                    "Filter",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ColorTheme.hintTitleColor,
                    ),
                  ),
                )

              ],
            ),
            SizedBox(height: 10), // Add space of height 10
            Container(
              width: width-width/11,
              height: 2, // Adjust the height of the line as needed
              color: ColorTheme.colorIconNav, // Set the color to red
            ),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(left:20,right : 15,bottom: 5),
                    color: ColorTheme.colorBackgroundCard,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 0), // Add spacing between image and ListTile
                        Expanded(
                          child: SingleChildScrollView(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    orders[index]['productOrders'],
                                    style: TextStyle(fontWeight: FontWeight.bold, color: ColorTheme.smalTitleColor,fontSize: 20),
                                  ),
                                  Text(
                                    orders[index]['dateOrders'].toString().substring(0, 10) +
                                        " " +
                                        orders[index]['dateOrders'].toString().substring(12, 16),
                                    style: TextStyle(color: ColorTheme.smalTitleColor, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(FontAwesomeIcons.arrowUp, size: 10),
                                          if(orders[index]['startingPoint'].toString().length>18)
                                          Text(" " + orders[index]['startingPoint'].toString().substring(0,18)+"...", style: TextStyle(fontSize: 11,color: Colors.grey)),
                                          if(orders[index]['startingPoint'].toString().length<=18)
                                            Text(" " + orders[index]['startingPoint'].toString(), style: TextStyle(fontSize: 11,color: Colors.grey)),


                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(FontAwesomeIcons.arrowDown, size: 10),
                                          if(orders[index]['arrivalPoint'].toString().length>18)
                                            Text(" " + orders[index]['arrivalPoint'].toString().substring(0,18)+"...", style: TextStyle(fontSize: 11,color: Colors.grey)),
                                          if(orders[index]['arrivalPoint'].toString().length<=18)
                                            Text(" " + orders[index]['arrivalPoint'].toString().toString(), style: TextStyle(fontSize: 11,color: Colors.grey)),


                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(orders[index]['driver']['name'],style: TextStyle(color: Colors.teal),),
                                      if (orders[index]['status'].toString() == "IN_PROGRESS")
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "IN PROGRESS" + " ",
                                              style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.schedule_send, color: Colors.green, size: 15),
                                          ],
                                        ),
                                      if (orders[index]['status'].toString() == "PENDING")
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              orders[index]['status'] + " ",
                                              style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.pending, color: Colors.orange, size: 15),
                                          ],
                                        ),
                                      if (orders[index]['status'].toString() == "COMPLETED")
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              orders[index]['status'] + " ",
                                              style: TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.verified, color: Colors.teal, size: 15),
                                          ],
                                        ),
                                      if (orders[index]['status'].toString() == "CANCELED")
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              orders[index]['status'] + " ",
                                              style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.cancel_rounded, color: Colors.red, size: 15),
                                          ],
                                        ),
                                      if (orders[index]['status'].toString() == "DELAYED")
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              orders[index]['status'] + " ",
                                              style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.replay_circle_filled_sharp, color: Colors.grey, size: 15),
                                          ],
                                        ),
                                    ],
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                              leading: Icon(
                                Icons.arrow_forward_ios,
                                color: ColorTheme.smalTitleColor,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DetailsOrder(orders[index])),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ), // Add space of height 10
            SizedBox(height: height/12), // Add space of height 10

          ],
        ),
      );

  }

  Widget _buildGridView() {
    return
      WillPopScope(
        onWillPop: () async {
          // Navigating back to HomePage when user tries to exit
          print("Back To Home");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => NavBar()),
          );
          return true; // Prevents the app from being closed
        },
        child: Column(
          children: [


            SizedBox(height: 10), // Add space of height 10
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(left: 10, right: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:
                  (MediaQuery.of(context).size.height - 300) / (4 * 160),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 5,
                ),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  dynamic order = orders[index];
                  return GridTile(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsOrder(order)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.transparent,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 5),
                                color: Color.fromRGBO(31, 48, 97, .1),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Card(
                            color: ColorTheme.colorBackgroundCard,
                            elevation:
                            0, // Set elevation to 0 to prevent default shadow
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /*
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  padding: EdgeInsets.all(3),
                                  width: 70, // Example width
                                  height: 70, // Example height
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    shape: BoxShape.circle, // Set shape to circle
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(31, 48, 97, .2),
                                        spreadRadius: 2,
                                        blurRadius: 15,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.memory(
                                      Uint8List.fromList(orders[index].photo),
                                      fit: BoxFit.cover,
                                      width: 70, // Example width
                                      height: 70, // Example height
                                    ),
                                  ),
                                ),*/
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    orders[index]['dateOrders'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: ColorTheme.smalTitleColor),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    orders[index]['arrivalPoint'],
                                    style: TextStyle(color: ColorTheme.smalTitleColor),
                                  ),
                                ),
                                Container(
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: ColorTheme.smalTitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      );


  }
}

class OrderSearchDelegate extends SearchDelegate<dynamic> {
  final List<dynamic> orders; // List of drivers
  late List<dynamic> filteredOrders; // List to store filtered drivers

  OrderSearchDelegate(this.orders) {
    filteredOrders =
        orders; // Initialize filtered drivers with all drivers initially
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          filteredOrders =
              orders; // Reset filtered drivers when the search is cleared
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: ColorTheme.titleAppBarColor),
      onPressed: () {
        close(context,
            orders.first); // Close with null as there's no selected driver
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10), // Add space of height 10
        Expanded(
          child: ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              return Card(
                color: ColorTheme.colorBackgroundCard,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Container(
                      padding: EdgeInsets.all(3),
                      width: 70, // Example width
                      height: 70, // Example height
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Set shape to circle
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(31, 48, 97, .2),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.memory(
                          Uint8List.fromList(filteredOrders[index].photo),
                          fit: BoxFit.cover,
                          width: 70, // Example width
                          height: 70, // Example height
                        ),
                      ),
                    ),*/
                    SizedBox(
                        width: 16), // Add spacing between image and ListTile
                    Expanded(
                      child: ListTile(
                        title: Text(filteredOrders[index]['dateOrders']),
                        subtitle: Text(filteredOrders[index]['status']),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: ColorTheme.smalTitleColor),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsOrder(filteredOrders[index])),
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
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Filter the drivers based on the current query
    filteredOrders = query.isEmpty
        ? orders
        : orders
        .where((order) =>
        order['arrivalPoint'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Show suggestions while typing in the search bar
    return Container(
      color: ColorTheme.backgroundNormalColor,
      child: ListView.builder(
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          return Card(
            color: ColorTheme.colorBackgroundCard,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                /*Container(
                  padding: EdgeInsets.all(3),
                  width: 70, // Example width
                  height: 70, // Example height
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Set shape to circle
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(31, 48, 97, .2),
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.memory(
                      Uint8List.fromList(filteredOrders[index].photo),
                      fit: BoxFit.cover,
                      width: 70, // Example width
                      height: 70, // Example height
                    ),
                  ),
                ),*/
                SizedBox(width: 16), // Add spacing between image and ListTile
                Expanded(
                  child: ListTile(
                    title: Text(filteredOrders[index]['dateOrders'],
                        style: TextStyle(color: ColorTheme.smalTitleColor)),
                    subtitle: Text(filteredOrders[index]['arrivalPoint']),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: ColorTheme.smalTitleColor),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailsOrder(filteredOrders[index])),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        color: ColorTheme.homeTopColor, // Change color of the app bar
        iconTheme: IconThemeData(
            color: ColorTheme.titleAppBarColor), // Change color of icons
      ),
      textTheme: theme.textTheme.copyWith(
        headline6: TextStyle(
          color: ColorTheme.smalTitleColor,
        ), // Change color of text
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: ColorTheme.smalTitleColor),
        fillColor: ColorTheme.colorBackgroundCard, // Color of the search bar
        filled: true,
        contentPadding: EdgeInsets.all(10), // Padding inside the search bar
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), // Adjust the radius here
          borderSide: BorderSide.none, // No border
        ),
      ),
    );
  }
}
