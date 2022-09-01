import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const kPrimaryColor = Color(0xFFfca404);
const ksecondaryColor = Color(0xFFB5BFD0);
const kCardColor = Color(0xFFfebd1b);
const kTextLightColor = Color(0xFF6A727D);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kCornerShapeColor = Color(0xff343232);
const kTextFieldColor = Color(0xFFf7f7f7);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kBackgroundShapeColor = Colors.white;
const kTextCardColor = Color(0xFFffffff);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const bottomBarColor = Colors.white;
const shadowColor = Colors.black87;

const kAnimationDuration = Duration(milliseconds: 200);

const defaultDuration = Duration(milliseconds: 250);
const appbarcolor = Color(0xFF1F4690);
const appbarcolor2 = Colors.blueAccent;
// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

String token() {
  return "wrtaw46veltitizqhbs";
}

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
}

final List monthlist = [
  {'tile': 'JAN', 'title': 'JANUARY'},
  {'tile': 'FEB', 'title': 'FEBRUARY'},
  {'tile': 'MAR', 'title': 'MARCH'},
  {'tile': 'APR', 'title': 'APRIL'},
  {'tile': 'MAY', 'title': 'MAY'},
  {'tile': 'JUN', 'title': 'JUNE'},
  {'tile': 'JUL', 'title': 'JULY'},
  {'tile': 'AUG', 'title': 'AUGUST'},
  {'tile': 'SEP', 'title': 'SEPTEMBER'},
  {'tile': 'OCT', 'title': 'OCTOBER'},
  {'tile': 'NOV', 'title': 'NOVEMBER'},
  {'tile': 'DEC', 'title': 'DECEMBER'},
];
