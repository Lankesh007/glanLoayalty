import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/models/profiledata.dart';
import 'package:tayal/network/api.dart';

class TransactionlistScreen extends StatefulWidget {
  const TransactionlistScreen({Key key}) : super(key: key);

  @override
  _TransactionlistScreenState createState() => _TransactionlistScreenState();
}

class _TransactionlistScreenState extends State<TransactionlistScreen> {
  List<dynamic> _txnlist = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gettxndata().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _txnlist.length == 0
              ? Center(
                  child: Text("Data not found",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                )
              : ListView.separated(
                  itemCount: _txnlist.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(height: 1, color: Colors.grey),
                  itemBuilder: (BuildContext context, int index) {
                    if (_txnlist.isEmpty || _txnlist.length == 0) {
                      return Center(
                          child:
                              CircularProgressIndicator(color: Colors.indigo));
                    } else {
                      return ListTile(
                        title: Text(
                            '${_txnlist[index]['created_at'].toString()}',
                            style: TextStyle(
                                color: Colors.indigo.shade400, fontSize: 16)),
                        subtitle: Text(
                            '${_txnlist[index]['description'].toString()}',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        trailing: _txnlist[index]['transaction_type']
                                    .toString() ==
                                "credit"
                            ? Text(
                                '\u20B9 ${_txnlist[index]['points'].toString()} Cr',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 12))
                            : Text(
                                '\u20B9 ${_txnlist[index]['points'].toString()} Dr',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12)),
                      );
                    }
                  },
                ),
    );
  }

  Future _gettxndata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + wallettxn),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'].toString() == "0") {
        setState(() {
          _txnlist = json.decode(response.body)['Response']['transactions'];
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
