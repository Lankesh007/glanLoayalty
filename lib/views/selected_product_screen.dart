import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/models/select_product_data.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/views/dashboard_screen.dart';

class SelectProductScreen extends StatefulWidget {
  const SelectProductScreen({Key key}) : super(key: key);

  @override
  _SelectProductScreenState createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen> {


  List<String> images = [
    "assets/images/product_image1.png",
    "assets/images/product_image3.png",
    "assets/images/product_image2.png",
    "assets/images/product_image3.png"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: kBackgroundShapeColor,
       body: Stack(
          children: [
             Column(
                children: [
                  SizedBox(height: 30),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SvgPicture.asset('assets/images/back.svg', fit: BoxFit.fill),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text("Based on pin code select any 2 product", style: TextStyle(color: Colors.black, fontSize: 16.0)),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Expanded(
                      //height: size.height * 0.72,
                      //padding: EdgeInsets.all(5.0),
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 80),
                          child: FutureBuilder(
                              future: _getproducts(),
                              builder: (context, snapshot){
                                List<dynamic> mylist = snapshot.data;
                                print("calling");
                                print(mylist);
                                if(!snapshot.hasData){
                                  return Center(
                                    child: Container(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(color: Colors.indigo),
                                    ),
                                  );
                                }
                                else{
                                  return GridView.builder(
                                    itemCount: mylist.length,
                                    padding: EdgeInsets.zero,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 2.0,
                                        mainAxisSpacing: 2.0
                                    ),
                                    itemBuilder: (BuildContext context, int index){
                                      if(mylist[index]['product_image'].toString() != null || mylist[index]['product_image'].toString() != ""){
                                        return Image.network(mylist[index]['product_image'].toString());
                                      }
                                      else{
                                        return SizedBox();
                                      }
                                    },
                                  );
                                }

                              }
                          ),
                      )
                  ),
                ],
             ),
            Positioned(
                left: 20,
                bottom: 10,
                right: 20,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  width: size.width * 0.9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: newElevatedButton(),
                  ),
                ),
            )
          ],
       ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: (){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashBoardScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Future _getproducts() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();

    var response = await http.post(Uri.parse(BASE_URL+product),
        headers : {'Authorization': 'Bearer $mytoken'}
    );
    if (response.statusCode == 200 )
    {
      Iterable list = json.decode(response.body)['ItemResponse']['data'];
      //print(list);
      return list;
      //var _productlist = list.map((m) => Data.fromJson(m)).toList();
      //return _productlist;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
