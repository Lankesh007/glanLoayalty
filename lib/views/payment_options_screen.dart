import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/thanku_screen.dart';

class PaymentOptionsScreen extends StatefulWidget {
  String payableAmount;
  String walletAmount;
  String cashBack;
  String utilizeAmount;
  PaymentOptionsScreen(
      {this.payableAmount,
      this.walletAmount,
      this.cashBack,
      this.utilizeAmount});

  @override
  _PaymentOptionsScreenState createState() => _PaymentOptionsScreenState(
      payableAmount, walletAmount, cashBack, utilizeAmount);
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  String payableAmount;
  String walletAmount;
  String utilizeAmount;
  String cashBack;
  _PaymentOptionsScreenState(
      this.payableAmount, this.walletAmount, this.cashBack, this.utilizeAmount);

  bool _walletVisibility = false;
  bool _cashVisibility = false;
  bool _onlineVisibility = false;
  int selectedIndex = 0;

  Razorpay _razorpay;
  bool _loading = false;

  var orderid;

  bool walletCheckBox = true;
  bool showWalletCheck = false;
  @override
  void initState() {
    setState(() {
      utilizeAmount = double.parse(utilizeAmount).toStringAsFixed(2).toString();
    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();

    _getWalletBalance();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("success");
    //print(response.orderId.toString());
    print(response.paymentId.toString());
    _onlinePayment(orderid.toString(), response.paymentId.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Failed");
    print(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  _onlinePayment(String orderid, String paymentid) async {
    print("online payment option");
    print("order id " + orderid);
    print("payment id " + paymentid);
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "razorpay_order_id": orderid,
      "razorpay_payment_id": paymentid
    };
    var response = await http.post(Uri.parse(BASE_URL + updateonlinepaymet),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _loading = false;
      });
      if (json.decode(response.body)['ErrorMessage'].toString() == "success") {
        prefs.setString("cartcount", "0");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ThankuScreen(
                      orderid: json
                          .decode(response.body)['Response']['idc_order_id']
                          .toString(),
                    )));
        //var orderid = json.decode(response.body)['Response']['razorpay_order']['id'].toString();
        //startPayment(orderid, amount);
      }
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarcolor,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(
              "assets/images/back.png",
              scale: 20,
              color: Colors.white,
            )),
        centerTitle: true,
        title: Text("Payment Options",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 21,
                fontWeight: FontWeight.bold)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Total Payable Amount : " +
                          double.parse(widget.payableAmount.toString())
                              .toStringAsFixed(2),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 12.0, right: 12.0, bottom: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Wallet Payment",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 4.0),
                              Text("Available Amount: \u20B9 $walletAmount",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                              Text("Utilized Amount: \u20B9 $utilizeAmount",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                              // SizedBox(height: 4.0),
                              // selectedIndex == 0 &&
                              //         double.parse(payableAmount) >
                              //             double.parse("$walletAmount")
                              //     ? Text(
                              //         "Payable Amount: \u20B9" +
                              //             ((double.parse(payableAmount) -
                              //                         double.parse(
                              //                             "$walletAmount"))
                              //                     .toStringAsFixed(2))
                              //                 .toString(),
                              //         style: TextStyle(
                              //             color: Colors.black, fontSize: 14.0))
                              //     : Text("Payable Amount: \u20B9" +
                              //         ((double.parse(payableAmount))
                              //                 .toStringAsFixed(2))
                              //             .toString())
                            ],
                          ),
                          //  CustomRadioButton(0)
                          Checkbox(
                              value: walletCheckBox,
                              activeColor: Colors.indigo,
                              onChanged: (val) {
                                setState(() {
                                  walletCheckBox = !walletCheckBox;
                                  if (walletCheckBox) {
                                    if (double.parse(utilizeAmount) <
                                        double.parse(payableAmount)) {
                                      payableAmount =
                                          (double.parse(payableAmount) -
                                                  double.parse(utilizeAmount))
                                              .toString();
                                      setState(() {
                                        showWalletCheck = false;
                                      });
                                    } else {
                                      setState(() {
                                        showWalletCheck = true;
                                        selectedIndex = 0;
                                        CustomRadioButton(0);
                                        _onlineVisibility = false;
                                        _cashVisibility = false;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      showWalletCheck = false;
                                    });
                                    payableAmount =
                                        widget.payableAmount.toString();
                                  }
                                });
                              })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    showWalletCheck
                        ? InkWell(
                            onTap: () {
                              _placeorderonline();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Container(
                                height: 55.0,
                                width: double.infinity,
                                child: Card(
                                  elevation: 4.0,
                                  color: Colors.indigo,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.indigo, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                        "PAY BY WALLET : \u20B9 " +
                                            double.parse(payableAmount)
                                                .toStringAsFixed(2)
                                                .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),

                    SizedBox(height: 5.0),
                    // Visibility(
                    //   visible: _walletVisibility,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(
                    //         left: 10.0, right: 10.0, bottom: 10.0),
                    //     child: InkWell(
                    //       onTap: () {},
                    //       child: Container(
                    //         height: 55.0,
                    //         width: double.infinity,
                    //         child: Card(
                    //           elevation: 4.0,
                    //           color: Colors.indigo,
                    //           shape: RoundedRectangleBorder(
                    //             side:
                    //                 BorderSide(color: Colors.indigo, width: 1),
                    //             borderRadius: BorderRadius.circular(10),
                    //           ),
                    //           child: Padding(
                    //             padding: const EdgeInsets.only(top: 15.0),
                    //             child: double.parse(payableAmount) >
                    //                     double.parse("$walletAmount")
                    //                 ? Text(
                    //                     "PAY \u20B9 " +
                    //                         ((double.parse(payableAmount) -
                    //                                     double.parse(
                    //                                         "$walletAmount"))
                    //                                 .toStringAsFixed(2))
                    //                             .toString() +
                    //                         " BY ONLINE",
                    //                     textAlign: TextAlign.center,
                    //                     style: TextStyle(
                    //                         color: Colors.white,
                    //                         fontWeight: FontWeight.w500))
                    //                 : Text(
                    //                     "PAY \u20B9 " +
                    //                         ((double.parse(payableAmount))
                    //                                 .toStringAsFixed(2))
                    //                             .toString() +
                    //                         " BY WALLET",
                    //                     textAlign: TextAlign.center,
                    //                     style: TextStyle(
                    //                         color: Colors.white,
                    //                         fontWeight: FontWeight.w500)),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              SizedBox(height: 15),
              Stack(
                children: [
                  AbsorbPointer(
                    absorbing: showWalletCheck,
                    child: Column(
                      children: [
                        Card(
                          elevation: 4.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 12.0, right: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Online Payment",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(height: 4.0),
                                        const SizedBox(
                                            width: 290,
                                            child: Text(
                                                "Choose online payment option",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0))),
                                        // selectedIndex == 0
                                        //     ? Text(
                                        //         "Payable Amount: \u20B9 $payableAmount",
                                        //         style: TextStyle(
                                        //             color: Colors.black,
                                        //             fontSize: 14.0))
                                        //     : Container()
                                        Text(
                                            "Payable Amount: \u20B9 " +
                                                double.parse(payableAmount)
                                                    .toStringAsFixed(2)
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0)),

                                        cashBack == "" || cashBack == null
                                            ? SizedBox(height: 0)
                                            : SizedBox(height: 15),
                                        cashBack == "" || cashBack == null
                                            ? SizedBox(height: 0)
                                            : Center(
                                                child: Card(
                                                  elevation: 4.0,
                                                  color: Colors.indigo.shade50,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: Colors.indigo,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0,
                                                                  left: 12.0,
                                                                  right: 12.0),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                  'assets/images/cashback_amt.png',
                                                                  scale: 3),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text("Cashback",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .indigo,
                                                                      fontSize:
                                                                          14))
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5.0,
                                                                  left: 12.0,
                                                                  right: 12.0),
                                                          child: cashBack == "" ||
                                                                  cashBack ==
                                                                      null
                                                              ? SizedBox(
                                                                  height: 0.0)
                                                              : SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      1.4,
                                                                  child: Text(
                                                                      "$cashBack",
                                                                      maxLines:
                                                                          2,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .indigo,
                                                                          fontSize:
                                                                              14.0,
                                                                          decoration:
                                                                              TextDecoration.none))),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                    CustomRadioButton(1)
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Visibility(
                                visible: _onlineVisibility,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, bottom: 10.0),
                                  child: InkWell(
                                    onTap: () {
                                      _placeorderonline();
                                    },
                                    child: Container(
                                      height: 55.0,
                                      width: double.infinity,
                                      child: Card(
                                        elevation: 4.0,
                                        color: Colors.indigo,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.indigo, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                              "PAY ONLINE : \u20B9 " +
                                                  double.parse(payableAmount)
                                                      .toStringAsFixed(2)
                                                      .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        // Card(
                        //   elevation: 4.0,
                        //   color: Colors.white,
                        //   shape: RoundedRectangleBorder(
                        //     side: BorderSide(color: Colors.white, width: 1),
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.only(
                        //             top: 10.0, left: 12.0, right: 12.0),
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Column(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.start,
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 const Text("Cash on delivery",
                        //                     style: TextStyle(
                        //                         color: Colors.black,
                        //                         fontSize: 14.0,
                        //                         fontWeight: FontWeight.w500)),
                        //                 SizedBox(height: 4.0),
                        //                 SizedBox(
                        //                     width: MediaQuery.of(context)
                        //                             .size
                        //                             .width *
                        //                         0.75,
                        //                     child: const Text(
                        //                         "Pay cash at the time of delivery. We recommend you use online payments for contactless delivery",
                        //                         maxLines: 3,
                        //                         style: TextStyle(
                        //                             color: Colors.grey,
                        //                             fontSize: 12.0))),
                        //                 const SizedBox(height: 4.0),
                        //                 // selectedIndex == 1
                        //                 //     ? Text(
                        //                 //         "Payable Amount: \u20B9 $payableAmount",
                        //                 //         style: TextStyle(
                        //                 //             color: Colors.black,
                        //                 //             fontSize: 14.0))
                        //                 //     : Container()
                        //                 Text(
                        //                     "Payable Amount: \u20B9 " +
                        //                         double.parse(payableAmount)
                        //                             .toStringAsFixed(2)
                        //                             .toString(),
                        //                     style: TextStyle(
                        //                         color: Colors.black,
                        //                         fontSize: 14.0))
                        //               ],
                        //             ),
                        //             CustomRadioButton(2)
                        //           ],
                        //         ),
                        //       ),
                        //       SizedBox(height: 5.0),
                        //       Visibility(
                        //         visible: _cashVisibility,
                        //         child: Padding(
                        //           padding: const EdgeInsets.only(
                        //               left: 10.0, right: 10.0, bottom: 10.0),
                        //           child: InkWell(
                        //             onTap: () {
                        //               _placeorder();
                        //             },
                        //             child: Container(
                        //               height: 55.0,
                        //               width: double.infinity,
                        //               child: Card(
                        //                 elevation: 4.0,
                        //                 color: Colors.indigo,
                        //                 shape: RoundedRectangleBorder(
                        //                   side: BorderSide(
                        //                       color: Colors.indigo, width: 1),
                        //                   borderRadius:
                        //                       BorderRadius.circular(10),
                        //                 ),
                        //                 child: const Padding(
                        //                   padding: EdgeInsets.only(top: 15.0),
                        //                   child: Text("PLACE ORDER",
                        //                       textAlign: TextAlign.center,
                        //                       style: TextStyle(
                        //                           color: Colors.white,
                        //                           fontWeight: FontWeight.w500)),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  showWalletCheck
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey.withOpacity(0.2),
                        )
                      : SizedBox()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void changeIndex(int index) {
    if (index == 0) {
      setState(() {
        selectedIndex = index;
        _walletVisibility = true;
        _onlineVisibility = false;
        _cashVisibility = false;
      });
    } else if (index == 1) {
      setState(() {
        selectedIndex = index;
        _walletVisibility = false;
        _onlineVisibility = true;
        _cashVisibility = false;
      });
    } else {
      setState(() {
        selectedIndex = index;
        _walletVisibility = false;
        _onlineVisibility = false;
        _cashVisibility = true;
      });
    }
  }

  Widget CustomRadioButton(int index) {
    if (selectedIndex == index) {
      return InkWell(
        onTap: () => changeIndex(index),
        child: Container(
          height: 24.0,
          width: 24.0,
          child: Icon(Icons.check_circle, size: 24.0, color: Colors.indigo),
        ),
      );
    } else {
      return InkWell(
        onTap: () => changeIndex(index),
        child: Container(
          height: 20.0,
          width: 20.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey, width: 1)),
        ),
      );
    }
  }

  Future _placeorderonline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    setState(() {
      _loading = true;
    });
    var response = await http.post(Uri.parse(BASE_URL + placeorderonline),
        headers: {'Authorization': 'Bearer $mytoken'},
        body: {"use_wallet": "1"});
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      if (json.decode(response.body)['ErrorCode'] == 0) {
        if (json
            .decode(response.body)['Response']["razorpay_order"]
            .toString()
            .isEmpty) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ThankuScreen(
                        orderid: json
                            .decode(response.body)['Response']['order_id']
                            .toString(),
                      )));
        } else {
          orderid = json
              .decode(response.body)['Response']['razorpay_order']['id']
              .toString();
          startPayment(orderid, payableAmount);
        }
      }
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  void startPayment(String orderid, String amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(orderid + "test");
    try {
      var options = {
        'key': 'rzp_test_MhKrOdDQM8C8PL',
        //'key': 'rzp_test_MhKrOdDQM8C8PL',
        //'key': 'rzp_live_BFMsXWTfZmdTnn',
        // 'amount': ((int.parse(amount)) * 100)
        // .toString(), //in the smallest currency sub-unit.
        'name': 'Tayal',
        'order_id': orderid,
        //"reference_id": orderid.toString(),
        'description': '',
        'timeout': 600, // in seconds
        'prefill': {
          'contact': prefs.getString('mobile'),
          'email': prefs.getString('email')
        }
      };
      _razorpay.open(options);
    } catch (e) {
      print("test2-----" + e.toString());
    }
  }

  Future _placeorder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    setState(() {
      _loading = true;
    });
    var response = await http.post(Uri.parse(BASE_URL + placeorder),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      print(response.body);
      if (json.decode(response.body)['ErrorCode'].toString() == "0") {
        if (json.decode(response.body)['ErrorMessage'].toString() ==
            "success") {
          prefs.setString("cartcount", "0");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ThankuScreen(
                        orderid: json
                            .decode(response.body)['Response']['order_id']
                            .toString(),
                      )));
        }
      }
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  void _getWalletBalance() {
    if (double.parse(utilizeAmount) > 0) {
      if (double.parse(utilizeAmount) > double.parse(payableAmount)) {
        setState(() {
          showWalletCheck = true;
        });
      } else {
        setState(() {
          showWalletCheck = false;
          // _walletVisibility = true;
          payableAmount =
              (double.parse(payableAmount) - double.parse(utilizeAmount))
                  .toString();
        });
      }
    } else {
      setState(() {
        _onlineVisibility = false;
      });
    }
  }
}
