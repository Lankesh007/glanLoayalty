import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckOutNewPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CheckOutNewPage>
    with SingleTickerProviderStateMixin {
  var _razorpay = Razorpay();

  var _userId, takeaway_address;

  //var _dateDropdownVal = 'Today';
  var _timeDropdownVal;

  var type_of_order = "";
  var _placeOrderBtnParent = 'Place Order';

  //var _placeOrderBtn = 'Place Order';
  Future _myCartList;
  final nameController = TextEditingController();
  final couponcodeController = TextEditingController();
  final instructionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var errorCode;
  var response;
  var data, total;
  AnimationController _animationController;
  List dataModel = new List();
  Map<String, dynamic> value = new Map();
  String _paymentMode = "Online Payment";
  bool isPress1 = false;
  bool isPress2 = false;

  String _name, _mobile, _email;
  String radioButtonItem = 'Today';
  String radioButtonItem1 = 'OnlIne Delivery';
  int id;
  int id1 = 1;
  var today, tomorrow;
  String formatted;

  List<bool> isChecked;

  List addextraitem = [];

  double totalPrice = 0.0;
  String couponcode = "";

  double finalPrice = 0;

  String userinstructions = "";
  FocusNode myFocusNode;

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    final now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    today = DateTime(now.year, now.month, now.day);
    formatted = formatter.format(today);
    _timeDropdownVal = DateFormat('hh:mm:ss').format(DateTime.now());

    myFocusNode = FocusNode();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("success");
    print(response.orderId);
    //_onlinePayment(response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Failed");
    print(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  void dispose() {
    couponcodeController.dispose();
    nameController.dispose();
    instructionController.dispose();
    myFocusNode.dispose();
    _razorpay.clear();

    super.dispose();
  }

  Widget _emptyCart() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              // height: 150,
              // width: 150,
              margin: const EdgeInsets.only(bottom: 20),
              child: Image.asset("assets/images/empty_cart.png"),
            ),
            Text(
              "No Items Yet!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 10, bottom: 80),
              child: Text(
                "Browse and add items in your shopping bag.",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  changeThemeMode1() {
    if (isPress1) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.reverse(from: 1.0);
    }
  }

  changeThemeMode2() {
    if (isPress2) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.reverse(from: 1.0);
    }
  }

  bool _loading = false;

  Widget build(BuildContext context) {
    /*pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(
      progress: 80.0,
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(10.0), child: CircularProgressIndicator(color: kPrimaryColor)),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w100),
    );*/

    return Scaffold(
        appBar: AppBar(
          title: Text('My Shopping Basket'),
        ),
        body: Container()
        // ModalProgressHUD(
        //   inAsyncCall: _loading,
        //   child: RefreshIndicator(
        //     child: Container(
        //       color: Colors.grey[200],
        //       child: ,
        //     ),
        //     onRefresh: refreshList,
        //   ),
        // ),
        );
  }

  Widget itemContainer(
      List<dynamic> allitems,
      int index,
      String id,
      String cardid,
      String productname,
      String productimage,
      String qty,
      String rate,
      String amount,
      String offerprice) {
    return Container(
        child: Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product-details',
                      arguments: <String, String>{
                        'product_id': id,
                        'title': productname,
                      },
                    );
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      //color: Colors.blue.shade200,
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(productimage),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/product-details',
                                arguments: <String, String>{
                                  'product_id': id.toString(),
                                  'title': productname,
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 8, top: 0),
                              child: Text(
                                productname,
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  flex: 100,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\u20B9 " + "$amount",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(25 / 2),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.remove,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(allitems[index]['quantity'].toString()),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () async {
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25 / 2),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget extraItemContainer(
      List<dynamic> allitems,
      int index,
      String id,
      String cardid,
      String totalprice,
      String productname,
      String productimage,
      String qty,
      String rate,
      String amount,
      String offerprice,
      List<dynamic> extraitem) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/product-details',
                        arguments: <String, String>{
                          'product_id': id,
                          'title': productname,
                        },
                      );
                    },
                    child: Container(
                      margin:
                          EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        //color: Colors.blue.shade200,
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(productimage),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/product-details',
                                arguments: <String, String>{
                                  'product_id': id.toString(),
                                  'title': productname,
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 8, top: 0),
                              child: Text(
                                productname,
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListView.builder(
                                            itemCount: extraitem.length,
                                            shrinkWrap: true,
                                            primary: false,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return extraitem[index]['enabled']
                                                          .toString() ==
                                                      "1"
                                                  ? Text(
                                                      extraitem[index]
                                                              ['addon_name']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade500,
                                                          fontSize: 12.0))
                                                  : Container();
                                            }),
                                        GestureDetector(
                                          onTap: () {
                                            extraItem(
                                                context,
                                                amount,
                                                rate,
                                                extraitem,
                                                totalprice,
                                                id,
                                                offerprice,
                                                qty,
                                                addextraitem);
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text("CUSTOMIZED",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontSize: 14.0)),
                                              SizedBox(width: 2.0),
                                              Icon(
                                                  Icons
                                                      .keyboard_arrow_down_sharp,
                                                  size: 24.0,
                                                  color: Colors.grey.shade700)
                                            ],
                                          ),
                                        )
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
                    flex: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      height: 80,
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "\u20B9 " + "${allitems[index]['amount']}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {},
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(25 / 2),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.remove,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(allitems[index]['quantity'].toString()),
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () async {},
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25 / 2),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  extraItem(
      context,
      String amount,
      String rate,
      List<dynamic> items,
      String totalprice,
      String id,
      String offerprice,
      String qty,
      List addextraitem) {
    addextraitem.clear();
    List group_ids = [];
    items.forEach((element) {
      group_ids.add(element['group_id'].toString());
    });
    List mylist = [];
    Map newMap = groupBy(items, (obj) => obj['group_id']);
    group_ids.toSet().toList().forEach((element) {
      Map mymap = {};
      mymap['group_id'] = element.toString();

      mymap['data'] = newMap[int.parse(element.toString())];
      mymap['title_name'] =
          newMap[int.parse(element.toString())][0]['title_name'];
      mymap['group_name'] =
          newMap[int.parse(element.toString())][0]['group_name'];
      mymap['addon_limit'] =
          newMap[int.parse(element.toString())][0]['addon_limit'];
      mylist.add(mymap);
    });
    //var temp = addextraitem.toSet().toList();
    //print(temp);
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter extrasetState) {
                return Container(
                    height: 600,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0))),
                    child: Stack(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: mylist.map((e) {
                                List tempList = e['data'];
                                return Column(children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 8, top: 10),
                                      child: Text(e['group_name'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                  SizedBox(height: 2.0),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: e['addon_limit'].toString() == "0"
                                          ? Container()
                                          : Text(
                                              e['title_name']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0)),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Column(
                                    children: tempList
                                        .map((ee) => Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Container(
                                                height: 40,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 12.0,
                                                      width: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.green,
                                                              width: 1.0)),
                                                      child: Icon(
                                                        Icons.circle,
                                                        color: Colors.green,
                                                        size: 6.0,
                                                      ),
                                                    ),
                                                    SizedBox(width: 6.0),
                                                    Text(ee['addon_name']),
                                                    SizedBox(width: 10.0),
                                                    Expanded(
                                                        child: ee['addon_price']
                                                                    .toString() ==
                                                                "0.00"
                                                            ? Text("")
                                                            : Text("\u20B9" +
                                                                ee['addon_price'])),
                                                    Checkbox(
                                                      activeColor: Colors.green,
                                                      value: ee['enabled']
                                                                  .toString() ==
                                                              "1"
                                                          ? true
                                                          : false,
                                                      onChanged: (val) {
                                                        if (int.parse(e[
                                                                    'addon_limit']
                                                                .toString()) ==
                                                            0) {
                                                          print("1");
                                                          if (ee['enabled']
                                                                  .toString() ==
                                                              "1") {
                                                            extrasetState(() {
                                                              ee['enabled'] =
                                                                  "0";
                                                            });
                                                            addextraitem.add({
                                                              "id": ee['id']
                                                                  .toString(),
                                                              "price": ee[
                                                                      'addon_price']
                                                                  .toString(),
                                                              "status": 0
                                                            });
                                                            extrasetState(() {
                                                              totalprice = (double
                                                                          .parse(
                                                                              totalprice) -
                                                                      double.parse(
                                                                          ee['addon_price']))
                                                                  .toString();
                                                            });
                                                            /*for (int i = 0; i < addextraitem.length; i++) {
                                                      if (addextraitem[i]['id'].toString() == ee['id'].toString()) {
                                                        addextraitem.removeAt(i);
                                                        */ /*extrasetState(() {
                                                           totalprice =(double.parse(totalprice)-double.parse(ee['addon_price'])).toString();
                                                        });*/ /*
                                                      }
                                                    }*/
                                                          } else {
                                                            extrasetState(() {
                                                              ee['enabled'] =
                                                                  "1";
                                                            });
                                                            addextraitem.add({
                                                              "id": ee['id']
                                                                  .toString(),
                                                              "price": ee[
                                                                      'addon_price']
                                                                  .toString(),
                                                              "status": 1
                                                            });
                                                          }
                                                        } else {
                                                          if (ee['enabled']
                                                                  .toString() ==
                                                              "1") {
                                                            extrasetState(() {
                                                              ee['enabled'] =
                                                                  "0";
                                                            });
                                                            addextraitem.add({
                                                              "id": ee['id']
                                                                  .toString(),
                                                              "price": ee[
                                                                      'addon_price']
                                                                  .toString(),
                                                              "status": 0
                                                            });
                                                            extrasetState(() {
                                                              totalprice = (double
                                                                          .parse(
                                                                              totalprice) -
                                                                      double.parse(
                                                                          ee['addon_price']))
                                                                  .toString();
                                                            });
                                                            /*for (int i = 0; i < addextraitem.length; i++) {
                                                      if (addextraitem[i]['id'].toString() == ee['id'].toString()) {
                                                        addextraitem.removeAt(i);
                                                        */ /*extrasetState(() {
                                                          totalprice =(double.parse(totalprice)-double.parse(ee['addon_price'])).toString();
                                                        });*/ /*
                                                      }
                                                    }*/
                                                          } else {
                                                            int total = 0;
                                                            tempList.forEach(
                                                                (element) {
                                                              if (element['enabled']
                                                                      .toString() ==
                                                                  "1") {
                                                                total++;
                                                                //totalprice = totalprice+double.parse(element['addon_price'].toString());

                                                              }
                                                            });
                                                            if (total <
                                                                int.parse(e[
                                                                        'addon_limit']
                                                                    .toString())) {
                                                              extrasetState(() {
                                                                ee['enabled'] =
                                                                    "1";
                                                              });
                                                              addextraitem.add({
                                                                "id": ee['id']
                                                                    .toString(),
                                                                "price": ee[
                                                                        'addon_price']
                                                                    .toString(),
                                                                "status": 1
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg: e['title_name']
                                                                          .toString() +
                                                                      " items\nUnselect selected items");
                                                            }
                                                          }
                                                        }
                                                        print("my print");
                                                        double temp1 = 0;
                                                        for (int i = 0;
                                                            i <
                                                                addextraitem
                                                                    .length;
                                                            i++) {
                                                          if (addextraitem[i]
                                                                      ['status']
                                                                  .toString() ==
                                                              "1") {
                                                            temp1 = temp1 +
                                                                double.parse(addextraitem[
                                                                            i][
                                                                        'price']
                                                                    .toString());
                                                            print(addextraitem[
                                                                i]);
                                                          }
                                                        }
                                                        print(temp1);
                                                        extrasetState(() {
                                                          finalPrice = temp1;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  )
                                ]);
                              }).toList(),
                            )),
                        Positioned(
                          bottom: 10.0,
                          left: 10.0,
                          right: 10.0,
                          child: GestureDetector(
                            onTap: () {
                              //Navigator.of(context).pop();
                              Navigator.pop(context);
                            },
                            child: StatefulBuilder(
                              builder: (BuildContext context,
                                      StateSetter extrasetState) =>
                                  Container(
                                height: 45,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Total Price : " +
                                              (double.parse(totalprice
                                                          .toString()) +
                                                      finalPrice)
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                      Text("UPDATE ITEM & CLOSE",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ));
              },
            ));
  }

  Widget buildInstructionContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Card(
        elevation: 4.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 24,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.75,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8.0),
                  child: TextFormField(
                    focusNode: myFocusNode,
                    controller: instructionController,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write instructions for restaurant',
                    ),
                    onChanged: (value) {
                      userinstructions = value;
                    },
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline,
                    size: 20.0, color: Colors.grey.shade500),
                onPressed: () {
                  myFocusNode.requestFocus();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
