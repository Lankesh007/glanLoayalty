// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/views/account_verified_screen.dart';

class SelectCatagory extends StatefulWidget {
  String pincode = "";
  SelectCatagory({this.pincode});

  @override
  _SelectCatagoryState createState() => _SelectCatagoryState();
}

class _SelectCatagoryState extends State<SelectCatagory> {
  List list = [];
  List listCopy = [];

  bool isSearch = false;
  int maxSelection = 0;
  int selectedCount = 0;
  Future _gettxndata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + registeredCat),
        headers: {'Authorization': 'Bearer $mytoken'});
    print(response.body);
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'].toString() == "0") {
        setState(() {
          List temp = json.decode(response.body)['Response']['category'];
          temp.forEach((element) {
            setState(() {
              element['selected'] = false;
            });
          });
          list.addAll(temp);
          listCopy.addAll(temp);
          maxSelection = int.parse(jsonDecode(response.body)['Response']
                  ['register_category_count']
              .toString());
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gettxndata();
  }

  @override
  Widget build(BuildContext context) {
    print(list);
    print("object");
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: appbarcolor,
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
        backgroundColor: kPrimaryLightColor,
        appBar: AppBar(
          backgroundColor: appbarcolor,
          title: isSearch
              ? TextFormField(
                  onChanged: (val) {
                    print(val);
                    List dummyListData = [];
                    if (val.isNotEmpty) {
                      listCopy.forEach((item) {
                        item.forEach((key, value) {
                          if (value
                              .toString()
                              .toLowerCase()
                              .contains(val.toLowerCase())) {
                            dummyListData.add(item);
                          }
                        });
                      });
                      setState(() {
                        list.clear();
                        list.addAll(dummyListData.toSet().toList());
                      });
                    } else {
                      setState(() {
                        list.clear();
                        list.addAll(listCopy);
                      });
                    }
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              setState(() {
                                list.clear();
                                list.addAll(listCopy);
                              });
                              isSearch = !isSearch;
                            });
                          },
                          icon: Icon(Icons.clear))),
                )
              : Text("Select Category(" +
                  selectedCount.toString() +
                  "/" +
                  maxSelection.toString() +
                  ")"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isSearch = !isSearch;
                  });
                },
                icon: Icon(Icons.search))
          ],
        ),
        bottomSheet: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () async {
                List sendList = [];
                list.forEach((element) {
                  if (element['selected']) {
                    sendList.add(element['id'].toString());
                  }
                });
                if (sendList.length == 0) {
                  Fluttertoast.showToast(
                      msg: "Please select atleast one category",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white);
                } else {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  print(BASE_URL + registeredCatPost);
                  var res = await http.post(
                    Uri.parse(BASE_URL + registeredCatPost),
                    headers: {
                      'Authorization':
                          'Bearer ' + prefs.getString('token').toString(),
                      'Content-Type': 'application/json'
                    },
                    body: jsonEncode({"category_ids": sendList}),
                  );

                  if (jsonDecode(res.body)['ErrorCode'] == 0) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountVerifiedScreen()));
                  } else {
                    Fluttertoast.showToast(msg: "Category not saved");
                  }
                }
              },
              child: Text("Save"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(appbarcolor)),
            )),
        body: Container(
          height: MediaQuery.of(context).size.height / 1.2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              // scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.6,
              shrinkWrap: true,
              children: list.map((e) {
                String images = "assets/images/no_image.jpg";

                return Stack(children: [
                  GridTile(
                      child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (!e['selected']) {
                        if (selectedCount < maxSelection) {
                          setState(() {
                            e['selected'] = !e['selected'];
                          });
                          setState(() {
                            selectedCount = 0;
                          });
                          list.forEach((element) {
                            if (element['selected']) {
                              setState(() {
                                selectedCount++;
                              });
                            }
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "Can't select more than " +
                                  maxSelection.toString() +
                                  " items");
                        }
                      } else {
                        setState(() {
                          e['selected'] = !e['selected'];
                          selectedCount--;
                        });
                      }
                    },
                    child: Card(
                      elevation: 0,
                      color: e['selected'] ? Colors.green[200] : Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.green[50],
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0,
                                      ),
                                    ]),
                                padding: EdgeInsets.all(10),
                                child: e['icon'].toString().isEmpty
                                    ? Image.asset(images)
                                    : Image.network(e['icon'].toString()),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  e['category_name'].toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
                  Checkbox(
                      value: e['selected'],
                      onChanged: (val) {
                        setState(() {
                          e['selected'] = val;
                        });
                      }),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
