// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/helper/dialog_helper.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/helper/dialog_helper.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({Key key}) : super(key: key);

  @override
  _CampaignScreenState createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  bool _loading = true;
  StreamController<int> selected = StreamController<int>();
  //int selected = 0;

  String minvalue = "0.0";
  String maxvalue = "0.0";
  String annual_campaign_achive = "0.0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getcampaigndata();
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  final items = <String>[
    '3 Lac + Silver Plate',
    '5 Lac + Samsung J7',
    '11 Lac + Gold coin',
    '18 Lac + Activa 5G',
    '30 Lac + Dubai Trip',
    '40 Lac + Alto 800',
    '60 Lac + Wagonr minor',
    '75 Lac + Swift Dzire',
    '1 Cr + Maruti Ciaz'
  ];

  var colors = [
    Colors.red,
    Colors.blue,
    Colors.cyan,
    Colors.green,
    Colors.yellow,
    Colors.red,
    Colors.blue,
    Colors.cyan,
    Colors.green
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      appBar: AppBar(
        backgroundColor: appbarcolor,
        centerTitle: true,
        title: Text("Campaign",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 21,
                fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 260,
                      width: MediaQuery.of(context).size.width,
                      child: SfRadialGauge(
                          // backgroundColor: Colors.orange,
                          enableLoadingAnimation: true,
                          animationDuration: 2000,
                          title: GaugeTitle(
                              alignment: GaugeAlignment.center,
                              text: "Total Points Earned - " +
                                  NumberFormat.compact()
                                      .format(
                                          double.parse(annual_campaign_achive))
                                      .toString(),
                              textStyle: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                          axes: <RadialAxis>[
                            RadialAxis(
                                minimum: double.parse(minvalue),
                                maximum: double.parse(maxvalue),
                                startAngle: 180,
                                canScaleToFit: true,
                                endAngle: 0,
                                labelsPosition: ElementsPosition.outside,
                                showLabels: false,
                                ranges: [
                                  GaugeRange(
                                    startValue: double.parse(minvalue),
                                    endValue: double.parse(maxvalue),
                                    // label: "0",
                                    color: Colors.green,
                                    startWidth: 40,
                                    endWidth: 40,

                                    gradient: const SweepGradient(
                                        colors: <Color>[
                                          Color(0xFFFF7676),
                                          Color(0xFFF54EA2)
                                        ],
                                        stops: <double>[
                                          0.25,
                                          0.75
                                        ]),
                                  ),
                                  // GaugeRange(
                                  //     startValue: 50,
                                  //     endValue: 100,
                                  //     color: Colors.orange,
                                  //     startWidth: wheelSize,
                                  //     endWidth: wheelSize),
                                  // GaugeRange(
                                  //     startValue: 100,
                                  //     endValue: 150,
                                  //     label: "150",
                                  //     color: Colors.red,
                                  //     startWidth: wheelSize,
                                  //     endWidth: wheelSize)
                                ],
                                pointers: [
                                  // MarkerPointer(text: "yyy"),
                                  NeedlePointer(
                                      animationDuration: 1000,
                                      enableAnimation: true,
                                      value:
                                          double.parse(annual_campaign_achive),
                                      lengthUnit: GaugeSizeUnit.factor,
                                      needleLength: 0.8,
                                      needleEndWidth: 11,
                                      gradient: const LinearGradient(
                                          colors: <Color>[
                                            Colors.grey,
                                            Colors.grey,
                                            Colors.black,
                                            Colors.black
                                          ],
                                          stops: <double>[
                                            0,
                                            0.5,
                                            0.5,
                                            1
                                          ]),
                                      needleColor: const Color(0xFFF67280),
                                      knobStyle: KnobStyle(
                                          knobRadius: 0.08,
                                          sizeUnit: GaugeSizeUnit.factor,
                                          color: Colors.black)),
                                ],
                                annotations: [
                                  GaugeAnnotation(
                                      angle: 180,
                                      horizontalAlignment:
                                          GaugeAlignment.center,
                                      positionFactor: 0.9,
                                      verticalAlignment: GaugeAlignment.near,
                                      widget: Text(
                                        "0",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  GaugeAnnotation(
                                      angle: 0,
                                      horizontalAlignment:
                                          GaugeAlignment.center,
                                      positionFactor: 0.9,
                                      verticalAlignment: GaugeAlignment.near,
                                      widget: Text(
                                        NumberFormat.compact()
                                            .format(double.parse(maxvalue)),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                ])
                          ])),
                  Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/down_arrow1.png",
                          ),
                          scale: 14,
                          alignment: Alignment(0, 5),
                        )),
                    child: const Text("FOR PRIZE DETAIL CLICK BELOW AREA",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18)),
                  ),
                  // Image.asset('assets/images/down_arrow1.png',
                  //     scale: 14, color: Colors.indigo),
                  SizedBox(
                    height: 22,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected.add(
                          Fortune.randomInt(0, items.length),
                        );
                      });
                    },
                    child: Container(
                      height: size.height * 0.35,
                      child: FortuneWheel(
                        physics: CircularPanPhysics(
                          duration: Duration(seconds: 1),
                          curve: Curves.decelerate,
                        ),
                        onFling: () {
                          selected.add(1);
                        },

                        /*indicators: const <FortuneIndicator>[
                    FortuneIndicator(
                      alignment: Alignment(0, -1.5),
                      child: TriangleIndicator(
                        color: Colors.indigo,
                      ),
                    ),
                  ],*/
                        indicators: [],
                        animateFirst: false,
                        selected: selected.stream,
                        items: const [
                          FortuneItem(
                              style: FortuneItemStyle(
                                color: Colors.orange,
                                borderColor: Colors.white,
                                borderWidth: 1,
                              ),
                              child: Text('3 Lac + Silver Plate',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 8))),
                          FortuneItem(
                              style: FortuneItemStyle(
                                color: Colors.red,
                                borderColor: Colors.white,
                                borderWidth: 1,
                              ),
                              child: Text('5 Lac + Samsung J7',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 8))),
                          FortuneItem(
                              style: FortuneItemStyle(
                                color: Colors.indigo,
                                borderColor: Colors.white,
                                borderWidth: 1,
                              ),
                              child: Text('11 Lac + Gold coin',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 8))),
                          FortuneItem(
                              style: FortuneItemStyle(
                                color: Colors.orangeAccent,
                                borderColor: Colors.white,
                                borderWidth: 1,
                              ),
                              child: Text('18 Lac + Activa 5G',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 8))),
                          FortuneItem(
                              style: FortuneItemStyle(
                                color: Colors.blueAccent,
                                borderColor: Colors.white,
                                borderWidth: 1,
                              ),
                              child: Text('30 Lac + Dubai Trip',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 8))),
                          FortuneItem(
                              style: FortuneItemStyle(
                                color: Colors.green,
                                borderColor: Colors.white,
                                borderWidth: 1,
                              ),
                              child: Text('40 Lac + Alto 800',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 8))),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future _getcampaigndata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + campaign), headers: {
      'Authorization': 'Bearer $mytoken',
      'Content-Type': 'application/json'
    });
    setState(() {
      _loading = false;
    });
    if (response.statusCode == 200) {
      print(response.body);
      if (json.decode(response.body)['ErrorCode'] == 0) {
        setState(() {
          minvalue = json
              .decode(response.body)['Response']['annual_campaign_min']
              .toString();
          maxvalue = json
              .decode(response.body)['Response']['annual_campaign_max']
              .toString();
          annual_campaign_achive = json
              .decode(response.body)['Response']['annual_campaign_achive']
              .toString();
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
