// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, missing_return

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/models/profiledata.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/notification_screen.dart';
import 'package:tayal/views/order_detail_screen.dart';
import 'package:tayal/views/order_list_screen.dart';
import 'package:tayal/views/payment_statement_screen.dart';
import 'package:tayal/views/wallet_statement_screen.dart';
import 'package:tayal/widgets/navigation_drawer_widget.dart';

import '../main.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;
  double wheelSize = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  List ordervalue = [
    {'label': 'week', 'selected': true},
    {'label': 'month', 'selected': false},
    {'label': 'year', 'selected': false}
  ];

  int _counter = 0;
  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title.toString(),
            notification.body.toString(),
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
                fullScreenIntent: true,
              ),
            ),
            payload: "");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp");
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
                fullScreenIntent: true,
              ),
            ),
            payload: "");
      }
    });

    Future<List<ProfileResponse>> temp = _getprofile();
    temp.then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', value[0].username.toString());
      prefs.setString('email', value[0].email.toString());
      prefs.setString('mobile', value[0].mobile.toString());
    });

    _dashBoardApi();
  }

  double height = 0;
  double width = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    wheelSize = 60;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: kBackgroundShapeColor,
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
            backgroundColor: appbarcolor,
            leading: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Image.asset(
                  "assets/images/circle.png",
                  scale: 25,
                  color: Colors.white,
                )),
            centerTitle: true,
            title: Text("My Dashboard",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 21,
                    fontWeight: FontWeight.bold)),
            actions: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NotificationScreen()));
                  },
                  child: Image.asset(
                    "assets/images/bell.png",
                    scale: 25,
                    color: Colors.white,
                  ))
            ]),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ordervalue
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              ordervalue.forEach((element) {
                                setState(() {
                                  element['selected'] = false;
                                });
                              });
                              setState(() {
                                e['selected'] = true;
                                totalOrderVal = "";
                                totalOrderVal =
                                    totalOrderValue[e['label'].toString()][
                                            'current_' +
                                                e['label'].toString() +
                                                '_value']
                                        .toString();

                                smallValue = double.parse(
                                        totalOrderValue[e['label'].toString()][
                                                'current_' +
                                                    e['label'].toString() +
                                                    '_value']
                                            .toString()) -
                                    double.parse(
                                        totalOrderValue[e['label'].toString()][
                                                'last_' +
                                                    e['label'].toString() +
                                                    '_value']
                                            .toString());
                              });
                            },
                            child: Card(
                              elevation: 4.0,
                              color: e['selected']
                                  ? Colors.indigo
                                  : Color.fromARGB(255, 156, 63, 190),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(e['label'].toString().toUpperCase(),
                                    style: TextStyle(
                                        color: e['selected']
                                            ? Colors.white
                                            : Colors.white,
                                        fontSize: 12)),
                              ),
                            ),
                          ),
                        )
                        .toList()),
              ),
              SizedBox(height: 10),
              Text("My Total orders",
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              SizedBox(height: 5),

              Text("\u20B9 500000".toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
              // Text("\u20B9 " + totalOrderVal.toString(),
              //     style: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 24)),
              SizedBox(height: 10),
              Container(
                height: 45,
                width: 120,
                child: Card(
                  elevation: 4.0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          smallValue > 0
                              ? Icon(
                                  Icons.arrow_drop_up,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.red,
                                ),
                          SizedBox(width: 4.0),
                          Text(
                              "\u20B9 1000" +
                                  double.parse(smallValue.toString())
                                      .toStringAsFixed(2),
                              style:
                                  TextStyle(color: Colors.indigo, fontSize: 10))
                        ],
                      )),
                ),
              ),
              // SizedBox(height: 10),
              // loadGaude
              //     ? Center(
              //         // child: CircularProgressIndicator(),
              //         child: Container(),
              //       )
              //     :
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: SizedBox(
                  height: 200,
                  child: SfRadialGauge(
                      // backgroundColor: Colors.orange,
                      enableLoadingAnimation: true,
                      animationDuration: 2000,

                      // title: GaugeTitle(
                      //     text: 'Speedometer',
                      //     textStyle: const TextStyle(
                      //         fontSize: 20.0,
                      //         fontWeight: FontWeight.bold)),
                      axes: <RadialAxis>[
                        RadialAxis(
                            minimum: 0,
                            maximum: 1000,
                            startAngle: 180,
                            canScaleToFit: true,
                            endAngle: 0,
                            labelsPosition: ElementsPosition.outside,
                            showLabels: false,
                            ranges: [
                              GaugeRange(
                                startValue: 0,
                                endValue: 1000,
                                // label: "0",
                                color: Colors.green,
                                startWidth: wheelSize,
                                endWidth: wheelSize,

                                gradient: const SweepGradient(colors: <Color>[
                                  Color(0xFFFF7676),
                                  Color(0xFFF54EA2)
                                ], stops: <double>[
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
                                  animationDuration: 10000,
                                  enableAnimation: true,
                                  value: 100,
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
                                  horizontalAlignment: GaugeAlignment.center,
                                  positionFactor: 0.8,
                                  verticalAlignment: GaugeAlignment.near,
                                  widget: Text(
                                    "100",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              GaugeAnnotation(
                                  angle: 0,
                                  horizontalAlignment: GaugeAlignment.center,
                                  positionFactor: 0.8,
                                  verticalAlignment: GaugeAlignment.near,
                                  widget: Text(
                                    NumberFormat.compact().format(10000000),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ])
                      ]),
                ),
              ),
              // SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 2,
                  physics: ClampingScrollPhysics(),
                  childAspectRatio: 2.4,
                  children: activities
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            if (e['page'].toString().isNotEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => e['page']));
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, left: 7),
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, top: 10, bottom: 10, right: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(e['image'],
                                        fit: BoxFit.fill),
                                    SizedBox(width: 7.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(e['label'],
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10)),
                                        Text("\u20B9 10000" + e['value'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Text("Recent Order",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderlistScreen()));
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Text("See all",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ),
                ],
              ),
              ledgerDetailsWidget(),
              ledgerDetailsWidget(),
              ledgerDetailsWidget(),
              ledgerDetailsWidget(),
              ledgerDetailsWidget(),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: recent
                      .map((e) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderDetailScreen(
                                            orderid: e['order_id'].toString(),
                                          )));
                            },
                            child: Card(
                              child: ListTile(
                                minLeadingWidth: 2,
                                leading: SvgPicture.asset(
                                    'assets/images/order.svg',
                                    fit: BoxFit.fill),
                                title: Text(e['order_id'].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("STATUS : " + e['status'].toString(),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14)),
                                    Text(
                                        DateFormat.yMMMd()
                                            .format(
                                                DateTime.tryParse(e['date']))
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14))
                                  ],
                                ),
                                trailing: Text(
                                    "\u20B9 " + e['order_value'].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ));
  }

  List activities = [
    {
      "label": "Bonus Points",
      "image": "assets/images/bonus_points.svg",
      "page": "",
      "value": ""
    },
    {
      "label": "Wallet Balance",
      "image": "assets/images/txn_points.svg",
      "page": WalletStatementScreen(),
      "value": ""
    },
    {
      "label": "Outstanding Balance",
      "image": "assets/images/outstanding_blnc.svg",
      "page": PaymentStatementScreen(),
      "value": ""
    },
    {
      "label": "Pending Order Value",
      "image": "assets/images/pending_order.svg",
      "page": OrderlistScreen(),
      "value": ""
    },
  ];
  Future<List<ProfileResponse>> _getprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    log("bearer Token---->" + mytoken);
    var response = await http.post(Uri.parse(BASE_URL + profile),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response'];
      List<ProfileResponse> _list =
          list.map((m) => ProfileResponse.fromJson(m)).toList();
      return _list;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  // String mainAmount = "";

  // String smallWeek = "";
  // String smallMonth = "";
  // String smallYear = "";
  Map totalOrderValue = {};
  String bonus = "";
  String walletbalance = "";
  String outstanding = "";
  String pending = "";
  String totalOrderVal = "";
  double smallValue = 0;
  double maxValue = 0;
  List recent = [];
  bool loadGaude = true;
  Future<void> _dashBoardApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + dashboardapi),
        headers: {'Authorization': 'Bearer $mytoken'});

    if (json.decode(response.body)['ErrorCode'] == 0) {
      Map map = jsonDecode(response.body)['Response'];
      print(map['totalordervalue']);
      setState(() {
        totalOrderValue = map['totalordervalue'];

        activities[0]['value'] = map['bonus'].toString();
        activities[1]['value'] = map['wallet_balance'].toString();
        activities[2]['value'] = map['outstanding'].toString();
        activities[3]['value'] = map['pending'].toString();

        recent.clear();
        recent.addAll(map['recent_list']);

        totalOrderVal =
            map['totalordervalue']['week']['current_week_value'].toString();

        smallValue = double.parse(map['totalordervalue']['week']
                    ['current_week_value']
                .toString()) -
            double.parse(
                map['totalordervalue']['week']['last_week_value'].toString());
        maxValue = double.parse(map['totalordervalue']['year']
                        ['current_year_value']
                    .toString()) *
                2 +
            1;

        loadGaude = false;
      });
    }
  }

  Widget ledgerDetailsWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: height * 0.21,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invoice Date : Wed, july/02/2022",
                      style: TextStyle(
                          color: appbarcolor, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Invoice No : 35443545",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Text(
                "500000 dr.",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            "Remarks :  Testing the remarks",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Divider(),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrderDetailScreen()));
            },
            child: Container(
              height: height * 0.06,
              width: width * 0.9,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: appbarcolor, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "View Details",
                style:
                    TextStyle(color: appbarcolor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: appbarcolor,
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
