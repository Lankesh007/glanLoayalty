import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/helper/api_helper.dart';
import 'package:tayal/models/ledger_model.dart';
import 'package:tayal/network/apis.dart';
import 'package:tayal/themes/constant.dart';

import 'ledger_details_screen.dart';

class NewLedgerScreen extends StatefulWidget {
  const NewLedgerScreen({Key key}) : super(key: key);

  @override
  State<NewLedgerScreen> createState() => _NewLedgerScreenState();
}

class _NewLedgerScreenState extends State<NewLedgerScreen> {
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
  List<LedgerModel> ledgerModelList = [];

  @override
  void initState() {
    getLedgerDetails();
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
          'Ledger',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
              alignment: Alignment.center,
              child: Text("List Count: ${ledgerModelList.length}  "))
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            getallDateWidget(),
            Divider(),
            SizedBox(
              height: 20,
            ),
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
                    child: ledgerModelList.isNotEmpty
                        ? ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: ledgerModelList.length,
                            itemBuilder: (context, index) =>
                                ledgerDetailsWidget(
                              ledgerModelList[index],
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

  Widget ledgerDetailsWidget(LedgerModel item) {
    var date = (DateFormat.yMMMEd().format(DateTime.parse(item.dd)));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: height * 0.14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invoice Date : " + date,
                      style: TextStyle(
                          color: appbarcolor, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Invoice No : " + item.documentNo,
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Text(
                item.amtInLocCur == "-"
                    ? " ₹ ${item.amtInLocCur}Cr."
                    : " ₹ ${item.amtInLocCur.replaceAll("-", "")} Dr.",
                style: TextStyle(
                    color: item.amtInLocCur == "-" ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            "Remarks : " + item.text,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),

          Divider(),

          // InkWell(
          //   onTap: (){
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>LedgerDetailsScreen()));
          //   },
          //   child: Container(
          //     height: height * 0.06,
          //     width: width * 0.9,
          //     alignment: Alignment.center,
          //     decoration: BoxDecoration(
          //       border: Border.all(color: appbarcolor,width: 1),
          //       borderRadius: BorderRadius.circular(10)
          //     ),
          //     child: Text("View Details",style: TextStyle(color: appbarcolor,fontWeight: FontWeight.bold),),
          //   ),
          // ),
          

          Divider(
            color: appbarcolor,
          ),
          SizedBox(
            height: 5,
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
        getLedgerDetails();
      });
    }
  }

  Future getLedgerDetails() async {
    setState(() {
      isLoader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String acessToken = prefs.getString('token').toString();

    var url = Apis.ledgerDetails;
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
        ledgerModelList.clear();
        var listdata = _list.map((e) => LedgerModel.fromJson(e)).toList();
        ledgerModelList.addAll(listdata);
      });
    }
    setState(() {
      isLoader = false;
    });
  }
}
