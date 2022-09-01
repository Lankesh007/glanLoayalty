import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/helper/api_helper.dart';
import 'package:tayal/models/pending_order_model.dart';
import 'package:tayal/network/apis.dart';
import 'package:tayal/themes/constant.dart';

import 'pending_order_details_screen.dart';

class PendingOrderScreen extends StatefulWidget {
  const PendingOrderScreen({Key key}) : super(key: key);

  @override
  State<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends State<PendingOrderScreen> {
  double height = 0;
  double width = 0;
  String startDate = "From Date";
  String endDate = "To Date";
  List ledgerList = [];
  int count = 1;
  int totalPageCount = 0;
  bool isLoader = false;
  String orderId = '';

  String totalDue = "0";

  List<PendingOrderModel> pendingOrderList = [];

  @override
  void initState() {
    getPendingOrderDetails();

    setState(() {
      startDate = DateTime(DateTime.now().year, DateTime.now().month, 1)
          .toString()
          .split(" ")[0];
      endDate = DateTime.now().toString().split(" ")[0];
      ledgerList.clear();
      totalPageCount = 0;
      count = 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarcolor,
        title: Text(
          "Pending Orders",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        centerTitle: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              getallDateWidget(),
              Divider(),
              isLoader == true
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height * 0.2,
                        ),
                        CircularProgressIndicator(color: appbarcolor),
                      ],
                    )
                  : SizedBox(
                      height: height * 0.9,
                      width: width,
                      child: pendingOrderList.isNotEmpty
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: pendingOrderList.length,
                              itemBuilder: (context, index) =>
                                  pendingOrderDetailsWidget(
                                pendingOrderList[index],
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    height: height * 0.6,
                                    child: Text("NO data Found !!")),
                              ],
                            ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getallDateWidget() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                ledgerList.clear();
              });
              _selectStartDate(context);
            },
            child: Card(
              elevation: 4.0,
              child: Container(
                  height: height * 0.06,
                  color: Colors.indigo.shade50,
                  width: width * 0.44,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          startDate,
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 16.0),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            Icons.calendar_today_sharp,
                            color: Colors.grey,
                            size: 20,
                          )),
                    ],
                  )),
            ),
          ),
          InkWell(
            onTap: () {
              if (startDate != "From Date") {
                setState(() {
                  ledgerList.clear();
                });
                _selectedEndDate(context);
              } else {
                Fluttertoast.showToast(msg: "Please select Start Date");
              }
            },
            child: Card(
              elevation: 4.0,
              child: Container(
                  height: height * 0.06,
                  color: Colors.indigo.shade50,
                  width: width * 0.44,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          endDate,
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 16.0),
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(
                            Icons.calendar_today_sharp,
                            color: Colors.grey,
                            size: 20,
                          )),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      //firstDate: DateTime.now().subtract(Duration(days: 0)),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
              primaryColor: Colors.indigo,
              accentColor: Colors.indigo,
              primarySwatch: const MaterialColor(
                0xFF3949AB,
                <int, Color>{
                  50: Colors.indigo,
                  100: Colors.indigo,
                  200: Colors.indigo,
                  300: Colors.indigo,
                  400: Colors.indigo,
                  500: Colors.indigo,
                  600: Colors.indigo,
                  700: Colors.indigo,
                  800: Colors.indigo,
                  900: Colors.indigo,
                },
              )),
          child: child,
        );
      },
    );

    if (picked != null) {
      setState(() {
        startDate = picked.toString().split(" ")[0];
        endDate = "To Date";
        totalDue = "0";
        count = 1;
        totalPageCount = 0;
        ledgerList.clear();
      });
    }
  }

  Future<void> _selectedEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        // firstDate: DateTime.now().subtract(Duration(days: 0)),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
                primaryColor: Colors.indigo,
                accentColor: Colors.indigo,
                primarySwatch: const MaterialColor(
                  0xFF3949AB,
                  <int, Color>{
                    50: Colors.indigo,
                    100: Colors.indigo,
                    200: Colors.indigo,
                    300: Colors.indigo,
                    400: Colors.indigo,
                    500: Colors.indigo,
                    600: Colors.indigo,
                    700: Colors.indigo,
                    800: Colors.indigo,
                    900: Colors.indigo,
                  },
                )),
            child: child,
          );
        });

    if (picked != null) {
      setState(() {
        endDate = picked.toString().split(" ")[0];
        totalDue = "0";
        count = 1;
        totalPageCount = 0;
        ledgerList.clear();
        getPendingOrderDetails();
      });
    }
  }

  Widget pendingOrderDetailsWidget(PendingOrderModel item) {
// var format = DateFormat.d(item.orderDate);
    var date = (DateFormat.yMMMEd().format(DateTime.parse(item.orderDate)));

    return SizedBox(
      height: height * 0.22,
      width: width * 0.99,
      child: Column(
        children: [
          SizedBox(
            height: 0,
          ),
          Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Order Date :" + date.toString(),
                style: TextStyle(color: Colors.grey, fontSize: 13),
              )),
          SizedBox(
            height: 0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order id : " + item.orderNo.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Qunatity " + item.totalItem.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.35,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  item.totalAmount == "-"
                      ? " ₹ ${item.totalAmount}dr"
                      : " ₹ ${item.totalAmount.replaceAll("-", "")} cr.",
                  style: TextStyle(
                      color:
                          item.totalAmount == "-" ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              setState(() {
                orderId = item.orderNo.toString();
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PendingOrderDetailsScreen(
                          orderDate: date.toString(),
                          pendingOrderModel: item,
                          orderId: item.orderNo.toString(),
                          qunatity: item.totalItem.toString(),  totalAmount: double.parse(item.totalAmount),)));
            },
            child: Container(
              alignment: Alignment.center,
              height: height * 0.06,
              width: width * 0.96,
              decoration: BoxDecoration(
                  border: Border.all(color: appbarcolor, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "View Details",
                style:
                    TextStyle(color: appbarcolor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: appbarcolor,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  // ------------- API CALL------------------//

  Future getPendingOrderDetails() async {
    setState(() {
      isLoader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String acessToken = prefs.getString('token').toString();

    var url = Apis.pendingOrder;
    var data = {
      "token": acessToken.toString(),
      "from": startDate.toString(),
      "to": endDate.toString(),
    };

    var response = await APIHelper.apiPostRequest(url, data);
    var result = jsonDecode(response);

    if (result['success'] == true) {
      var _list = result['data'] as List;
      setState(() {
        pendingOrderList.clear();
        var listdata = _list.map((e) => PendingOrderModel.fromJson(e)).toList();
        pendingOrderList.addAll(listdata);
      });
    }
    setState(() {
      isLoader = false;
    });
  }
}
