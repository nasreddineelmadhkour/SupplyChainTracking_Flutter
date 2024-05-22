import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';
import 'package:supplychaintracking/Views/Widgets/line_edit.dart';
import 'package:supplychaintracking/Views/Widgets/password_edit.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile>
{
  File? _imageFile = null;
  bool readOnly = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height+40;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This hides the back button
        title: Row(
          children: [
             // Add spacer to push the title to the right
            Padding(
              padding: const EdgeInsets.only(left:20 ),
              child: Text(
                "Profile",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: ColorTheme.appBarBigTitleColor,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: ColorTheme.backgroundNormalColor,
      ),

      body: SingleChildScrollView(
        child: Container(
          color: ColorTheme.backgroundNormalColor,
          height: height,
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                ],
              ),
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              70), // Set the same radius as the CircleAvatar
                          child: _imageFile != null
                              ? Image.file(
                            _imageFile!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                              : Image.memory(
                            Uint8List.fromList(
                                StaticAccount.staticAccount.photo),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
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
              const SizedBox(height: 30),

              // -- Form Fields
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ Text(
                    "Personal info",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: ColorTheme.bigTitleColor,),
                  ),
                    SizedBox(height: 20),
                    LineEdit(
                        title: StaticAccount.staticAccount.name,
                        icon: Icons.account_circle,
                        readOnly: !readOnly),
                    const SizedBox(height: 20),
                    LineEdit(
                        title: StaticAccount.staticAccount.email,
                        icon: Icons.email,
                        readOnly: !readOnly),
                    const SizedBox(height: 20),
                    LineEdit(
                        title: StaticAccount.staticAccount.phoneNumber,
                        icon: Icons.phone,
                        readOnly: !readOnly),
                    const SizedBox(height: 20),

                    PasswordEdit(
                        title: StaticAccount.staticAccount.password,
                        icon: Icons.lock,
                        readOnly: !readOnly,
                        showPassword: false),
                    if (StaticAccount.staticAccount.role.toString() == "DRIVER")
                      const SizedBox(
                        height: 20,
                      ),
                    const SizedBox(height: 20),

                    // -- Form Submit Button
                    Container(
                      height: 50,
                      width: width,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: width,
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: InkWell(
                                child: Visibility(

                                  child: Container(

                                    margin: EdgeInsets.only(left: width-(width/2.5)), // Adjust the left margin as needed
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
                    if (StaticAccount.staticAccount.role.toString() == "DRIVER")
                      Text(
                        "Carrier info",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: ColorTheme.bigTitleColor,),
                      ),
                    if (StaticAccount.staticAccount.role.toString() == "DRIVER")
                      const SizedBox(
                        height: 20,
                      ),
                    if (StaticAccount.staticAccount.role.toString() == "DRIVER")
                      LineEdit(
                        title: (StaticAccount.staticAccount.cardNumber),
                        icon: FontAwesomeIcons.solidIdCard,
                        readOnly: readOnly,
                      ),
                    if (StaticAccount.staticAccount.role.toString() == "DRIVER")
                      const SizedBox(
                        height: 20,
                      ),
                    if (StaticAccount.staticAccount.role.toString() == "DRIVER")
                      LineEdit(
                          title: (StaticAccount.staticAccount.serialNumber),
                          icon: FontAwesomeIcons.trailer,
                          readOnly: readOnly),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to select image from gallery or camera
  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource
            .gallery); // You can also use ImageSource.camera for capturing from camera
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
}

