// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/favourite_products_screen.dart';
import 'package:tayal/views/help_screen.dart';
import 'package:tayal/views/ledger_screen.dart';
import 'package:tayal/views/new%20glan/invoice_screen.dart';
import 'package:tayal/views/new%20glan/new_ledger_screen.dart';
import 'package:tayal/views/notification_screen.dart';
import 'package:tayal/views/order_list_screen.dart';
import 'package:tayal/views/payment_statement_screen.dart';
import 'package:tayal/views/new%20glan/pending_order_screen.dart';
import 'package:tayal/views/profile_screen.dart';
import 'package:tayal/views/referral_screen.dart';
import 'package:tayal/views/new%20glan/sales_register_screen.dart';
import 'package:tayal/views/wallet_statement_screen.dart';
import 'package:tayal/widgets/navigation_drawer_widget.dart';

class MyBizScreen extends StatefulWidget {
  const MyBizScreen({Key key}) : super(key: key);

  @override
  _MyBizScreenState createState() => _MyBizScreenState();
}

class _MyBizScreenState extends State<MyBizScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }
  List labels = [
    {
      "label": "Profile",
      "image": "assets/icons/profile_icon.png",
      "page": ProfileScreen()
    },
    {
      "label": "Order",
      "image": "assets/icons/order_icon.png",
      "page": OrderlistScreen()
    },
    {
      "label": "Ledger",
      "image": "assets/icons/ledger_icon.png",
      "page": NewLedgerScreen()
    },
    {
      "label": "Payments",
      "image": "assets/icons/payment_icon.png",
      "page": PaymentStatementScreen()
    },
    {
      "label": "Wallet",
      "image": "assets/icons/waller.png",
      "page": WalletStatementScreen()
    },
    {
      "label": "Help",
      "image": "assets/icons/help_icon.png",
      "page": HelpScreen()
    },
    {
      "label": "Referal",
      "image": "assets/icons/referal.png",
      "page": ReferralScreen()
    },
    {
      "label": "Favourite",
      "image": "assets/icons/fav.png",
      "page": FavouriteProductScreen()
    },
    {
      "label": "Pending Orders",
      "image": "assets/icons/order_icon.png",
      "page": PendingOrderScreen()
    },
      {
      "label": "Sales Register",
      "image": "assets/icons/sale_register.png",
      "page": SalesRegisterScreen()
    }, {
      "label": "Invoice",
      "image": "assets/icons/invoice.png",
      "page": InvoiceScreen()
    }
  ];


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: kBackgroundShapeColor,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
          backgroundColor: appbarcolor,
          leading: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.openDrawer();
              },
              child: Image.asset(
                "assets/images/circle.png",
                scale: 25,
                color: Colors.white,
              )),
          centerTitle: true,
          title: Text("My Biz",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 21,
                  fontWeight: FontWeight.bold)),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NotificationScreen()));
                },
                child: Image.asset(
                  "assets/images/bell.png",
                  scale: 25,
                  color: Colors.white,
                ))
          ]),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.9,
          physics: ClampingScrollPhysics(),
          children: labels
              .map(
                (e) => InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => e['page']));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Card(
                        elevation: 4.0,
                        color: Colors.indigo.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 15),
                              Container(
                                height: 40,
                                child: Image.asset(e['image'].toString(),
                                    scale: labels.indexOf(e) == 7 ? 6 : 6),
                              ),
                              SizedBox(width: 10.0),
                              Text(e['label'],
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      )),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
