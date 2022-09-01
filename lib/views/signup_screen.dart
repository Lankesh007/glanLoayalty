// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tayal/components/loader.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/otp_screen.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:path/path.dart' as p;

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  List locList1 = [];
  List locList2 = [];
  List locList3 = [];
  List locList4 = [];
  List locList5 = [];
  List locList6 = [];
  List PerlocList1 = [];
  List PerlocList2 = [];
  List PerlocList3 = [];
  List PerlocList4 = [];
  List PerlocList5 = [];
  List PerlocList6 = [];

  List memberTypeList = [];

  String loc1Val;
  String loc2Val;
  String loc3Val;
  String loc4Val;
  String loc5Val;
  String loc6Val;

  String Perloc1Val;
  String Perloc2Val;
  String Perloc3Val;
  String Perloc4Val;
  String Perloc5Val;
  String Perloc6Val;

  String memberTypeVal;

  String addressProof = "";
  String govIdProof = "";
  String profileProof = "";
  double height = 15;
  bool isLoading = true;
  bool sameAddress = true;
  bool married = false;

  TextEditingController ownerNameCont = TextEditingController();
  TextEditingController sapidCont = TextEditingController();
  TextEditingController mobileNoCont = TextEditingController();
  TextEditingController firmNameCont = TextEditingController();
  TextEditingController firmAdd1Cont = TextEditingController();
  TextEditingController firmAdd2Cont = TextEditingController();
  TextEditingController salesExtMobileNoCont = TextEditingController();
  TextEditingController perAdd1Cont = TextEditingController();
  TextEditingController perAdd2Cont = TextEditingController();
  TextEditingController emailIdCont = TextEditingController();
  TextEditingController dobCont = TextEditingController();
  TextEditingController altMobileNoCont = TextEditingController();
  TextEditingController latCont = TextEditingController();
  TextEditingController lonCont = TextEditingController();
  TextEditingController gstNoCont = TextEditingController();
  TextEditingController marrAniDateCont = TextEditingController();
  TextEditingController spoNameCont = TextEditingController();
  TextEditingController spoDOBCont = TextEditingController();
  TextEditingController child1NameCont = TextEditingController();
  TextEditingController child1DOBCont = TextEditingController();
  TextEditingController child2NameCont = TextEditingController();
  TextEditingController child2DOBCont = TextEditingController();

  GlobalKey ownerNameKey = GlobalKey();
  GlobalKey sapidKey = GlobalKey();
  GlobalKey mobileNoKey = GlobalKey();
  GlobalKey firmNameKey = GlobalKey();
  GlobalKey firmAdd1Key = GlobalKey();
  GlobalKey firmAdd2Key = GlobalKey();
  GlobalKey salesExtMobileNoKey = GlobalKey();
  GlobalKey perAdd1Key = GlobalKey();
  GlobalKey perAdd2Key = GlobalKey();
  GlobalKey emailIdKey = GlobalKey();
  GlobalKey dobKey = GlobalKey();
  GlobalKey altMobileNoKey = GlobalKey();
  GlobalKey latKey = GlobalKey();
  GlobalKey lonKey = GlobalKey();
  GlobalKey gstNoKey = GlobalKey();
  GlobalKey marrAniDateKey = GlobalKey();
  GlobalKey spoNameKey = GlobalKey();
  GlobalKey spoDOBKey = GlobalKey();
  GlobalKey child1NameKey = GlobalKey();
  GlobalKey child1DOBKey = GlobalKey();
  GlobalKey child2NameKey = GlobalKey();
  GlobalKey child2DOBKey = GlobalKey();

