import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'package:provider/provider.dart';
import 'package:supplychaintracking/Models/ImageUpload.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/ViewModel/AccountViewModel.dart';
import 'package:supplychaintracking/Views/LoginView/login.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';
import 'package:supplychaintracking/Views/Widgets/line_edit.dart';
import 'package:supplychaintracking/Views/Widgets/password_edit.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {

  AccountViewModel accountViewModel = AccountViewModel();
  File? _imageFile = null;
  ImageUpload imageUpload = ImageUpload(image: File("assets/images/icons/avatar.png"));
  bool readOnly = true,
      isPhoto = false,
      isName = false,
      isEmail = false,
      isPhone = false,
      isPassword = false;
  bool showPassword=false;

  TextEditingController
  nameController = TextEditingController(text: ""),
      emailController = TextEditingController(text: ""),
      phoneController = TextEditingController(text: ""),
      passwordController = TextEditingController(text: "");

String name="",email="",phone="",password="";
int status = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height + 40;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This hides the back button
        title: Row(
          children: [
            // Add spacer to push the title to the right
            Padding(
              padding: const EdgeInsets.only(left: 20),
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
                children: [],
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
                  children: [
                    Text(
                      "Personal info",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: ColorTheme.bigTitleColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) => {
                        nameController.text=value,
                        if(nameController.text!=StaticAccount.staticAccount.name && nameController.text!=""){
                          isName = true,
                        }
                        else {
                          isName=false,
                        }

                      },
                      controller: nameController,
                      readOnly: !readOnly,
                      cursorColor: ColorTheme.principalTeal,
                      style: TextStyle(color: ColorTheme.principalTeal),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ColorTheme.colorBackgroundCard,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        label: Text(
                          StaticAccount.staticAccount.name,
                          style: TextStyle(color: ColorTheme.smalTitleColor),
                        ),
                        prefixIcon: Icon(Icons.account_circle,
                            color: ColorTheme.principalTeal, size: 25),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              width: 2,
                              color: ColorTheme
                                  .principalTeal), // Bordure bleue quand en focus
                        ),
                      ),
                    ),


                    const SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) => {
                      emailController.text=value,
                      if(emailController.text!=StaticAccount.staticAccount.email && emailController.text!=""){
                      isEmail = true,
                      }
                      else {
                        isEmail=false,
                      }

                      },
                      controller: emailController,
                      readOnly: !readOnly,
                      cursorColor: ColorTheme.principalTeal,
                      style: TextStyle(color: ColorTheme.principalTeal),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ColorTheme.colorBackgroundCard,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        label: Text(
                          StaticAccount.staticAccount.email,
                          style: TextStyle(color: ColorTheme.smalTitleColor),
                        ),
                        prefixIcon: Icon(Icons.email,
                            color: ColorTheme.principalTeal, size: 25),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              width: 2,
                              color: ColorTheme
                                  .principalTeal), // Bordure bleue quand en focus
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) => {
                        phoneController.text=value,
                        if(phoneController.text!=StaticAccount.staticAccount.phoneNumber && phoneController.text!=""){
                          isPhone = true,
                        }
                        else {
                          isPhone=false,
                        }

                      },
                      controller: phoneController,
                      readOnly: !readOnly,
                      cursorColor: ColorTheme.principalTeal,
                      style: TextStyle(color: ColorTheme.principalTeal),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ColorTheme.colorBackgroundCard,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        label: Text(
                          StaticAccount.staticAccount.phoneNumber,
                          style: TextStyle(color: ColorTheme.smalTitleColor),
                        ),
                        prefixIcon: Icon(Icons.phone,
                            color: ColorTheme.principalTeal, size: 25),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              width: 2,
                              color: ColorTheme
                                  .principalTeal), // Bordure bleue quand en focus
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
/*
                    PasswordEdit(
                        title: StaticAccount.staticAccount.password,
                        icon: Icons.lock,
                        readOnly: !readOnly,
                        showPassword: false),*/

                    TextField(
                      onChanged: (value) => {
                        passwordController.text=value,
                        if(passwordController.text!=StaticAccount.staticAccount.password && passwordController.text!=""){
                          isPassword = true,
                        }
                        else {
                          isPassword=false,
                        }

                      },
                      controller: passwordController,
                      readOnly: !readOnly,
                      obscureText: !showPassword,
                      cursorColor: ColorTheme.principalTeal,
                      style: TextStyle(color: ColorTheme.principalTeal),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ColorTheme.colorBackgroundCard,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: StaticAccount.staticAccount.password,
                        labelStyle: TextStyle(color: ColorTheme.smalTitleColor),
                        prefixIcon: Icon(Icons.lock, color: ColorTheme.principalTeal, size: 25),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(width: 2, color: ColorTheme.principalTeal),
                        ),
                        suffixIcon: IconButton(padding: EdgeInsets.only(right: 30),
                          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off,color: ColorTheme.smalTitleColor),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                    )
                    ,

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
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      updateProfile();
                                    }),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: width -
                                              (width /
                                                  2.5)), // Adjust the left margin as needed
                                      height: 50,
                                      width: 100,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.save,
                                            color: ColorTheme
                                                .backgroundNormalColor,
                                          ),
                                          SizedBox(width: 8),
                                          // Adding some space between icon and text
                                          Text(
                                            'Save',
                                            style: TextStyle(
                                              color: ColorTheme
                                                  .backgroundNormalColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                    if (StaticAccount.staticAccount.role.toString() == "DRIVER")
                      Text(
                        "Carrier info",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: ColorTheme.bigTitleColor,
                        ),
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



  updateProfile() async{



    print("photo:" +
        this.isPhoto.toString() +
        " name:" +
        this.isName.toString() +
        " phone:" +
        this.isPhone.toString() +
        " password:" +
        this.isPassword.toString()+
      " Email:"+this.isEmail.toString());

    status = await
    accountViewModel.updateProfile(imageUpload,nameController.text,phoneController.text,passwordController.text,emailController.text
        ,isPhoto,isName,isPhone,isPassword,isEmail);

    if(status == 200)
    {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.teal,
          content: Row(
            children: [
              Icon(
                Icons.verified,
                size: 30,
              ),
              Text(
                "Edditing successful",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      );
      if(isPhone)
        {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.teal,
              content: Row(
                children: [
                  Icon(
                    Icons.logout,
                    size: 30,
                  ),
                  Text(
                    "Logout ... reconnect please .",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
          );
          StaticAccount.staticAccount.phoneNumber=phoneController.text;
          await Future.delayed(Duration(seconds: 3));
          Provider.of<AccountViewModel>(context,
              listen: false)
              .logout();
          // Navigator.of(context).pop();
          Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (context) => Login()));
        }


      setState(() {
        passwordController.text="";
        emailController.text="";
        nameController.text="";
        phoneController.text="";

        isEmail = false;
        isName = false;
        isPassword = false;
        isPhoto = false;
        isPhone= false;
        _imageFile=null;

      });
    }
    else if(status == 409){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(
                Icons.dangerous_rounded,
                size: 30,
              ),
              Text(
                "Phone number Or Email already Exist",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(
                Icons.dangerous_rounded,
                size: 30,
              ),
              Text(
                "Error server ",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      );
    }
    }





  // Function to select image from gallery or camera
  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource
            .gallery); // You can also use ImageSource.camera for capturing from camera
    if (pickedFile != null) {
      setState(() {
        this.isPhoto = true;
        imageUpload.image = File(pickedFile.path);
        _imageFile = File(pickedFile.path);
      });
    }
  }
}
