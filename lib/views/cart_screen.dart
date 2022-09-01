// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/components/loader.dart';
import 'package:tayal/helper/dialog_helper.dart';
import 'package:tayal/models/cartlistdata.dart';
import 'package:tayal/network/api.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/category_screen.dart';
import 'package:tayal/views/change_address.dart';
import 'package:tayal/views/checkout_screen.dart';
import 'package:tayal/views/payment_options_screen.dart';
import 'package:tayal/views/product_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String totalprice = "0.0";
  String address = "";
  String userwallet = "";
  String cashback = "";
  int totalitems = 0;
  String utilizeAmount = "";
  String nodata = "";
  List mainData = [];
  String addressType = "Home-";
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCartData();

    _getCartBadge();
  }

  void _getCartBadge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    totalitems = int.parse(prefs.getString('cartcount'));
  }

  TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 12);
  TextStyle textStylePay = TextStyle(color: Colors.indigo, fontSize: 12);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kBackgroundShapeColor,
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
              title: Text("My Cart",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 21,
                      fontWeight: FontWeight.bold)),
              actions: [
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Empty Cart"),
                                content: Text("Do you want to empty cart."),
                                actionsAlignment: MainAxisAlignment.spaceAround,
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: Text("Cancel")),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        _emptyCart();
                                      },
                                      child: Text("Empty"))
                                ],
                              ));
                    },
                    icon: Image.asset(
                      "assets/images/emptycart.png",
                      color: Colors.white,
                    ))
              ]),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : nodata == "" || nodata == null
                  ? Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 5.0),
                              child: Card(
                                color: Colors.indigo.shade100,
                                elevation: 0.0,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.location_on_outlined,
                                              color: Colors.black, size: 20),
                                          SizedBox(width: 2),
                                          Expanded(
                                              child: Text("Deliver to : " +
                                                  addressType)),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              height: 25,
                                              width: 90,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                  border: Border.all(
                                                      color: Colors.indigo,
                                                      width: 1)),
                                              child: GestureDetector(
                                                child: Text(
                                                  address != null
                                                      ? 'Change'
                                                      : 'Add New',
                                                  style: const TextStyle(
                                                    color: Colors.indigo,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChangeAddressPage()));
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      // SizedBox(
                                      //     width: MediaQuery.of(context).size.width *
                                      //         0.65,
                                      //     child: address == null || address == ""
                                      //         ? Text("")
                                      //         : Text(
                                      //             address.toString().toUpperCase(),
                                      //             style: TextStyle(
                                      //                 color: Colors.black,
                                      //                 fontSize: 12)))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: '',
                                    style: DefaultTextStyle.of(context).style,
                                    children: const [
                                      TextSpan(
                                          text: 'Cart Items',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),
                                      // TextSpan(
                                      //     text: ' (Swipe item left to delete)',
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.bold,
                                      //         color: Colors.black,
                                      //         fontSize: 10)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                SizedBox(
                                  height: roundoff != "null"
                                      ? MediaQuery.of(context).size.height /
                                          2.22
                                      : MediaQuery.of(context).size.height /
                                          2.12,
                                  child: Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: ListView.separated(
                                          itemCount: mainData.length,
                                          padding: EdgeInsets.zero,
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider(
                                                      height: 3,
                                                      color: Colors.grey),
                                          itemBuilder: (context, index) {
                                            return itemContainer(
                                                index,
                                                mainData,
                                                mainData[index]['id']
                                                    .toString(),
                                                mainData[index]['cart_id']
                                                    .toString(),
                                                mainData[index]['product_name']
                                                    .toString(),
                                                mainData[index]['product_image']
                                                    .toString(),
                                                mainData[index]['quantity']
                                                    .toString(),
                                                mainData[index]['amount']
                                                    .toString(),
                                                mainData[index]['offer_price']
                                                    .toString(),
                                                mainData[index]
                                                        ['short_description']
                                                    .toString(),
                                                (parse(parse(mainData[index][
                                                                    'group_price']
                                                                .toString())
                                                            .body
                                                            .text)
                                                        .documentElement
                                                        .text)
                                                    .toString());
                                          })),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentOptionsScreen(
                                                    utilizeAmount:
                                                        utilizeAmount,
                                                    payableAmount: totalprice,
                                                    walletAmount: userwallet,
                                                    cashBack: cashback)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Sub-Total",
                                                  style: textStyle),
                                              Text(
                                                  "\u20B9 " +
                                                      double.parse(subtotal
                                                              .toString())
                                                          .toStringAsFixed(2)
                                                          .toString(),
                                                  style: textStyle),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Delivery (incl. tax)",
                                                  style: textStyle),
                                              Text("\u20B9 " + delevivery,
                                                  style: textStyle),
                                            ],
                                          ),
                                          Column(
                                            children: taxList
                                                .map((e) => Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          e['title']
                                                                  .toString() +
                                                              " (%" +
                                                              e['rate']
                                                                  .toString() +
                                                              ")",
                                                          style: textStyle,
                                                        ),
                                                        Text(
                                                          "\u20B9 " +
                                                              e['tax_amount']
                                                                  .toString(),
                                                          style: textStyle,
                                                        )
                                                      ],
                                                    ))
                                                .toList(),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Cash Discount",
                                                  style: textStyle),
                                              Text("\u20B9 " + discount,
                                                  style: textStyle),
                                            ],
                                          ),
                                          roundoff == "null"
                                              ? SizedBox()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Round Off",
                                                        style: textStyle),
                                                    Text("\u20B9 " + roundoff,
                                                        style: textStyle),
                                                  ],
                                                ),
                                          Card(
                                            color: Colors.green,
                                            margin: EdgeInsets.zero,
                                            elevation: 10,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  totalitems.toString() == "1"
                                                      ? Text(
                                                          totalitems
                                                                  .toString() +
                                                              " Item",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18))
                                                      : Text(
                                                          totalitems
                                                                  .toString() +
                                                              " Items",
                                                          style:
                                                              TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18)),
                                                  Text(
                                                    totalprice.toString() !=
                                                            null
                                                        ? "(\u20B9 " +
                                                            double.parse(totalprice
                                                                    .toString())
                                                                .toStringAsFixed(
                                                                    2) +
                                                            ") " +
                                                            "Pay"
                                                        : 0.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // InkWell(
                                //   onTap: () {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) =>
                                //                 PaymentOptionsScreen(
                                //                     payableAmount: totalprice,
                                //                     walletAmount: userwallet,
                                //                     cashBack: cashback)));
                                //   },
                                //   child: Container(
                                //     // height: 50,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(12),
                                //       color: Colors.indigo,
                                //     ),
                                //     child: Padding(
                                //       padding:
                                //           EdgeInsets.symmetric(horizontal: 10),
                                //       child: Row(
                                //         children: [
                                //           totalitems.toString() == "1"
                                //               ? Text(
                                //                   totalitems.toString() + " Item",
                                //                   style: const TextStyle(
                                //                     fontSize: 16,
                                //                     color: Colors.white,
                                //                   ))
                                //               : Text(
                                //                   totalitems.toString() +
                                //                       " Items",
                                //                   style: const TextStyle(
                                //                       fontSize: 16,
                                //                       color: Colors.white,
                                //                       fontWeight:
                                //                           FontWeight.w500)),
                                //           const SizedBox(width: 10),
                                //           const Padding(
                                //             padding: EdgeInsets.symmetric(
                                //                 horizontal: 5),
                                //             child: VerticalDivider(
                                //                 width: 2, color: Colors.white),
                                //           ),
                                //           SizedBox(width: 10),
                                //           Expanded(
                                //             child: Text(
                                //               totalprice.toString() != null
                                //                   ? "\u20B9 $totalprice"
                                //                   : 0.toString(),
                                //               style: const TextStyle(
                                //                   color: Colors.white,
                                //                   fontWeight: FontWeight.w500,
                                //                   fontSize: 16),
                                //             ),
                                //           ),
                                //           const Text("Proceed to pay",
                                //               style: TextStyle(
                                //                   color: Colors.white,
                                //                   fontSize: 16,
                                //                   fontWeight: FontWeight.w500)),
                                //           const SizedBox(width: 5),
                                //           const Icon(
                                //               Icons.arrow_forward_ios_rounded,
                                //               color: Colors.white,
                                //               size: 16)
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: size.height,
                      width: size.width,
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Container(
                              height: 90,
                              width: 90,
                              child:
                                  Image.asset('assets/images/empty_cart.png'),
                            ),
                            SizedBox(height: 10),
                            Text(nodata.toString().toUpperCase(),
                                textAlign: TextAlign.center)
                          ]))),
        ),
        onWillPop: () async {
          Navigator.of(context).pop();
        });
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text(
        "Proceed",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CheckOutScreen(
                      address: address,
                      amount: totalprice,
                    )));
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Widget itemContainer(
      int index,
      List data,
      String id,
      String cardid,
      String productname,
      String productimage,
      String qty,
      String rate,
      String offerprice,
      String description,
      String groupprice) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
        child: Container(
          child: Stack(alignment: Alignment.topRight, children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      //color: Colors.blue.shade200,
                      border: Border.all(),

                      //     image: DecorationImage(
                      //         image: NetworkImage(productimage),
                      //         fit: BoxFit.fitWidth),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        productimage,
                        scale: 8,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // child: Container(
                  //   width: 80,
                  //   height: 80,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //     //color: Colors.blue.shade200,
                  //     border: Border.all(),

                  //     image: DecorationImage(
                  //         image: NetworkImage(productimage),
                  //         fit: BoxFit.fitWidth),
                  //   ),
                  // ),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productname,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                      text:
                                          '\u20B9 ${mainData[index]['rate'].toString()}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: ' MRP',
                                      style: TextStyle(fontSize: 9)),
                                ],
                              ),
                            ),
                            mainData[index]['discount_price'] == null
                                ? SizedBox()
                                : RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                            text:
                                                '\u20B9 ${mainData[index]['discount_price'].toString()}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: ' DEALER PR.',
                                            style: TextStyle(fontSize: 9)),
                                      ],
                                    ),
                                  ),
                            mainData[index]['trade_price'] == null
                                ? SizedBox()
                                : RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                            text:
                                                '\u20B9 ${mainData[index]['trade_price'].toString()}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: ' SCHEME PR.',
                                            style: TextStyle(fontSize: 9)),
                                      ],
                                    ),
                                  ),

                            // Text(
                            //     "\u20B9 " +
                            //         mainData[index]['offer_price'].toString(),
                            //     maxLines: 2,
                            //     style:
                            //         TextStyle(color: Colors.black, fontSize: 14)),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // Text("\u20B9 " + mainData[index]['rate'].toString(),
                            //     maxLines: 2,
                            //     style: TextStyle(
                            //         color: Colors.grey,
                            //         fontSize: 14,
                            //         decoration: TextDecoration.lineThrough)),
                          ],
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: Text(groupprice,
                            maxLines: 2,
                            style:
                                TextStyle(color: Colors.black, fontSize: 10))),
                  ],
                ),
                // Expanded(
                //     child: Text("x" + data[index]['quantity'].toString(),
                //         style: const TextStyle(
                //             color: Colors.black,
                //             fontSize: 14,
                //
                // fontWeight: FontWeight.w700))),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text("\u20B9 " + data[index]['amount'].toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    Container(
                      width: 80,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: data[index]["controller"],
                        onChanged: (val) {
                          setState(() {
                            data[index]['quantity'] = int.parse(val);
                            data[index]['isChange'] = true;
                          });
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 5,
                        decoration: InputDecoration(

                            // suffix: Icon(
                            //     Icons.add),
                            counterText: "",
                            contentPadding: EdgeInsets.only(left: 5),
                            isDense: true,
                            isCollapsed: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 5))),
                      ),
                    ),
                    Container(
                        width: 80,
                        height: 20,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: data[index]['isChange']
                                    ? MaterialStateProperty.all(Colors.indigo)
                                    : MaterialStateProperty.all(
                                        Colors.indigo[300]),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                )),
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero)),
                            onPressed: () {
                              if (data[index]['isChange']) {
                                FocusScope.of(context).unfocus();
                                if (data[index]['quantity'] <
                                    data[index]['avaliable_stock']) {
                                  showLaoding(context);
                                  _addtocart(
                                          data[index]['id'].toString(),
                                          data[index]['offer_price'].toString(),
                                          data[index]['quantity'].toString(),
                                          data[index]['amount'].toString())
                                      .then((value) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    _getCartData();
                                  });
                                } else {
                                  Fluttertoast.showToast(msg: "Out of Stock");
                                }
                              }
                            },
                            child: Text("UPDATE")))
                  ],
                )
              ],
            ),
            InkWell(
              onTap: () {
                showAlertDialog(context, cardid.toString());
              },
              child: Icon(
                Icons.clear,
                color: Colors.red,
              ),
            )
          ]),
        ));
  }

  List taxList = [];
  String delevivery = "-";
  String subtotal = "-";
  String discount = "-";
  String roundoff = "-";
  Future<void> _getCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + cartlist),
        headers: {'Authorization': 'Bearer $mytoken'});
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'].toString() != "0") {
        setState(() {
          nodata = json.decode(response.body)['ErrorMessage'].toString();
          prefs.setString('cartcount', "0");
        });
      } else {
        print(response.body);
        List data = [];
        Map map = jsonDecode(response.body)['Response']['tax'];

        map.forEach((key, value) {
          if (isNumeric(key.toString())) {
            print(key);
            data.add(key.toString());
          }
        });

        setState(() {
          taxList.clear();
        });
        data.forEach((element) {
          setState(() {
            taxList.add(map[element.toString()]);
          });
        });
        print(taxList);
        setState(() {
          delevivery = "";
          delevivery =
              jsonDecode(response.body)['Response']['delivery_fee'].toString();
          subtotal = "";
          subtotal =
              jsonDecode(response.body)['Response']['sub_total'].toString();
          discount = "";
          discount =
              jsonDecode(response.body)['Response']['discount'].toString();
          roundoff = "";
          roundoff =
              jsonDecode(response.body)['Response']['roundoff'].toString();
        });
        print(delevivery);

        setState(() {
          totalprice =
              json.decode(response.body)['Response']['total_price'].toString();
          address =
              json.decode(response.body)['Response']['address'].toString();
          addressType = "";
          addressType =
              json.decode(response.body)['Response']['address_type'].toString();

          userwallet =
              json.decode(response.body)['Response']['user_wallet'].toString();

          utilizeAmount = json
              .decode(response.body)['Response']['utilizeAmount']
              .toString();

          cashback = (parse(parse(json
                          .decode(response.body)['Response']['pay_now_bonus']
                          .toString())
                      .body
                      .text)
                  .documentElement
                  .text)
              .toString();
          totalitems = json.decode(response.body)['Response']['items'].length;
        });
        Iterable list = json.decode(response.body)['Response']['items'];

        list.forEach((element) {
          setState(() {
            element["controller"] =
                TextEditingController(text: element['quantity'].toString());
            element["isChange"] = false;
          });
        });
        setState(() {
          mainData.clear();
          mainData = list;
          //print(mainData[1]);
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  Future<bool> _addtocart(
      String id, String offerprice, String quantity, String rate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "product_id": id,
      "offer_price": offerprice,
      "rate": (double.parse(rate) * 1).toInt(),
      "quantity": quantity
    };
    var response = await http.post(Uri.parse(BASE_URL + addcart),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });
    print(jsonEncode({
      "product_id": id,
      "offer_price": offerprice,
      "rate": (double.parse(rate) * 1).toInt(),
      "quantity": quantity
    }));
    // if (response.statusCode == 200) {
    //   print(response.body);

    // } else {
    //   print(response.body);
    //   throw Exception('Failed to get data due to ${response.body}');
    // }
    print(response.body);
    if (json.decode(response.body)['ErrorCode'].toString() == "0") {
      setState(() {
        prefs.setString('cartcount',
            json.decode(response.body)['Response']['count'].toString());
        totalitems = int.parse(
            json.decode(response.body)['Response']['count'].toString());
      });
    } else {
      Fluttertoast.showToast(
          msg: jsonDecode(response.body)['ErrorMessage'].toString());
    }
    return true;
  }

  void showAlertDialog(BuildContext context, String itemid) {
    Widget cancelButton = FlatButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: const Text("Delete"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        _deleteitemfromCart(itemid);
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Item"),
      content: const Text("Are you sure to delete this item from cart?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future _deleteitemfromCart(String itemid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "cart_id": itemid,
    };
    var response = await http.post(Uri.parse(BASE_URL + cartitemdelete),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      print(response.body);
      if (json.decode(response.body)['ErrorMessage'].toString() == "success") {
        showToast('Item deleted successfully from cart');
        setState(() {
          _getCartData();
          totalprice =
              json.decode(response.body)['Response']['total_price'].toString();
          totalitems = json.decode(response.body)['Response']['count'];
          prefs.setString('cartcount',
              json.decode(response.body)['Response']['count'].toString());
        });
      }
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _emptyCart() async {
    showLaoding(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();

    var response = await http.post(Uri.parse(BASE_URL + cartempty), headers: {
      'Authorization': 'Bearer $mytoken',
      'Content-Type': 'application/json'
    });
    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
