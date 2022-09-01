import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/network/api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tayal/themes/constant.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/views/cart_screen.dart';
import 'package:tayal/views/category_screen.dart';
import 'package:tayal/views/help_screen.dart';
import 'package:tayal/views/mybiz_screen.dart';
import 'package:tayal/widgets/bottom_appbar.dart';

class ProductDetailScreen extends StatefulWidget {
  String productid;
  String totalprice;
  ProductDetailScreen({this.productid, this.totalprice});

  @override
  _ProductDetailScreenState createState() =>
      _ProductDetailScreenState(productid, totalprice);
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String productid;
  String totalprice;
  _ProductDetailScreenState(this.productid, this.totalprice);

  int proQty = 1;
  int _counter = 0;
  int current_stock = 0;

  //int _totalprice = 0;

  List<dynamic> images = [];
  String productimage = "";
  String productname;
  String productprice;
  String short_desc;
  String long_desc;
  String netweight;

  String rate;
  String amount;
  String offerprice;
  String tradeprice;

  String itemlength;
  String itemwidth;
  String itemheight;

  String groupprice;

  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productdetails(productid).then((value) {
      setState(() {
        _loading = false;
      });
    });
    _getCartCount();
  }

  void _getCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   _counter = int.parse(prefs.getString('cartcount'));
    // });

    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + cartlist),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'].toString() != "0") {
      } else {
        setState(() {
          _counter = 0;
          _counter = json.decode(response.body)['Response']['items'].length;
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.of(context).pushReplacement(
      //           MaterialPageRoute(builder: (context) => CategoryScreen()));
      //     },
      //     backgroundColor: Colors.indigo,
      //     child: Icon(Icons.add)),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: const BottomAppBar(
      //   shape: CircularNotchedRectangle(),
      //   color: Color(0xffBCBEFD),
      //   child: MyBottomAppBar(),
      // ),
      appBar: AppBar(
          backgroundColor: appbarcolor,
          centerTitle: true,
          title: Text("Product Detail",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 21,
                  fontWeight: FontWeight.bold)),
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                "assets/images/back.png",
                scale: 20,
                color: Colors.white,
              )),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Badge(
                    badgeColor: Colors.white,
                    animationDuration: Duration(milliseconds: 10),
                    animationType: BadgeAnimationType.scale,
                    padding: EdgeInsets.all(5),
                    badgeContent: Text(
                      '$_counter',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                    child: Image.asset(
                      "assets/images/cart.png",
                      color: Colors.white,
                    )),
                onPressed: () {
                  if (_counter > 0) {
                    // Get.offNamed('/cart');
                    //Get.off(CartScreen());
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen()))
                        .then((value) {});
                  } else {
                    showToast('Your cart is empty');
                  }
                },
              ),
            )
          ]),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.pop(context);
                      //       },
                      //       child: SvgPicture.asset('assets/images/back.svg'),
                      //     ),
                      //     //SizedBox(width: MediaQuery.of(context).size.width * 0.08),
                      //     const Text("Product Detail",
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             fontStyle: FontStyle.normal,
                      //             fontSize: 21,
                      //             fontWeight: FontWeight.bold)),
                      //     Padding(
                      //       padding: EdgeInsets.only(right: 10),
                      //       child: IconButton(
                      //         icon: Badge(
                      //           animationDuration: Duration(milliseconds: 10),
                      //           animationType: BadgeAnimationType.scale,
                      //           badgeContent: Text(
                      //             '$_counter',
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //           child: const Icon(Icons.shopping_basket,
                      //               color: Colors.grey, size: 28),
                      //         ),
                      //         onPressed: () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => CartScreen()));
                      //         },
                      //       ),
                      //     )
                      //   ],
                      // ),
                      Expanded(
                          child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        children: [
                          Column(
                            children: [
                              Card(
                                  elevation: 4.0,
                                  shape: const RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: images.length == 0 || images.isEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: CachedNetworkImage(
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      'assets/images/no_image.jpg'),
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                      'assets/images/no_image.jpg'),
                                              imageUrl: productimage),
                                        )
                                      : CarouselSlider.builder(
                                          itemCount: images.length,
                                          itemBuilder: (context, itemIndex) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                child: CachedNetworkImage(
                                                    width: double.infinity,
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Image.asset(
                                                            'assets/images/no_image.jpg'),
                                                    placeholder: (context,
                                                            url) =>
                                                        Image.asset(
                                                            'assets/images/no_image.jpg'),
                                                    imageUrl:
                                                        images[itemIndex]),
                                              ),
                                            );
                                          },
                                          options: CarouselOptions(
                                            height: 200.0,
                                            //enlargeCenterPage: true,
                                            autoPlay: true,
                                            //aspectRatio: 16 / 7,
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enableInfiniteScroll: true,
                                            autoPlayAnimationDuration:
                                                Duration(milliseconds: 800),
                                            viewportFraction: 1.0,
                                          ),
                                        )),
                              SizedBox(height: 5),
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        productname.toString() == "" ||
                                                productname.toString() ==
                                                    "null" ||
                                                productname.toString() == null
                                            ? ""
                                            : productname,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                              ),
                              netweight == "" || netweight == null
                                  ? SizedBox()
                                  : Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                              netweight.toString() == "" ||
                                                      netweight.toString() ==
                                                          null ||
                                                      netweight.toString() ==
                                                          "null"
                                                  ? ""
                                                  : "Netweight(gm): $netweight",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ),
                              itemlength == "" || itemlength == null
                                  ? SizedBox()
                                  : Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                              itemlength.toString() == "" ||
                                                      itemlength.toString() ==
                                                          null ||
                                                      itemlength.toString() ==
                                                          "null"
                                                  ? ""
                                                  : "Dimension(cm): $itemlength x $itemwidth x $itemheight",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ),
                              SizedBox(height: 5),
                              Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("MRP"),
                                          Text("\u20B9 $rate",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("DEALER PRICE"),
                                          Text("\u20B9 $offerprice",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("SCHEME PRICE"),
                                          Text("\u20B9 $tradeprice",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14)),
                                        ],
                                      )
                                    ],
                                  )),
                              groupprice == "" || groupprice == null
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          left: 15, top: 5, right: 15),
                                      child: Card(
                                        elevation: 0,
                                        color: Colors.indigo.shade100,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 5, 8, 5),
                                          child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  groupprice.toString() == "" ||
                                                          groupprice
                                                                  .toString() ==
                                                              null ||
                                                          groupprice
                                                                  .toString() ==
                                                              "null"
                                                      ? ""
                                                      : "$groupprice",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                        ),
                                      )),
                              SizedBox(height: 10),
                              Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          short_desc.toString() == "" ||
                                                  short_desc.toString() ==
                                                      null ||
                                                  short_desc.toString() ==
                                                      "null"
                                              ? ""
                                              : short_desc,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15)))),
                              Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          long_desc.toString() == "" ||
                                                  long_desc.toString() ==
                                                      null ||
                                                  long_desc.toString() == "null"
                                              ? ""
                                              : long_desc,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)))),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, bottom: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 150,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        // controller: data[index]["controller"],
                                        onChanged: (val) {
                                          setState(() {
                                            proQty = int.parse(val.toString());
                                          });
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        maxLength: 5,
                                        initialValue: proQty.toString(),
                                        decoration: InputDecoration(

                                            // suffix: Icon(
                                            //     Icons.add),
                                            counterText: "",
                                            contentPadding:
                                                EdgeInsets.only(left: 20),
                                            // isDense: true,
                                            // isCollapsed: true,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: Colors.indigo,
                                                    width: 10))),
                                      ),
                                    ),
                                    // Card(
                                    //     elevation: 4.0,
                                    //     color: Colors.indigo,
                                    //     shape: RoundedRectangleBorder(
                                    //       side: BorderSide(
                                    //           color: Colors.indigo, width: 1),
                                    //       borderRadius: BorderRadius.circular(28),
                                    //     ),
                                    //     child: Row(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.spaceBetween,
                                    //       children: [
                                    //         IconButton(
                                    //             onPressed: () {
                                    //               if (proQty == 0) {
                                    //                 showToast(
                                    //                     "Sorry!! Add minimum 1 quantity in cart");
                                    //               } else {
                                    //                 if (proQty == 1) {
                                    //                   showToast(
                                    //                       "Already select minimum quantity");
                                    //                 } else {
                                    //                   setState(() {
                                    //                     proQty = proQty - 1;
                                    //                   });
                                    //                 }
                                    //               }
                                    //             },
                                    //             icon: Icon(Icons.remove,
                                    //                 size: 24, color: Colors.white)),
                                    //         Container(
                                    //           height: 24,
                                    //           width: 24,
                                    //           alignment: Alignment.center,
                                    //           decoration: BoxDecoration(
                                    //               color: Colors.white,
                                    //               borderRadius:
                                    //                   BorderRadius.circular(12)),
                                    //           child: Text(
                                    //               proQty == 1
                                    //                   ? "1"
                                    //                   : proQty.toString(),
                                    //               style: TextStyle(
                                    //                   color: Colors.indigo,
                                    //                   fontSize: 12)),
                                    //         ),
                                    //         IconButton(
                                    //             onPressed: () {
                                    //               if (int.parse(proQty.toString()) <
                                    //                   int.parse(current_stock
                                    //                       .toString())) {
                                    //                 setState(() {
                                    //                   proQty = proQty + 1;
                                    //                 });
                                    //               } else {
                                    //                 ScaffoldMessenger.of(context)
                                    //                     .showSnackBar(const SnackBar(
                                    //                         duration: Duration(
                                    //                             seconds: 1,
                                    //                             milliseconds: 500),
                                    //                         backgroundColor:
                                    //                             Colors.red,
                                    //                         content: Text(
                                    //                             'Stock not available',
                                    //                             style: TextStyle(
                                    //                                 color: Colors
                                    //                                     .white))));
                                    //               }
                                    //             },
                                    //             icon: Icon(Icons.add,
                                    //                 size: 24, color: Colors.white)),
                                    //       ],
                                    //     )),
                                    InkWell(
                                      onTap: () {
                                        if (proQty.toString() == "0") {
                                          showToast(
                                              "Your product quantity is less than 1");
                                        } else {
                                          if (int.parse(proQty.toString()) <
                                              int.parse(
                                                  current_stock.toString())) {
                                            _addtocart(
                                                productid.toString(),
                                                offerprice.toString(),
                                                proQty.toString(),
                                                rate.toString());
                                          } else {
                                            Fluttertoast.showToast(
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.CENTER,
                                                backgroundColor: Colors.black,
                                                textColor: Colors.white,
                                                msg: "Available Stock Qty - " +
                                                    current_stock.toString());
                                          }
                                        }
                                      },
                                      child: Card(
                                          elevation: 4.0,
                                          color: Colors.indigo,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.indigo, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(28),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 40),
                                            child: Text("Add to cart",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14)),
                                          )),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget showItemWidget() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartScreen()));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Container(
            height: 55,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(15.0)),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: _counter == 0 || _counter == 1
                      ? Text("${_counter.toString()} Item",
                          style: TextStyle(color: Colors.white, fontSize: 14.0))
                      : Text("${_counter.toString()} Items",
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.0)),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      left: 5.0, top: 15.0, bottom: 15.0, right: 5.0),
                  child: VerticalDivider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 5.0, top: 15.0, bottom: 15.0, right: 5.0),
                      child: Text("\u20B9 ${totalprice.toString()}",
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.0))),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Text("View Cart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500)),
                )
              ],
            ),
          ),
        ));
  }

  Future _productdetails(String productid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "product_id": productid,
    };
    var response = await http.post(Uri.parse(BASE_URL + productdetail),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });
    print(productid);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        images.addAll(json.decode(response.body)['Response']['details']
            ['additional_images']);

        productimage = json
            .decode(response.body)['Response']['details']['product_image']
            .toString();
        productname = json
            .decode(response.body)['Response']['details']['product_name']
            .toString();
        netweight = json
            .decode(response.body)['Response']['details']['weight']
            .toString();
        short_desc = json
            .decode(response.body)['Response']['details']['short_description']
            .toString();
        long_desc = json
            .decode(response.body)['Response']['details']['long_description']
            .toString();

        proQty = int.parse(
            json.decode(response.body)['Response']['quantity'].toString());
        print(proQty.toString() + "---000");
        rate =
            json.decode(response.body)['Response']['details']['mrp'].toString();
        offerprice = json
            .decode(response.body)['Response']['details']['discount_price']
            .toString();
        tradeprice = json
            .decode(response.body)['Response']['details']['trade_price']
            .toString();
        amount =
            json.decode(response.body)['Response']['details']['mrp'].toString();

        itemlength =
            json.decode(response.body)['Response']['details']['length'];
        itemwidth = json.decode(response.body)['Response']['details']['width'];
        itemheight =
            json.decode(response.body)['Response']['details']['height'];

        current_stock = int.parse(
            json.decode(response.body)['Response']['current_stock'].toString());

        final document = parse(
            json.decode(response.body)['Response']['group_price'].toString());
        groupprice = parse(document.body.text).documentElement.text.toString();
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _addtocart(
      String id, String offerprice, String quantity, String rate) async {
    setState(() {
      _loading = true;
    });
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
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      print(response.body);
      if (json.decode(response.body)['ErrorCode'].toString() == "0") {
        //showToast('Product added successfully');
        setState(() {
          prefs.setString('cartcount',
              json.decode(response.body)['Response']['count'].toString());
          prefs.setString('carttotal',
              json.decode(response.body)['Response']['total_price'].toString());
          _counter = int.parse(
              json.decode(response.body)['Response']['count'].toString());
          //_totalprice = json.decode(response.body)['Response']['total_price'].toString();
        });
      }
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
