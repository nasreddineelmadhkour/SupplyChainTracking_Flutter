import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:supplychaintracking/Models/Driver.dart';
import 'package:supplychaintracking/ViewModel/DriverViewModel.dart';
import 'package:supplychaintracking/Views/DriverView/ListDrivers.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class DetailsDriver extends StatefulWidget {
  final Driver _driver;
  DetailsDriver(this._driver);

  @override
  _DetailsDriverState createState() => _DetailsDriverState();
}

class _DetailsDriverState extends State<DetailsDriver> {
  bool _showPassword = false;
  bool _nameNotEmpty = true;
  bool _emailNotEmpty = true;
  bool _phoneNotEmpty = true;
  bool _passwordNotEmpty = true;
  bool _serialcodeNotEmpty = true,
      _cardNotEmpty = true;
  String isP = "false";
  bool editEtat = true;
  DriverViewModel driverViewModel = DriverViewModel();
  int status = 0;

  // Define controllers for each text field
  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _phoneController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
  TextEditingController _serialcodeController = TextEditingController(text: '');
  TextEditingController _cardController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget._driver.name);
    _emailController = TextEditingController(text: widget._driver.email);
    _phoneController = TextEditingController(text: widget._driver.phoneNumber);
    _passwordController = TextEditingController(text: widget._driver.password);
    _serialcodeController =
        TextEditingController(text: widget._driver.serialNumber);
    _cardController = TextEditingController(text: widget._driver.cardNumber);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: ColorTheme.backgroundNormalColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget._driver.name,
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListDrivers()),
              );
            },
          ),
        ),
        actions: [
          IconButton(
            color: ColorTheme.titleAppBarColor,
            icon: Icon(Icons.delete, size: 30),
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirm Delete"),
                    content: Text(
                        "Are you sure you want to delete this driver : "+widget._driver.name+" ?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (await driverViewModel.deleteDriver(
                              widget._driver.userNumber)) {
                            Navigator.of(context).pop();

                          }


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
                      Container(
                          margin: EdgeInsets.only(top: 15),
                          padding: EdgeInsets.all(1),
                          width: 125,
                          // Example width
                          height: 125,
                          // Example height
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
                          )),
                      Container(
                        width: width,
                        height: height,
                        padding: EdgeInsets.only(right: 30, left: 45, top: 20),
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _nameNotEmpty
                                        ? Colors.teal
                                        : Colors.red),
                                color: ColorTheme.colorBackgroundCard,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(

                                readOnly: editEtat,
                                controller: _nameController,
                                style: TextStyle(
                                    color: ColorTheme.smalTitleColor),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.solidUser,
                                      color: ColorTheme.smalTitleColor),
                                  hintText: "Name",
                                  hintStyle: TextStyle(
                                      color: ColorTheme.smalTitleColor),

                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  errorText: _nameNotEmpty
                                      ? null
                                      : 'Name cannot be empty',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _nameNotEmpty = value.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _emailNotEmpty
                                        ? Colors.teal
                                        : Colors.red),
                                color: ColorTheme.colorBackgroundCard,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                    color: ColorTheme.smalTitleColor),

                                readOnly: editEtat,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.alternate_email,
                                      color: ColorTheme.smalTitleColor),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: ColorTheme.smalTitleColor),

                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  errorText: _emailNotEmpty
                                      ? null
                                      : 'Email cannot be empty',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _emailNotEmpty = value.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _phoneNotEmpty
                                        ? Colors.teal
                                        : Colors.red),
                                color: ColorTheme.colorBackgroundCard,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                    color: ColorTheme.smalTitleColor),

                                readOnly: editEtat,
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone,
                                      color: ColorTheme.smalTitleColor),
                                  hintText: "Phone Number",
                                  hintStyle: TextStyle(
                                      color: ColorTheme.smalTitleColor),

                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  errorText: _phoneNotEmpty
                                      ? null
                                      : 'Phone number cannot be empty',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _phoneNotEmpty = value.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _passwordNotEmpty
                                        ? Colors.teal
                                        : Colors.red),
                                color: ColorTheme.colorBackgroundCard,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                    color: ColorTheme.smalTitleColor),

                                readOnly: editEtat,
                                controller: _passwordController,
                                obscureText: !_showPassword,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock,
                                      color: ColorTheme.smalTitleColor),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: ColorTheme.smalTitleColor),

                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  suffixIcon: IconButton(
                                    icon: Icon(_showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                    color: ColorTheme.smalTitleColor
                                    ,
                                  ),
                                  errorText: _passwordNotEmpty
                                      ? null
                                      : 'Password cannot be empty',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _passwordNotEmpty = value.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _serialcodeNotEmpty
                                        ? Colors.teal
                                        : Colors.red),
                                color: ColorTheme.colorBackgroundCard,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                    color: ColorTheme.smalTitleColor),

                                readOnly: editEtat,
                                controller: _serialcodeController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.trailer,
                                      color: ColorTheme.smalTitleColor),
                                  hintText: "Serial Number",
                                  hintStyle: TextStyle(
                                      color: ColorTheme.smalTitleColor),

                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  errorText: _serialcodeNotEmpty
                                      ? null
                                      : 'Serial number cannot be empty',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _serialcodeNotEmpty = value.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _cardNotEmpty
                                        ? Colors.teal
                                        : Colors.red),
                                color: ColorTheme.colorBackgroundCard,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                    color: ColorTheme.smalTitleColor),

                                readOnly: editEtat,
                                controller: _cardController,
                                decoration: InputDecoration(
                                  prefixIcon:
                                  Icon(FontAwesomeIcons.solidIdCard,
                                      color: ColorTheme.smalTitleColor),
                                  hintText: "Card Number",
                                  hintStyle: TextStyle(
                                      color: ColorTheme.smalTitleColor),

                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  errorText: _cardNotEmpty
                                      ? null
                                      : 'Card number cannot be empty',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _cardNotEmpty = value.isNotEmpty;
                                  });
                                },
                              ),
                            ),
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

                  child:
                  GestureDetector(
                    onTap: () => updateDriver(),
                    child: InkWell(
                      child: Visibility(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 100),
                          // Adjust the left margin as needed
                          height: 55,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:

                          Row(
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
                          ),),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width - 200), // Add some space between buttons
                IconButton(
                  icon: Icon(
                      Icons.edit, color: ColorTheme.backgroundNormalColor),
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
          if (editEtat) {
            _passwordController.text = "";
          }
          else {
            _passwordController.text = widget._driver.password;
          }
          setState(() {
            editEtat = !editEtat;
          });
        },
        child: Icon(Icons.edit, color: ColorTheme.backgroundNormalColor),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  updateDriver() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty ||
        _phoneController.text.isEmpty || _cardController.text.isEmpty
        || _serialcodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PLEASE FILL ALL FIELDS ',
                style: TextStyle(fontSize: 15),
              ),
              Icon(
                Icons.error_outline,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(width: 10,),

            ],
          ),
        ),
      );
    }
    else {
      if (_passwordController.text.isEmpty) {
        isP = "false";
      }
      else {
        isP = "true";
      }


      status = await driverViewModel.updateDriverByCarrier(
          _nameController.text,
          _emailController.text,
          _phoneController.text,
          _cardController.text,
          _serialcodeController.text,
          widget._driver.userNumber,
          _passwordController.text,
          isP);

      if (status == 200) {

        setState(() {
          print("update : name." + _nameController.text
              + " email." + _emailController.text
              + " phone." + _phoneController.text
              + " serialcode." + _serialcodeController.text
              + " card." + _cardController.text
              + " password." + _passwordController.text
          );

          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListDrivers()),
          );


          editEtat = !editEtat;
          _passwordController.text = widget._driver.password;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.teal,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "EDIT SUCCESSFUL ",
                  style: TextStyle(fontSize: 15),
                ),
                Icon(
                  Icons.check_circle,
                  size: 30,
                  color: Colors.white,

                ),

              ],

            ),
          ),
        );
      }
      else
        if(status==409){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Email already exist . ",
                    style: TextStyle(fontSize: 15),
                  ),
                  Icon(
                    Icons.dangerous_rounded,
                    size: 30,
                    color: Colors.white,

                  ),

                ],

              ),
            ),
          );
        }
        else
        if(status==208){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Phone Number already exist . ",
                    style: TextStyle(fontSize: 15),
                  ),
                  Icon(
                    Icons.dangerous_rounded,
                    size: 30,
                    color: Colors.white,

                  ),

                ],

              ),
            ),
          );
        }




    }
  }
  void _navigateAndAwaitResult(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListDrivers()),
    );

    // Handle result after the second screen is popped
    print('Result: $result');
  }
}

