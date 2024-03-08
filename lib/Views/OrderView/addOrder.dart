import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supplychaintracking/Views/OrderView/addOrderInfo1.dart';
import 'package:supplychaintracking/Views/OrderView/addOrderInfo3.dart';
import 'package:supplychaintracking/Views/OrderView/addOrderInfo2.dart';
import 'package:supplychaintracking/Views/OrderView/widget/progress.dart';

class AddOrder extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  PFormController pformController = PFormController(3);

  @override
  void initState() {
    super.initState();
    pformController = PFormController(3);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0,top: 15),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),

      body: Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          FontAwesomeIcons.route,
                          size: 60,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Ajouter Destination",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            maxChildSize: 1,
            minChildSize: .75,
            initialChildSize: .75,
            builder: (ctx, controller) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PForm(
                        controller: pformController,
                        pages: [
                          AddOrderInfo1(),
                          AddOrderInfo2(),
                          AddOrderInfo3(),
                        ],
                        title: [
                          PTitle(
                            title: "Order Infos         ",
                            subTitle: "Add infos order",
                          ),
                          PTitle(
                            title: "Driver Infos         ",
                            subTitle: "Add infos driver",
                          ),
                          PTitle(
                            title: "Address Infos         ",
                            subTitle: "Add infos address",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              if (pformController.currentPage != 0) {
                pformController.prevPage();
              }
            },
            child: Visibility(
              visible: pformController.currentPage != 0,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 50,
                width: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              if (pformController.currentPage != pformController.length - 1) {
                pformController.nextPage();
              }
            },
            child: Visibility(
              visible: pformController.currentPage != pformController.length - 1,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 50,
                width: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
