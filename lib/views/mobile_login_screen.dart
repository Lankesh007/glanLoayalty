import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/network/api.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/otp_screen.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({Key key}) : super(key: key);

  @override
  _MobileLoginScreenState createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {

  TextEditingController phoneController = new TextEditingController();
  String phoneNumber = "";
  int phonemaxLength = 10;

  bool _loading = false;

  void _onCountryChange(CountryCode countryCode) {
    this.phoneNumber =  countryCode.toString();
    print("New Country selected: " + countryCode.toString());
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      body: ModalProgressHUD(
        color: Colors.indigo,
        inAsyncCall: _loading,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SvgPicture.asset('assets/images/back.svg',
                          fit: BoxFit.fill),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Welcome",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16)),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0,  top: 5.0, right: 25.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Fill the form to become our guest",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(height: 60),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            child: Card(
                              elevation: 5,
                              shape:  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: size.width * 0.28,
                                    child: CountryCodePicker(
                                      onChanged: (value){

                                      },
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
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Phone Number",
                                        ),
                                        onChanged: (value) {
                                          if(value.length <= phonemaxLength){
                                             phoneNumber = value;
                                          }
                                          else{
                                            showToast("Please enter valid mobile number");
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

                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                left: size.width * 0.25,
                bottom: size.height * 0.20,
                right: size.width * 0.25,
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        if(phoneNumber.trim().toString().length > 10 || phoneNumber.trim().toString() == null || phoneNumber.trim().toString() == ""){
                          showToast("Please enter valid mobile number");
                        }
                        else{
                          _sendOtp(phoneNumber);
                        }
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.indigo,
                        ),
                        child: Icon(Icons.arrow_forward, size: 32, color: Colors.white,),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("Next",
                        style:
                        TextStyle(color: Colors.black, fontSize: 17.0))
                  ],
                )
            ),
            Positioned(
                left: size.width * 0.20,
                bottom: 15,
                right: size.width * 0.20,
                child: Text("Terms of use & Privacy Policy",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700)))
          ],
        ),
      ),
    );
  }

  Future _sendOtp(String phone) async {
    setState(() {
       _loading = true;
    });
    var res = await http.post(Uri.parse(BASE_URL + sendotp),
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
      if(data['ErrorCode'].toString() == "100"){
         showToast("OTP : ${data['Response']['otp'].toString().trim()}");
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpScreen(
                 phone : phone,
                 otp : data['Response']['otp'].toString().trim(),
             )));
      }
      else{}
    }
  }
}
