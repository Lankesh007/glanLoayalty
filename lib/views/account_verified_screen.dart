import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/login_screen.dart';
import 'package:tayal/views/selected_product_screen.dart';

class AccountVerifiedScreen extends StatefulWidget {
  const AccountVerifiedScreen({Key key}) : super(key: key);

  @override
  _AccountVerifiedScreenState createState() => _AccountVerifiedScreenState();
}

class _AccountVerifiedScreenState extends State<AccountVerifiedScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 70),
            child: Column(
              children: [
                // const Text("Login",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         fontStyle: FontStyle.normal,
                //         fontSize: 21,
                //         fontWeight: FontWeight.bold)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                            "Thank You.\nYou have successfully registered.",
                            style: TextStyle(
                                color: Colors.black,
                                // fontStyle: Fon,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        SizedBox(height: 50),
                        Container(
                          height: 300,
                          child: Image.asset(
                              'assets/images/login_main_image.png',
                              fit: BoxFit.fill),
                        ),
                        const SizedBox(height: 20),
                        const Text("Your account is under review.",
                            style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, top: 10.0, bottom: 10.0, right: 25.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                                "We will notify you once your account reviewed.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          width: size.width * 0.9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(29),
                            child: newElevatedButton(),
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
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text(
        "Go to Login",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400)),
    );
  }
}
