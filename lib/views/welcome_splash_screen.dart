import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/login_screen.dart';

class WelcomeSplashScreen extends StatefulWidget {
  const WelcomeSplashScreen({Key key}) : super(key: key);

  @override
  _WelcomeSplashScreenState createState() => _WelcomeSplashScreenState();
}

class _WelcomeSplashScreenState extends State<WelcomeSplashScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: kBackgroundShapeColor,
       body: Center(
          child: Column(
             children: [
                SizedBox(height: size.height * 0.20),
                Container(
                   height: 150,
                   child: Image.asset('assets/images/logo_image.png'),
                ),
               SizedBox(height: size.height * 0.10),
               Padding(
                   padding: EdgeInsets.only(left: 35, right: 35),
                   child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Welcome to", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold)),
                        SizedBox(height: 0.0),
                        Text("Tayal", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold))
                      ],
                   )
               ),
               SizedBox(height: size.height * 0.15),
               Text("Click the button below to start", style: TextStyle(color: Colors.grey, fontSize: 16.0)),
               Align(
                 alignment: Alignment.center,
                 child: Container(
                   height: 50,
                   margin: EdgeInsets.all(20),
                   width: MediaQuery.of(context).size.width * 0.45,
                   child: FlatButton(
                     child: Padding(
                       padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                       child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Get Started", style: TextStyle(color: Colors.white, fontSize: 16)),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward, color: Colors.white)
                          ],
                       ),
                     ),
                     onPressed: () async{
                       SharedPreferences prefs = await SharedPreferences.getInstance();
                       prefs.setString("visited", "true");
                       Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(
                           builder: (_) => LoginScreen(),
                         ),
                       );
                     },
                     color: Colors.indigo,
                     textColor: Colors.white,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(14),
                     ),
                   ),
                 ),
               )
             ],
          ),
       ),
    );
  }
}
