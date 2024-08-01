

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supplychaintracking/ViewModel/ClaimViewModel.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class AddClaim extends StatefulWidget {
  final dynamic order;
  AddClaim(this.order);

  @override
  _AddClaimState createState() => _AddClaimState();
}

class _AddClaimState extends State<AddClaim>{


  ClaimViewModel claimViewModel = ClaimViewModel();

  bool readOnly = true,isEmail = false;
TextEditingController       descriptionController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorTheme.backgroundNormalColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "CLAIM",
          style: TextStyle(color: ColorTheme.titleAppBarColor),
        ),
        backgroundColor: ColorTheme.homeTopColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: ColorTheme.titleAppBarColor,
          onPressed: () {
           Navigator.popAndPushNamed(context, '/detailsOrderForDriver',arguments: widget.order);
          },
        )
      ),
      body:
      Stack(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width,
                    height: height,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20,),
                        Text(
                          "What is the problem ?",
                          style: TextStyle(
                              color: ColorTheme.bigTitleColor, fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          onChanged: (value) => {
                            descriptionController.text = value,
                          },
                          controller: descriptionController,
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
                            labelText: "Description",
                            labelStyle: TextStyle(color: ColorTheme.smalTitleColor),
                            prefixIcon: Icon(
                              Icons.description,
                              color: ColorTheme.principalTeal,
                              size: 25,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                width: 2,
                                color: ColorTheme.principalTeal, // Blue border when focused
                              ),
                            ),
                            contentPadding: EdgeInsets.only(left: width/2.8, top: 200.0, right: 16.0, bottom: 8.0), // Adjust padding
                          ),
                        ),
                        SizedBox(height: 15),


                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            child: FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: () async {
                if(await claimViewModel.addClaim(descriptionController.text, widget.order['ordersNumber'])){
                  widget.order['reclamation']="CLAIM";
                  Navigator.popAndPushNamed(context, '/detailsOrderForDriver',arguments: widget.order);
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
                            "Thank you for submitting your claim.",
                            style: TextStyle(fontSize: 15),
                          )
                        ],

                      ),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20,),

                  Text(
                    "SEND",
                    style: TextStyle(
                      color: ColorTheme.backgroundNormalColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 15,),
                  Icon(Icons.check, color: ColorTheme.backgroundNormalColor),
                ],
              ),
            ),

          )


        ],
      )
          ,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}