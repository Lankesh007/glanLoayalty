// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/helper/dialog_helper.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/views/cart_screen.dart';
import 'package:tayal/views/subcategory_product_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController searchtextController = TextEditingController();

  List<dynamic> _searchResult = [];
  List<dynamic> _categorylist = [];

  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getcategory();

    _getCountBadge();
  }

  Future _getCountBadge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   _counter = int.parse(prefs.getString('cartcount'));
    // });

    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + cartlist),
        headers: {'Authorization': 'Bearer $mytoken'});
    print(response.body);
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'] == 0) {
        setState(() {
          _counter = 0;
          _counter = json.decode(response.body)['Response']['items'].length;
        });
      } else {
        setState(() {
          _counter = 0;
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: Colors.indigo[50],
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Close this app?",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Image.asset(
                        "assets/images/logo_image.png",
                        scale: 3,
                      )
                    ],
                  ),
                  content: Text("Are you sure you want to exit.",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel")),
                    ElevatedButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: Text("Confirm"))
                  ],
                ));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundShapeColor,
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () {},
        //     backgroundColor: Colors.indigo,
        //     child: Icon(Icons.add)),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomNavigationBar: BottomAppBar(
        //   shape: CircularNotchedRectangle(),
        //   color: Color(0xffBCBEFD),
        //   child: Container(
        //       width: size.width,
        //       height: 70,
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             InkWell(
        //               onTap: () {},
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   SvgPicture.asset('assets/icons/home.svg',
        //                       fit: BoxFit.fill),
        //                   Text("Home",
        //                       style: TextStyle(
        //                           color: Colors.indigo.shade500, fontSize: 12))
        //                 ],
        //               ),
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 Navigator.of(context).push(MaterialPageRoute(
        //                     builder: (context) => MyBizScreen()));
        //               },
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   SvgPicture.asset('assets/icons/mybiz.svg',
        //                       fit: BoxFit.fill),
        //                   Text("My Biz",
        //                       style: TextStyle(
        //                           color: Colors.indigo.shade500, fontSize: 12))
        //                 ],
        //               ),
        //             ),
        //             SizedBox.shrink(),
        //             InkWell(
        //               onTap: () {},
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   SvgPicture.asset('assets/icons/reward.svg',
        //                       fit: BoxFit.fill),
        //                   Text("Campaign",
        //                       style: TextStyle(
        //                           color: Colors.indigo.shade500, fontSize: 12))
        //                 ],
        //               ),
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 Navigator.of(context).push(MaterialPageRoute(
        //                     builder: (context) => HelpScreen()));
        //               },
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   SvgPicture.asset('assets/icons/help.svg',
        //                       fit: BoxFit.fill),
        //                   Text("Help",
        //                       style: TextStyle(
        //                           color: Colors.indigo.shade500, fontSize: 12))
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       )),
        // ),
        appBar: AppBar(
            backgroundColor: appbarcolor,
            centerTitle: true,
            title: Text("Category",
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
                      // Get.offNamed('/cart');
                      //Get.off(CartScreen());
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartScreen()))
                          .then((value) {
                        _getCountBadge();
                      });
                    } else {
                      showToast('Your cart is empty');
                    }
                  },
                ),
              )
            ]),
        body: _searchResult.isEmpty
            ? errprMessage.isEmpty
                ? Center(
                    child: Container(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.indigo),
                    ),
                  )
                : Center(
                    child: Text(errprMessage),
                  )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  crossAxisCount:
                      (MediaQuery.of(context).size.width / 180).floor(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.85,
                  children: _searchResult
                      .map((e) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SubCategoryProductScreen(
                                            categoryid: e['id'].toString(),
                                            categoryname:
                                                e['category_name'].toString(),
                                          ))).then((value) {
                                _getCountBadge();
                              });
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              borderOnForeground: true,
                              color: Colors.indigo.shade50,
                              // shadowColor: Colors.teal,
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 140,
                                      width: 140,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: e['icon'] == ""
                                              ? Image.asset(
                                                  "assets/images/no_image.jpg")
                                              : Image(
                                                  image: NetworkImage(
                                                      e['icon'].toString()),
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        height: 45,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            e['category_name']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18,
                                                fontFamily: 'Poppins-Regular',
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 1),
                                            textAlign: TextAlign.center,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
      ),
    );
  }

  String errprMessage = "";
  Future _getcategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + category),
        headers: {'Authorization': 'Bearer $mytoken'});
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['ErrorCode'] == 0) {
        Iterable list = json.decode(response.body)['Response']['category'];
        setState(() {
          _searchResult.addAll(list);
          _categorylist.addAll(list);
        });
      } else {
        setState(() {
          errprMessage = json.decode(response.body)['ErrorMessage'].toString();
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  onSearchTextChanged(String text) async {
    if (text.isNotEmpty) {
      List dummyList = [];
      _categorylist.forEach((categoryDetail) {
        if (categoryDetail['category_name']
            .toString()
            .toUpperCase()
            .contains(text.toString().toUpperCase())) {
          dummyList.add(categoryDetail);
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
        _searchResult.addAll(_categorylist);
      });
    }
  }
}
