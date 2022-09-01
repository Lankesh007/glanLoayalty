import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/cart_screen.dart';


class FavouriteProductScreen extends StatefulWidget {
  const FavouriteProductScreen({Key key}) : super(key: key);

  @override
  _FavouriteProductScreenState createState() => _FavouriteProductScreenState();
}

class _FavouriteProductScreenState extends State<FavouriteProductScreen> {
  int _counter = 0;
  String _totalprice = "0.0";

  List<dynamic> _searchResult = [];
  Future<dynamic> _myfavouriteproducts;
  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myfavouriteproducts = _getfavouriteproducts();
    _getCountBadge();
  }

  Future _getCountBadge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = int.parse(prefs.getString('cartcount'));
    /*String mytoken = prefs.getString('token').toString();

    var response = await http.post(Uri.parse(BASE_URL + cartlist),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'].toString() != "0") {
      } else {
        setState(() {
          _counter = json.decode(response.body)['Response']['items'].length;
          _totalprice = json.decode(response.body)['Response']['total_price'].toString();
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kBackgroundShapeColor,
          appBar: AppBar(
              backgroundColor: appbarcolor,
              centerTitle: true,
              leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    "assets/images/back.png",
                    scale: 20,
                    color: Colors.white,
                  )),
              title: Text("Favourite Product",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 21,
                      fontWeight: FontWeight.bold)),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen()));
                      } else {
                        showToast('Your cart is empty');
                      }
                    },
                  ),
                )
              ]),
          body: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: _searchResult.length == 0 || _searchResult.isEmpty
                  ? _emptyCategories(context)
                  : GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _searchResult.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 0.85),
                      itemBuilder: (context, index) {
                        return Card(
                            elevation: 5.0,
                            color: Colors.white,
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              /* Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(
                                      productid : _searchResult[index]['product_id'].toString(),
                                      totalprice : _totalprice.toString()
                                  )));*/
                                            },
                                            child: Container(
                                              width: 180,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                //color: Colors.blue.shade200,
                                                image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                        _searchResult[index][
                                                                'product_image']
                                                            .toString()),
                                                    fit: BoxFit.fitWidth),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              top: 5.0,
                                              right: 5.0,
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                                child: Image.asset(
                                                    'assets/images/heart24.png',
                                                    scale: 2),
                                              ))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 7.0, right: 7.0),
                                      child: Text(
                                          _searchResult[index]['product_name']
                                              .toString(),
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 7.0, right: 7.0),
                                      child: _searchResult[index]
                                                      ['short_description'] ==
                                                  null ||
                                              _searchResult[index]
                                                      ['short_description'] ==
                                                  ""
                                          ? SizedBox()
                                          : Text(
                                              _searchResult[index]
                                                      ['short_description']
                                                  .toString(),
                                              maxLines: 2,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10)),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 7.0, top: 2.0, right: 7.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "\u20B9 ${_searchResult[index]['mrp'].toString()}",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                "\u20B9 ${_searchResult[index]['discount_price'].toString()}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ))
                                  ],
                                ),
                                Positioned(
                                    left: 10,
                                    bottom: 5,
                                    right: 10,
                                    child: _searchResult[index]['is_stock']
                                                    .toString() ==
                                                "0" ||
                                            _searchResult[index]['is_stock']
                                                    .toString() ==
                                                null
                                        ? Center(
                                            child: Text(
                                              "Out of Stock",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        : _searchResult[index]['quantity'] == 0
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _searchResult[index]
                                                        ['quantity'] = "1";
                                                    _addtocart(
                                                        _searchResult[index]
                                                                ['product_id']
                                                            .toString(),
                                                        _searchResult[index][
                                                                'discount_price']
                                                            .toString(),
                                                        "1",
                                                        _searchResult[index]
                                                                ['mrp']
                                                            .toString());
                                                  });
                                                },
                                                child: Container(
                                                  height: 25.0,
                                                  width: 85.0,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.indigo,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                      border: Border.all(
                                                          width: 1,
                                                          color:
                                                              Colors.indigo)),
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.0),
                                                      child: Row(
                                                        children: const [
                                                          Expanded(
                                                              child: Text(
                                                                  "Add to cart",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12.0))),
                                                          SizedBox(width: 2),
                                                          VerticalDivider(
                                                              width: 2,
                                                              color:
                                                                  Colors.white),
                                                          Icon(Icons.add,
                                                              color:
                                                                  Colors.white,
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
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.white)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _searchResult[index]
                                                                    [
                                                                    'quantity'] =
                                                                int.parse(_searchResult[index]
                                                                            [
                                                                            'quantity']
                                                                        .toString()) -
                                                                    1;
                                                          });
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
                                                              _searchResult[
                                                                          index]
                                                                      [
                                                                      'quantity']
                                                                  .toString(),
                                                              _searchResult[
                                                                          index]
                                                                      ['mrp']
                                                                  .toString());
                                                        },
                                                        child: Container(
                                                          height: 24,
                                                          width: 24,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.indigo,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25 / 2),
                                                          ),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.remove,
                                                              size: 16,
                                                              color:
                                                                  Colors.indigo,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Text(
                                                          _searchResult[index]
                                                                  ['quantity']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.indigo,
                                                              fontSize: 16)),
                                                      const SizedBox(width: 12),
                                                      InkWell(
                                                        onTap: () {
                                                          if (int.parse(_searchResult[
                                                                          index]
                                                                      [
                                                                      'quantity']
                                                                  .toString()) <
                                                              int.parse(_searchResult[
                                                                          index]
                                                                      [
                                                                      'current_stock']
                                                                  .toString())) {
                                                            setState(() {
                                                              _searchResult[
                                                                          index]
                                                                      [
                                                                      'quantity'] =
                                                                  int.parse(_searchResult[index]
                                                                              [
                                                                              'quantity']
                                                                          .toString()) +
                                                                      1;
                                                            });
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
                                                                _searchResult[
                                                                            index]
                                                                        [
                                                                        'quantity']
                                                                    .toString(),
                                                                _searchResult[
                                                                            index]
                                                                        ['mrp']
                                                                    .toString());
                                                          } else {
                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                duration: Duration(
                                                                    seconds: 1,
                                                                    milliseconds:
                                                                        500),
                                                                backgroundColor:
                                                                    Colors.red,
                                                                content: Text(
                                                                    'Stock not available',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))));
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 24,
                                                          width: 24,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.indigo,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25 / 2),
                                                          ),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.add,
                                                              size: 16,
                                                              color:
                                                                  Colors.indigo,
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
          ),
        ),
        onWillPop: () async {
          Navigator.of(context).pop();
        });
  }

  Widget showItemWidget() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartScreen()));
        },
        child: Container(
          height: 55,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.indigo, borderRadius: BorderRadius.circular(0.0)),
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
                    child: Text("\u20B9 ${_totalprice.toString()}",
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

  Future _getfavouriteproducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + favouritelist),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      setState(() {
        _searchResult = json.decode(response.body)['Response'];
      });
      return json.decode(response.body)['Response'];
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
