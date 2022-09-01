import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/models/sales_register_model.dart';
import 'package:tayal/themes/constant.dart';

import '../../helper/api_helper.dart';
import '../../network/apis.dart';
import 'sales_register_details_screen.dart';

class SalesRegisterScreen extends StatefulWidget {
  const SalesRegisterScreen({Key key}) : super(key: key);

  @override
  State<SalesRegisterScreen> createState() => _SalesRegisterScreenState();
}

class _SalesRegisterScreenState extends State<SalesRegisterScreen> {
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

  List<RegisterSalesModel> registerSalesList = [];

  @override
  void initState() {
    setState(() {
      startDate = DateTime(DateTime.now().year, DateTime.now().month, 1)
          .toString()
          .split(" ")[0];
      endDate = DateTime.now().toString().split(" ")[0];
      ledgerList.clear();
      totalPageCount = 0;
      count = 1;
    });
    getSalesRegisterDetails();
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
          "Sales Register",
          style: TextStyle(
            color: Colors.white,
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
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: Text("List Count: " + registerSalesList.length.toString()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
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
                    height: height,
                    width: width,
                    child: registerSalesList.isNotEmpty
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: registerSalesList.length,
                            itemBuilder: (context, index) =>
                                salesRegisterDetailsWidget(
                              registerSalesList[index],
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
        getSalesRegisterDetails();
      });
    }
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

  Widget salesRegisterDetailsWidget(RegisterSalesModel item) {
    var date = (DateFormat.yMMMEd().format(DateTime.parse(item.date)));

    return SizedBox(
      height: height * 0.2,
      width: width,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bill No : " + item.billNo,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Bill Date : " + date,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: width * 0.5,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      item.totalItem.toString() + " Qty",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                  Container(
                    width: width * 0.5,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Code : " + item.customerCode,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.35,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  item.totalAmount != "-"
                      ? " ₹ ${item.totalAmount.toStringAsFixed(2)} Cr."
                      : " ₹ ${item.totalAmount.toStringAsFixed(2).replaceAll("-", "")} Dr.",
                  style: TextStyle(
                      color:
                          item.totalAmount != "-" ? Colors.green : Colors.red,
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SalesRegisterDetailsScreen(
                            billNo: item.billNo.toString(),
                            totalAmount: item.totalAmount,
                            totalQuantity: item.totalItem.toString(),
                            date: date,
                          )));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              height: height * 0.06,
              width: width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(color: appbarcolor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "View Details",
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: appbarcolor),
              ),
            ),
          ),
          Divider(
            color: appbarcolor,
            thickness: 1,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

// ----------------Api call---------------//
  Future getSalesRegisterDetails() async {
    setState(() {
      isLoader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String acessToken = prefs.getString('token').toString();

    var url = Apis.slaesOrder;
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
        registerSalesList.clear();
        var listdata =
            _list.map((e) => RegisterSalesModel.fromJson(e)).toList();
        registerSalesList.addAll(listdata);
      });
    }
    setState(() {
      isLoader = false;
    });
  }
}
