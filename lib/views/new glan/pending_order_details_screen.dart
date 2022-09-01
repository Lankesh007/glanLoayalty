import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/models/pending_order_details_model.dart';
import 'package:tayal/models/pending_order_model.dart';
import '../../helper/api_helper.dart';
import '../../network/apis.dart';
import '../../themes/constant.dart';

class PendingOrderDetailsScreen extends StatefulWidget {
  final String orderDate;
  final String qunatity;
  final String orderId;
  final double totalAmount;
  final PendingOrderModel pendingOrderModel;
  const PendingOrderDetailsScreen({
    this.orderId,
    this.orderDate,
    this.pendingOrderModel,
    this.qunatity,
    this.totalAmount,
    Key key,
  }) : super(key: key);

  @override
  State<PendingOrderDetailsScreen> createState() =>
      _PendingOrderDetailsScreenState();
}

class _PendingOrderDetailsScreenState extends State<PendingOrderDetailsScreen> {
  double height = 0;
  double width = 0;
  bool isLoader = false;
  List<PendingOrderDetailsModel> pendingOrderDetailsList = [];

  var itemsData;

  @override
  void initState() {
    getPendingOrderFullDetails();
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
          "Pending Orders Details",
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
      body: ListView(
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
              : pendingOrderDetailsWidget(),

              
        ],
      ),
    );
  }

  Widget pendingOrderDetailsWidget() {
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
              "No of Items : " + widget.qunatity,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            )),
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Order on : " + widget.orderDate,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            )),
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Bill no : " + widget.orderId,
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
                          columnWidths: const{
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                          },
                          border: TableBorder.all(color: Colors.black),
                          children: pendingOrderDetailsList
                              .map((e) => TableRow(children: [
                                    Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          e.material,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.grey),
                                        )),
                                    Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          "₹ " + e.netPrice,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.grey),
                                        )),
                                    Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          e.orderQty.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.grey),
                                        )),
                                    Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          "₹ " + e.netValue,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.grey),
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
                    Text(widget.qunatity,
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

  Future getPendingOrderFullDetails() async {
    setState(() {
      isLoader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String acessToken = prefs.getString('token').toString();

    var url = Apis.pendingOrderDetails;
    var data = {
      "token": acessToken.toString(),
      "order_id": widget.orderId.toString(),
    };

    var response = await APIHelper.apiPostRequest(url, data);
    var result = jsonDecode(response);

    if (result['success'] == true) {
      var _list = result['data'] as List;
      setState(() {
        pendingOrderDetailsList.clear();
        var listdata =
            _list.map((e) => PendingOrderDetailsModel.fromJson(e)).toList();
        pendingOrderDetailsList.addAll(listdata);
      });
    }
    setState(() {
      isLoader = false;
    });
  }
}
