import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/dashboard.dart';

class OtpScreen extends StatefulWidget {
  String phone;
  String otp;
  String type;
  OtpScreen({this.phone, this.otp, this.type});

  @override
  _OtpScreenState createState() => _OtpScreenState(phone, otp, type);
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String userotp;

  String phone;
  String otp;
  String type;
  _OtpScreenState(this.phone, this.otp, this.type);

  bool _loading = false;

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  String fcmToken = "";
  OTPTextEditController controller;
  OTPInteractor _otpInteractor;

  TextEditingController otpControll = TextEditingController();

  void listenSMS() async {
    _otpInteractor = OTPInteractor();
    _otpInteractor.getAppSignature().then((value) => print('signature - $value'));
    controller = OTPTextEditController(
      codeLength: 4,
      autoStop: true,
      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          print(code);
          String OTP = code.replaceAll(new RegExp(r'[^0-9]'), '');
          print(OTP.toString());
          setState(() {
            otpControll.text = "";
            userotp = "";
            otpControll.text = OTP.toString();
            userotp = OTP.toString();
          });
          clickSubmit();
          final exp = RegExp(r'(\d{4})');
          return exp.stringMatch(code ?? '') ?? '';
        },
      );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        fcmToken = value.toString();
        print(fcmToken);
      });
    });
    initConnectivity();
    listenSMS();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on Exception catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() {
          _connectionStatus = result.toString();
        });
        if (_connectionStatus.toString() ==
            ConnectivityResult.none.toString()) {
          _scaffoldKey.currentState.showSnackBar(const SnackBar(
              content: Text("Please check your internet connection.",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red));
        }
        break;
      default:
        setState(() {
          _connectionStatus = 'Failed to get connectivity.';
        });
        break;
    }
  }

  Future _verifyotp(String mobile, String otp, String membertype) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _loading = true;
    });
    print(jsonEncode({
      "mobile_no" : mobile,
      "otp" : otp,
      "type" : membertype
    }));
    var res = await http.post(Uri.parse(BASE_URL + 'login'),
      body: {
        "mobile_no": mobile,
        "otp" : otp,
        "type" : membertype
      },
    );
    setState((){
      _loading = false;
    });
    if(jsonDecode(res.body)['message'] == "An OTP verify success"){
      prefs.setString('token', jsonDecode(res.body)['success']['token'].toString());
      prefs.setString('isLoggedIn', "true");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonDecode(res.body)['message'].toString(), style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green));
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Dashboard()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed!", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
        title: const Text("Verification",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 21,
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
                            padding: EdgeInsets.only(left: 15.0, top: 5.0, right: 15.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("We sent you an sms code",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, top: 5.0, right: 25.0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      const Text("On number:", style: TextStyle(color: Colors.black, fontSize: 12)),
                                      const SizedBox(width: 5.0),
                                      Text("+91 $phone", style: const TextStyle(color: Colors.indigo, fontSize: 12))
                                    ],
                                  ))),
                          Padding(padding: const EdgeInsets.only(
                                  left: 60.0,
                                  top: 80.0,
                                  right: 60.0,
                                  bottom: 10.0),
                              child: PinCodeTextField(
                                appContext: context,
                                length: 4,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 50,
                                ),
                                cursorColor: Colors.black,
                                animationDuration: const Duration(milliseconds: 300),
                                controller: otpControll,
                                keyboardType: TextInputType.number,
                                boxShadows: const [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.white,
                                    blurRadius: 10,
                                  )
                                ],
                                onCompleted: (v) {
                                  setState((){
                                    userotp = v.toString();
                                  });
                                },
                                onChanged: (value) {
                                   setState((){
                                      userotp = value.toString();
                                   });
                                },
                              )
                              ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 60.0,
                                top: 20.0,
                                right: 60.0,
                                bottom: 10.0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: size.width * 0.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(29),
                                child: newElevatedButton(),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                userotp = "";
                                otpControll.text = "";
                              });
                              if (type == "login") {
                                _sendloginotp(phone);
                              } else {
                                _sendregisterotp(phone);
                              }
                            },
                            child: const Padding(
                                padding:
                                    EdgeInsets.only(top: 20.0, bottom: 10.0),
                                child: Text("Re-Send OTP.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.indigo, fontSize: 12))),
                          )
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

  void clickSubmit() async {
    if (_connectionStatus.toString() == ConnectivityResult.none.toString()) {
      _scaffoldKey.currentState.showSnackBar(const SnackBar(
          content: Text("Please check your internet connection.",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red));
    } else {
      _verifyotp(phone, userotp, type);
    }
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text(
        "Submit",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        clickSubmit();
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Future _sendloginotp(String phone) async {
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
        listenSMS();
      }
    } else {
      setState(() {
        _loading = false;
      });
      showToast('Sorry! Error occured');
    }
  }

  Future _sendregisterotp(String phone) async {
    var res = await http.post(
      Uri.parse(BASE_URL + sendotp),
      body: {
        "phone": phone,
      },
    );
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      if (data['ErrorCode'].toString() == "100") {
        showToast("OTP Sent");
        listenSMS();
      } else {}
    }
  }
}

class SampleStrategy extends OTPStrategy {
  @override
  Future<String> listenForCode() {
    return Future.delayed(
      const Duration(seconds: 4),
      () => 'Your code is 5432',
    );
  }
}
