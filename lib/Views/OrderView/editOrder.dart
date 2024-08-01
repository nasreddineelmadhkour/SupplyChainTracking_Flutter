import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/Models/StaticMethode.dart';
import 'package:supplychaintracking/ViewModel/OrderViewModel.dart';
import 'package:supplychaintracking/Views/OrderView/ListOrders.dart';
import 'package:supplychaintracking/Views/OrderView/editOrderinfo1.dart';
import 'package:supplychaintracking/Views/OrderView/editOrderinfo2.dart';
import 'package:supplychaintracking/Views/OrderView/editOrderinfo3.dart';
import 'package:supplychaintracking/Views/OrderView/widget/progress.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class EditOrder extends StatefulWidget {
  final dynamic order;
  EditOrder(this.order);

  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  PFormController pformController = PFormController(3);

  OrderViewModel orderViewModel = OrderViewModel();

  int isA = 0 , isS = 0;

  @override
  void initState() {
    super.initState();
    pformController = PFormController(3);
    var addForm = StaticMethode().addOrder;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.homeTopColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0,top: 15),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: ColorTheme.titleAppBarColor,
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListOrders()),
              );

            },
          ),
        ),
      ),

      body: Stack(
        children: [
          Container(
            width: width,
            // height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorTheme.homeTopColor,Colors.teal],
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
                        backgroundColor: Colors.teal,
                        child: Icon(
                          FontAwesomeIcons.route,
                          size: 60,
                          color: ColorTheme.backgroundNormalColor,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Edit Destination",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorTheme.titleAppBarColor,
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
                  color: ColorTheme.colorBackgroundCard,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(

                    controller: controller,
                    child:
                    Container(
                      color: ColorTheme.colorBackgroundCard,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PForm(
                            controller: pformController,
                            pages: [
                              EditOrderInfo1(widget.order),
                              EditOrderInfo2(widget.order),
                              EditOrderInfo3(widget.order),
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
                      ),)

                ),
              )
              ;
            },
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          color: ColorTheme.colorBackgroundCard, // White background color
          margin: EdgeInsets.only(bottom: 10),
          child:
          Container(

            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(

                      color: ColorTheme.colorBackgroundCard, // White background color
                      child: Container(
                        height: 2, // Adjust the height of the green line
                        width: MediaQuery.of(context).size.width,
                        color: Color.fromRGBO(31, 48, 97, .1), // Specify your desired green color
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                    ),

                  ],
                ),

                Row(

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
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: ColorTheme.backgroundNormalColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        if (pformController.currentPage != pformController.length - 1) {
                          pformController.nextPage();
                        }
                      },
                      child: Visibility(
                        visible: pformController.currentPage != pformController.length - 1,
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: ColorTheme.backgroundNormalColor,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => {
                        verifForm()
                      },
                      child: Visibility(
                        child: Container(
                          margin: EdgeInsets.only(left: 100), // Adjust the left margin as needed
                          height: 50,
                          width: 125,
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
                              SizedBox(width: 8), // Adding some space between icon and text
                              Text(
                                'Update',
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
                  ],
                ),

              ],
            ) ,)

      ),
    );
  }

  verifForm() async {
    print(StaticMethode.staticOrder.dateOrders.toString());
    print(StaticMethode.staticOrder.productOrders);
    print(StaticMethode.staticOrder.weightOrders.toString());
    print(StaticMethode.staticOrder.unitProduct);
    StaticMethode.staticOrder.carrierNumber=StaticAccount.staticAccount.userNumber;
    print(StaticMethode.staticOrder.distance);
    print(StaticMethode.staticOrder.carrierNumber);
    print(StaticMethode.staticOrder.estimation);
    print(StaticMethode.staticOrder.startingPoint);
    print(StaticMethode.staticOrder.arrivalPoint);
    print(StaticMethode.staticOrder.driverNumber);
    print(StaticMethode.staticOrder.startingLat);
    print(StaticMethode.staticOrder.startingLong);

    print(StaticMethode.staticOrder.arrivalLong);
    print(StaticMethode.staticOrder.arrivalLat);




    if (StaticMethode.staticOrder.dateOrders.toString() != "" &&
        StaticMethode.staticOrder.productOrders != "" &&
        StaticMethode.staticOrder.weightOrders.toString() != "" &&
        StaticMethode.staticOrder.unitProduct != "" &&
        StaticMethode.staticOrder.distance != "" &&
        StaticMethode.staticOrder.carrierNumber.toString() != "" &&
        StaticMethode.staticOrder.estimation != "" &&
        StaticMethode.staticOrder.driverNumber.toString() != "" &&
        StaticMethode.staticOrder.startingLat.toString() != "" &&
        StaticMethode.staticOrder.startingLong.toString() != "" &&
        StaticMethode.staticOrder.arrivalLat.toString() != "" &&
        StaticMethode.staticOrder.arrivalLong.toString() != "") {


    if( StaticMethode.staticOrder.startingPoint != "" )
    {
      isS = 1;
    }
    if(StaticMethode.staticOrder.arrivalPoint != "")
    {
      isA = 1;
    }

    print("Update succesfull");

      if(await orderViewModel.updateOrder(widget.order['ordersNumber'],isS, isA) )
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
                  "Update successful",
                  style: TextStyle(fontSize: 15),
                )
              ],

            ),
          ),
        );
        // Delay for 2 seconds to let the SnackBar finish displaying
        Future.delayed(Duration(seconds: 2), () {
          // Navigate to another page
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListOrders()),
          );

          // Reset order details
          StaticMethode.staticOrder.productOrders = "";
          StaticMethode.staticOrder.unitProduct = "";
          StaticMethode.staticOrder.distance = "";
          StaticMethode.staticOrder.estimation = "";
          StaticMethode.staticOrder.startingPoint = "";
          StaticMethode.staticOrder.arrivalPoint = "";
        });
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Row(
              children: [
                Icon(
                  Icons.verified,
                  size: 30,
                ),
                Text(
                  "Erreur Serveur",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        );
      }



    }

    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 30,
              ),
              SizedBox(width: 10,),
              Text(
                'Please fill all fields',
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      );
    }
/*
    // Reset order details
    StaticMethode.staticOrder.productOrders = "";
    StaticMethode.staticOrder.unitProduct = "";
    StaticMethode.staticOrder.distance = "";
    StaticMethode.staticOrder.estimation = "";
    StaticMethode.staticOrder.startingPoint = "";
    StaticMethode.staticOrder.arrivalPoint = "";
    StaticMethode.staticOrder.weightOrders=0;
*/

  }

  formAddOrderController(){
    if(StaticMethode().addOrder==true){
      return true;
    }
    else
      return false;

  }
}