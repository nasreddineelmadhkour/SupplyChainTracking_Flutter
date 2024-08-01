import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supplychaintracking/Models/Driver.dart';
import 'package:supplychaintracking/Models/ImageUpload.dart';
import 'package:supplychaintracking/ViewModel/DriverViewModel.dart';
import 'package:supplychaintracking/Views/DriverView/ListDrivers.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class AddDriver extends StatefulWidget {
  @override
  _AddDriverState createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  bool firstImage = true;
  ImageUpload imageUpload = ImageUpload(image: File("assets/images/icons/avatar.png"));




  bool _showPassword = false;
  bool _showConfirmPassword = false;
  // Define variables to track the state of each input
  bool _nameNotEmpty = true;
  bool _emailNotEmpty = true;
  bool _phoneNotEmpty = true;
  bool _passwordNotEmpty = true;
  bool _confirmPasswordNotEmpty = true;
  bool _serialcodeNotEmpty = true,_cardNotEmpty=true;
  // Define controllers for each text field
  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _phoneController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
  TextEditingController _confirmPasswordController = TextEditingController(text: '');
  TextEditingController _serialcodeController = TextEditingController(text: '');
  TextEditingController _cardController = TextEditingController(text: '');

  Driver driver = Driver(userNumber: 0, name: "", photo: Uint8List(0), phoneNumber: "", email: "", password: "", serialNumber: "", cardNumber: "")  ;
  DriverViewModel driverViewModel = DriverViewModel();
  
  // Function to check if any input field is empty
  bool _isAnyFieldEmpty() {
    return _nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _serialcodeController.text.isEmpty ||
        _cardController.text.isEmpty
    ;
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height+70;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorTheme.backgroundNormalColor,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 55),
          child: Text(
            "NEW DRIVER",
            style: TextStyle(color: ColorTheme.titleAppBarColor),
          ),
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
                MaterialPageRoute(
                    builder: (context) =>
                        ListDrivers()), // Navigate to ListDrivers screen
              );
            },
          ),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 10),
            icon: Icon(Icons.undo),
            color: ColorTheme.titleAppBarColor,
            onPressed: () {
              // Add your undo functionality here
            },
          ),
        ],
      ),

      body:
      WillPopScope(
        onWillPop: () async {
          // Navigating back to HomePage when user tries to exit
          print("Back To ListDriver()");
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ListDrivers()),
          );
          return true; // Prevents the app from being closed
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: width,
                height: height,
                padding: EdgeInsets.only(right: 30, left: 45, top: 20),
                //color: Colors.white,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: width,
                          height: 125,
                          child: Container(
                            height: 125,
                            width: 125,
                            child: CircleAvatar(
                              backgroundColor: Colors.teal,
                              child: !firstImage? ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: Image.file(
                                  imageUpload.image,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ):ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: Image.asset(
                                  "assets/images/icons/avatar.png",
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ), // Replace with your image asset
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: width / 4.8,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ColorTheme.principalTeal),
                            child: GestureDetector(
                              onTap: () {
                                _selectImage(); // Call function to select image
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: ColorTheme.backgroundNormalColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: _nameNotEmpty ? Colors.teal : Colors.red),
                        color: ColorTheme.colorBackgroundCard,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(

                        controller: _nameController,
                        style: TextStyle(color: ColorTheme.smalTitleColor),
                        decoration: InputDecoration(
                          prefixIcon: Icon(FontAwesomeIcons.solidUser,color: ColorTheme.smalTitleColor),
                          hintText: "Name",
                          hintStyle: TextStyle(color: ColorTheme.smalTitleColor),

                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          errorText:
                          _nameNotEmpty ? null : 'Name cannot be empty',

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
                            color: _emailNotEmpty ? Colors.teal : Colors.red),
                        color: ColorTheme.colorBackgroundCard,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        style: TextStyle(color: ColorTheme.smalTitleColor),

                        controller: _emailController,
                        decoration: InputDecoration(

                          fillColor: ColorTheme.colorBackgroundCard,

                          prefixIcon: Icon(Icons.alternate_email,color: ColorTheme.smalTitleColor),
                          hintText: "Email",
                          hintStyle: TextStyle(color: ColorTheme.smalTitleColor),

                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          errorText:
                          _emailNotEmpty ? null : 'Email cannot be empty',
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
                            color: _phoneNotEmpty ? Colors.teal : Colors.red),
                        color: ColorTheme.colorBackgroundCard,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        style: TextStyle(color: ColorTheme.smalTitleColor),

                        controller: _phoneController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone,color: ColorTheme.smalTitleColor),
                          hintText: "Phone Number",
                          hintStyle: TextStyle(color: ColorTheme.smalTitleColor),

                          border: OutlineInputBorder(borderSide: BorderSide.none),
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
                            color: _passwordNotEmpty ? Colors.teal : Colors.red),
                        color: ColorTheme.colorBackgroundCard,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        style: TextStyle(color: ColorTheme.smalTitleColor),

                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock,color: ColorTheme.smalTitleColor),
                          hintText: "Password",
                          hintStyle: TextStyle(color: ColorTheme.smalTitleColor),

                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },color: ColorTheme.smalTitleColor,
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
                            color: _confirmPasswordNotEmpty
                                ? Colors.teal
                                : Colors.red),
                        color: ColorTheme.colorBackgroundCard,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        style: TextStyle(color: ColorTheme.smalTitleColor),

                        controller: _confirmPasswordController,
                        obscureText: !_showConfirmPassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock,color: ColorTheme.smalTitleColor),
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(color: ColorTheme.smalTitleColor),

                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          suffixIcon: IconButton(
                            icon: Icon(_showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _showConfirmPassword = !_showConfirmPassword;
                              });
                            },
                              color: ColorTheme.smalTitleColor
                          ),
                          errorText: _confirmPasswordNotEmpty
                              ? null
                              : 'Confirm Password cannot be empty',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _confirmPasswordNotEmpty = value.isNotEmpty;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: _serialcodeNotEmpty ? Colors.teal : Colors.red),
                        color: ColorTheme.colorBackgroundCard,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        style: TextStyle(color: ColorTheme.smalTitleColor),

                        controller: _serialcodeController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(FontAwesomeIcons.trailer,color: ColorTheme.smalTitleColor),
                          hintText: "Serial Number",
                          hintStyle: TextStyle(color: ColorTheme.smalTitleColor),

                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          errorText: _serialcodeNotEmpty ? null : 'Serial number cannot be empty',
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
                            color: _cardNotEmpty ? Colors.teal : Colors.red),
                        color: ColorTheme.colorBackgroundCard,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        style: TextStyle(color: ColorTheme.smalTitleColor),

                        controller: _cardController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(FontAwesomeIcons.solidIdCard,color: ColorTheme.smalTitleColor),
                          hintText: "Card Number",
                          hintStyle: TextStyle(color: ColorTheme.smalTitleColor),

                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          errorText: _cardNotEmpty ? null : 'Card number cannot be empty',
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
            ),
            GestureDetector(
              onTap: () {
                setState(() async {
                  // Check if any field is empty
                  bool anyFieldEmpty = _isAnyFieldEmpty();

                  // If any field is empty, mark empty fields with red borders
                  _nameNotEmpty = _nameController.text.isNotEmpty;
                  _emailNotEmpty = _emailController.text.isNotEmpty;
                  _phoneNotEmpty = _phoneController.text.isNotEmpty;
                  _passwordNotEmpty = _passwordController.text.isNotEmpty;
                  _confirmPasswordNotEmpty = _confirmPasswordController.text.isNotEmpty;
                  _serialcodeNotEmpty = _serialcodeController.text.isNotEmpty;
                  _cardNotEmpty = _cardController.text.isNotEmpty;




                  // Display Snackbar if any field is empty
                  if (anyFieldEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all fields'),
                      ),
                    );
                  } else {
                    driver.name=_nameController.text;
                    driver.email=_emailController.text;
                    driver.phoneNumber=_phoneController.text;
                    driver.password = _passwordController.text;
                    driver.serialNumber = _serialcodeController.text;
                    driver.cardNumber = _cardController.text;
                    if(await driverViewModel.addDriver(driver ,imageUpload)){
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ListDrivers()), // Navigate to ListDrivers screen
                      );
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Driver Exist'),
                        ),
                      );
                    }
                  }
                });
              },

              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: ColorTheme.colorBackgroundCard,
                    width: width,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: InkWell(
                          child: Visibility(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: (width - (width / 1.4)),
                                  right: (width - (width / 1.4)),
                                  top: 10), // Adjust the left margin as needed
                              height: 50,
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
                                  SizedBox(width: 8),
                                  // Adding some space between icon and text
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
                        )

                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

  }




  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageUpload.image = File(pickedFile.path);
        firstImage = false ;
      });
    }
  }
}
