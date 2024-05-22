import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:supplychaintracking/Models/Driver.dart';
import 'package:supplychaintracking/Models/Order.dart';
import 'package:supplychaintracking/ViewModel/DriverViewModel.dart';
import 'package:supplychaintracking/ViewModel/OrderViewModel.dart';
import 'package:supplychaintracking/Views/DriverView/ListDrivers.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';
import 'package:supplychaintracking/Views/Widgets/line_edit.dart';

class DetailsOrder extends StatefulWidget {
  final dynamic order;
  DetailsOrder(this.order);

  @override
  _DetailsOrderState createState() => _DetailsOrderState();
}

class _DetailsOrderState extends State<DetailsOrder> {
  bool dateOrdersNotEmpty = false;
  bool productOrdersNotEmpty = true;
  bool weightOrdersNotEmpty = true;
  bool unitProductNotEmpty = true;
  bool startingPointNotEmpty = true;
  bool arrivalPointNotEmpty = true;
  bool estimationNotEmpty = true;
  bool statusNotEmpty=true;


  bool editEtat = true;


  OrderViewModel orderViewModel = OrderViewModel();

  // Define controllers for each text field
  TextEditingController dateOrdersController = TextEditingController(text: '');

  TextEditingController productOrdersController = TextEditingController(text: '');
  TextEditingController weightOrdersController = TextEditingController(text: '');
  TextEditingController unitProductController = TextEditingController(text: '');
  TextEditingController startingPointController = TextEditingController(text: '');
  TextEditingController arrivalPointController = TextEditingController(text: '');
  TextEditingController estimationController = TextEditingController(text: '');
  TextEditingController statusController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();

    dateOrdersController = TextEditingController(text:  widget.order['dateOrders']);
    productOrdersController = TextEditingController(text: widget.order['productOrders']);
    weightOrdersController = TextEditingController(text: widget.order['weightOrders'].toString());
    unitProductController = TextEditingController(text: widget.order['unitProduct']);
    startingPointController = TextEditingController(text: widget.order['startingPoint']);
    arrivalPointController = TextEditingController(text: widget.order['arrivalPoint']);
    estimationController = TextEditingController(text: widget.order['estimation']);
    statusController = TextEditingController(text: widget.order['status']);

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorTheme.backgroundNormalColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.order['status'],
          style: TextStyle(color: ColorTheme.titleAppBarColor,),
        ),
        backgroundColor: ColorTheme.homeTopColor,
        leading: Padding(
          padding: const EdgeInsets.only(),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: ColorTheme.titleAppBarColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          IconButton(
            color: ColorTheme.titleAppBarColor,
            icon: Icon(Icons.delete, size: 30),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirm Delete"),
                    content: Text("Are you sure you want to delete this driver?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          /*
                          if(await driverViewModel.deleteDriver(widget._driver.userNumber)){

                          }
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ListDrivers()), // Navigate to ListDrivers screen
                          );
                          print('hello');*/
                        },
                        child: Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
          ),

        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(),
          ),
          Container(
            width: width,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*Container(
                          margin: EdgeInsets.only(top: 15),
                          padding: EdgeInsets.all(1),
                          width: 125, // Example width
                          height: 125, // Example height
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            shape: BoxShape.circle, // Set shape to circle
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(31, 48, 97, .3),
                                spreadRadius: 10,
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Container(
                            child: ClipOval(
                              child: Image.memory(
                                Uint8List.fromList(widget._driver.photo),
                                fit: BoxFit.cover,
                                width: 120, // Example width
                                height: 120, // Example height
                              ),
                            ),
                          )),*/
                      Container(
                        width: width,
                        height: height,
                        padding: EdgeInsets.only(right: 30, left: 45, top: 20),
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            LineEdit(title: dateOrdersController.text, icon: Icons.calendar_month, readOnly: true),
                            SizedBox(height: 15),
                            LineEdit(title: productOrdersController.text, icon: Icons.production_quantity_limits_sharp, readOnly: true),
                            SizedBox(height: 15),
                            LineEdit(title: weightOrdersController.text, icon: FontAwesomeIcons.weightHanging, readOnly: true),
                            SizedBox(height: 15),
                            LineEdit(title: startingPointController.text, icon: Icons.arrow_forward, readOnly: true),
                            SizedBox(height: 15),
                            LineEdit(title: arrivalPointController.text, icon: Icons.arrow_back, readOnly: true),
                            SizedBox(height: 15),
                            LineEdit(title: estimationController.text, icon: Icons.access_time_filled, readOnly: true),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              children: [
                Visibility(
                  visible: !editEtat,
                  child: InkWell(
                    child: Visibility(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 100), // Adjust the left margin as needed
                        height: 55,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save,
                              color: ColorTheme.backgroundNormalColor,
                            ),
                            SizedBox(
                                width:
                                8), // Adding some space between icon and text
                            Text(
                              'Save',
                              style: TextStyle(
                                color: ColorTheme.backgroundNormalColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width-200), // Add some space between buttons
                IconButton(
                  icon: Icon(Icons.edit,color: ColorTheme.backgroundNormalColor),
                  onPressed: () {
                    // Implement edit functionality here
                    setState(() {
                      editEtat = !editEtat;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.edit,color: ColorTheme.backgroundNormalColor),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
