import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/components/loader.dart';
import 'package:tayal/helper/dialog_helper.dart';
import 'package:tayal/models/profiledata.dart';
import 'package:tayal/network/api.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/themes/constant.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:tayal/views/mybiz_screen.dart';
import 'package:tayal/views/profile_screen.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key key}) : super(key: key);

  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  bool _loading = false;
  String referralcode = "";

  String startDate = "From Date";
  String endDate = "To Date";

  DateTime selectedDate = DateTime.now();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  List<dynamic> _referrallist = [];
  int _value = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getreferraldata("", "");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
        title: Text("Referral",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 21,
                fontWeight: FontWeight.bold)),
      ),
      body: ModalProgressHUD(
        color: Colors.indigo,
        inAsyncCall: _loading,
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Card(
                    elevation: 0.0,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 10.0, top: 8.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("My Referral Code",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                referralcode == "" || referralcode == null
                                    ? Text("")
                                    : Text(referralcode,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14))
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                _onShare(context, referralcode);
                              },
                              icon: Icon(Icons.share,
                                  color: Colors.black, size: 24)),
                          IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                        ClipboardData(text: referralcode))
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: appbarcolor,
                                          content: Text("Referral code copied",
                                              style: TextStyle(
                                                  color: Colors.white))));
                                });
                              },
                              icon: Icon(Icons.copy_outlined,
                                  color: Colors.black, size: 24))
                        ],
                      ),
                    ),
                  ),
                ),
                /* Padding (
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectStartDate(context);
                        },
                        child: Card(
                          elevation: 4.0,
                          child: Container(
                              height: size.height * 0.06,
                              color: Colors.white,
                              width: size.width * 0.44,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      startDate,
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Icon(
                                        Icons.calendar_today_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      )),
                                ],
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectedEndDate(context);
                        },
                        child: Card(
                          elevation: 4.0,
                          child: Container(
                              height: size.height * 0.06,
                              color: Colors.white,
                              width: size.width * 0.44,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      endDate,
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Icon(
                                        Icons.calendar_today_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      )),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ListView.separated(
                    itemCount: _referrallist.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                            color: Colors.grey, height: 1, thickness: 1),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Name:",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    const SizedBox(width: 5.0),
                                    Text(
                                        "${_referrallist[index]['username'].toString()}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400))
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    const Text("Mobile:",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    const SizedBox(width: 5.0),
                                    Text(
                                        "${_referrallist[index]['mobile'].toString()}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400))
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Date:",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    const SizedBox(width: 5.0),
                                    Text(
                                        "${_referrallist[index]['created_at'].toString().split(" ")[0]}",
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400))
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    const Text("Points:",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    const SizedBox(width: 5.0),
                                    Text(
                                        "${_referrallist[index]['refer_by_point'].toString()}",
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400))
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      //firstDate: DateTime.now().subtract(Duration(days: 0)),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
              primaryColor: Colors.indigo,
              accentColor: Colors.indigo,
              primarySwatch: const MaterialColor(
                0xFF3949AB,
                <int, Color>{
                  50: Colors.indigo,
                  100: Colors.indigo,
                  200: Colors.indigo,
                  300: Colors.indigo,
                  400: Colors.indigo,
                  500: Colors.indigo,
                  600: Colors.indigo,
                  700: Colors.indigo,
                  800: Colors.indigo,
                  900: Colors.indigo,
                },
              )),
          child: child,
        );
      },
    );

    if (picked != null)
      setState(() {
        _value = 1;
        selectedStartDate = picked;
        startDate = selectedStartDate.toString().split(" ")[0];
      });
  }

  Future<void> _selectedEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        // firstDate: DateTime.now().subtract(Duration(days: 0)),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
                primaryColor: Colors.indigo,
                accentColor: Colors.indigo,
                primarySwatch: const MaterialColor(
                  0xFF3949AB,
                  <int, Color>{
                    50: Colors.indigo,
                    100: Colors.indigo,
                    200: Colors.indigo,
                    300: Colors.indigo,
                    400: Colors.indigo,
                    500: Colors.indigo,
                    600: Colors.indigo,
                    700: Colors.indigo,
                    800: Colors.indigo,
                    900: Colors.indigo,
                  },
                )),
            child: child,
          );
        });

    if (picked != null)
      setState(() {
        _value = 1;
        selectedEndDate = picked;
        endDate = selectedEndDate.toString().split(" ")[0];
      });
  }

  Future _getreferraldata(String startdate, String enddate) async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();

    final body = {"start_date": startdate, "end_date": enddate};
    var response = await http.post(Uri.parse(BASE_URL + referrallist),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });

    if (response.statusCode == 200) {
      print(response.body);
      if (json.decode(response.body)['ErrorCode'] == 0) {
        setState(() {
          _referrallist.clear();
          referralcode = json
              .decode(response.body)['Response']['my_referral_code']
              .toString();
          _referrallist = json.decode(response.body)['Response']['referrals'];
          _loading = false;
        });
      }
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  void _onShare(BuildContext context, String referralcode) async {
    final box = context.findRenderObject() as RenderBox;
    await FlutterShare.share(
        title: 'Referral Code',
        text: 'Referral Code - ' + referralcode.toString(),
        linkUrl:
            'https://play.google.com/store/apps/details?id=com.glen.glenLoyalty',
        chooserTitle: 'Referral Code');
    // await Share.share(
    //     'My Referrral code is : $referralcode\n<a href="https://www.google.com/">App Link</a>',
    //     subject: "Referral Code",
    //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<List<ProfileResponse>> _getprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + profile),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response'];
      List<ProfileResponse> _list =
          list.map((m) => ProfileResponse.fromJson(m)).toList();
      return _list;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
