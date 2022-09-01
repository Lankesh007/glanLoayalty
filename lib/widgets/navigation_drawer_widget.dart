import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/helper/dialog_helper.dart';
import 'package:tayal/models/profiledata.dart';
import 'package:tayal/network/api.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/favourite_products_screen.dart';
import 'package:tayal/views/profile_screen.dart';
import 'package:tayal/views/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  String name;
  String email;
  String urlImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<List<ProfileResponse>> temp = _getprofile();
    temp.then((value) {
      setState(() {
        urlImage = value[0].profileImage.toString();
        name = value[0].username.toString();
        email = value[0].email.toString();
      });
    });

    _setUserdetail(name, email);
  }

  void _setUserdetail(String name, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('email', email);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          color: appbarcolor,
          child: BackdropFilter(
            filter: new ImageFilter.blur(
                sigmaX: 0.5, sigmaY: 0.5, tileMode: TileMode.clamp),
            child: ListView(
              children: <Widget>[
                buildHeader(
                    urlImage: urlImage,
                    name: name,
                    email: email,
                    onClicked: () => Navigator.of(context).pop()),
                Container(
                  padding: padding,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      buildMenuItem(
                        text: 'Profile',
                        icon: TablerIcons.user,
                        onClicked: () => selectedItem(context, 0),
                      ),
                      Divider(color: Colors.white70),
                      buildMenuItem(
                        text: 'Home',
                        icon: TablerIcons.home,
                        onClicked: () => selectedItem(context, 1),
                      ),
                      // Divider(color: Colors.white70),
                      // buildMenuItem(
                      //   text: 'Setting',
                      //   icon: Icons.settings,
                      //   onClicked: () => selectedItem(context, 2),
                      // ),
                      // Divider(color: Colors.white70),
                      // buildMenuItem(
                      //   text: 'Favourite',
                      //   icon: Icons.favorite,
                      //   onClicked: () => selectedItem(context, 3),
                      // ),
                      // Divider(color: Colors.white70),
                      // buildMenuItem(
                      //   text: 'Message',
                      //   icon: Icons.message,
                      //   onClicked: () => selectedItem(context, 4),
                      // ),
                      Divider(color: Colors.white70),
                      buildMenuItem(
                        text: 'Privacy Policy',
                        icon: TablerIcons.message_2,
                        onClicked: () => selectedItem(context, 6),
                      ),
                      Divider(color: Colors.white70),
                      buildMenuItem(
                        text: 'Terms & Conditions',
                        icon: TablerIcons.message_2,
                        onClicked: () => selectedItem(context, 7),
                      ),
                      Divider(color: Colors.white70),
                      buildMenuItem(
                        text: 'Refund Policy',
                        icon: TablerIcons.message_2,
                        onClicked: () => selectedItem(context, 8),
                      ),
                      Divider(color: Colors.white70),
                      buildMenuItem(
                        text: 'Sign out',
                        icon: TablerIcons.logout,
                        onClicked: () => selectedItem(context, 5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildHeader(
      {String urlImage, String name, String email, VoidCallback onClicked}) {
    return Column(
      children: [
        InkWell(
          onTap: onClicked,
          child: Container(
            padding: padding.add(EdgeInsets.symmetric(vertical: 15)),
            child: const Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromRGBO(30, 60, 168, 1),
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            height: 80,
            width: 80,
            child: urlImage == "" || urlImage == null
                ? Image.asset('assets/images/logo_user.png', fit: BoxFit.fill)
                : Image.network(urlImage, fit: BoxFit.fill),
          ),
        ),
        SizedBox(height: 10.0),
        name == "" || name == null
            ? Text("")
            : Text(name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700)),
        SizedBox(height: 5.0),
        email == "" || email == null
            ? Text("")
            : Text(email, style: TextStyle(color: Colors.white, fontSize: 14))
      ],
    );
  }

  Widget buildMenuItem({
    String text,
    IconData icon,
    VoidCallback onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) async {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DashBoardScreen(),
        ));
        break;
      case 2:
        break;
      // case 3:
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => FavouriteProductScreen(),
      //   ));
      //   break;
      case 4:
        break;
      case 5:
        DialogHelper.logout(context);

        break;
      case 6:
        launchUrl(Uri.parse("https://tayalgroup.in/privacy-policy"));
        break;
      case 7:
        launchUrl(Uri.parse("https://tayalgroup.in/tnc"));
        break;
      case 8:
        launchUrl(Uri.parse("https://tayalgroup.in/refund"));
        break;
    }
  }

  Future<List<ProfileResponse>> _getprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + profile),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      print(response.body);
      Iterable list = json.decode(response.body)['Response'];
      List<ProfileResponse> _list =
          list.map((m) => ProfileResponse.fromJson(m)).toList();
      return _list;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
