import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supplychaintracking/Models/Driver.dart';
import 'package:supplychaintracking/Models/StaticMethode.dart';
import 'package:supplychaintracking/ViewModel/AccountViewModel.dart';
import 'package:supplychaintracking/ViewModel/DriverViewModel.dart';
import 'package:supplychaintracking/Views/OrderView/widget/textField.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class EditOrderInfo2 extends StatefulWidget {
  final dynamic order;
  EditOrderInfo2(this.order);

  @override
  _EditOrderInfo2State createState() => _EditOrderInfo2State();
}

class _EditOrderInfo2State extends State<EditOrderInfo2> {
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
        int driverNumber = widget.order['driver']['userNumber'];
        print(widget.order);
        selectedDriver = drivers.firstWhere(
              (driver) => driver.userNumber == driverNumber,
        //  orElse: () => null,
        );
      });
    } catch (error) {
      print('Error fetching drivers: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedDriver != null) {

      serialNumberController.text = selectedDriver!.serialNumber.toString();
      cardNumberController.text = selectedDriver!.cardNumber.toString();
      StaticMethode.staticOrder.driverNumber = selectedDriver!.userNumber;
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
                _nameNotEmpty = selected.name.isNotEmpty;
                selectedDriver = selected;
              });
            },
            fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController ,
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

                  onChanged: (value) {
                    setState(() {
                      _nameNotEmpty = value.isNotEmpty;
                    });
                  },
                  controller: textEditingController,
                  focusNode: focusNode,

                  onFieldSubmitted: (value) {
                    onFieldSubmitted();
                  },
                  style: TextStyle(color: ColorTheme.principalTeal),

                  decoration: InputDecoration(

                    prefixIcon: Icon(FontAwesomeIcons.solidUser, color: ColorTheme.smalTitleColor),
                    hintText: "Name",
                    labelText: selectedDriver!.name,
                    labelStyle: TextStyle(color: ColorTheme.principalTeal),
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
              style: TextStyle(color: ColorTheme.principalTeal),
              readOnly: true,
              controller: serialNumberController,
              decoration: InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.trailer, color: ColorTheme.smalTitleColor),
                hintText: "Serial Number",
                hintStyle: TextStyle(color: ColorTheme.smalTitleColor),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
                color: Colors.grey.withOpacity(.3),
                borderRadius: BorderRadius.circular(15)),
            child: TextFormField(
              style: TextStyle(color: ColorTheme.principalTeal),
              readOnly: true,
              controller: cardNumberController,
              decoration: InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.solidIdCard, color: ColorTheme.smalTitleColor),
                hintText: "Card Number",
                hintStyle: TextStyle(color: ColorTheme.smalTitleColor),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(height: 15),
          // Add your other widgets here
        ],
      ),
    );
  }
}