//influencer
  TextEditingController influencerNameCont = TextEditingController();
  TextEditingController rddrMobileNoCont = TextEditingController();
  TextEditingController dobInfluCont = TextEditingController();

  GlobalKey influencerNameContKey = GlobalKey();
  GlobalKey rddrMobileNoKey = GlobalKey();

  //customer
  TextEditingController customerNameCont = TextEditingController();
  TextEditingController customerMobileCont = TextEditingController();
  TextEditingController customerEmailCont = TextEditingController();

  GlobalKey customerNameContKey = GlobalKey();
  GlobalKey customerMobileContKey = GlobalKey();
  GlobalKey customerEmailContKey = GlobalKey();

  GlobalKey<FormState> form = GlobalKey<FormState>();

  String addresslabelName = "Firm";

  Future locLevelFirst() async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc1),
      body: {"auth_key": auth_key},
    );
    if (jsonDecode(res.body)['success']) {
      setState(() {
        locList1.addAll(jsonDecode(res.body)['loc_first']);
        loc1Val = locList1[0]['id'].toString();
      });
    }
  }

  Future locLevelSecond(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc2),
      body: {"auth_key": auth_key, "loc_first": id.toString()},
    );
    if (jsonDecode(res.body)['success']) {
      setState(() {
        locList2.add({"id": "0", "level_2_name": "Select"});
        locList2.addAll(jsonDecode(res.body)['loc_second']);
        loc2Val = "0";
      });
    }
  }

  Future locLevelThird(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc3),
      body: {"auth_key": auth_key, "loc_second": id.toString()},
    );
    if (jsonDecode(res.body)['success']) {
      setState(() {
        locList3.add({"id": "0", "level_3_name": "Select"});
        locList3.addAll(jsonDecode(res.body)['loc_third']);
        loc3Val = "0";
      });
    }
  }

  Future locLevelFouth(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc4),
      body: {"auth_key": auth_key, "loc_third": id.toString()},
    );
    print(res.body);
    if (jsonDecode(res.body)['success']) {
      setState(() {
        locList4.add({"id": "0", "level_4_name": "Select"});
        locList4.addAll(jsonDecode(res.body)['loc_four']);
        loc4Val = "0";
      });
    }
  }

  Future locLevelFifth(String id) async {
    print("object");
    var res = await http.post(
      Uri.parse(BASE_URL + loc5),
      body: {"auth_key": auth_key, "loc_four": id.toString()},
    );
    print(res.body);
    if (jsonDecode(res.body)['success']) {
      setState(() {
        locList5.add({"id": "0", "level_5_name": "Select"});
        locList5.addAll(jsonDecode(res.body)['loc_five']);
        loc5Val = "0";
      });
    }
  }

  Future locLevelSixth(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc6),
      body: {"auth_key": auth_key, "loc_five": id.toString()},
    );
    if (jsonDecode(res.body)['success']) {
      setState(() {
        locList6.add({"id": "0", "level_6_name": "Select"});
        locList6.addAll(jsonDecode(res.body)['loc_six']);
        loc6Val = "0";
      });
    }
  }

  //for Personal
  Future PerlocLevelFirst() async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc1),
      body: {"auth_key": auth_key},
    );
    if (jsonDecode(res.body)['success']) {
      setState(() {
        PerlocList1.addAll(jsonDecode(res.body)['loc_first']);
        Perloc1Val = PerlocList1[0]['id'].toString();
      });
    }
  }

  Future PerlocLevelSecond(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc2),
      body: {"auth_key": auth_key, "loc_first": id.toString()},
    );
    if (jsonDecode(res.body)['success']) {
      setState(() {
        PerlocList2.add({"id": "0", "level_2_name": "Select"});
        PerlocList2.addAll(jsonDecode(res.body)['loc_second']);
        Perloc2Val = "0";
      });
    }
  }

  Future PerlocLevelThird(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc3),
      body: {"auth_key": auth_key, "loc_second": id.toString()},
    );
    if (jsonDecode(res.body)['success']) {
      setState(() {
        PerlocList3.add({"id": "0", "level_3_name": "Select"});
        PerlocList3.addAll(jsonDecode(res.body)['loc_third']);
        Perloc3Val = "0";
      });
    }
  }

  Future PerlocLevelFouth(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc4),
      body: {"auth_key": auth_key, "loc_third": id.toString()},
    );
    if (jsonDecode(res.body)['success']) {
      setState(() {
        PerlocList4.add({"id": "0", "level_4_name": "Select"});
        PerlocList4.addAll(jsonDecode(res.body)['loc_four']);
        Perloc4Val = "0";
      });
    }
  }

  Future PerlocLevelFifth(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc5),
      body: {"auth_key": auth_key, "loc_four": id.toString()},
    );
    print(jsonEncode({"auth_key": auth_key, "loc_four": id.toString()}));
    print(res.body.toString() + " -----");
    if (jsonDecode(res.body)['success']) {
      setState(() {
        PerlocList5.add({"id": "0", "level_5_name": "Select"});
        PerlocList5.addAll(jsonDecode(res.body)['loc_five']);
        Perloc5Val = "0";
      });
    }
  }

  Future PerlocLevelSixth(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc6),
      body: {"auth_key": auth_key, "loc_five": id.toString()},
    );
    if (jsonDecode(res.body)['success']) {
      setState(() {
        PerlocList6.add({"id": "0", "level_6_name": "Select"});
        PerlocList6.addAll(jsonDecode(res.body)['loc_six']);
        Perloc6Val = "0";
      });
    }
  }

  Future getMemberType() async {
    var res = await http.post(
      Uri.parse(BASE_URL + memberType),
      body: {"auth_key": auth_key},
    );
    print(res.body);
    if (jsonDecode(res.body)['success']) {
      setState(() {
        memberTypeList.addAll(jsonDecode(res.body)['membertype']);
        memberTypeVal = memberTypeList[0]['id'].toString();
      });
    }
  }



  Future<void> callFunctions() async {
    await getMemberType();
    await locLevelFirst().then((value) {
      locLevelSecond(loc1Val.toString());
    });
    await PerlocLevelFirst().then((value) {
      PerlocLevelSecond(Perloc1Val.toString());
    });
    _determinePosition().then((value) => _getAddress(value));
    setState(() {
      isLoading = false;
    });
  }

  void showToastSignUp(String message) {
    Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    callFunctions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundShapeColor,
      appBar: AppBar(
        backgroundColor: appbarcolor,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });

                _determinePosition().then((value) => _getAddress(value));
              },
              icon: Icon(Icons.gps_fixed))
        ],
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
        title: const Text("Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 21,
                fontWeight: FontWeight.bold)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Form(
                key: form,
                child: Column(
                  children: memberTypeVal == "4"
                      ? [
                          SizedBox(
                            height: height,
                          ),
                          FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    labelText: "Member Type",
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: memberTypeVal,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        memberTypeVal = newValue.toString();
                                        if (newValue == "3") {
                                          addresslabelName = "Business";
                                        } else {
                                          addresslabelName = "Firm";
                                        }
                                      });
                                    },
                                    items: memberTypeList.map((value) {
                                      return DropdownMenuItem(
                                        value: value['id'].toString(),
                                        child: Text(value['member_type']
                                            .toString()
                                            .toUpperCase()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey,
                            height: 40,
                          ),
                          TextFormField(
                            key: customerNameContKey,
                            onTap: () {
                              Scrollable.ensureVisible(
                                  customerNameContKey.currentContext,
                                  alignment: 0.03,
                                  duration: Duration(milliseconds: 1300));
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Required Field";
                              else
                                return null;
                            },
                            controller: customerNameCont,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                                alignLabelWithHint: true,
                                labelText: "Customer Name",
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),
                          SizedBox(
                            height: height,
                          ),
                          TextFormField(
                            key: customerMobileContKey,
                            onTap: () {
                              Scrollable.ensureVisible(
                                  customerMobileContKey.currentContext,
                                  alignment: 0.03,
                                  duration: Duration(milliseconds: 1300));
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Required Field";
                              else
                                return null;
                            },
                            onChanged: (val) {
                              if (val.length == 10) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                            controller: customerMobileCont,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                labelText: "Mobile No.",
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),
                          SizedBox(
                            height: height,
                          ),
                          TextFormField(
                            key: customerEmailContKey,
                            onTap: () {
                              Scrollable.ensureVisible(
                                  customerEmailContKey.currentContext,
                                  alignment: 0.03,
                                  duration: Duration(milliseconds: 1300));
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Required Field";
                              else
                                return null;
                            },
                            controller: customerEmailCont,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: "Email Id",
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),
                          SizedBox(height: height),
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (!form.currentState.validate()) {
                                  showErrorMessage("Fill required fields");
                                } else {
                                  showLaoding(context);
                                  var request = http.MultipartRequest('POST',
                                      Uri.parse(BASE_URL + memberSignup));
                                  request.headers.addAll({
                                    'Accept': 'application/json',
                                    // 'Authorization': 'Bearer ' + api_token.toString(),
                                  });

                                  request.fields["member_type"] = "4";
                                  request.fields["customer_name"] =
                                      customerNameCont.text;
                                  request.fields["customer_mobile"] =
                                      customerMobileCont.text;
                                  request.fields["customer_email"] =
                                      customerEmailCont.text;
                                  print(jsonEncode(request.fields));
                                  var response = await request.send();

                                  var respStr =
                                      await response.stream.bytesToString();
                                  print(respStr);
                                  Navigator.of(context).pop();
                                  if (jsonDecode(respStr)['success'] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              jsonDecode(respStr)['message']
                                                  .toString()),
                                          duration: Duration(seconds: 2)),
                                    );
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                              child: Text("SUBMIT"),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                            ),
                          ),
                          SizedBox(
                            height: height,
                          ),
                        ]
                      : [
                          SizedBox(
                            height: height,
                          ),
                          FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    labelText: "Member Type",
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: memberTypeVal,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        memberTypeVal = newValue.toString();
                                        if (newValue == "3") {
                                          addresslabelName = "Business";
                                        } else {
                                          addresslabelName = "Firm";
                                        }
                                      });
                                    },
                                    items: memberTypeList.map((value) {
                                      return DropdownMenuItem(
                                        value: value['id'].toString(),
                                        child: Text(value['member_type']
                                            .toString()
                                            .toUpperCase()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey,
                            height: 40,
                          ),
                          memberTypeVal == "3"
                              ? TextFormField(
                                  key: influencerNameContKey,
                                  onTap: () {
                                    Scrollable.ensureVisible(
                                        influencerNameContKey.currentContext,
                                        alignment: 0.03,
                                        duration: Duration(milliseconds: 1300));
                                  },
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return "Required Field";
                                    else
                                      return null;
                                  },
                                  controller: influencerNameCont,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      labelText: "Influencer Name",
                                      contentPadding: EdgeInsets.all(12),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffD0D5DD))),
                                      fillColor: Colors.white,
                                      isDense: true,
                                      filled: true),
                                )
                              : TextFormField(
                                  key: ownerNameKey,
                                  onTap: () {
                                    Scrollable.ensureVisible(
                                        ownerNameKey.currentContext,
                                        alignment: 0.03,
                                        duration: Duration(milliseconds: 1300));
                                  },
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return "Required Field";
                                    else
                                      return null;
                                  },
                                  controller: ownerNameCont,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      labelText: "Owner Name",
                                      contentPadding: EdgeInsets.all(12),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffD0D5DD))),
                                      fillColor: Colors.white,
                                      isDense: true,
                                      filled: true),
                                ),
                          SizedBox(
                            height: height,
                          ),
                          memberTypeVal == "3"
                              ? TextFormField(
                                  key: rddrMobileNoKey,
                                  onTap: () {
                                    Scrollable.ensureVisible(
                                        rddrMobileNoKey.currentContext,
                                        alignment: 0.03,
                                        duration: Duration(milliseconds: 1300));
                                  },
                                  onChanged: (val) {
                                    if (val.length == 10) {
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                  controller: rddrMobileNoCont,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                      labelText:
                                          "Referring Distributor/Dealer Registered Mobile No",
                                      contentPadding: EdgeInsets.all(12),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffD0D5DD))),
                                      fillColor: Colors.white,
                                      isDense: true,
                                      filled: true),
                                )
                              : TextFormField(
                                  key: sapidKey,
                                  onTap: () {
                                    Scrollable.ensureVisible(
                                        sapidKey.currentContext,
                                        alignment: 0.03,
                                        duration: Duration(milliseconds: 1300));
                                  },
                                  controller: sapidCont,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                      labelText: "SAPID",
                                      contentPadding: EdgeInsets.all(12),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffD0D5DD))),
                                      fillColor: Colors.white,
                                      isDense: true,
                                      filled: true),
                                ),
                          SizedBox(
                            height: height,
                          ),
                          TextFormField(
                            key: mobileNoKey,
                            onTap: () {
                              Scrollable.ensureVisible(
                                  mobileNoKey.currentContext,
                                  alignment: 0.03,
                                  duration: Duration(milliseconds: 1300));
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Required Field";
                              else
                                return null;
                            },
                            onChanged: (val) {
                              if (val.length == 10) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                            controller: mobileNoCont,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                labelText: "Mobile No.",
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),

                          // memberTypeVal == "3"
                          //     ? Column(
                          //         children: [
                          //           SizedBox(
                          //             height: height,
                          //           ),
                          //           TextFormField(
                          //             readOnly: true,
                          //             onTap: () async {
                          //               final DateTime picked = await showDatePicker(
                          //                   context: context,
                          //                   initialDate: DateTime.now(),
                          //                   firstDate: DateTime(1900),
                          //                   lastDate: DateTime(2101));
                          //               if (picked != null) {
                          //                 setState(() {
                          //                   dobInfluCont.text =
                          //                       picked.toString().split(" ")[0];
                          //                 });
                          //               }
                          //             },
                          //             // validator: (value) {
                          //             //   if (value.isEmpty)
                          //             //     return "Required Field";
                          //             //   else
                          //             //     return null;
                          //             // },
                          //             controller: dobInfluCont,

                          //             decoration: InputDecoration(
                          //                 labelText: "Date of Birth",
                          //                 contentPadding: EdgeInsets.all(12),
                          //                 border: OutlineInputBorder(
                          //                     borderSide: BorderSide(
                          //                         color: Color(0xffD0D5DD))),
                          //                 fillColor: Colors.white,
                          //                 isDense: true,
                          //                 filled: true),
                          //           ),
                          //         ],
                          //       )
                          //     : SizedBox(),

                          Stack(alignment: Alignment.center, children: [
                            Divider(
                              thickness: 1,
                              height: 60,
                            ),
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text(addresslabelName + " Address Details"),
                              ),
                            )
                          ]),

                          Column(
                            children: [
                              TextFormField(
                                key: firmNameKey,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Required Field";
                                  else
                                    return null;
                                },
                                onTap: () {
                                  Scrollable.ensureVisible(
                                    firmNameKey.currentContext,
                                    alignment: 0.03,
                                    duration: Duration(milliseconds: 1300),
                                  );
                                },
                                controller: firmNameCont,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                    labelText: addresslabelName + " Name",
                                    contentPadding: EdgeInsets.all(12),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffD0D5DD))),
                                    fillColor: Colors.white,
                                    isDense: true,
                                    filled: true),
                              ),
                              SizedBox(
                                height: height,
                              ),
                            ],
                          ),

                          TextFormField(
                            key: firmAdd1Key,
                            onTap: () {
                              Scrollable.ensureVisible(
                                  firmAdd1Key.currentContext,
                                  alignment: 0.03,
                                  duration: Duration(milliseconds: 1300));
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Required Field";
                              else
                                return null;
                            },
                            controller: firmAdd1Cont,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                                labelText: addresslabelName + " Address 1",
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),
                          SizedBox(
                            height: height,
                          ),
                          TextFormField(
                            key: firmAdd2Key,
                            onTap: () {
                              Scrollable.ensureVisible(
                                  firmAdd2Key.currentContext,
                                  alignment: 0.03,
                                  duration: Duration(milliseconds: 1300));
                            },
                            // validator: (value) {
                            //   if (value.isEmpty)
                            //     return "Required Field";
                            //   else
                            //     return null;
                            // },
                            controller: firmAdd2Cont,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                                labelText: addresslabelName + " Address 2",
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),
                          SizedBox(
                            height: height,
                          ),
                          FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    labelText: addresslabelName + " Country",
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: loc1Val,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        loc1Val = newValue.toString();
                                        locList2.clear();
                                        locList3.clear();
                                        locList4.clear();
                                        locList5.clear();
                                        locList6.clear();
                                      });
                                      showLaoding(context);
                                      locLevelSecond(loc1Val).then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    items: locList1.map((value) {
                                      return DropdownMenuItem(
                                        value: value['id'].toString(),
                                        child: Text(value['level_1_name']
                                            .toString()
                                            .toUpperCase()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: height),
                          FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    labelText: addresslabelName + " State",
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: loc2Val,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      if (newValue == "0") {
                                        showToastSignUp("Please select valid " +
                                            addresslabelName +
                                            " State");
                                      } else {
                                        setState(() {
                                          loc2Val = newValue.toString();
                                          locList3.clear();
                                          locList4.clear();
                                          locList5.clear();
                                          locList6.clear();
                                        });
                                        showLaoding(context);
                                        locLevelThird(loc2Val).then((value) {
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    },
                                    items: locList2.map((value) {
                                      return DropdownMenuItem(
                                        value: value['id'].toString(),
                                        child: Text(value['level_2_name']
                                            .toString()
                                            .toUpperCase()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: height),
                          FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    labelText: addresslabelName + " District",
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: loc3Val,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      if (newValue == "0") {
                                        showToastSignUp("Please select valid " +
                                            addresslabelName +
                                            " District");
                                      } else {
                                        setState(() {
                                          loc3Val = newValue.toString();
                                          locList4.clear();
                                          locList5.clear();
                                          locList6.clear();
                                        });
                                        print(loc3Val);
                                        showLaoding(context);
                                        locLevelFouth(loc3Val).then((value) {
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    },
                                    items: locList3.map((value) {
                                      return DropdownMenuItem(
                                        value: value['id'].toString(),
                                        child: Text(value['level_3_name']
                                            .toString()
                                            .toUpperCase()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: height),
                          FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    labelText: addresslabelName + " City",
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: loc4Val,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      if (newValue == "0") {
                                        showToastSignUp("Please select valid " +
                                            addresslabelName +
                                            " District");
                                      } else {
                                        setState(() {
                                          loc4Val = newValue.toString();
                                          locList5.clear();
                                          locList6.clear();
                                        });
                                        showLaoding(context);
                                        locLevelFifth(loc4Val).then((value) {
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    },
                                    items: locList4.map((value) {
                                      return DropdownMenuItem(
                                        value: value['id'].toString(),
                                        child: Text(value['level_4_name']
                                            .toString()
                                            .toUpperCase()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: height),
                          FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    labelText: addresslabelName + " Area",
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: loc5Val,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      if (newValue == "0") {
                                        showToastSignUp("Please select valid " +
                                            addresslabelName +
                                            " District");
                                      } else {
                                        setState(() {
                                          loc5Val = newValue.toString();
                                          locList6.clear();
                                        });
                                        showLaoding(context);
                                        locLevelSixth(loc5Val).then((value) {
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    },
                                    items: locList5.map((value) {
                                      return DropdownMenuItem(
                                        value: value['id'].toString(),
                                        child: Text(value['level_5_name']
                                            .toString()
                                            .toUpperCase()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: height),
                          FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    labelText: "Pincode",
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: loc6Val,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      if (newValue == "0") {
                                        showToastSignUp("Please select valid " +
                                            addresslabelName +
                                            " District");
                                      } else {
                                        setState(() {
                                          loc6Val = newValue.toString();
                                        });
                                      }
                                    },
                                    items: locList6.map((value) {
                                      return DropdownMenuItem(
                                        value: value['id'].toString(),
                                        child: Text(value['level_6_name']
                                            .toString()
                                            .toUpperCase()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: height,
                          ),
                          TextFormField(
                            key: salesExtMobileNoKey,
                            onTap: () {
                              Scrollable.ensureVisible(
                                  salesExtMobileNoKey.currentContext,
                                  alignment: 0.03,
                                  duration: Duration(milliseconds: 1300));
                            },
                            // validator: (value) {
                            //   if (value.isEmpty)
                            //     return "Required Field";
                            //   else
                            //     return null;
                            // },
                            onChanged: (val) {
                              if (val.length == 10) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                            controller: salesExtMobileNoCont,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                labelText: "Sales Executive Mobile No.",
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),
                          //permanent address
                          Stack(alignment: Alignment.center, children: [
                            Divider(
                              thickness: 1,
                              height: 60,
                            ),
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Personal Address Details"),
                              ),
                            )
                          ]),
                          InkWell(
                            onTap: () {
                              setState(() {
                                sameAddress = !sameAddress;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Same as " + addresslabelName + " Address",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                sameAddress
                                    ? Icon(
                                        Icons.check_box_outlined,
                                        color: Colors.blue,
                                      )
                                    : Icon(
                                        Icons.check_box_outline_blank_rounded,
                                        color: Colors.blue,
                                      )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height,
                          ),
                          !sameAddress
                              ? Column(
                                  children: [
                                    TextFormField(
                                      key: perAdd1Key,
                                      onTap: () {
                                        Scrollable.ensureVisible(
                                            perAdd1Key.currentContext,
                                            alignment: 0.03,
                                            duration:
                                                Duration(milliseconds: 1300));
                                      },
                                      validator: (value) {
                                        if (value.isEmpty && !sameAddress)
                                          return "Required Field";
                                        else
                                          return null;
                                      },
                                      controller: perAdd1Cont,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: InputDecoration(
                                          labelText: "Personal Address 1",
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD0D5DD))),
                                          fillColor: Colors.white,
                                          isDense: true,
                                          filled: true),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    TextFormField(
                                      key: perAdd2Key,
                                      onTap: () {
                                        Scrollable.ensureVisible(
                                            perAdd2Key.currentContext,
                                            alignment: 0.03,
                                            duration:
                                                Duration(milliseconds: 1300));
                                      },
                                      // validator: (value) {
                                      //   if (value.isEmpty)
                                      //     return "Required Field";
                                      //   else
                                      //     return null;
                                      // },
                                      controller: perAdd2Cont,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: InputDecoration(
                                          labelText: "Personal Address 2",
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD0D5DD))),
                                          fillColor: Colors.white,
                                          isDense: true,
                                          filled: true),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    FormField(
                                      builder: (FormFieldState state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              isDense: true,
                                              labelText:
                                                  "Personal Address Country",
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0))),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              value: Perloc1Val,
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  Perloc1Val =
                                                      newValue.toString();
                                                  PerlocList2.clear();
                                                  PerlocList3.clear();
                                                  PerlocList4.clear();
                                                  PerlocList5.clear();
                                                  PerlocList6.clear();
                                                });
                                                showLaoding(context);
                                                PerlocLevelSecond(Perloc1Val)
                                                    .then((value) {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              items: PerlocList1.map((value) {
                                                return DropdownMenuItem(
                                                  value: value['id'].toString(),
                                                  child: Text(
                                                      value['level_1_name']
                                                          .toString()
                                                          .toUpperCase()),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    FormField(
                                      builder: (FormFieldState state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              isDense: true,
                                              labelText:
                                                  "Personal Address State",
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0))),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              value: Perloc2Val,
                                              isDense: true,
                                              onChanged: (newValue) {
                                                if (newValue == "0") {
                                                  showToastSignUp(
                                                      "Please select valid Personal Address State");
                                                } else {
                                                  setState(() {
                                                    Perloc2Val =
                                                        newValue.toString();
                                                    PerlocList3.clear();
                                                    PerlocList4.clear();
                                                    PerlocList5.clear();
                                                    PerlocList6.clear();
                                                  });
                                                  showLaoding(context);
                                                  PerlocLevelThird(Perloc2Val)
                                                      .then((value) {
                                                    Navigator.of(context).pop();
                                                  });
                                                }
                                              },
                                              items: PerlocList2.map((value) {
                                                return DropdownMenuItem(
                                                  value: value['id'].toString(),
                                                  child: Text(
                                                      value['level_2_name']
                                                          .toString()
                                                          .toUpperCase()),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    FormField(
                                      builder: (FormFieldState state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              isDense: true,
                                              labelText:
                                                  "Personal Address District",
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0))),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              value: Perloc3Val,
                                              isDense: true,
                                              onChanged: (newValue) {
                                                if (newValue == "0") {
                                                  showToastSignUp(
                                                      "Please select valid Personal Address District");
                                                } else {
                                                  setState(() {
                                                    Perloc3Val =
                                                        newValue.toString();
                                                    PerlocList4.clear();
                                                    PerlocList5.clear();
                                                    PerlocList6.clear();
                                                  });
                                                  print(Perloc3Val);
                                                  showLaoding(context);
                                                  PerlocLevelFouth(Perloc3Val)
                                                      .then((value) {
                                                    Navigator.of(context).pop();
                                                  });
                                                }
                                              },
                                              items: PerlocList3.map((value) {
                                                return DropdownMenuItem(
                                                  value: value['id'].toString(),
                                                  child: Text(
                                                      value['level_3_name']
                                                          .toString()
                                                          .toUpperCase()),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    FormField(
                                      builder: (FormFieldState state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              isDense: true,
                                              labelText:
                                                  "Personal Address City",
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0))),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              value: Perloc4Val,
                                              isDense: true,
                                              onChanged: (newValue) {
                                                if (newValue == "0") {
                                                  showToastSignUp(
                                                      "Please select valid Personal Address District");
                                                } else {
                                                  setState(() {
                                                    Perloc4Val =
                                                        newValue.toString();
                                                    PerlocList5.clear();
                                                    PerlocList6.clear();
                                                  });
                                                  showLaoding(context);
                                                  PerlocLevelFifth(Perloc4Val)
                                                      .then((value) {
                                                    Navigator.of(context).pop();
                                                  });
                                                }
                                              },
                                              items: PerlocList4.map((value) {
                                                return DropdownMenuItem(
                                                  value: value['id'].toString(),
                                                  child: Text(
                                                      value['level_4_name']
                                                          .toString()
                                                          .toUpperCase()),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    FormField(
                                      builder: (FormFieldState state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              isDense: true,
                                              labelText:
                                                  "Personal Address Area",
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0))),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              value: Perloc5Val,
                                              isDense: true,
                                              onChanged: (newValue) {
                                                if (newValue == "0") {
                                                  showToastSignUp(
                                                      "Please select valid Personal Address District");
                                                } else {
                                                  setState(() {
                                                    Perloc5Val =
                                                        newValue.toString();
                                                    PerlocList6.clear();
                                                  });
                                                  showLaoding(context);
                                                  PerlocLevelSixth(Perloc5Val)
                                                      .then((value) {
                                                    Navigator.of(context).pop();
                                                  });
                                                }
                                              },
                                              items: PerlocList5.map((value) {
                                                return DropdownMenuItem(
                                                  value: value['id'].toString(),
                                                  child: Text(
                                                      value['level_5_name']
                                                          .toString()
                                                          .toUpperCase()),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    FormField(
                                      builder: (FormFieldState state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              isDense: true,
                                              labelText:
                                                  "Personal Address Pincode",
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0))),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              value: Perloc6Val,
                                              isDense: true,
                                              onChanged: (newValue) {
                                                if (newValue == "0") {
                                                  showToastSignUp(
                                                      "Please select valid Personal Address Pincode");
                                                } else {
                                                  setState(() {
                                                    Perloc6Val =
                                                        newValue.toString();
                                                  });
                                                }
                                              },
                                              items: PerlocList6.map((value) {
                                                return DropdownMenuItem(
                                                  value: value['id'].toString(),
                                                  child: Text(
                                                      value['level_6_name']
                                                          .toString()
                                                          .toUpperCase()),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                  ],
                                )
                              : SizedBox(),

                          TextFormField(
                            key: emailIdKey,
                            onTap: () {
                              Scrollable.ensureVisible(
                                  emailIdKey.currentContext,
                                  alignment: 0.03,
                                  duration: Duration(milliseconds: 1300));
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Required Field";
                              else
                                return null;
                            },
                            controller: emailIdCont,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: "Email Id",
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),

                          memberTypeVal == "3"
                              ? SizedBox()
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: height,
                                    ),
                                    TextFormField(
                                      key: altMobileNoKey,
                                      onTap: () {
                                        Scrollable.ensureVisible(
                                            altMobileNoKey.currentContext,
                                            alignment: 0.03,
                                            duration:
                                                Duration(milliseconds: 1300));
                                      },
                                      // validator: (value) {
                                      //   if (value.isEmpty)
                                      //     return "Required Field";
                                      //   else
                                      //     return null;
                                      // },
                                      onChanged: (val) {
                                        if (val.length == 10) {
                                          FocusScope.of(context).unfocus();
                                        }
                                      },
                                      controller: altMobileNoCont,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                          labelText: "Alternate Mobile No.",
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD0D5DD))),
                                          fillColor: Colors.white,
                                          isDense: true,
                                          filled: true),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 5, 0),
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required Field";
                                                else
                                                  return null;
                                              },
                                              controller: latCont,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  labelText: "Latitude",
                                                  contentPadding:
                                                      EdgeInsets.all(12),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xffD0D5DD))),
                                                  fillColor: Colors.white,
                                                  isDense: true,
                                                  filled: true),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 0, 0, 0),
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required Field";
                                                else
                                                  return null;
                                              },
                                              controller: lonCont,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  labelText: "Longitude",
                                                  contentPadding:
                                                      EdgeInsets.all(12),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xffD0D5DD))),
                                                  fillColor: Colors.white,
                                                  isDense: true,
                                                  filled: true),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    TextFormField(
                                      key: gstNoKey,
                                      onTap: () {
                                        Scrollable.ensureVisible(
                                            gstNoKey.currentContext,
                                            alignment: 0.03,
                                            duration:
                                                Duration(milliseconds: 1300));
                                      },
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "Required Field";
                                        else
                                          return null;
                                      },
                                      controller: gstNoCont,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                          labelText: "GST No.",
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD0D5DD))),
                                          fillColor: Colors.white,
                                          isDense: true,
                                          filled: true),
                                    ),
                                  ],
                                ),

                          Stack(alignment: Alignment.center, children: [
                            Divider(
                              thickness: 1,
                              height: 60,
                            ),
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Documents"),
                              ),
                            )
                          ]),
                          Card(
                              elevation: 10,
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Upload Address Proof"),
                                    IconButton(
                                        onPressed: () {
                                          showPhotoCaptureOptions("AP");
                                        },
                                        icon: Icon(
                                          Icons.upload_file,
                                          color: Colors.blue,
                                        ))
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: addressProof == ""
                                      ? SizedBox()
                                      : SizedBox(
                                          height: 150,
                                          width: 100,
                                          child: Image.file(File(addressProof),
                                              fit: BoxFit.fill),
                                        ),
                                ),
                              )),
                          SizedBox(
                            height: height,
                          ),
                          Card(
                              elevation: 10,
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Upload Govt. ID Proof"),
                                    IconButton(
                                        onPressed: () {
                                          showPhotoCaptureOptions("GP");
                                        },
                                        icon: Icon(
                                          Icons.upload_file,
                                          color: Colors.blue,
                                        ))
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: govIdProof == ""
                                      ? SizedBox()
                                      : SizedBox(
                                          height: 150,
                                          width: 100,
                                          child: Image.file(File(govIdProof),
                                              fit: BoxFit.fill),
                                        ),
                                ),
                              )),
                          SizedBox(
                            height: height,
                          ),
                          Card(
                              elevation: 10,
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Upload Profile Picture"),
                                    IconButton(
                                        onPressed: () {
                                          showPhotoCaptureOptions("PP");
                                        },
                                        icon: Icon(
                                          Icons.upload_file,
                                          color: Colors.blue,
                                        ))
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: profileProof == ""
                                      ? SizedBox()
                                      : SizedBox(
                                          height: 150,
                                          width: 100,
                                          child: Image.file(File(profileProof),
                                              fit: BoxFit.fill),
                                        ),
                                ),
                              )),

                          Stack(alignment: Alignment.center, children: [
                            Divider(
                              thickness: 1,
                              height: 60,
                            ),
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Personal Details"),
                              ),
                            )
                          ]),
                          TextFormField(
                            readOnly: true,
                            onTap: () async {
                              final DateTime picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2101));
                              if (picked != null) {
                                setState(() {
                                  dobCont.text =
                                      picked.toString().split(" ")[0];
                                });
                              }
                            },
                            validator: (value) {
                              if (value.isEmpty && memberTypeVal == "3")
                                return "Required Field";
                              else
                                return null;
                            },
                            controller: dobCont,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: "Date of Birth",
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),
                          SizedBox(
                            height: height,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Married"),
                                ToggleSwitch(
                                  initialLabelIndex: married ? 0 : 1,
                                  cornerRadius: 20.0,
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey,
                                  inactiveFgColor: Colors.white,
                                  totalSwitches: 2,
                                  labels: ['YES', 'NO'],
                                  onToggle: (index) {
                                    setState(() {
                                      married = index == 0 ? true : false;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height,
                          ),
                          married
                              ? Column(
                                  children: [
                                    TextFormField(
                                      readOnly: true,
                                      onTap: () async {
                                        final DateTime picked =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2101));
                                        if (picked != null) {
                                          setState(() {
                                            marrAniDateCont.text =
                                                picked.toString().split(" ")[0];
                                          });
                                        }
                                      },
                                      validator: (value) {
                                        if (value.isEmpty && married)
                                          return "Required Field";
                                        else
                                          return null;
                                      },
                                      controller: marrAniDateCont,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          labelText:
                                              "Marriage Anniversary Date",
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD0D5DD))),
                                          fillColor: Colors.white,
                                          isDense: true,
                                          filled: true),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    TextFormField(
                                      key: spoNameKey,
                                      onTap: () {
                                        Scrollable.ensureVisible(
                                            spoNameKey.currentContext,
                                            alignment: 0.03,
                                            duration:
                                                Duration(milliseconds: 1300));
                                      },
                                      validator: (value) {
                                        if (value.isEmpty && married)
                                          return "Required Field";
                                        else
                                          return null;
                                      },
                                      controller: spoNameCont,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: InputDecoration(
                                          labelText: "Spouse Name",
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD0D5DD))),
                                          fillColor: Colors.white,
                                          isDense: true,
                                          filled: true),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      onTap: () async {
                                        final DateTime picked =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2101));
                                        if (picked != null) {
                                          setState(() {
                                            spoDOBCont.text =
                                                picked.toString().split(" ")[0];
                                          });
                                        }
                                      },
                                      validator: (value) {
                                        if (value.isEmpty && married)
                                          return "Required Field";
                                        else
                                          return null;
                                      },
                                      controller: spoDOBCont,
                                      decoration: InputDecoration(
                                          labelText: "Spouse DOB",
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD0D5DD))),
                                          fillColor: Colors.white,
                                          isDense: true,
                                          filled: true),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    TextFormField(
                                      key: child1NameKey,
                                      onTap: () {
                                        Scrollable.ensureVisible(
                                            child1NameKey.currentContext,
                                            alignment: 0.03,
                                            duration:
                                                Duration(milliseconds: 1300));
                                      },
                                      // validator: (value) {
                                      //   if (value.isEmpty)
                                      //     return "Required Field";
                                      //   else
                                      //     return null;
                                      // },
                                      controller: child1NameCont,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: InputDecoration(
                                          labelText: "Child 1 Name",
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD0D5DD))),
                                          fillColor: Colors.white,
                                          isDense: true,
                                          filled: true),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      onTap: () async {
                                        final DateTime picked =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2101));
                                        if (picked != null) {
                                          setState(() {
                                            child1DOBCont.text =
                                                picked.toString().split(" ")[0];
                                          });
                                        }
                                      },
                                      // validator: (value) {
                                      //   if (value.isEmpty)
                                      //     return "Required Field";
                                      //   else
                                      //     return null;
                                      // },
                                      controller: child1DOBCont,
                                      decoration: InputDecoration(
                                          labelText: "Child 1 DOB",
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD0D5DD))),
                                          fillColor: Colors.white,
                                          isDense: true,
                                          filled: true),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    TextFormField(
                                      key: child2NameKey,
                                      onTap: () {
                                        Scrollable.ensureVisible(
                                            child2NameKey.currentContext,
                                            alignment: 0.03,
                                            duration:
                                                Duration(milliseconds: 1300));
                                      },
                                      // validator: (value) {
                                      //   if (value.isEmpty)
                                      //     return "Required Field";
                                      //   else
                                      //     return null;
                                      // },
                                      controller: child2NameCont,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: InputDecoration(
                                          labelText: "Child 2 Name",
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD0D5DD))),
                                          fillColor: Colors.white,
                                          isDense: true,
                                          filled: true),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      onTap: () async {
                                        final DateTime picked =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2101));
                                        if (picked != null) {
                                          setState(() {
                                            child2DOBCont.text =
                                                picked.toString().split(" ")[0];
                                          });
                                        }
                                      },
                                      // validator: (value) {
                                      //   if (value.isEmpty)
                                      //     return "Required Field";
                                      //   else
                                      //     return null;
                                      // },
                                      controller: child2DOBCont,
                                      decoration: InputDecoration(
                                          labelText: "Child 2 DOB",
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD0D5DD))),
                                          fillColor: Colors.white,
                                          isDense: true,
                                          filled: true),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();

                                if (loc2Val == "0") {
                                  showErrorMessage(
                                      "Select " + addresslabelName + " State");
                                } else if (loc3Val == "0") {
                                  showErrorMessage("Select " +
                                      addresslabelName +
                                      " District");
                                } else if (loc4Val == "0") {
                                  showErrorMessage(
                                      "Select " + addresslabelName + " City");
                                } else if (loc5Val == "0") {
                                  showErrorMessage(
                                      "Select " + addresslabelName + " Area");
                                } else if (loc6Val == "0") {
                                  showErrorMessage("Select " +
                                      addresslabelName +
                                      " Pincode");
                                } else if (Perloc2Val == "0" && !sameAddress) {
                                  showErrorMessage(
                                      "Select Personal Address State");
                                } else if (Perloc3Val == "0" && !sameAddress) {
                                  showErrorMessage(
                                      "Select Personal Address District");
                                } else if (Perloc4Val == "0" && !sameAddress) {
                                  showErrorMessage(
                                      "Select Personal Address City");
                                } else if (Perloc5Val == "0" && !sameAddress) {
                                  showErrorMessage(
                                      "Select Personal Address Area");
                                } else if (Perloc6Val == "0" && !sameAddress) {
                                  showErrorMessage(
                                      "Select Personal Address Pincode");
                                } else if (addressProof.isEmpty) {
                                  showErrorMessage("Upload Address Proof");
                                } else if (govIdProof.isEmpty) {
                                  showErrorMessage("Upload Govt. ID Proof");
                                } else if (profileProof.isEmpty) {
                                  showErrorMessage("Upload Profile Picture");
                                } else if (!form.currentState.validate()) {
                                  showErrorMessage("Fill required fields");
                                } else {
                                  showLaoding(context);
                                  var request = http.MultipartRequest('POST',
                                      Uri.parse(BASE_URL + memberSignup));
                                  request.headers.addAll({
                                    'Accept': 'application/json',
                                    // 'Authorization': 'Bearer ' + api_token.toString(),
                                  });

                                  switch (memberTypeVal) {
                                    case "1":
                                    case "2":
                                      request.fields["member_type"] = "1";
                                      request.fields["owner_name"] =
                                          ownerNameCont.text;
                                      request.fields["sapid"] = sapidCont.text;
                                      request.fields["mobile"] =
                                          mobileNoCont.text;
                                      request.fields["firm_name"] =
                                          firmNameCont.text;
                                      request.fields["address1"] =
                                          firmAdd1Cont.text;
                                      request.fields["address2"] =
                                          firmAdd2Cont.text;
                                      request.fields["level_1_id"] =
                                          loc1Val.toString();
                                      request.fields["level_2_id"] =
                                          loc2Val.toString();
                                      request.fields["level_3_id"] =
                                          loc3Val.toString();
                                      request.fields["level_4_id"] =
                                          loc4Val.toString();
                                      request.fields["level_5_id"] =
                                          loc5Val.toString();
                                      request.fields["level_6_id"] = "";
                                      request.fields["pin"] =
                                          loc6Val.toString();
                                      request.fields["sale_mobile"] =
                                          salesExtMobileNoCont.text;

                                      if (!sameAddress) {
                                        request.fields["Permanent_address1"] =
                                            firmAdd1Cont.text;
                                        request.fields["Permanent_address2"] =
                                            firmAdd2Cont.text;
                                        request.fields["Permanent_level_1_id"] =
                                            Perloc1Val.toString();
                                        request.fields["Permanent_level_2_id"] =
                                            Perloc2Val.toString();
                                        request.fields["Permanent_level_3_id"] =
                                            Perloc3Val.toString();
                                        request.fields["Permanent_level_4_id"] =
                                            Perloc4Val.toString();
                                        request.fields["Permanent_level_5_id"] =
                                            Perloc5Val.toString();
                                        request.fields["Permanent_level_6_id"] =
                                            "";
                                        request.fields["Permanent_pin"] =
                                            Perloc6Val.toString();
                                      }
                                      request.fields["email"] =
                                          emailIdCont.text;
                                      request.fields["alter_phone"] =
                                          altMobileNoCont.text;
                                      request.fields["latitude"] = latCont.text;
                                      request.fields["longitude"] =
                                          lonCont.text;
                                      request.fields["gst"] = gstNoCont.text;
                                      request.fields["dob"] = dobCont.text;
                                      request.fields["married"] =
                                          married ? "1" : "0";
                                      request.fields["anniversary"] = married
                                          ? marrAniDateCont.text.toString()
                                          : "";
                                      request.fields["spouse_name"] =
                                          spoNameCont.text;
                                      request.fields["spouse_dob"] =
                                          spoDOBCont.text;
                                      request.fields["child_1_name"] =
                                          child1NameCont.text;
                                      request.fields["child_1_dob"] =
                                          child1DOBCont.text;
                                      request.fields["child_2_name"] =
                                          child2NameCont.text;
                                      request.fields["child_2_dob"] =
                                          child1DOBCont.text;
                                      request.fields["status"] = "0";

                                      request.files.add(http.MultipartFile(
                                          'address_proof',
                                          File(addressProof)
                                              .readAsBytes()
                                              .asStream(),
                                          File(addressProof).lengthSync(),
                                          filename: "address_proof" +
                                              p.extension(addressProof)));

                                      request.files.add(http.MultipartFile(
                                          'govt_id_proof',
                                          File(govIdProof)
                                              .readAsBytes()
                                              .asStream(),
                                          File(govIdProof).lengthSync(),
                                          filename: "govt_id_proof" +
                                              p.extension(govIdProof)));

                                      request.files.add(http.MultipartFile(
                                          'profile_picture',
                                          File(profileProof)
                                              .readAsBytes()
                                              .asStream(),
                                          File(profileProof).lengthSync(),
                                          filename: "profile_picture" +
                                              p.extension(profileProof)));
                                      break;
                                    case "3":
                                      request.fields["member_type"] = "3";
                                      request.fields["influencer_name"] =
                                          influencerNameCont.text;
                                      request.fields["referral_mobile"] =
                                          rddrMobileNoCont.text;
                                      request.fields["mobile"] =
                                          mobileNoCont.text;
                                      request.fields["influencer_dob"] =
                                          dobCont.text;

                                      request.fields["business_address1"] =
                                          firmAdd1Cont.text;
                                      request.fields["business_address2"] =
                                          firmAdd2Cont.text;
                                      request.fields["business_level_1_id"] =
                                          loc1Val.toString();
                                      request.fields["business_level_2_id"] =
                                          loc2Val.toString();
                                      request.fields["business_level_3_id"] =
                                          loc3Val.toString();
                                      request.fields["business_level_4_id"] =
                                          loc4Val.toString();
                                      request.fields["business_level_5_id"] =
                                          loc5Val.toString();
                                      request.fields["business_level_6_id"] =
                                          "";
                                      request.fields["influencer_pin"] =
                                          loc6Val.toString();
                                      request.fields["influencer_sale_mobile"] =
                                          salesExtMobileNoCont.text;

                                      if (!sameAddress) {
                                        request.fields[
                                                "influencer_Permanent_address1"] =
                                            Perloc1Val.toString();
                                        request.fields[
                                                "influencer_Permanent_address2"] =
                                            Perloc1Val.toString();
                                        request.fields[
                                                "influencer_Permanent_level_1_id"] =
                                            Perloc1Val.toString();
                                        request.fields[
                                                "influencer_Permanent_level_2_id"] =
                                            Perloc2Val.toString();
                                        request.fields[
                                                "influencer_Permanent_level_3_id"] =
                                            Perloc3Val.toString();
                                        request.fields[
                                                "influencer_Permanent_level_4_id"] =
                                            Perloc4Val.toString();
                                        request.fields[
                                                "influencer_Permanent_level_5_id"] =
                                            Perloc5Val.toString();
                                        request.fields[
                                            "influencer_Permanent_level_6_id"] = "";
                                        request.fields[
                                                "influencer_Permanent_pin"] =
                                            Perloc6Val.toString();
                                      }
                                      request.fields["influencer_email"] =
                                          emailIdCont.text;
                                      request.fields["married"] =
                                          married ? "1" : "0";
                                      request.fields["anniversary"] = married
                                          ? marrAniDateCont.text.toString()
                                          : "";
                                      request.fields["spouse_name"] =
                                          spoNameCont.text;
                                      request.fields["spouse_dob"] =
                                          spoDOBCont.text;
                                      request.fields["child_1_name"] =
                                          child1NameCont.text;
                                      request.fields["child_1_dob"] =
                                          child1DOBCont.text;
                                      request.fields["child_2_name"] =
                                          child2NameCont.text;
                                      request.fields["child_2_dob"] =
                                          child1DOBCont.text;
                                      request.fields["status"] = "0";

                                      request.files.add(http.MultipartFile(
                                          'address_proof',
                                          File(addressProof)
                                              .readAsBytes()
                                              .asStream(),
                                          File(addressProof).lengthSync(),
                                          filename: "influencer_address_proof" +
                                              p.extension(addressProof)));

                                      request.files.add(http.MultipartFile(
                                          'govt_id_proof',
                                          File(govIdProof)
                                              .readAsBytes()
                                              .asStream(),
                                          File(govIdProof).lengthSync(),
                                          filename: "influencer_govt_id_proof" +
                                              p.extension(govIdProof)));

                                      request.files.add(http.MultipartFile(
                                          'profile_picture',
                                          File(profileProof)
                                              .readAsBytes()
                                              .asStream(),
                                          File(profileProof).lengthSync(),
                                          filename:
                                              "influencer_profile_picture" +
                                                  p.extension(profileProof)));
                                      break;
                                    case "4":
                                      request.fields["member_type"] = "4";
                                      request.fields["customer_name"] =
                                          customerNameCont.text;
                                      request.fields["customer_mobile"] =
                                          customerMobileCont.text;
                                      request.fields["customer_email"] =
                                          customerEmailCont.text;
                                      break;
                                  }
                                  // print(jsonEncode(request.fields));
                                  var response = await request.send();

                                  var respStr =
                                      await response.stream.bytesToString();
                                  Navigator.of(context).pop();
                                  if (jsonDecode(respStr)['success'] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              jsonDecode(respStr)['message']
                                                  .toString()),
                                          duration: Duration(seconds: 2)),
                                    );
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                              child: Text("SUBMIT"),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                            ),
                          ),
                          SizedBox(
                            height: height,
                          ),
                        ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showErrorMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: Duration(milliseconds: 1200)),
    );
  }

  Future<void> showPhotoCaptureOptions(String selectionFor) async {
    FocusScope.of(context).unfocus();
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
                    child: Text(
                      'Select',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () async {
                            uploadImages(selectionFor, true);
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.grey)))),
                          icon: Icon(
                            Icons.camera,
                            color: Colors.black,
                          ),
                          label: Text(
                            "Camera",
                            style: TextStyle(color: Colors.black),
                          )),
                      SizedBox(
                        width: 30,
                      ),
                      ElevatedButton.icon(
                          onPressed: () async {
                            uploadImages(selectionFor, false);
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.grey)))),
                          icon: Icon(
                            Icons.photo,
                            color: Colors.black,
                          ),
                          label: Text(
                            "Gallery",
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  )
                ])));
  }

  final ImagePicker _picker = ImagePicker();

  void uploadImages(selectionFor, type) async {
    final XFile result = await _picker.pickImage(
        source: type ? ImageSource.camera : ImageSource.gallery,
        maxHeight: 900,
        maxWidth: 1000,
        imageQuality: 90);

    if (result != null) {
      switch (selectionFor) {
        case "AP":
          setState(() {
            addressProof = result.path.toString();
          });
          break;
        case "GP":
          setState(() {
            govIdProof = result.path.toString();
          });
          break;
        case "PP":
          setState(() {
            profileProof = result.path.toString();
          });
          break;
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddress(value) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Location Found"),
      ),
    );
    setState(() {
      latCont.text = value.latitude.toString();
      lonCont.text = value.longitude.toString();
      isLoading = false;
    });
  }
}
