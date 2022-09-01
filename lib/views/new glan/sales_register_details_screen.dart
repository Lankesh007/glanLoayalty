// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/models/sales_register_details_model.dart';

import '../../helper/api_helper.dart';
import '../../network/apis.dart';
import '../../themes/constant.dart';

class SalesRegisterDetailsScreen extends StatefulWidget {
  final String billNo;
  final String totalQuantity;
  final double totalAmount;
  final String date;
  const SalesRegisterDetailsScreen(
      {this.billNo, this.totalAmount, this.totalQuantity, this.date, Key key})
      : super(key: key);

  @override
  State<SalesRegisterDetailsScreen> createState() =>
      _SalesRegisterDetailsScreenState();
}

class _SalesRegisterDetailsScreenState
    extends State<SalesRegisterDetailsScreen> {
  double height = 0;
  double width = 0;
  bool isLoader = false;
  List<RegisterSalesDetailsModel> salesDetailsList = [];

  @override
  void initState() {
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
          "Sales Register Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isLoader == true
                ? Container(
                    height: height * 0.6,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [CircularProgressIndicator()],
                    ),
                  )
                : salesRegisterDetailsWidget(),
          ],
        ),
      ),
    );
  }

  Widget salesRegisterDetailsWidget() {
    var date;

    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "No of Items : " + widget.totalQuantity,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            )),
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Order on : " + widget.date,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            )),
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Bill no : " + widget.billNo,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            )),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.center,
          height: 30,
          color: Color.fromRGBO(158, 158, 158, 1),
          child: Text(
            "Product Summary",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      Table(
                        columnWidths: {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                        },
                        border: TableBorder.all(color: Colors.black),
                        children: [
                          TableRow(children: [
                            Container(
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Products',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Unit pr.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Qty',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Total',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ])
                        ],
                      ),
                      Table(
                          columnWidths: {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                          },
                          border: TableBorder.all(color: Colors.black),
                          children: salesDetailsList
                              .map((e) => TableRow(children: [
                                    Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          e.code,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,fontSize: 13,color: Colors.grey),
                                        )),
                                   Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          "₹ "+e.rate,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,fontSize: 13,color: Colors.grey),
                                        )),
                                    Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          e.qty,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,fontSize: 13,color: Colors.grey),
                                        )),
                                    Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                         "₹ "+ e.amount,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,fontSize: 13,color: Colors.grey),
                                        )),
                                  ]))
                              .toList()),
                    ],
                  ),
                ),

      
              ],
            )),
        SizedBox(
          height: 30,
        ),
        Container(
          height: height * 0.2,
          width: width * 0.99,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 30,
                color: Color.fromRGBO(158, 158, 158, 1),
                child: Text(
                  "Payment Summary",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Qty :"),
                    Text(widget.totalQuantity,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ),
              Divider(
                color: appbarcolor,
              ),
              Divider(
                color: appbarcolor,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Price :"),
                    Text(
                      "₹ " + widget.totalAmount.toStringAsFixed(2),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Divider(
                color: appbarcolor,
              ),
            ],
          ),
        ),
      ],
    );
  }

// ----------------Api call---------------//

  Future getSalesRegisterDetails() async {
    setState(() {
      isLoader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String acessToken = prefs.getString('token').toString();

    var url = Apis.salesRegisterDetails;
    var data = {
      "token": acessToken.toString(),
      "bill_no": widget.billNo,
    };

    var response = await APIHelper.apiPostRequest(url, data);
    var result = jsonDecode(response);

    if (result['success'] == true) {
      var _list = result['data'] as List;
      setState(() {
        salesDetailsList.clear();
        var listdata =
            _list.map((e) => RegisterSalesDetailsModel.fromJson(e)).toList();
        salesDetailsList.addAll(listdata);
      });
    }
    setState(() {
      isLoader = false;
    });
  }
}
