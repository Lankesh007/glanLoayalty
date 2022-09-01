import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/thanku_screen.dart';

class CheckOutScreen extends StatefulWidget {

  String address;
  String amount;
  CheckOutScreen({this.address, this.amount});

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState(address, amount);
}

class _CheckOutScreenState extends State<CheckOutScreen> {

   String address;
   String amount;
  _CheckOutScreenState(this.address, this.amount);

   bool _loading = false;
   bool bycourierVisibility = false;
   bool byselfVisibility = true;

   var _razorpay = Razorpay();

   @override
  void initState() {
     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      super.initState();
  }

   void _handlePaymentSuccess(PaymentSuccessResponse response) {
     print("success");
     print(response.orderId);
     _onlinePayment(response.orderId.toString(), response.paymentId.toString());
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

   _onlinePayment(String orderid, String paymentid) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String mytoken = prefs.getString('token').toString();
     setState(() {
       _loading = true;
     });
     final body = {
       "razorpay_order_id" : orderid,
       "razorpay_payment_id" : paymentid
     };
     var response = await http.post(Uri.parse(BASE_URL+placeorderonline),
         body: json.encode(body),
         headers: {
           'Authorization': 'Bearer $mytoken',
           'Content-Type': 'application/json'
         }
         );
     if (response.statusCode == 200)
     {
       setState(() {
         _loading = false;
       });
       if(json.decode(response.body)['ErrorMessage'].toString() == "success"){
         prefs.setString("cartcount", "0");
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ThankuScreen()));
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
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      body: ModalProgressHUD(
        color: Colors.indigo,
        inAsyncCall: _loading,
        child: Stack (
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SvgPicture.asset('assets/images/back.svg', fit: BoxFit.fill),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                      Text("Checkout", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 21, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: const[
                                  Text("Payment Method", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                                  Text("CHANGE", style: TextStyle(fontSize: 14, color: Colors.grey))
                               ],
                             ),
                             const SizedBox(height: 20),
                             Row(
                                 children: const[
                                   Icon(Icons.web_asset, size: 24, color: Colors.black),
                                   SizedBox(width: 10),
                                   Text(".... .... ..4747", style: TextStyle(fontSize: 14, color: Colors.grey))
                                 ]

                             ),
                             const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const[
                                Text("Delivery Address", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                                Text("CHANGE", style: TextStyle(fontSize: 14, color: Colors.grey))
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                                children: [
                                  Image.asset('assets/images/home.png'),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.70,
                                      child: address == "" || address == null ? Text("") : Text(address, textAlign: TextAlign.start, maxLines: 4, style: TextStyle(fontSize: 14, color: Colors.grey)))
                                ]

                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const[
                                Text("Delivery options", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                                Text("CHANGE", style: TextStyle(fontSize: 14, color: Colors.grey))
                              ],
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  byselfVisibility = true;
                                  bycourierVisibility = false;
                                });
                              },
                              child: Row(
                                  children: [
                                    SvgPicture.asset('assets/images/walking.svg'),
                                    const SizedBox(width: 10),
                                    const Expanded(child: Text("I'll pick up myself", maxLines: 4, style: TextStyle(fontSize: 14, color: Colors.grey))),
                                    Visibility(
                                        visible: byselfVisibility,
                                        child: const Icon(Icons.check, color: Colors.grey, size: 20)
                                    )
                                  ]

                              ),
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: (){
                                setState(() {
                                    byselfVisibility = false;
                                    bycourierVisibility = true;
                                });
                              },
                              child: Row(
                                  children: [
                                    SvgPicture.asset('assets/images/bike.svg'),
                                    const SizedBox(width: 10),
                                    const Expanded(child: Text("By Courier", maxLines: 4, style: TextStyle(fontSize: 14, color: Colors.grey))),
                                    Visibility(
                                        visible: bycourierVisibility,
                                        child: const Icon(Icons.check, color: Colors.grey, size: 20)
                                    )
                                  ]

                              ),
                            ),

                          ],
                        ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                left: 20,
                bottom: 30,
                right: 20,
                child: newElevatedButton()
            )
          ],
        ),
      ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: Text(
        "Payment",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: (){
        if(byselfVisibility){
          _placeorder();
        }
        else{
          _placeorderonline();
        }

      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Future _placeorder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    setState(() {
      _loading = true;
    });
    var response = await http.post(Uri.parse(BASE_URL+placeorder),
        headers : {'Authorization': 'Bearer $mytoken'}
    );
    if (response.statusCode == 200)
    {
      setState(() {
        _loading = false;
      });
      print(response.body);
      if(json.decode(response.body)['ErrorCode'].toString() == "0"){
        if(json.decode(response.body)['ErrorMessage'].toString() == "success"){
          prefs.setString("cartcount", "0");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ThankuScreen()));
        }
      }
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

   Future _placeorderonline() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String mytoken = prefs.getString('token').toString();
     setState(() {
       _loading = true;
     });
     var response = await http.post(Uri.parse(BASE_URL+placeorderonline),
         headers : {'Authorization': 'Bearer $mytoken'}
     );
     if (response.statusCode == 200)
     {
       setState(() {
         _loading = false;
       });
       if(json.decode(response.body)['ErrorMessage'].toString() == "success"){
        var orderid = json.decode(response.body)['Response']['razorpay_order']['id'].toString();
        startPayment(orderid, amount);
       }

     } else {
       setState(() {
         _loading = false;
       });
       throw Exception('Failed to get data due to ${response.body}');
     }
   }

   void startPayment(String orderid, String amount) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     try {
       var options = {
         'key': 'rzp_test_MhKrOdDQM8C8PL',
         //'key': 'rzp_test_MhKrOdDQM8C8PL',
         //'key': 'rzp_live_BFMsXWTfZmdTnn',
         'amount' : ((int.parse(amount))*100).toString(), //in the smallest currency sub-unit.
         'name': 'Tayal',
         //'order_id' : orderid,
         "reference_id": orderid.toString(),
         'description': '',
         'timeout': 600, // in seconds
         'prefill': {
           'contact': prefs.getString('mobile'),
           'email': prefs.getString('email')
         }
       };
       _razorpay.open(options);
     }
     catch(e) {}}
}
