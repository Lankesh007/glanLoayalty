// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, avoid_print, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/models/profiledata.dart';
import 'package:tayal/network/api.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/themes/constant.dart';

class LedgerStatementScreen extends StatefulWidget {
  String title;
  LedgerStatementScreen({this.title});

  @override
  _LedgerStatementScreenState createState() => _LedgerStatementScreenState();
}

class _LedgerStatementScreenState extends State<LedgerStatementScreen>
    with SingleTickerProviderStateMixin {
  String mobile;
  String walletblnc;

  TabController _tabController;

  List ledgerList = [];
  String startDate = "From Date";
  String endDate = "To Date";
  final controller = ScrollController();
  int totalPageCount = 0;
  String total_due = "0";
  int count = 1;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<List<ProfileResponse>> temp = _getprofile();
    temp.then((value) {
      setState(() {
        mobile = value[0].mobile.toString();
        walletblnc = value[0].userWallet.toString();
      });
    });
    setState(() {
      startDate = DateTime(DateTime.now().year, DateTime.now().month, 1)
          .toString()
          .split(" ")[0];
      endDate = DateTime.now().toString().split(" ")[0];
      ledgerList.clear();
      totalPageCount = 0;
      count = 1;
    });

    _getLedgerData(
        DateTime(DateTime.now().year, DateTime.now().month, 1)
            .toString()
            .split(" ")[0],
        DateTime.now().toString().split(" ")[0],
        "1");
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() {
          count++;
        });
        if (count <= totalPageCount) {
          _getLedgerData(startDate, endDate, count.toString());
        }
      }
    });
    //_tabController = TabController(length: 2, vsync: this);
    //_tabController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 180,
            color: appbarcolor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon:
                                  Icon(Icons.arrow_back, color: Colors.white)),
                          Text(
                            widget.title.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "List Count : " + ledgerList.length.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      )
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.white),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.48,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              const Text("Mobile Number",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              Text('$mobile',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.04,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
                          child: VerticalDivider(
                            color: Colors.white,
                            thickness: 1,
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.48,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Wallet Balance",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              Text("\u20B9 $walletblnc",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Total Due : " + total_due.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14))
              ],
            ),
          ),
          Padding(
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
                        height: size.height * 0.06,
                        color: Colors.indigo.shade50,
                        width: size.width * 0.44,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                startDate,
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16.0),
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
                        height: size.height * 0.06,
                        color: Colors.indigo.shade50,
                        width: size.width * 0.44,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                endDate,
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16.0),
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
          ),
       
          Container(
              height: MediaQuery.of(context).size.height / 1.7,
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ledgerList.length == 0
                      ? Center(
                          child: Text("No data available"),
                        )
                      : ListView.separated(
                          controller: controller,
                          itemCount: ledgerList.length + 1,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(height: 1, color: Colors.grey),
                          itemBuilder: (BuildContext context, int index) {
                            if (index == ledgerList.length) {
                              return ListTile(
                                title: Center(
                                    child: totalPageCount != count || count == 1
                                        ? Text("List End")
                                        : CircularProgressIndicator()),
                              );
                            } else {
                              return ledgerList[index]['entry_type'].toString() ==
                                      "orders"
                                  ? ListTile(
                                      title: Text(
                                          ledgerList[index]['created_at']
                                              .toString()
                                              .split(".")[0]
                                              .replaceAll("T", " "),
                                          style: TextStyle(
                                              color: Colors.indigo.shade400,
                                              fontSize: 16)),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Order Placed Against Order No. - ' +
                                                  ledgerList[index]['order_no']
                                                      .toString()
                                                      .toUpperCase()
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          Text(
                                              'Payment Status - ' +
                                                  ledgerList[index]
                                                          ['payment_status']
                                                      .toString()
                                                      .toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          // Text(
                                          //     'Trans. Type - ' +
                                          //         ledgerList[index]['payment_method']
                                          //             .toString()
                                          //             .toUpperCase(),
                                          //     style: TextStyle(
                                          //         color: Colors.grey, fontSize: 12)),
                                        ],
                                      ),
                                      trailing: ledgerList[index]['txn_type'].toString() == "credit"
                                          ? Text('\u20B9 ' + ledgerList[index]['amount'].toString() + ' Cr',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12))
                                          : Text(
                                              '\u20B9 ' +
                                                  ledgerList[index]['amount']
                                                      .toString() +
                                                  ' Dr',
                                              style: TextStyle(color: Colors.red, fontSize: 12)))
                                  : ListTile(
                                      title: Text(ledgerList[index]['created_at'].toString().split(".")[0].replaceAll("T", " "), style: TextStyle(color: Colors.indigo.shade400, fontSize: 16)),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Payment Against Order No. - ' +
                                                  ledgerList[index]['order_no']
                                                      .toString()
                                                      .toUpperCase()
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          Text(
                                              'Trans. Type - ' +
                                                  ledgerList[index]
                                                          ['payment_method']
                                                      .toString()
                                                      .toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                      trailing: ledgerList[index]['txn_type'].toString() == "credit" ? Text('\u20B9 ' + ledgerList[index]['amount'].toString() + ' Cr', style: TextStyle(color: Colors.green, fontSize: 12)) : Text('\u20B9 ' + ledgerList[index]['amount'].toString() + ' Dr', style: TextStyle(color: Colors.red, fontSize: 12)));
                            }
                          }))
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

    if (picked != null)
      setState(() {
        startDate = picked.toString().split(" ")[0];
        endDate = "To Date";
        total_due = "0";
        count = 1;
        totalPageCount = 0;
        ledgerList.clear();
      });
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

      if (picked != null)
        setState(() {
          endDate = picked.toString().split(" ")[0];
          _getLedgerData(startDate, endDate, "1");
          total_due = "0";
          count = 1;
          totalPageCount = 0;
          ledgerList.clear();
        });
    }

  Future<List<ProfileResponse>> _getprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + profile),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response'];
      List<ProfileResponse> _list =
          list.map((m) => ProfileResponse.fromJson(m)).toList();
      return _list;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _getLedgerData(String date1, String date2, String page) async {
    print({
      "start_date": date1,
      "end_date": date2,
      "page": page.toString(),
      "page_wise_count": "10",
    });
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + ledger), headers: {
      'Authorization': 'Bearer $mytoken'
    }, body: {
      "start_date": date1,
      "end_date": date2,
      "page": page.toString(),
      "page_wise_count": "10",
    });
    if (response.statusCode == 200) {
      Map map = jsonDecode(response.body)['Response'];

      List test = [];
      map.forEach((key, value) {
        if (isNumeric(key.toString())) {
          test.add({
            "order_no": value['order_no'].toString(),
            "user_id": value['user_id'].toString(),
            "mobile_no": value['mobile_no'].toString(),
            "payment_id": value['payment_id'].toString(),
            "payment_mode": value['payment_mode'].toString(),
            "payment_status": value['payment_status'].toString(),
            "payment_method": value['payment_method'].toString(),
            "amount": value['amount'].toString(),
            "created_at": value['created_at'].toString(),
            "txn_type": value['txn_type'].toString(),
            "entry_type": value['entry_type'].toString(),
          });
        } else if (key.toString() != "total_due" &&
            key.toString() != "total_page") {
          // print(key);
          test.add({
            "order_no": value['order_id'].toString(),
            "user_id": value['user_id'].toString(),
            "mobile_no": value['mobile_no'].toString(),
            "payment_id": value['payment_id'].toString(),
            "payment_mode": "",
            "payment_status": value['payment_status'].toString(),
            "payment_method": "",
            "amount": value['amount'].toString(),
            "created_at": value['created_at'].toString(),
            "txn_type": value['txn_type'].toString(),
            "entry_type": value['entry_type'].toString(),
          });
        }
      });

      setState(() {
        // ledgerList.clear();
        ledgerList.addAll(test);
        totalPageCount = int.parse(map['total_page'].toString());
        total_due = map['total_due'].toString();
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }

    setState(() {
      isLoading = false;
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }
}
