import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/models/profiledata.dart';
import 'package:tayal/network/api.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/themes/constant.dart';
import 'package:tayal/wallet_tab_views/transaction_list_screen.dart';
import 'package:tayal/wallet_tab_views/wallet_statement_detail_screen.dart';

class WalletStatementScreen extends StatefulWidget {
  const WalletStatementScreen({Key key}) : super(key: key);

  @override
  _WalletStatementScreenState createState() => _WalletStatementScreenState();
}

class _WalletStatementScreenState extends State<WalletStatementScreen>
    with SingleTickerProviderStateMixin {
  String mobile;
  String walletblnc;

  TabController _tabController;

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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 145,
            color: appbarcolor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back, color: Colors.white)),
                      Text("Wallet Statement",
                          style: TextStyle(color: Colors.white, fontSize: 16))
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
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: appbarcolor,
            child: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.white,
              labelColor: Colors.white,
              controller: _tabController,
              tabs: [
                Tab(
                  text: "LAST 10 TRANSACTIONS",
                ),
                Tab(
                  text: "DETAIL STATEMENT",
                )
              ],
            ),
          ),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [TransactionlistScreen(), WalletStatementTabScrren()],
          ))
        ],
      ),
    );
  }

  Future<List<ProfileResponse>> _getprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + profile),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      print(response.body);
      Iterable list = json.decode(response.body)['Response'];
      List<ProfileResponse> _list =
          list.map((m) => ProfileResponse.fromJson(m)).toList();
      return _list;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
