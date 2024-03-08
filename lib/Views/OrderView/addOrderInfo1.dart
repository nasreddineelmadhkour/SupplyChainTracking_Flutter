import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supplychaintracking/Models/StaticMethode.dart';
import 'package:supplychaintracking/Views/OrderView/widget/textField.dart';

class AddOrderInfo1 extends StatefulWidget {
  @override
  _AddOrderInfo1State createState() => _AddOrderInfo1State();
}

class _AddOrderInfo1State extends State<AddOrderInfo1> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

@override
void initState() {
    StaticMethode.staticOrder.weightOrders=0;
    StaticMethode.staticOrder.productOrders="";
    print(StaticMethode.staticOrder.weightOrders);
    super.initState();
  }
  String dateOrder = "", timeOrder = "", concatDateTime = "";
  DateTime combinedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    color: Colors.grey.withOpacity(.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.date_range),
                      hintText: "Date",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    onTap: () => _setDateCommande(context),
                    readOnly: true,
                  ),
                ),
              ),
              SizedBox(
                  width: 16), // Add some spacing between the TextFormFields
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    color: Colors.grey.withOpacity(.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.access_time_rounded),
                      hintText: "Time",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    onTap: () => _setTimeCommande(context),
                    readOnly: true,
                    // Add onTap or onChanged as needed for the second field
                  ),
                ),
              ),
            ],
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
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.production_quantity_limits_sharp),
                  hintText: "Product",
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
              onChanged: (value) => productController(value),
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
                onChanged: (value) => weightcontroller(value),
                textAlign: TextAlign.left,
                keyboardType:
                    TextInputType.number, // Accepts only numeric input
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')), // Only allow digits
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  prefixIcon: Icon(
                    FontAwesomeIcons.weightHanging,
                  ),

                  hintText: 'Weight',
                  suffixIcon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'kg',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _setDateCommande(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      StaticMethode.staticOrder.dateOrders = pickedDate;
      int year = pickedDate.year;
      int month = pickedDate.month;
      int day = pickedDate.day;
      dateOrder =
          '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

      if (timeOrder.length > 4) {
        concatDateTime = "$dateOrder $timeOrder:00";
        StaticMethode.staticOrder.dateOrders = DateTime.parse(concatDateTime);
      } else {
        concatDateTime = dateOrder;
      }
      setState(() {
        _dateController.text = pickedDate.year.toString() +
            "-" +
            pickedDate.month.toString() +
            "-" +
            pickedDate.day.toString();
      });
    }
  }

  Future<void> _setTimeCommande(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input);
    if (pickedTime != null) {
      int hour = pickedTime.hour;
      int minute = pickedTime.minute;
      timeOrder =
          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      if (dateOrder.length > 6) {
        concatDateTime = "$dateOrder $timeOrder:00";
        StaticMethode.staticOrder.dateOrders = DateTime.parse(concatDateTime);
      }
      setState(() {
        _timeController.text =
            pickedTime.hour.toString() + ":" + pickedTime.minute.toString();
      });
    }
  }

  productController(String value) {
    StaticMethode.staticOrder.productOrders=value;
    print(StaticMethode.staticOrder.productOrders);
  }
  weightcontroller(String value){
    StaticMethode.staticOrder.weightOrders=int.parse(value);
    print(StaticMethode.staticOrder.weightOrders
    );
  }


}
