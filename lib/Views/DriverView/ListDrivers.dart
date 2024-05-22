import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supplychaintracking/Models/Driver.dart';
import 'package:supplychaintracking/ViewModel/DriverViewModel.dart';
import 'package:supplychaintracking/Views/DriverView/AddDriver.dart';
import 'package:supplychaintracking/Views/DriverView/DetailsDriver.dart';
import 'package:supplychaintracking/Views/HomeView/navBar.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class ListDrivers extends StatefulWidget {
  @override
  _ListDriversState createState() => _ListDriversState();
}

class _ListDriversState extends State<ListDrivers> {
  final DriverViewModel _driverViewModel = DriverViewModel();
  late Future<List<Driver>> _futureDrivers;
  late TextEditingController _searchController;
  late List<Driver> _drivers; // List to store drivers
  bool _isGridView = false; // Track current view type

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _futureDrivers = _driverViewModel.getDriverByCarrier();
    _drivers = []; // Initialize the list
    _fetchDrivers(); // Fetch drivers when the widget initializes
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method to fetch drivers
  Future<void> _fetchDrivers() async {
    try {
      final drivers = await _futureDrivers;
      setState(() {
        _drivers = drivers; // Update the list of drivers
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
            "LIST DRIVERS",
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
                  delegate: DriverSearchDelegate(_drivers),
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
            Expanded(
              child: ListView.builder(
                itemCount: _drivers.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: ColorTheme.colorBackgroundCard,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
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
                              Uint8List.fromList(_drivers[index].photo),
                              fit: BoxFit.cover,
                              width: 70, // Example width
                              height: 70, // Example height
                            ),
                          ),
                        ),
                        SizedBox(
                            width: 16), // Add spacing between image and ListTile
                        Expanded(
                          child: ListTile(
                              title: Text(
                                _drivers[index].name,
                                style: TextStyle(color: ColorTheme.smalTitleColor),
                              ),
                              subtitle: Text(_drivers[index].cardNumber),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: ColorTheme.smalTitleColor,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsDriver(_drivers[index])),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
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
                itemCount: _drivers.length,
                itemBuilder: (context, index) {
                  Driver driver = _drivers[index];
                  return GridTile(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsDriver(driver)),
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
                                      Uint8List.fromList(_drivers[index].photo),
                                      fit: BoxFit.cover,
                                      width: 70, // Example width
                                      height: 70, // Example height
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    _drivers[index].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: ColorTheme.smalTitleColor),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    _drivers[index].cardNumber,
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

class DriverSearchDelegate extends SearchDelegate<Driver> {
  final List<Driver> drivers; // List of drivers
  late List<Driver> filteredDrivers; // List to store filtered drivers

  DriverSearchDelegate(this.drivers) {
    filteredDrivers =
        drivers; // Initialize filtered drivers with all drivers initially
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          filteredDrivers =
              drivers; // Reset filtered drivers when the search is cleared
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
            drivers.first); // Close with null as there's no selected driver
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
            itemCount: filteredDrivers.length,
            itemBuilder: (context, index) {
              return Card(
                color: ColorTheme.colorBackgroundCard,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                          Uint8List.fromList(filteredDrivers[index].photo),
                          fit: BoxFit.cover,
                          width: 70, // Example width
                          height: 70, // Example height
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 16), // Add spacing between image and ListTile
                    Expanded(
                      child: ListTile(
                        title: Text(filteredDrivers[index].name),
                        subtitle: Text(filteredDrivers[index].cardNumber),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: ColorTheme.smalTitleColor),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsDriver(filteredDrivers[index])),
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
    filteredDrivers = query.isEmpty
        ? drivers
        : drivers
            .where((driver) =>
                driver.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    // Show suggestions while typing in the search bar
    return Container(
      color: ColorTheme.backgroundNormalColor,
      child: ListView.builder(
        itemCount: filteredDrivers.length,
        itemBuilder: (context, index) {
          return Card(
            color: ColorTheme.colorBackgroundCard,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Container(
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
                      Uint8List.fromList(filteredDrivers[index].photo),
                      fit: BoxFit.cover,
                      width: 70, // Example width
                      height: 70, // Example height
                    ),
                  ),
                ),
                SizedBox(width: 16), // Add spacing between image and ListTile
                Expanded(
                  child: ListTile(
                    title: Text(filteredDrivers[index].name,
                        style: TextStyle(color: ColorTheme.smalTitleColor)),
                    subtitle: Text(filteredDrivers[index].cardNumber),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: ColorTheme.smalTitleColor),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailsDriver(filteredDrivers[index])),
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
