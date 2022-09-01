import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/components/filterStatement.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';

class WalletStatementTabScrren extends StatefulWidget {
  const WalletStatementTabScrren({Key key}) : super(key: key);

  @override
  _WalletStatementTabScrrenState createState() =>
      _WalletStatementTabScrrenState();
}

class _WalletStatementTabScrrenState extends State<WalletStatementTabScrren> {
  String startDate = "From Date";
  String endDate = "To Date";

  DateTime selectedDate = DateTime.now();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  List<dynamic> _txnlist = [];

  int _value = 0;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      startDate = DateTime(DateTime.now().year, DateTime.now().month, 1)
          .toString()
          .split(" ")[0];
      endDate = DateTime.now().toString().split(" ")[0];
    });

    _gettxndata(startDate, endDate, "datewise");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
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
                  GestureDetector(
                    onTap: () {
                      _selectedEndDate(context);
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Radio(
                              value: 1,
                              groupValue: _value,
                              activeColor: Colors.indigo,
                              onChanged: (value) {
                                setState(() {
                                  startDate = "From Date";
                                  endDate = "To Date";
                                  _value = value;
                                });
                                _gettxndata("0", "0", "yesterday");
                              }),
                          const Text('Yesterday',
                              style: TextStyle(fontSize: 12))
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              value: 2,
                              activeColor: Colors.indigo,
                              groupValue: _value,
                              onChanged: (value) {
                                setState(() {
                                  startDate = "From Date";
                                  endDate = "To Date";
                                  _value = value;
                                });
                                _gettxndata("0", "0", "today");
                              }),
                          Text('Today', style: TextStyle(fontSize: 12))
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              value: 3,
                              groupValue: _value,
                              activeColor: Colors.indigo,
                              onChanged: (value) {
                                setState(() {
                                  startDate = "From Date";
                                  endDate = "To Date";
                                  _value = value;
                                });
                                _gettxndata("0", "0", "month");
                              }),
                          Text('Month Till Date',
                              style: TextStyle(fontSize: 12))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(bottom: 45.0),
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _txnlist.isEmpty || _txnlist.length == 0
                      ? Padding(
                          padding: EdgeInsets.only(bottom: size.height * 0.08),
                          child: Center(
                            child: Text("Data not found",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16)),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _txnlist.length,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(height: 1, color: Colors.grey),
                          itemBuilder: (BuildContext context, int index) {
                            if (_txnlist.isEmpty || _txnlist.length == 0) {
                              return Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.indigo));
                            } else {
                              return ListTile(
                                title: Text(
                                    '${_txnlist[index]['created_at'].toString()}',
                                    style: TextStyle(
                                        color: Colors.indigo.shade400,
                                        fontSize: 16)),
                                subtitle: Text(
                                    '${_txnlist[index]['description'].toString()}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                                trailing: _txnlist[index]['transaction_type']
                                            .toString() ==
                                        "credit"
                                    ? Text(
                                        '\u20B9 ${_txnlist[index]['points'].toString()} Cr',
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 12))
                                    : Text(
                                        '\u20B9 ${_txnlist[index]['points'].toString()} Dr',
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 12)),
                              );
                            }
                          },
                        ),
            )),
          ],
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: InkWell(
              onTap: () {
                if (_value == 0) {
                  if (startDate == "From Date") {
                    showToast('Please select start date');
                    return;
                  } else if (endDate == "To Date") {
                    showToast('Please select start date');
                    return;
                  } else {
                    setState(() {
                      _txnlist.clear();
                    });
                    _gettxndata(startDate, endDate, "datewise");
                  }
                } else {
                  if (_value == 1) {
                    setState(() {
                      _txnlist.clear();
                    });
                    _gettxndata("0", "0", "yesterday");
                  } else if (_value == 2) {
                    setState(() {
                      _txnlist.clear();
                    });
                    _gettxndata("0", "0", "today");
                  } else {
                    setState(() {
                      _txnlist.clear();
                    });
                    _gettxndata("0", "0", "month");
                  }
                }
              },
              child: Container(
                height: 45,
                width: double.infinity,
                color: Colors.indigo,
                alignment: Alignment.center,
                child: const Text("GET STATEMENT",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ))
      ],
    ));
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
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
        _value = 0;
        selectedStartDate = picked;
        startDate = selectedStartDate.year.toString() +
            "-" +
            selectedStartDate.month.toString() +
            "-" +
            selectedStartDate.day.toString();
        _txnlist.clear();
      });
  }

  Future<void> _selectedEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
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
        _value = 0;
        selectedEndDate = picked;
        endDate = selectedEndDate.year.toString() +
            "-" +
            selectedEndDate.month.toString() +
            "-" +
            selectedEndDate.day.toString();
        _txnlist.clear();
      });
  }

  Future _gettxndata(
      String startdate, String enddate, String filtertype) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    print(jsonEncode({
      "start_date": startdate,
      "end_date": enddate,
    }));
    final body = {
      "start_date": startdate,
      "end_date": enddate,
    };
    var response = await http.post(Uri.parse(BASE_URL + wallettxnstatement),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'].toString() == "0") {
        if (filtertype == "datewise") {
          setState(() {
            _txnlist = json.decode(response.body)['Response']['date_filter'];
          });
        } else if (filtertype == "today") {
          setState(() {
            _txnlist = json.decode(response.body)['Response']['today'];
          });
        } else if (filtertype == "yesterday") {
          setState(() {
            _txnlist = json.decode(response.body)['Response']['yesterday'];
          });
        } else {
          setState(() {
            _txnlist = json.decode(response.body)['Response']['till_date'];
          });
        }
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
