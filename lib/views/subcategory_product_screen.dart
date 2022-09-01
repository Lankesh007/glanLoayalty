// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/helper/dialog_helper.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/views/cart_screen.dart';
import 'package:tayal/views/category_screen.dart';
import 'package:tayal/views/product_detail_screen.dart';

class SubCategoryProductScreen extends StatefulWidget {
  String categoryid;
  String categoryname;
  SubCategoryProductScreen({this.categoryid, this.categoryname});

  @override
  _SubCategoryProductScreenState createState() =>
      _SubCategoryProductScreenState(categoryid, categoryname);
}

class _SubCategoryProductScreenState extends State<SubCategoryProductScreen> {
  String categoryid;
  String categoryname;
  _SubCategoryProductScreenState(this.categoryid, this.categoryname);

  List itemlist = [];
  List subcategorylist = [];

  List<dynamic> _productlist = [];
  List<dynamic> _searchResult = [];

  int _counter = 0;
  String _totalprice = "0.0";
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSubcategory(categoryid).then((value) {
      setState(() {
        mainData = value;
      });
    });
    _getcategoryproducts(categoryid);

    _getCartData();
  }

  Future _getCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + cartlist),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'].toString() != "0") {
        print("if");
        setState(() {
          _counter = 0;
          _totalprice = "0.0";
          //nodata = json.decode(response.body)['ErrorMessage'].toString();
        });
      } else {
        print("else");
        setState(() {
          _totalprice =
              json.decode(response.body)['Response']['total_price'].toString();
          _counter = int.parse(prefs.getString('cartcount'));
        });
      }
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundShapeColor,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: appbarcolor,
                      border: Border(
                        bottom: BorderSide(width: 1.5, color: Colors.grey[400]),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 25, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              //Navigator.pop(context);
                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CategoryScreen()));
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.arrow_back,
                                size: 24, color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                //showCategoriesSheet();
                              },
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "$categoryname"
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    SizedBox(height: 0.0),
                                    /*Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("see all categories", style: TextStyle(color: Colors.green, fontSize: 16)),
                                    SizedBox(width: 0.0),
                                    Icon(Icons.keyboard_arrow_down, color: Colors.green, size: 20)
                                  ],
                                )*/
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    )),
                isLoading
                    ? Expanded(
                        child: Center(
                            child:
                                CircularProgressIndicator(color: appbarcolor)))
                    : _searchResult.length == 0 || _searchResult.isEmpty
                        ? Expanded(child: Center(child: Text("No Data Found")))
                        : Expanded(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Container(
                                    width: 75,
                                    margin: EdgeInsets.only(top: 1),
                                    height: _counter != 0
                                        ? MediaQuery.of(context).size.height /
                                            1.33
                                        : MediaQuery.of(context).size.height /
                                            1.21,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 1,
                                            blurRadius: 1)
                                      ],
                                    ),
                                    child: ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemCount: mainData['Response'].length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () async {
                                            _getcategoryproducts(
                                                mainData['Response'][index]
                                                        ['id']
                                                    .toString());
                                            /*List temp = snapshot.data['Response'];
                                          temp.forEach((element) {
                                            setState(() {
                                              element['isSelected'] = "false";
                                            });
                                          });
                                          setState(() {
                                            snapshot.data['Response'][index]['isSelected'] = "true";
                                          });*/
                                          },
                                          child: CategoryItem(
                                            title: mainData['Response'][index]
                                                    ['category_name']
                                                .toString(),
                                            image: mainData['Response'][index]
                                                    ['icon']
                                                .toString(),
                                            id: mainData['Response'][index]
                                                    ['id']
                                                .toString(),
                                            isSelected: "false",
                                          ),
                                        );
                                      },
                                    )),
                                Expanded(
                                  child: SizedBox(
                                    height: _counter != 0
                                        ? MediaQuery.of(context).size.height /
                                            1.33
                                        : MediaQuery.of(context).size.height /
                                            1.21,
                                    child:
                                        _searchResult.length == 0 ||
                                                _searchResult.isEmpty
                                            ? _emptyCategories(context)
                                            : GridView.builder(
                                                padding: EdgeInsets.zero,
                                                itemCount: _searchResult.length,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        childAspectRatio: 0.52),
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                      elevation: 5.0,
                                                      color: Colors.white,
                                                      child: Stack(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            4.0),
                                                                child: Stack(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => ProductDetailScreen(productid: _searchResult[index]['product_id'].toString(), totalprice: _totalprice.toString())));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            180,
                                                                        height:
                                                                            90,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10)),
                                                                          //color: Colors.blue.shade200,
                                                                          image: DecorationImage(
                                                                              image: CachedNetworkImageProvider(_searchResult[index]['product_image'].toString()),
                                                                              fit: BoxFit.fitWidth),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    _searchResult[index]['is_favorite'].toString() ==
                                                                            "0"
                                                                        ? Positioned(
                                                                            top:
                                                                                5.0,
                                                                            right:
                                                                                5.0,
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  _searchResult[index]['is_favorite'] = 1;
                                                                                });
                                                                                _addtofavourite(_searchResult[index]['product_id'].toString(), 1);
                                                                              },
                                                                              child: SvgPicture.asset('assets/images/favourite.svg'),
                                                                            ))
                                                                        : Positioned(
                                                                            top:
                                                                                5.0,
                                                                            right:
                                                                                5.0,
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                //showToast("Product Already added to favourite list");
                                                                                setState(() {
                                                                                  _searchResult[index]['is_favorite'] = 0;
                                                                                });
                                                                                _addtofavourite(_searchResult[index]['product_id'].toString(), 0);
                                                                              },
                                                                              child: Container(
                                                                                height: 20,
                                                                                width: 20,
                                                                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                                child: Image.asset('assets/images/heart24.png', scale: 2),
                                                                              ),
                                                                            ))
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            7.0,
                                                                        right:
                                                                            7.0),
                                                                child: Text(
                                                                    _searchResult[index]
                                                                            [
                                                                            'product_name']
                                                                        .toString(),
                                                                    maxLines: 2,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black)),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => ProductDetailScreen(
                                                                              productid: _searchResult[index]['product_id'].toString(),
                                                                              totalprice: _totalprice.toString())));
                                                                },
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              7.0,
                                                                          right:
                                                                              7.0),
                                                                  child: _searchResult[index]['short_description'] == null ||
                                                                          _searchResult[index]['short_description'] ==
                                                                              ""
                                                                      ? SizedBox()
                                                                      : Text(
                                                                          _searchResult[index]['short_description'].toString().split(" (")[
                                                                              0],
                                                                          maxLines:
                                                                              2,
                                                                          textAlign: TextAlign
                                                                              .start,
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 10)),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => ProductDetailScreen(
                                                                              productid: _searchResult[index]['product_id'].toString(),
                                                                              totalprice: _totalprice.toString())));
                                                                },
                                                                child: Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            7.0,
                                                                        top:
                                                                            2.0,
                                                                        right:
                                                                            2.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                '',
                                                                            style:
                                                                                DefaultTextStyle.of(context).style,
                                                                            children: [
                                                                              TextSpan(text: '\u20B9 ${_searchResult[index]['mrp'].toString()}', style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontWeight: FontWeight.bold)),
                                                                              TextSpan(text: ' MRP', style: TextStyle(fontSize: 9)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        _searchResult[index]['discount_price'] ==
                                                                                null
                                                                            ? SizedBox()
                                                                            : RichText(
                                                                                text: TextSpan(
                                                                                  text: '',
                                                                                  style: DefaultTextStyle.of(context).style,
                                                                                  children: [
                                                                                    TextSpan(text: '\u20B9 ${_searchResult[index]['discount_price'].toString()}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                    TextSpan(text: ' DEALER PR.', style: TextStyle(fontSize: 9)),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                        _searchResult[index]['trade_price'] ==
                                                                                null
                                                                            ? SizedBox()
                                                                            : RichText(
                                                                                text: TextSpan(
                                                                                  text: '',
                                                                                  style: DefaultTextStyle.of(context).style,
                                                                                  children: [
                                                                                    TextSpan(text: '\u20B9 ${_searchResult[index]['trade_price'].toString()}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                    TextSpan(text: ' SCHEME PR.', style: TextStyle(fontSize: 9)),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                        Text(
                                                                            "(GST Inclusive)",
                                                                            style:
                                                                                TextStyle(fontSize: 9, fontWeight: FontWeight.bold))
                                                                        // Text(
                                                                        //     "MRP: \u20B9 ${_searchResult[index]['mrp'].toString()}",
                                                                        //     style: TextStyle(
                                                                        //         color: Colors.grey,
                                                                        //         decoration: TextDecoration.lineThrough,
                                                                        //         fontWeight: FontWeight.bold)),
                                                                        // Text(
                                                                        //     "TR. Pr.: \u20B9 ${_searchResult[index]['trade_price'].toString()}",
                                                                        //     style:
                                                                        //         TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                                                        // Text(
                                                                        //     "DIS. Pr.\u20B9 ${_searchResult[index]['discount_price'].toString()}",
                                                                        //     style:
                                                                        //         TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                                                      ],
                                                                    )),
                                                              )
                                                            ],
                                                          ),
                                                          Positioned(
                                                              left: 10,
                                                              bottom: 5,
                                                              right: 10,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        TextFormField(
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      initialValue: _searchResult[index]['quantity'].toString() ==
                                                                              "0"
                                                                          ? ""
                                                                          : _searchResult[index]['quantity']
                                                                              .toString(),
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(
                                                                            () {
                                                                          if (val.length !=
                                                                              0) {
                                                                            _searchResult[index]['quantity'] =
                                                                                int.parse(val);
                                                                          }
                                                                        });
                                                                      },
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter
                                                                            .digitsOnly
                                                                      ],
                                                                      maxLength:
                                                                          5,
                                                                      decoration: InputDecoration(

                                                                          // suffix: Icon(
                                                                          //     Icons.add),
                                                                          counterText: "",
                                                                          contentPadding: EdgeInsets.only(left: 5),
                                                                          isDense: true,
                                                                          isCollapsed: true,
                                                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.black, width: 5))),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                          SizedBox(
                                                                    height: 25,
                                                                    child: ElevatedButton(
                                                                        style: ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(Colors.indigo),
                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(0),
                                                                            )),
                                                                            padding: MaterialStateProperty.all(EdgeInsets.zero)),
                                                                        onPressed: () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();

                                                                          if (int.parse(_searchResult[index]['current_stock'].toString()) >
                                                                              int.parse(_searchResult[index]['quantity'].toString())) {
                                                                            _addtocart(
                                                                                _searchResult[index]['product_id'].toString(),
                                                                                _searchResult[index]['discount_price'].toString(),
                                                                                _searchResult[index]['quantity'].toString(),
                                                                                _searchResult[index]['mrp'].toString());
                                                                          } else {
                                                                            Fluttertoast.showToast(
                                                                                toastLength: Toast.LENGTH_LONG,
                                                                                gravity: ToastGravity.CENTER,
                                                                                backgroundColor: Colors.black,
                                                                                textColor: Colors.white,
                                                                                msg: "Available Stock Qty - " + _searchResult[index]['current_stock'].toString());
                                                                          }
                                                                        },
                                                                        child: Text("ADD")),
                                                                  ))
                                                                ],
                                                              ))
                                                          // Positioned(
                                                          //     left: 10,
                                                          //     bottom: 5,
                                                          //     right: 10,
                                                          //     child: _searchResult[
                                                          //                         index]
                                                          //                     [
                                                          //                     'is_stock']
                                                          //                 .toString() ==
                                                          //             "0"
                                                          //         ? Center(
                                                          //             child: Text(
                                                          //               "Out of Stock",
                                                          //               style: TextStyle(
                                                          //                   color: Colors
                                                          //                       .red,
                                                          //                   fontWeight:
                                                          //                       FontWeight
                                                          //                           .w600),
                                                          //             ),
                                                          //           )
                                                          //         : _searchResult[index]
                                                          //                     [
                                                          //                     'quantity'] ==
                                                          //                 0
                                                          //             ? InkWell(
                                                          //                 onTap: () {
                                                          //                   setState(
                                                          //                       () {
                                                          //                     _searchResult[index]['quantity'] =
                                                          //                         "1";
                                                          //                     _addtocart(
                                                          //                         _searchResult[index]['product_id'].toString(),
                                                          //                         _searchResult[index]['discount_price'].toString(),
                                                          //                         "1",
                                                          //                         _searchResult[index]['mrp'].toString());
                                                          //                   });
                                                          //                 },
                                                          //                 child:
                                                          //                     Container(
                                                          //                   height:
                                                          //                       25.0,
                                                          //                   width:
                                                          //                       85.0,
                                                          //                   alignment:
                                                          //                       Alignment
                                                          //                           .center,
                                                          //                   decoration: BoxDecoration(
                                                          //                       color: Colors
                                                          //                           .indigo,
                                                          //                       borderRadius: BorderRadius.all(Radius.circular(
                                                          //                           5.0)),
                                                          //                       border: Border.all(
                                                          //                           width: 1,
                                                          //                           color: Colors.indigo)),
                                                          //                   child: Padding(
                                                          //                       padding: EdgeInsets.symmetric(horizontal: 5.0),
                                                          //                       child: Row(
                                                          //                         children: const [
                                                          //                           Expanded(child: Text("Add to cart", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12.0))),
                                                          //                           SizedBox(width: 2),
                                                          //                           VerticalDivider(width: 2, color: Colors.white),
                                                          //                           Icon(Icons.add, color: Colors.white, size: 16)
                                                          //                         ],
                                                          //                       )),
                                                          //                 ),
                                                          //               )
                                                          //             : Container(
                                                          //                 height:
                                                          //                     25.0,
                                                          //                 width: 85.0,
                                                          //                 decoration: BoxDecoration(
                                                          //                     color: Colors
                                                          //                         .white,
                                                          //                     borderRadius:
                                                          //                         BorderRadius.all(Radius.circular(
                                                          //                             5.0)),
                                                          //                     border: Border.all(
                                                          //                         width:
                                                          //                             1,
                                                          //                         color:
                                                          //                             Colors.white)),
                                                          //                 child:
                                                          //                     Padding(
                                                          //                   padding: const EdgeInsets
                                                          //                           .symmetric(
                                                          //                       horizontal:
                                                          //                           10.0),
                                                          //                   child:
                                                          //                       Row(
                                                          //                     mainAxisAlignment:
                                                          //                         MainAxisAlignment.spaceBetween,
                                                          //                     children: [
                                                          //                       InkWell(
                                                          //                         onTap:
                                                          //                             () {
                                                          //                           setState(() {
                                                          //                             _searchResult[index]['quantity'] = int.parse(_searchResult[index]['quantity'].toString()) - 1;
                                                          //                           });
                                                          //                           _addtocart(_searchResult[index]['product_id'].toString(), _searchResult[index]['discount_price'].toString(), _searchResult[index]['quantity'].toString(), _searchResult[index]['mrp'].toString());
                                                          //                         },
                                                          //                         child:
                                                          //                             Container(
                                                          //                           height: 24,
                                                          //                           width: 24,
                                                          //                           decoration: BoxDecoration(
                                                          //                             border: Border.all(
                                                          //                               color: Colors.indigo,
                                                          //                               width: 2,
                                                          //                             ),
                                                          //                             borderRadius: BorderRadius.circular(25 / 2),
                                                          //                           ),
                                                          //                           child: const Center(
                                                          //                             child: Icon(
                                                          //                               Icons.remove,
                                                          //                               size: 16,
                                                          //                               color: Colors.indigo,
                                                          //                             ),
                                                          //                           ),
                                                          //                         ),
                                                          //                       ),
                                                          //                       const SizedBox(
                                                          //                           width: 12),
                                                          //                       Text(
                                                          //                           _searchResult[index]['quantity'].toString(),
                                                          //                           style: TextStyle(color: Colors.indigo, fontSize: 16)),
                                                          //                       const SizedBox(
                                                          //                           width: 12),
                                                          //                       InkWell(
                                                          //                         onTap:
                                                          //                             () {
                                                          //                           if (int.parse(_searchResult[index]['quantity'].toString()) < int.parse(_searchResult[index]['current_stock'].toString())) {
                                                          //                             setState(() {
                                                          //                               _searchResult[index]['quantity'] = int.parse(_searchResult[index]['quantity'].toString()) + 1;
                                                          //                             });
                                                          //                             _addtocart(_searchResult[index]['product_id'].toString(), _searchResult[index]['discount_price'].toString(), _searchResult[index]['quantity'].toString(), _searchResult[index]['mrp'].toString());
                                                          //                           } else {
                                                          //                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(duration: Duration(seconds: 1, milliseconds: 500), backgroundColor: Colors.red, content: Text('Stock not available', style: TextStyle(color: Colors.white))));
                                                          //                           }
                                                          //                         },
                                                          //                         child:
                                                          //                             Container(
                                                          //                           height: 24,
                                                          //                           width: 24,
                                                          //                           decoration: BoxDecoration(
                                                          //                             border: Border.all(
                                                          //                               color: Colors.indigo,
                                                          //                               width: 2,
                                                          //                             ),
                                                          //                             borderRadius: BorderRadius.circular(25 / 2),
                                                          //                           ),
                                                          //                           child: const Center(
                                                          //                             child: Icon(
                                                          //                               Icons.add,
                                                          //                               size: 16,
                                                          //                               color: Colors.indigo,
                                                          //                             ),
                                                          //                           ),
                                                          //                         ),
                                                          //                       ),
                                                          //                     ],
                                                          //                   ),
                                                          //                 ),
                                                          //               ))
                                                        ],
                                                      ));
                                                },
                                              ),
                                  ),
                                )
                              ])),
              ],
            ),
            Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: _counter != 0 ? showItemWidget() : SizedBox())
          ],
        ),
      ),
      onWillPop: () async {
        Navigator.of(context).pop();
      },
    );
  }

  Widget showItemWidget() {
    return InkWell(
        onTap: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()))
              .then((value) {
            _getCartData();
          });
        },
        child: Container(
          height: 55,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: appbarcolor2,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: _counter == 0 || _counter == 1
                    ? Text("${_counter.toString()} Item",
                        style: TextStyle(color: Colors.white, fontSize: 14.0))
                    : Text("${_counter.toString()} Items",
                        style: TextStyle(color: Colors.white, fontSize: 14.0)),
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
                    child: Text(
                        "\u20B9 ${double.parse(_totalprice.toString()).toStringAsFixed(2).toString()}",
                        style: TextStyle(color: Colors.white, fontSize: 14.0))),
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
        ));
  }

  Widget _emptyCategories(context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                // height: 150,
                // width: 150,
                margin: const EdgeInsets.only(bottom: 20),
                child: Image.asset("assets/images/empty.png"),
              ),
              const Text(
                "Sorry No Products Available!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map mainData = {};

  Future<Map> _getSubcategory(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "parent_id": id,
    };
    var response = await http.post(Uri.parse(BASE_URL + subcategory),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      return json.decode(response.body);
      /*result.forEach((element) {
        setState(() {
          if(result.indexOf(element)==0){
            element['isSelected'] = "true";
          }else{
            element['isSelected'] = "false";
          }
        });

      });
      Map m={};
      m["ErrorCode"]="0";
      m["ErrorMessage"]="success";
      m['Response']=result;*/
      //_getcategoryproducts(result[0]['id'].toString());

    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  /*Future<dynamic> _getproducts() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cartcount', "0");
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL+product),
        headers : {'Authorization': 'Bearer $mytoken'}
    );
    if (response.statusCode == 200)
    {
      print(response.body);
      Iterable list = json.decode(response.body)['ItemResponse']['data'];
      //List<Data> _list = list.map((m) => Data.fromJson(m)).toList();
      setState(() {
        _productlist.addAll(list);
        _searchResult.addAll(list);
      });
      list.forEach((element) {
        if(element['quantity'] > 0){
          setState(() {
            _counter = _counter + element['quantity'];
            _totalprice = (double.parse(_totalprice) + double.parse(element['discount_price']) * element['quantity']).toString();
            prefs.setString('cartcount', _counter.toString());
            prefs.setString('totalprice', _totalprice.toString());
          });
        }
      });
      //return list;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }*/

  Future _getcategoryproducts(String id) async {
    print("test");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    _searchResult.clear();
    final body = {
      "category_id": id,
    };
    var response = await http.post(Uri.parse(BASE_URL + categoryproductlist),
        body: body, headers: {'Authorization': 'Bearer $mytoken'});
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      print(response.body);
      Iterable list =
          json.decode(response.body)['ItemResponse']['category_products'];
      setState(() {
        _productlist.addAll(list);
        _searchResult.addAll(list);
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _addtofavourite(String productid, int isfvaourite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "product_id": productid,
      "is_favorite": isfvaourite,
    };
    var response = await http.post(Uri.parse(BASE_URL + addfavoutite),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'].toString() == "0") {
        if (isfvaourite == 1) {
          showToast("Product successfully added to favourite");
        } else {
          showToast("Product successfully removed from favourite");
        }
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _addtocart(
      String id, String offerprice, String quantity, String rate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "product_id": id,
      "offer_price": "0",
      "rate": (double.parse(rate) * 1).toInt(),
      "quantity": quantity
    };
    print(jsonEncode(body));
    var response = await http.post(Uri.parse(BASE_URL + addcart),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });
    print(response.body);
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'].toString() == "0") {
        //showToast('Product added successfully');
        setState(() {
          prefs.setString('cartcount',
              json.decode(response.body)['Response']['count'].toString());
          prefs.setString('carttotal',
              json.decode(response.body)['Response']['total_price'].toString());
          _counter = int.parse(
              json.decode(response.body)['Response']['count'].toString());
          _totalprice =
              json.decode(response.body)['Response']['total_price'].toString();
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final String id;
  final String isSelected;
  CategoryItem(
      {@required this.title,
      @required this.image,
      @required this.id,
      @required this.isSelected});

  Widget build(BuildContext context) {
    print(image.toString() + " 7777");
    return Container(
      width: 100,
      //height: 100,
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            margin: EdgeInsets.only(right: 8, left: 8, top: 0, bottom: 0),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey,
              image: DecorationImage(
                  image: image.length != 0
                      ? CachedNetworkImageProvider(image)
                      : AssetImage('assets/images/no_image.jpg'),
                  fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 2.0),
          Text(title.toString().toUpperCase(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11,
                  color: isSelected == "true" ? Colors.black : Colors.grey[800],
                  fontWeight: isSelected == "true"
                      ? FontWeight.bold
                      : FontWeight.w400)),
        ]),
      ),
    );
  }
}
