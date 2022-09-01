import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/helper/dialog_helper.dart';
import 'package:tayal/models/productdata.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/cart_screen.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/help_screen.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/views/mybiz_screen.dart';
import 'package:tayal/views/product_detail_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedIndex;
  var productlist;

  List productCategorylist = [];

  int _counter = 0;

  TextEditingController searchtextController = TextEditingController();

  List<dynamic> _searchResult = [];
  List<dynamic> _productlist = [];

  @override
  void initState() {
    super.initState();
    _getcategory();
    _getproducts();
    _getCartCount();
  }

  void _getCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = int.parse(prefs.getString('cartcount'));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundShapeColor,
        floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.indigo,
            child: Icon(Icons.add)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Color(0xffBCBEFD),
          child: Container(
              width: size.width,
              height: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashBoardScreen()),
                            (route) => false);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/home.svg',
                              fit: BoxFit.fill),
                          Text("Home",
                              style: TextStyle(
                                  color: Colors.indigo.shade500, fontSize: 12))
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyBizScreen()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/mybiz.svg',
                              fit: BoxFit.fill),
                          Text("My Biz",
                              style: TextStyle(
                                  color: Colors.indigo.shade500, fontSize: 12))
                        ],
                      ),
                    ),
                    SizedBox.shrink(),
                    InkWell(
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/reward.svg',
                              fit: BoxFit.fill),
                          Text("Campaign",
                              style: TextStyle(
                                  color: Colors.indigo.shade500, fontSize: 12))
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HelpScreen()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/help.svg',
                              fit: BoxFit.fill),
                          Text("Help",
                              style: TextStyle(
                                  color: Colors.indigo.shade500, fontSize: 12))
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SvgPicture.asset('assets/images/back.svg',
                            fit: BoxFit.fill),
                      ),
                      const Text("Product",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 21,
                              fontWeight: FontWeight.w600)),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: Badge(
                            animationDuration: Duration(milliseconds: 10),
                            animationType: BadgeAnimationType.scale,
                            badgeContent: Text(
                              '$_counter',
                              style: TextStyle(color: Colors.white),
                            ),
                            child: const Icon(Icons.shopping_basket,
                                color: Colors.grey, size: 28),
                          ),
                          onPressed: () {
                            if (_counter != 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CartScreen()));
                            } else {
                              showToast("Your cart is empty");
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/search.svg'),
                            SizedBox(width: 12),
                            Container(
                              width: size.width * 0.72,
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          _searchResult.clear();
                                          _searchResult.addAll(_productlist);
                                          searchtextController.text = "";
                                          FocusScope.of(context).unfocus();
                                        });
                                      },
                                    ),
                                    border: InputBorder.none,
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.indigo.shade100),
                                    focusColor: Colors.indigo),
                                controller: searchtextController,
                                onChanged: (value) {
                                  onSearchTextChanged(value);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      child: Wrap(
                          spacing: 5.0,
                          runSpacing: 5.0,
                          children: productCategorylist
                              .map((e) => filterChipWidget(
                                  chipName: e['category_name'].toString(),
                                  categorylist: productCategorylist))
                              .toList()),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: _searchResult.length == 0 || _searchResult.isEmpty
                          ? Center(child: Text("No result found"))
                          : GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _searchResult.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.80),
                              itemBuilder: (context, index) {
                                return Card(
                                    elevation: 5.0,
                                    color: Colors.white,
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Stack(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      /*Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(
                                                      productid : _searchResult[index]['product_id'].toString(),
                                                    )));*/
                                                    },
                                                    child: Container(
                                                      width: 180,
                                                      height: 120,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        //color: Colors.blue.shade200,
                                                        image: DecorationImage(
                                                            image: CachedNetworkImageProvider(
                                                                _searchResult[
                                                                            index]
                                                                        [
                                                                        'product_image']
                                                                    .toString()),
                                                            fit: BoxFit
                                                                .fitWidth),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: 5.0,
                                                      right: 5.0,
                                                      child: SvgPicture.asset(
                                                          'assets/images/favourite.svg'))
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 7.0, right: 7.0),
                                              child: Text(
                                                  _searchResult[index]
                                                          ['product_name']
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 7.0, right: 7.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        "\u20B9 ${_searchResult[index]['mrp'].toString()}",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(
                                                        "\u20B9 ${_searchResult[index]['discount_price'].toString()}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                  ],
                                                ))
                                          ],
                                        ),
                                        Positioned(
                                            left: 10,
                                            bottom: 5,
                                            right: 10,
                                            child:
                                                _searchResult[index]
                                                            ['quantity'] ==
                                                        0
                                                    ? InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _searchResult[index]
                                                                    [
                                                                    'quantity'] =
                                                                "1";
                                                            _addtocart(
                                                                _searchResult[
                                                                            index]
                                                                        [
                                                                        'product_id']
                                                                    .toString(),
                                                                _searchResult[
                                                                            index]
                                                                        [
                                                                        'discount_price']
                                                                    .toString(),
                                                                "1",
                                                                _searchResult[
                                                                            index]
                                                                        ['mrp']
                                                                    .toString());
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 25.0,
                                                          width: 85.0,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.indigo,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5.0)),
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .indigo)),
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5.0),
                                                              child: Row(
                                                                children: const [
                                                                  Expanded(
                                                                      child: Text(
                                                                          "Add to cart",
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 12.0))),
                                                                  SizedBox(
                                                                      width: 2),
                                                                  VerticalDivider(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .white),
                                                                  Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 16)
                                                                ],
                                                              )),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 25.0,
                                                        width: 85.0,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.0)),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .white)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _searchResult[
                                                                            index]
                                                                        [
                                                                        'quantity'] = int.parse(
                                                                            _searchResult[index]['quantity'].toString()) -
                                                                        1;
                                                                  });
                                                                  _addtocart(
                                                                      _searchResult[index][
                                                                              'product_id']
                                                                          .toString(),
                                                                      _searchResult[index]
                                                                              [
                                                                              'discount_price']
                                                                          .toString(),
                                                                      _searchResult[index]
                                                                              [
                                                                              'quantity']
                                                                          .toString(),
                                                                      _searchResult[index]
                                                                              [
                                                                              'mrp']
                                                                          .toString());
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 24,
                                                                  width: 24,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .indigo,
                                                                      width: 2,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25 /
                                                                                2),
                                                                  ),
                                                                  child:
                                                                      const Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .indigo,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 12),
                                                              Text(
                                                                  _searchResult[
                                                                              index]
                                                                          [
                                                                          'quantity']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .indigo,
                                                                      fontSize:
                                                                          16)),
                                                              const SizedBox(
                                                                  width: 12),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _searchResult[
                                                                            index]
                                                                        [
                                                                        'quantity'] = int.parse(
                                                                            _searchResult[index]['quantity'].toString()) +
                                                                        1;
                                                                  });
                                                                  _addtocart(
                                                                      _searchResult[index][
                                                                              'product_id']
                                                                          .toString(),
                                                                      _searchResult[index]
                                                                              [
                                                                              'discount_price']
                                                                          .toString(),
                                                                      _searchResult[index]
                                                                              [
                                                                              'quantity']
                                                                          .toString(),
                                                                      _searchResult[index]
                                                                              [
                                                                              'mrp']
                                                                          .toString());
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 24,
                                                                  width: 24,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .indigo,
                                                                      width: 2,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25 /
                                                                                2),
                                                                  ),
                                                                  child:
                                                                      const Center(
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .indigo,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ))
                                      ],
                                    ));
                              },
                            ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        Navigator.of(context).pop();
      },
    );
  }

  onSearchTextChanged(String text) async {
    if (text.isNotEmpty) {
      List dummyList = [];
      _productlist.forEach((productDetail) {
        if (productDetail['product_name']
            .toString()
            .toUpperCase()
            .contains(text.toString().toUpperCase())) {
          dummyList.add(productDetail);
        }
      });
      setState(() {
        _searchResult.clear();
        _searchResult.addAll(dummyList);
      });
    } else {
      setState(() {
        FocusScope.of(context).unfocus();
        _searchResult.clear();
        _searchResult.addAll(_productlist);
      });
    }
  }

  Future _getcategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + category),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response'];
      productCategorylist.addAll(list);
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getcategoryproducts(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    _searchResult.clear();
    final body = {
      "category_id": id,
    };
    var response = await http.post(Uri.parse(BASE_URL + categoryproductlist),
        body: body, headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['ItemResponse']['items'];
      setState(() {
        _searchResult.addAll(list);
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<dynamic> _getproducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cartcount', "0");
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + product),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['ItemResponse']['data'];
      //List<Data> _list = list.map((m) => Data.fromJson(m)).toList();
      setState(() {
        _productlist.addAll(list);
        _searchResult.addAll(list);
      });
      list.forEach((element) {
        if (element['quantity'] > 0) {
          setState(() {
            _counter = _counter + 1;
            prefs.setString('cartcount', _counter.toString());
          });
        }
      });
      //return list;
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
      if (json.decode(response.body)['ErrorCode'].toString() == "0") {
        //showToast('Product added successfully');
        setState(() {
          prefs.setString('cartcount',
              json.decode(response.body)['Response']['count'].toString());
          _counter = int.parse(
              json.decode(response.body)['Response']['count'].toString());
        });
      }
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Widget filterChipWidget({String chipName, List categorylist}) {
    var _isSelected = false;
    return FilterChip(
        checkmarkColor: Colors.indigo,
        label: Text(chipName),
        labelStyle: TextStyle(
            color: _isSelected ? Colors.indigo : Colors.black, fontSize: 12.0),
        selected: _isSelected,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        backgroundColor: _isSelected ? Colors.indigo : Colors.white,
        onSelected: (isSelected) {
          setState(() {
            _isSelected = true;
          });
          categorylist.forEach((element) {
            if (element['category_name'].toString() == chipName) {
              _getcategoryproducts(element['id'].toString());
            }
          });
        },
        selectedColor: Color(0xffeadffd));
  }
}

class filterChipWidget extends StatefulWidget {
  final String chipName;
  final List categorylist;

  filterChipWidget({Key key, this.chipName, this.categorylist})
      : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

class _filterChipWidgetState extends State<filterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      checkmarkColor: Colors.indigo,
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: _isSelected ? Colors.indigo : Colors.black, fontSize: 12.0),
      selected: _isSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      backgroundColor: Colors.white,
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
          widget.categorylist.forEach((element) {
            if (element['category_name'].toString() == widget.chipName) {
              //_getcategoryproducts(element['id'].toString());
            }
          });
        });
      },
      selectedColor: Color(0xffeadffd),
    );
  }
}
