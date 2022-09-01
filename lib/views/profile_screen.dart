import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/dashboard.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/profile_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name, mobile, email, profileimage, address;

  var focusNode = FocusNode();

  bool _loading = false;
  String _profilepath = "";

  double height = 15;

  List locList1 = [];
  List locList2 = [];
  List locList3 = [];
  List locList4 = [];
  List locList5 = [];
  List locList6 = [];

  String loc1Val;
  String loc2Val;
  String loc3Val;
  String loc4Val;
  String loc5Val;
  String loc6Val;

  String addresslabelName = "Firm";

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GlobalKey nameKey = GlobalKey();
  GlobalKey phoneKey = GlobalKey();
  GlobalKey emailKey = GlobalKey();

  String employee_id;
  String username;
  String description;
  int enabled;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getprofile().then((value){
      locLevelFirst().then((value){
        locLevelSecond(value).then((value){
          locLevelThird(value).then((value){
            locLevelFouth(value).then((value){
              locLevelFifth(value).then((value){
                locLevelSixth(value);
              });
            });
          });
        });
      });

    });

    // Future<List<ProfileResponse>> temp = _getprofile();
    // temp.then((value) {
    //   setState(() {
    //     profileimage = value[0].profileImage.toString();
    //     name = value[0].username.toString();
    //     mobile = value[0].mobile.toString();
    //     email = value[0].email.toString();
    //     address = value[0].address.toString();
    //     print(profileimage);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
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
          title: const Text("Profile", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 21, fontWeight: FontWeight.bold)),
        ),
        body: ModalProgressHUD(
          color: Colors.indigo,
          inAsyncCall: _loading,
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 25.0),
                            child: Column(
                              children: [
                                SizedBox(height: 10.0),
                                InkWell(
                                  onTap: () {
                                    _showProfilePicker(context);
                                  },
                                  child: _profilepath.toString() == "" ||
                                          _profilepath.toString() == "null"
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            child: profileimage == "" ||
                                                    profileimage == null
                                                ? Image.asset(
                                                    'assets/images/logo_user.png',
                                                    fit: BoxFit.fill)
                                                : Image.network(profileimage,
                                                    fit: BoxFit.fill),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(
                                                        File(_profilepath)))),
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 15.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
                                  child: nameController.text == "" || nameController.text == null
                                      ? const SizedBox()
                                      : Text(nameController.text, style: const TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileDetailScreen()));
                            },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.edit_outlined,
                                        color: Colors.black, size: 24),
                                    SizedBox(width: 5.0),
                                    Text("Edit Profile",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              )),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          key: nameKey,
                          onTap: () {
                            Scrollable.ensureVisible(nameKey.currentContext, alignment: 0.03, duration: Duration(milliseconds: 1300));
                          },
                          validator: (value) {
                            if (value.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          controller: nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              labelText: "Name",
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffD0D5DD))),
                              fillColor: Colors.white,
                              isDense: true,
                              filled: true),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          key: phoneKey,
                          onTap: () {
                            Scrollable.ensureVisible(
                                phoneKey.currentContext,
                                alignment: 0.03,
                                duration: Duration(milliseconds: 1300));
                          },
                          validator: (value) {
                            if (value.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          controller: phoneController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              labelText: "Phone Number",
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffD0D5DD))),
                              fillColor: Colors.white,
                              isDense: true,
                              filled: true),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          key: emailKey,
                          onTap: () {
                            Scrollable.ensureVisible(
                                emailKey.currentContext,
                                alignment: 0.03,
                                duration: Duration(milliseconds: 1300));
                          },
                          validator: (value) {
                            if (value.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          controller: emailController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              labelText: "Email",
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffD0D5DD))),
                              fillColor: Colors.white,
                              isDense: true,
                              filled: true),
                        ),
                        const SizedBox(height: 20),
                        FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  isDense: true,
                                  labelText: addresslabelName + " Country",
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(5.0))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: loc1Val,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      loc1Val = newValue.toString();
                                      locList2.clear();
                                      locList3.clear();
                                      locList4.clear();
                                      locList5.clear();
                                      locList6.clear();
                                    });
                                    //showLaoding(context);
                                    locLevelSecond(loc1Val).then((value) {
                                      setState((){
                                        loc2Val = "0";
                                      });
                                    });
                                  },
                                  items: locList1.map((value) {
                                    return DropdownMenuItem(
                                      value: value['id'].toString(),
                                      child: Text(value['level_1_name']
                                          .toString()
                                          .toUpperCase()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: height),
                        FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  isDense: true,
                                  labelText: addresslabelName + " State",
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(5.0))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: loc2Val,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    if(newValue == "0") {
                                      showToastMessage("Please select valid " + addresslabelName + " State");
                                    } else {
                                      setState(() {
                                        loc2Val = newValue.toString();
                                        locList3.clear();
                                        locList4.clear();
                                        locList5.clear();
                                        locList6.clear();
                                      });
                                      //showLaoding(context);

                                      locLevelThird(loc2Val).then((value) {
                                        setState((){
                                           loc3Val = "0";
                                        });
                                        //Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                  items: locList2.map((value) {
                                    return DropdownMenuItem(
                                      value: value['id'].toString(),
                                      child: Text(value['level_2_name'].toString().toUpperCase()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: height),
                        FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  isDense: true,
                                  labelText: addresslabelName + " District",
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(5.0))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: loc3Val,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    if(newValue == "0") {
                                      showToastMessage("Please select valid " + addresslabelName + " District");
                                    } else {
                                      setState(() {
                                        loc3Val = newValue.toString();
                                        locList4.clear();
                                        locList5.clear();
                                        locList6.clear();
                                      });
                                      //showLaoding(context);
                                      locLevelFouth(loc3Val).then((value) {
                                        setState((){
                                          loc4Val = "0";
                                        });
                                        //Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                  items: locList3.map((value) {
                                    return DropdownMenuItem(
                                      value: value['id'].toString(),
                                      child: Text(value['level_3_name']
                                          .toString()
                                          .toUpperCase()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: height),
                        FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  isDense: true,
                                  labelText: addresslabelName + " City",
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(5.0))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: loc4Val,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    if (newValue == "0") {
                                      showToastMessage("Please select valid " + addresslabelName + " District");
                                    } else {
                                      setState(() {
                                        loc4Val = newValue.toString();
                                        locList5.clear();
                                        locList6.clear();
                                      });
                                      //showLaoding(context);
                                      locLevelFifth(loc4Val).then((value) {
                                        setState((){
                                          loc5Val = "0";
                                        });
                                        //Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                  items: locList4.map((value) {
                                    return DropdownMenuItem(
                                      value: value['id'].toString(),
                                      child: Text(value['level_4_name']
                                          .toString()
                                          .toUpperCase()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: height),
                        FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  isDense: true,
                                  labelText: addresslabelName + " Area",
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(5.0))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: loc5Val,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    if(newValue == "0") {
                                      showToastMessage("Please select valid " + addresslabelName + " District");
                                    } else {
                                      setState(() {
                                        loc5Val = newValue.toString();
                                        locList6.clear();
                                      });
                                      //showLaoding(context);
                                      locLevelSixth(loc5Val).then((value) {
                                        setState((){
                                          loc6Val = "0";
                                        });
                                      });
                                    }
                                  },
                                  items: locList5.map((value) {
                                    return DropdownMenuItem(
                                      value: value['id'].toString(),
                                      child: Text(value['level_5_name']
                                          .toString()
                                          .toUpperCase()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: height),
                        FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  isDense: true,
                                  labelText: "Pincode",
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: loc6Val,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    if(newValue == "0") {
                                      showToastMessage("Please select valid " + addresslabelName + " District");
                                    } else {
                                      setState(() {
                                        loc6Val = newValue.toString();
                                      });
                                    }
                                  },
                                  items: locList6.map((value) {
                                    return DropdownMenuItem(
                                      value: value['id'].toString(),
                                      child: Text(value['level_6_name']
                                          .toString()
                                          .toUpperCase()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.of(context).pop();
      },
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text(
        "Save",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () {
        _updateUserProfile();
        // if (_profilepath.toString() == "" || _profilepath.toString() == null) {
        //   showToast("Please select your profile picture");
        // } else {
        //   _updateprofile();
        // }
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Future<void> _getprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    print(mytoken);
    var response = await http.post(Uri.parse(BASE_URL + profile),
        body: {
           "token": mytoken,
        });
     if(response.statusCode == 200) {
      setState((){
         employee_id = jsonDecode(response.body)['employee_no'].toString();
         username = jsonDecode(response.body)['username'].toString();
         nameController.text = jsonDecode(response.body)['firstname'].toString()+" "+jsonDecode(response.body)['lastname'].toString();
         phoneController.text = jsonDecode(response.body)['mobile'].toString();
         emailController.text = jsonDecode(response.body)['email'].toString();
         //address = jsonDecode(response.body)['email'].toString();

         loc2Val = jsonDecode(response.body)['level_2_id'].toString();
         loc3Val = jsonDecode(response.body)['level_3_id'].toString();
         loc4Val = jsonDecode(response.body)['level_4_id'].toString();
         loc5Val = jsonDecode(response.body)['level_5_id'].toString();
         loc6Val = jsonDecode(response.body)['level_6_id'].toString();

         description = jsonDecode(response.body)['description'].toString();
         enabled = jsonDecode(response.body)['enabled'];
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _updateprofile() async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    print(json.encode({
      "employee_no": employee_id,
      "username": username,
      "fname": nameController.text.toString().split(" ")[0].toString(),
      "lname": nameController.text.toString().split(" ")[1].toString(),
      "mobile": phoneController.text,
      "desc": "Desc",
      "firm_name": "",
      "address1": "",
      "address2": "",
      "level_1_id": "",
      "level_2_id": "",
      "level_3_id": "",
      "level_4_id": "",
      "level_5_id": "",
      "level_6_id": "",
      "pin": "",
      "sale_mobile": "",
      "Permanent_level_1_id": "",
      "Permanent_level_2_id": "",
      "Permanent_level_3_id": "",
      "Permanent_level_4_id": "",
      "Permanent_level_5_id": "",
      "Permanent_level_6_id": "",
      "Permanent_pin" : "",
      "email": "maharaja@test.com",
      "alter_phone": "",
      "latitude": "",
      "longitude": "",
      "gst": "",
      "dob": "",
      "married_status": 1,
      "marriage_anniversery_date": "",
      "spouse_name": "",
      "spouse_dob": "",
      "chiild_1_name": null,
      "chiild_1_dob": null,
      "chiild_2_name": null,
      "chiild_2_dob": null,

      "status": ""
    }));
    var requestMulti = http.MultipartRequest('POST', Uri.parse(BASE_URL + updateprofile));
    //requestMulti.headers['authorization'] = 'Bearer $mytoken';

    requestMulti.fields["employee_no"] = name;
    requestMulti.fields["username"] = address;
    requestMulti.fields["fname"] = email;
    requestMulti.fields["lname"] = "";
    requestMulti.fields["mobile"] = "";
    requestMulti.fields["desc"] = "";
    requestMulti.fields["firm_name"] = name;
    requestMulti.fields["address1"] = address;
    requestMulti.fields["address2"] = email;
    requestMulti.fields["level_1_id"] = "";
    requestMulti.fields["level_2_id"] = "";
    requestMulti.fields["level_3_id"] = "";
    requestMulti.fields["level_4_id"] = "";
    requestMulti.fields["level_5_id"] = "";
    requestMulti.fields["level_6_id"] = "";
    requestMulti.fields["pin"] = "";
    requestMulti.fields["sale_mobile"] = "";
    requestMulti.fields["Permanent_level_1_id"] = "";
    requestMulti.fields["Permanent_level_2_id"] = "";
    requestMulti.fields["Permanent_level_3_id"] = "";
    requestMulti.fields["Permanent_level_4_id"] = "";
    requestMulti.fields["Permanent_level_5_id"] = "";
    requestMulti.fields["Permanent_level_6_id"] = "";
    requestMulti.fields["Permanent_pin"] = "";
    requestMulti.fields["email"] = "";
    requestMulti.fields["alter_phone"] = "";
    requestMulti.fields["latitude"] = "";
    requestMulti.fields["longitude"] = "";
    requestMulti.fields["gst"] = "";
    requestMulti.fields["dob"] = "";
    requestMulti.fields["married_status"] = "";
    requestMulti.fields["marriage_anniversery_date"] = "";
    requestMulti.fields["spouse_name"] = "";
    requestMulti.fields["spouse_dob"] = "";
    requestMulti.fields["chiild_1_name"] = "";
    requestMulti.fields["chiild_1_dob"] = "";
    requestMulti.fields["chiild_2_name"] = "";
    requestMulti.fields["chiild_2_dob"] = "";
    requestMulti.fields["status"] = "";


    requestMulti.files.add(await http.MultipartFile.fromPath('address_proof', _profilepath));
    requestMulti.files.add(await http.MultipartFile.fromPath('govt_id_proof', ""));
    requestMulti.files.add(await http.MultipartFile.fromPath('profile_picture', ""));

    requestMulti.send().then((response) {
      response.stream.toBytes().then((value) {
        try {
          var responseString = String.fromCharCodes(value);
          var jsonData = jsonDecode(responseString);
          if (jsonData['ErrorMessage'] == "success") {
            showToast("Profile updated successfully");
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => DashBoardScreen()));
            setState(() {
              _loading = false;
            });
          } else {
            showToast("Failed");
            setState(() {
              _loading = false;
            });
          }
        } catch (e) {}
      });
    });
  }

  Future<void> _updateUserProfile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    print(jsonEncode({
      "employee_no": employee_id,
      "username": username,
      "fname": nameController.text.toString().split(" ")[0].toString(),
      "lname": nameController.text.toString().split(" ")[1].toString(),
      "mobile": phoneController.text,
      "desc": description,
      "firm_name": "",
      "address1": "",
      "address2": "",
      "level_1_id": loc1Val,
      "level_2_id": loc2Val,
      "level_3_id": loc3Val,
      "level_4_id": loc4Val,
      "level_5_id": loc5Val,
      "level_6_id": loc6Val,
      "pin": loc6Val,
      "sale_mobile": "",
      "Permanent_level_1_id": "",
      "Permanent_level_2_id": "",
      "Permanent_level_3_id": "",
      "Permanent_level_4_id": "",
      "Permanent_level_5_id": "",
      "Permanent_level_6_id": "",
      "Permanent_pin" : "",
      "email": "maharaja@test.com",
      "alter_phone": "",
      "latitude": "",
      "longitude": "",
      "gst": "",
      "dob": "",
      "married_status": 1,
      "marriage_anniversery_date": "",
      "spouse_name": "",
      "spouse_dob": "",
      "chiild_1_name": null,
      "chiild_1_dob": null,
      "chiild_2_name": null,
      "chiild_2_dob": null,

      "status": enabled
    }));
    // var res = await http.post(Uri.parse(BASE_URL + updateprofile),
    //   body: {
    //     "token" : prefs.getString('token'),
    //     "employee_no": employee_id,
    //     "username" : username,
    //     "fname": nameController.text.toString().split(" ")[0].toString(),
    //     "lname": nameController.text.toString().split(" ")[1].toString(),
    //     "mobile": phoneController.text,
    //     "desc": "description",
    //     "email": emailController.text,
    //     // "firm_name": "",
    //     // "address1": "",
    //     // "address2": "",
    //     "level_1_id": loc1Val,
    //     "level_2_id": loc2Val,
    //     "level_3_id": loc3Val,
    //     "level_4_id": loc4Val,
    //     "level_5_id": loc5Val,
    //     "level_6_id": loc6Val,
    //     // "pin": "",
    //     // "sale_mobile": "",
    //     // "Permanent_level_1_id": "",
    //     // "Permanent_level_2_id": "",
    //     // "Permanent_level_3_id": "",
    //     // "Permanent_level_4_id": "",
    //     // "Permanent_level_5_id": "",
    //     // "Permanent_level_6_id": "",
    //     // "Permanent_pin" : "",
    //     // "alter_phone": "",
    //     // "latitude": "",
    //     // "longitude": "",
    //     // "gst": "",
    //     // "dob": "",
    //     // "married_status": 1,
    //     // "marriage_anniversery_date": "",
    //     // "spouse_name": "",
    //     // "spouse_dob": "",
    //     // "chiild_1_name": null,
    //     // "chiild_1_dob": null,
    //     // "chiild_2_name": null,
    //     // "chiild_2_dob": null,
    //     "status": 1
    //   },
    // );
    // setState((){
    //   _loading = false;
    // });
    // if(jsonDecode(res.body)['success'] == true){
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(jsonDecode(res.body)['message'].toString(), style: const TextStyle(color: Colors.white)),
    //       backgroundColor: Colors.green));
    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashBoardScreen()));
    // }
    // else{
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text(jsonDecode(res.body)['message'].toString(), style: const TextStyle(color: Colors.white)),
    //     backgroundColor: Colors.red,
    //   ));
    // }
  }

  void _showProfilePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () {
                        _profileimgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _profileimgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _profileimgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _profilepath = photo.path;
    });
  }

  _profileimgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _profilepath = image.path;
    });
  }

  Future<String> locLevelFirst() async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc1),
      body: {"auth_key": auth_key},
    );
    if(jsonDecode(res.body)['success']) {
      setState(() {
        locList1.addAll(jsonDecode(res.body)['loc_first']);
        loc1Val = locList1[0]['id'].toString();
      });

    }
    return loc1Val;
  }

  Future<String> locLevelSecond(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc2),
      body: {"auth_key": auth_key, "loc_first": id.toString()},
    );
    if (jsonDecode(res.body)['success']) {
      setState(() {
        locList2.add({"id": "0", "level_2_name": "Select"});
        locList2.addAll(jsonDecode(res.body)['loc_second']);
      });
    }
    return loc2Val;
  }

  Future<String> locLevelThird(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc3),
      body: {"auth_key": auth_key, "loc_second": id.toString()},
    );
    if (jsonDecode(res.body)['success']) {
      setState(() {
        locList3.add({"id": "0", "level_3_name": "Select"});
        locList3.addAll(jsonDecode(res.body)['loc_third']);
      });
    }
    return loc3Val;
  }

  Future<String> locLevelFouth(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc4),
      body: {"auth_key": auth_key, "loc_third": id.toString()},
    );
    print(res.body);
    if (jsonDecode(res.body)['success']) {
      setState(() {
        locList4.add({"id": "0", "level_4_name": "Select"});
        locList4.addAll(jsonDecode(res.body)['loc_four']);
      });
    }
    return loc4Val;
  }

  Future<String> locLevelFifth(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc5),
      body: {"auth_key": auth_key, "loc_four": id.toString()},
    );
    print(res.body);
    if (jsonDecode(res.body)['success']) {
      setState(() {
        locList5.add({"id": "0", "level_5_name": "Select"});
        locList5.addAll(jsonDecode(res.body)['loc_five']);
      });
    }
    return loc5Val;
  }

  Future locLevelSixth(String id) async {
    var res = await http.post(
      Uri.parse(BASE_URL + loc6),
      body: {"auth_key": auth_key, "loc_five": id.toString()},
    );
    if (jsonDecode(res.body)['success']) {
      setState(() {
        locList6.add({"id": "0", "level_6_name": "Select"});
        locList6.addAll(jsonDecode(res.body)['loc_six']);
      });
    }
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER);
  }
}
