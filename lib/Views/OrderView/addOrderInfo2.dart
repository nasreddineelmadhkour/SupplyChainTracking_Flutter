import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supplychaintracking/Models/Driver.dart';
import 'package:supplychaintracking/Models/StaticMethode.dart';
import 'package:supplychaintracking/ViewModel/AccountViewModel.dart';
import 'package:supplychaintracking/ViewModel/DriverViewModel.dart';
import 'package:supplychaintracking/Views/OrderView/widget/textField.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class AddOrderInfo2 extends StatefulWidget {
  @override
  _AddOrderInfo2State createState() => _AddOrderInfo2State();
}

class _AddOrderInfo2State extends State<AddOrderInfo2> {
  DriverViewModel driverViewModel = DriverViewModel();
  List<Driver> drivers = [];
  Driver? selectedDriver;
  TextEditingController serialNumberController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();

  bool _nameNotEmpty = true;


  @override
  void initState() {
    super.initState();
    _getDrivers();
  }

  Future<void> _getDrivers() async {
    try {
      List<Driver> fetchedDrivers = await driverViewModel.getDriverByCarrier();
      setState(() {
        drivers = fetchedDrivers;
      });
    } catch (error) {
      print('Error fetching drivers: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedDriver != null) {
      serialNumberController.text = selectedDriver!.serialNumber.toString();
    }
    if(selectedDriver != null) {
      cardNumberController.text = selectedDriver!.cardNumber.toString();
    }
    if(selectedDriver != null) {
      StaticMethode.staticOrder.driverNumber = selectedDriver!.userNumber;
      print(StaticMethode.staticOrder.driverNumber);
    }
    return Container(
      color: ColorTheme.colorBackgroundCard,
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Autocomplete<Driver>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              return drivers
                  .where((driver) => driver.name
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()))
                  .toList();
            },
            onSelected: (Driver selected) {
              setState(() {
                _nameNotEmpty= selected.name.isNotEmpty;
                selectedDriver = selected;
              });
            },
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: _nameNotEmpty ? Colors.teal : Colors.red),
                  color: Colors.grey.withOpacity(.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  onChanged: (value)=>{
                  setState((){

                  }),
                  _nameNotEmpty = value.isNotEmpty,
                  },
                  controller: textEditingController,
                  focusNode: focusNode,
                  onFieldSubmitted: (value) {
                    onFieldSubmitted();
                  },
                  style:
                      TextStyle(fontSize: 16), // Adjust the font size as needed
                  decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.solidUser,color: ColorTheme.smalTitleColor),
                    hintText: "Name",
                    hintStyle: TextStyle(color: ColorTheme.smalTitleColor),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              );
            },
            displayStringForOption: (Driver driver) => driver.name,
          ),

          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
                color: Colors.grey.withOpacity(.3),
                borderRadius: BorderRadius.circular(15)),
            child: TextFormField(
              readOnly: true,
              controller: serialNumberController,
              decoration: InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.trailer,color: ColorTheme.smalTitleColor),
                hintText: "Serial Number",
                hintStyle: TextStyle(color: ColorTheme.smalTitleColor),

                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),

          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
                color: Colors.grey.withOpacity(.3),
                borderRadius: BorderRadius.circular(15)),
            child: TextFormField(
              readOnly: true,
              controller: cardNumberController,
              decoration: InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.solidIdCard,color: ColorTheme.smalTitleColor),
                hintText: "Card Number",
                hintStyle: TextStyle(color: ColorTheme.smalTitleColor),

                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),

          SizedBox(
            height: 15,
          ),
          // Add your other widgets here
        ],
      ),
    );
  }
}
