import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/components/OrDivider.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tayal/views/dashboard.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/otp_screen.dart';
import 'package:tayal/views/select_catagory.dart';
import 'package:tayal/views/selected_product_screen.dart';
import 'package:tayal/views/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneNumber = "";
  int phonemaxLength = 10;

  bool _loading = false;

  String memberTypeVal = "Select";
  String addresslabelName = "Firm";
  List memberTypeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMemberType();
  }


  Future getMemberType() async {
    setState((){
       _loading = true;
    });
    var res = await http.post(
      Uri.parse(BASE_URL + memberType),
      body: {"auth_key": auth_key},
    );
    print(res.body);
    if (jsonDecode(res.body)['success']) {
      setState(() {
        memberTypeList.add({"id": "0", "member_type": "Select"});
        memberTypeList.add({"id": "100", "member_type": "Employee"});

        memberTypeList.addAll(jsonDecode(res.body)['membertype']);
        memberTypeVal = memberTypeList[0]['member_type'].toString();
      });
    }
    setState((){
      _loading = false;
    });
  }

  Future _login(String mobile, String membertype) async {
    setState((){
       _loading = true;
    });
    print(jsonEncode({
      "mobile_no": mobile,
      "type" : membertype
    }));
    var res = await http.post(Uri.parse(BASE_URL + 'login'),
      body: {
        "mobile_no": mobile,
        "type" : membertype
      },
    );
    print(res.body);
    setState((){
      _loading = false;
    });
    if(jsonDecode(res.body)['success'] == false){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           content: Text(jsonDecode(res.body)['message'].toString(), style: const TextStyle(color: Colors.white)),
           backgroundColor: Colors.red,
         ),
       );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(jsonDecode(res.body)['message'].toString(), style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
       ),
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpScreen(phone: mobile, otp: jsonDecode(res.body)['OTP'].toString(), type: membertype)));
      showToast(jsonDecode(res.body)['OTP'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbarcolor,
        centerTitle: true,
        title: const Text("Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.normal,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
      body: ModalProgressHUD(
        color: Colors.indigo,
        inAsyncCall: _loading,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Welcome Back",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Sign in to continue",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16)),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: FormField(
                              builder:(FormFieldState state) {
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
                                        });
                                      },
                                      items: memberTypeList.map((value) {
                                        return DropdownMenuItem(
                                          value: value['member_type'].toString(),
                                          child: Text(value['member_type'].toString()),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey, width: 1,),

                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: size.width * 0.28,
                                      child: CountryCodePicker(
                                        onChanged: (value) {},
                                        initialSelection: 'IN',
                                        favorite: ['+91', 'IN'],
                                        // optional. Shows only country name and flag
                                        showCountryOnly: false,
                                        // optional. Shows only country name and flag when popup is closed.
                                        showOnlyCountryWhenClosed: false,
                                        // optional. aligns the flag and the Text left
                                        alignLeft: true,
                                        enabled: true,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: VerticalDivider(
                                        thickness: 1,
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: TextField(
                                          maxLength: 10,
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Phone Number",
                                              counterText: ""),
                                          onChanged: (value) {
                                            phoneNumber = value;
                                            if (value.length == 10) {
                                              FocusScope.of(context).unfocus();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            width: size.width * 0.9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(29),
                              child: newElevatedButton(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 25, right: 5, bottom: 10),
                            child: OrDivider(),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(29),
                                  border: Border.all(
                                      color: Colors.grey.shade400, width: 1)),
                              child: const Text("Sign up with Email", textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text("Log in",
          style: TextStyle(color: Colors.white, fontSize: 18)),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if(memberTypeVal == "Select" || memberTypeVal == "SELECT"){
          showToast("Please select member type");
          return;
        }
        else if(phoneNumber.toString().trim().length == 0 || phoneNumber.toString().trim().length != 10) {
          showToast("Enter valid mobile number");
        } else {
          _login(phoneNumber, memberTypeVal.toLowerCase());
        }
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Future _sendOtp(String phone) async {
    setState(() {
      _loading = true;
    });
    var res = await http.post(
      Uri.parse(BASE_URL + loginsendotp),
      body: {
        "phone": phone,
      },
    );
    if (res.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      var data = json.decode(res.body);
      print(data);
      if (data['ErrorCode'].toString() == "100") {
        showToast("OTP Sent");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                    phone: phone,
                    otp: data['Response']['otp'].toString().trim(),
                    type: "login")));
      } else if (data['ErrorCode'].toString() == "902") {
        showToast('Your Account is under review yet.');
      } else {
        showToast('User not exists');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignupScreen()));
      }
    } else {
      setState(() {
        _loading = false;
      });
      showToast('Sorry! Error occured');
    }
  }
}
