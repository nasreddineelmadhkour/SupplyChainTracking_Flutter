import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supplychaintracking/Models/StaticMethode.dart';
import 'package:supplychaintracking/Views/OrderView/widget/textField.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';

class EditOrderInfo1 extends StatefulWidget {
  final dynamic order;
  EditOrderInfo1(this.order);


  @override
  _EditOrderInfo1State createState() => _EditOrderInfo1State();
}

class _EditOrderInfo1State extends State<EditOrderInfo1> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  bool _productNotEmpty = true;
  bool _timeNotEmpty = true;
  bool _dateNotEmpty = true;
  bool _weightNotEmpty = true;
  String _selectedUnit = "litre" ;// Default unit is kg
  @override
  void initState() {

    _dateController.text=widget.order['dateOrders'].toString().substring(0,10);
    _timeController.text=widget.order['dateOrders'].toString().substring(11,16);
    _productController.text=widget.order['productOrders'];

    _weightController.text=widget.order['weightOrders'].toString();

    _selectedUnit = widget.order['unitProduct'];

    concatDateTime = widget.order['dateOrders'].toString().substring(0,10)+" "+widget.order['dateOrders'].toString().substring(11,16)+":00";

    StaticMethode.staticOrder.productOrders = widget.order['productOrders'];
    StaticMethode.staticOrder.weightOrders = widget.order['weightOrders'];
    StaticMethode.staticOrder.dateOrders = DateTime.parse(concatDateTime);



    ///StaticMethode.staticOrder.dateOrders=DateTime(2000,1,1);
    super.initState();
  }


  bool _isAnyFieldEmpty() {
    return _dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _productController.text.isEmpty ||
        _weightController.text.isEmpty
    ;
  }

  String dateOrder = "", timeOrder = "", concatDateTime = "";
  DateTime combinedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    StaticMethode.staticOrder.unitProduct=_selectedUnit;
    return Container(
      color: ColorTheme.colorBackgroundCard,
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: _dateNotEmpty ? Colors.teal : Colors.red),
                    color: Colors.grey.withOpacity(.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    cursorColor: ColorTheme.principalTeal,
                    style: TextStyle(color: ColorTheme.principalTeal),
                    controller: _dateController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.date_range,
                          color: ColorTheme.smalTitleColor),
                      hintText: "Date",
                      hintStyle: TextStyle(color: ColorTheme.smalTitleColor),
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
                    border: Border.all(color: _timeNotEmpty ? Colors.teal : Colors.red),
                    color: Colors.grey.withOpacity(.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    cursorColor: ColorTheme.principalTeal,

                    style: TextStyle(color: ColorTheme.principalTeal),

                    controller: _timeController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.access_time_rounded,
                          color: ColorTheme.smalTitleColor),
                      hintText: "Time",
                      hintStyle: TextStyle(color: ColorTheme.smalTitleColor),
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

                border: Border.all( color: _productNotEmpty ? Colors.teal : Colors.red),
                color: Colors.grey.withOpacity(.1),
                borderRadius: BorderRadius.circular(30)),
            child: TextFormField(
              style: TextStyle(color: ColorTheme.principalTeal),

              cursorColor: ColorTheme.principalTeal,

              controller: _productController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.production_quantity_limits_sharp,
                      color: ColorTheme.smalTitleColor),
                  hintText: "Product",
                  hintStyle: TextStyle(color: ColorTheme.smalTitleColor),
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
              onChanged: (value)=>productController(value),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: _weightNotEmpty ? Colors.teal : Colors.red
              ),
              color: Colors.grey.withOpacity(.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: ColorTheme.principalTeal),

                    controller: _weightController,

                    onChanged: (value) => weightController(value),
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
                        color: ColorTheme.smalTitleColor,
                      ),
                      hintText: 'Weight',
                      hintStyle: TextStyle(color: ColorTheme.smalTitleColor),
                    ),

                  ),
                ),
                DropdownButton<String>(
                  value: _selectedUnit,
                  padding: EdgeInsets.only(right: 20),
                  style: TextStyle(color: ColorTheme.hintTitleColor),
                  underline: Container(), // Remove the underline
                  onChanged: (String? newValue) {
                    StaticMethode.staticOrder.unitProduct=newValue.toString();
                    print(StaticMethode.staticOrder.unitProduct);
                    setState(() {

                      _selectedUnit = newValue!;
                    });
                  },
                  items: <String>["litre", "kg"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setDateCommande(BuildContext context) async {

    _dateNotEmpty = _dateController.text.isNotEmpty;
    verifForm();
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
        concatDateTime = dateOrder +" "+widget.order['dateOrders'].toString().substring(11,16)+":00";
        StaticMethode.staticOrder.dateOrders = DateTime.parse(concatDateTime);
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

    _timeNotEmpty = _timeController.text.isNotEmpty;
    verifForm();
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
      else{
        concatDateTime = widget.order['dateOrders'].toString().substring(0,10) +" $timeOrder:00";
        StaticMethode.staticOrder.dateOrders = DateTime.parse(concatDateTime);
      }
      setState(() {
        _timeController.text =
            pickedTime.hour.toString() + ":" + pickedTime.minute.toString();
      });
    }
  }


  verifForm(){
    setState(() {
      _productNotEmpty = _productController.text.isNotEmpty;
      _dateNotEmpty = _dateController.text.isNotEmpty;
      _timeNotEmpty = _timeController.text.isNotEmpty;
      _weightNotEmpty= _weightController.text.isNotEmpty;
      // Display Snackbar if any field is empty
      /*if (anyFieldEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Please fill all fields'),
          ),
        );
      }*/
    });
  }



  productController(String value) {

    _productNotEmpty = value.isNotEmpty;

    StaticMethode.staticOrder.productOrders = _productController.text;
    verifForm();
    print(StaticMethode.staticOrder.productOrders);



  }

  weightController(String value) {
    _weightNotEmpty = value.isNotEmpty;

    verifForm();
    if(value.length>0){
      StaticMethode.staticOrder.weightOrders = int.parse(value);
      print(value);}
    /*else
      {
      StaticMethode.staticOrder.weightOrders = 0;
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("* Weight > 0  "),
          ),
        );
      });
      }*/;
  }
}
