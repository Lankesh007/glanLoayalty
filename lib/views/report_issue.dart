// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/components/loader.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:tayal/views/conversation.dart';

class ReportIssues extends StatefulWidget {
  @override
  _ReportIssuesState createState() => _ReportIssuesState();
}

class _ReportIssuesState extends State<ReportIssues> {
  List raiesTicketList = [];
  Future<void> issuesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + raisedTicketList),
        headers: {'Authorization': 'Bearer $mytoken'});

    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        raiesTicketList.clear();
        raiesTicketList.addAll(jsonDecode(response.body)['Response']);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    issuesList();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text("Issues List",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 21,
                fontWeight: FontWeight.bold)),
      ),
      bottomSheet: InkWell(
        onTap: () {
          setState(() {
            title.text = "";
            details.text = "";
          });
          showOrderTracking();
        },
        child: Container(
          height: 55,
          // width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: appbarcolor2,
          ),
          child: const Text("Raise Ticket",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: ListView.separated(
          itemCount: raiesTicketList.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 0,
            color: Colors.grey,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Conversation(
                                query_id: raiesTicketList[index]['query_id']
                                    .toString(),
                              )));
                },
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
                minLeadingWidth: 2,
                leading: Text((index + 1).toString() + ". "),
                title: Text(
                  raiesTicketList[index]['title'].toString().toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  raiesTicketList[index]['query'].toString(),
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String attachmentPath = "";
  TextEditingController title = TextEditingController();
  TextEditingController details = TextEditingController();
  Future<void> showOrderTracking() async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: Colors.white,
        context: context,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TextButton.icon(
                                //     onPressed: () async {
                                //       FilePickerResult result =
                                //           await FilePicker.platform.pickFiles();

                                //       if (result != null) {
                                //         setState(() {
                                //           attachmentPath =
                                //               result.files.single.path;
                                //         });
                                //       }
                                //     },
                                //     icon: Icon(Icons.attachment),
                                //     label: Text("Attachment")),
                                // attachmentPath.isEmpty
                                //     ? SizedBox()
                                //     : Text("File Attached"),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      onPressed: () {
                                        // setState(() {
                                        //   attachmentPath = "";
                                        // });
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              autofocus: true,
                              controller: title,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: "Title"),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: details,
                              maxLines: 3,
                              autofocus: true,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: "Report Issue"),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                showLaoding(context);

                                print(BASE_URL + raisedTicket);

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String mytoken =
                                    prefs.getString('token').toString();
                                var response = await http.post(
                                    Uri.parse(BASE_URL + raisedTicket),
                                    headers: {
                                      'Authorization': 'Bearer $mytoken'
                                    },
                                    body: {
                                      "title": title.text.toString(),
                                      "query_text": details.text.toString()
                                    });
                                print(response.body);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                if (response.statusCode == 200) {
                                  Fluttertoast.showToast(msg: "Ticket Raised");
                                  showLaoding(context);
                                  issuesList();
                                  Navigator.of(context).pop();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Ticket Raised Failed");
                                }
                              },
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(29.0),
                                    border: Border.all(
                                        color: Colors.indigo, width: 1)),
                                child: Text("SUBMIT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                            ),
                          ]),
                    ),
                  ));
            }));
  }
}
