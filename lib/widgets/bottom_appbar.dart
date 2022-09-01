import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayal/views/campaign_screen.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/help_screen.dart';
import 'package:tayal/views/mybiz_screen.dart';

class MyBottomAppBar extends StatefulWidget {
  const MyBottomAppBar({Key key}) : super(key: key);

  @override
  _MyBottomAppBarState createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashBoardScreen()),
                      (route) => false);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/home.svg', fit: BoxFit.fill),
                    Text("Home")
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyBizScreen()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/mybiz.svg',
                        fit: BoxFit.fill),
                    Text("My Biz")
                  ],
                ),
              ),
              SizedBox.shrink(),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CampaignScreen()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/reward.svg',
                        fit: BoxFit.fill),
                    Text("Campaign")
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HelpScreen()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/help.svg', fit: BoxFit.fill),
                    Text("Help")
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
