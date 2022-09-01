// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/views/report_issue.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  List helplist = [];

  Future<List> getFaq() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + faqs),
        headers: {'Authorization': 'Bearer $mytoken'});

    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response']['Faqs'];
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    getFaq().then((value) {
      setState(() {
        helplist.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      appBar: AppBar(
        backgroundColor: appbarcolor,
        centerTitle: true,
        title: Text("Help",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 21,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30),
        child: ListView.separated(
            itemCount: helplist.length,
            padding: EdgeInsets.zero,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(color: Colors.blue),
            itemBuilder: (BuildContext context, int index) {
              return ExpandableNotifier(
                  child: ExpandablePanel(
                      header: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(helplist[index]['question'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ),
                      expanded: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //     helplist[index]['created_at']
                            //         .toString()
                            //         .split(" ")[0],
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.bold)),
                            Divider(
                              thickness: 1,
                              height: 10,
                            ),
                            Text(
                              helplist[index]['answer'].toString(),
                              textAlign: TextAlign.justify,
                            )
                          ],
                        ),
                      )));

              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //       vertical: 8.0, horizontal: 20.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       SizedBox(
              //         width: size.width * 0.80,
              //         child: Text(
              //             helplist[index]['question'].toString(),
              //             style: TextStyle(
              //                 color: Colors.black, fontSize: 16)),
              //       ),
              //       Icon(Icons.arrow_forward_ios,
              //           size: 16, color: Colors.black)
              //     ],
              //   ),
              // );
            }),
      ),
      bottomSheet: Container(
        height: 55,
        // width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(10),
          //   topRight: Radius.circular(10),
          // ),
          color: appbarcolor2,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ReportIssues()));
                },
                child: const Text("Report and Issue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
              InkWell(
                  onTap: () async {
                    await launch("https://wa.me/9368705182");
                  },
                  child: Icon(
                    Icons.whatsapp_rounded,
                    color: Colors.white,
                    size: 30,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
