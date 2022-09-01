import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayal/helper/dialog_helper.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/order_detail_screen.dart';

class ThankuScreen extends StatefulWidget {
  String orderid;
  ThankuScreen({this.orderid});

  @override
  _ThankuScreenState createState() => _ThankuScreenState(orderid);
}

class _ThankuScreenState extends State<ThankuScreen> {
  String orderid;
  _ThankuScreenState(this.orderid);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: appbarcolor,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashBoardScreen()));
                },
                child: Image.asset(
                  "assets/images/back.png",
                  scale: 20,
                  color: Colors.white,
                )),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(
                child: Column(
              children: [
                Image.asset('assets/images/confirmation.png', fit: BoxFit.fill),
                const SizedBox(height: 10),
                const Text("Thank you!",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 21)),
                const SizedBox(height: 10),
                const Text("Your purchase is confirmed",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                const SizedBox(height: 20),
                const Text("Your order id",
                    style: TextStyle(color: Colors.black, fontSize: 14)),
                InkWell(
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(
                                    orderid: orderid.toString(),
                                  )));
                    }),
                    child: Text('$orderid',
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline)))
              ],
            )),
          ),
        ),
        onWillPop: () async {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashBoardScreen()));
        });
  }
}
