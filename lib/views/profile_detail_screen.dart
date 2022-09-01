// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/helper/dialog_helper.dart';
import 'package:tayal/models/profiledata.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/profile_screen.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({Key key}) : super(key: key);

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  String name,
      mobile,
      email,
      profileimage,
      panno,
      gstno,
      address,
      pancard,
      gstcertificate,
      agriculturelicense;
  bool _loading = false;
  String _profilepath = "";
  String _gstcertificatepath = "";
  String _agriculturelicensepath = "";
  String _pancardpath = "";

  TextEditingController nameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController pannoCont = TextEditingController();
  TextEditingController gstnoCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<List<ProfileResponse>> temp = _getprofile();

    temp.then((value) {
      setState(() {
        profileimage = value[0].profileImage.toString();
        name = value[0].username.toString();
        mobile = value[0].mobile.toString();
        email = value[0].email.toString();
        panno = value[0].panNo.toString();
        gstno = value[0].gstin.toString();
        address = value[0].address.toString();
        pancard = value[0].uploadPancard.toString();
        gstcertificate = value[0].uploadGstCertificate.toString();
        agriculturelicense = value[0].uploadAgricultureLicense.toString();
        nameCont.text = name;
        emailCont.text = email;
        pannoCont.text = panno;
        gstnoCont.text = gstno;
        addressCont.text = address;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
        title: Text("Profile",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 21,
                fontWeight: FontWeight.bold)),
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
                                  _showDocPicker(context, "profile");
                                },
                                child: _profilepath.toString() == "" ||
                                        _profilepath.toString() == "null"
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
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
                                        borderRadius: BorderRadius.circular(40),
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
                              SizedBox(height: 15.0),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 15.0),
                                child: name == "" || name == null
                                    ? Text("")
                                    : Text(name,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ))),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Name",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                      TextField(
                        controller: nameCont,
                        keyboardType: TextInputType.text,
                        //focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: name == "" || name == null ? "" : name,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            name = value.toString();
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Phone Number",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                      TextField(
                          controller: TextEditingController(text: mobile),
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText:
                                mobile == "" || mobile == null ? "" : mobile,
                            //suffix: Text("Edit", style: TextStyle(color: Colors.grey, fontSize: 14)),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          )),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Email",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                      TextField(
                        controller: emailCont,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: email == "" || email == null ? "" : email,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value.toString();
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Pan No.",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                      TextField(
                        controller: pannoCont,
                        decoration: InputDecoration(
                          hintText: panno == "" || panno == null ? "" : panno,
                          //suffix: Text("Change", style: TextStyle(fontSize: 14)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            panno = value.toString();
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("GST No.",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                      TextField(
                        controller: gstnoCont,
                        decoration: InputDecoration(
                          hintText: gstno == "" || gstno == null ? "" : gstno,
                          //suffix: Text("Change", style: TextStyle(fontSize: 14)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            gstno = value.toString();
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Address",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                      TextField(
                        controller: addressCont,
                        decoration: InputDecoration(
                          hintText:
                              address == "" || address == null ? "" : address,
                          //suffix: Text("Change", style: TextStyle(fontSize: 14)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            address = value.toString();
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("GST Certificate",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                DialogHelper.viewimagedialog(
                                    gstcertificate.toString(), context);
                              },
                              child: _gstcertificatepath.toString() == "" ||
                                      _gstcertificatepath.toString() == "null"
                                  ? Container(
                                      height: 45,
                                      width: 45,
                                      child: gstcertificate == "" ||
                                              gstcertificate == null
                                          ? Image.asset(
                                              'assets/images/no_image.jpg',
                                              fit: BoxFit.fill)
                                          : Image.network(gstcertificate,
                                              fit: BoxFit.fill),
                                    )
                                  : Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(
                                                  File(_gstcertificatepath)))),
                                    ),
                            ),
                            InkWell(
                              onTap: () {
                                _showDocPicker(context, "gstcertificate");
                              },
                              child: Container(
                                height: 35,
                                width: 95,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.indigo.shade300,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Text("Browse",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(height: 1, thickness: 1.2, color: Colors.white),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Pan Card",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                DialogHelper.viewimagedialog(
                                    pancard.toString(), context);
                              },
                              child: _pancardpath.toString() == "" ||
                                      _pancardpath.toString() == "null"
                                  ? Container(
                                      height: 45,
                                      width: 45,
                                      child: pancard == "" || pancard == null
                                          ? Image.asset(
                                              'assets/images/no_image.jpg',
                                              fit: BoxFit.fill)
                                          : Image.network(pancard,
                                              fit: BoxFit.fill),
                                    )
                                  : Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(
                                                  File(_pancardpath)))),
                                    ),
                            ),
                            InkWell(
                              onTap: () {
                                _showDocPicker(context, "pancard");
                              },
                              child: Container(
                                height: 35,
                                width: 95,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.indigo.shade300,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Text("Browse",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(height: 1, thickness: 1.2, color: Colors.white),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Agriculture license",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                DialogHelper.viewimagedialog(
                                    agriculturelicense.toString(), context);
                              },
                              child: _agriculturelicensepath.toString() == "" ||
                                      _agriculturelicensepath.toString() ==
                                          "null"
                                  ? Container(
                                      height: 45,
                                      width: 45,
                                      child: agriculturelicense == "" ||
                                              agriculturelicense == null
                                          ? Image.asset(
                                              'assets/images/no_image.jpg',
                                              fit: BoxFit.fill)
                                          : Image.network(agriculturelicense,
                                              fit: BoxFit.fill),
                                    )
                                  : Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(File(
                                                  _agriculturelicensepath)))),
                                    ),
                            ),
                            InkWell(
                              onTap: () {
                                _showDocPicker(context, "Agriculture");
                              },
                              child: Container(
                                height: 35,
                                width: 95,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.indigo.shade300,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Text("Browse",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(height: 1, thickness: 1.2, color: Colors.white),
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
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text("Save",
          style: TextStyle(color: Colors.white, fontSize: 18)),
      onPressed: () {
        _updateprofile();
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Future<List<ProfileResponse>> _getprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
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

  void _showDocPicker(context, doctype) {
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
                        _docimgFromGallery(doctype.toString());
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _docimgFromCamera(doctype.toString());
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _docimgFromCamera(doctype) async {
    final ImagePicker _picker = ImagePicker();
    final XFile photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (doctype.toString() == "gstcertificate") {
      setState(() {
        _gstcertificatepath = photo.path;
      });
    } else if (doctype.toString() == "Agriculture") {
      setState(() {
        _agriculturelicensepath = photo.path;
      });
    } else if (doctype.toString() == "pancard") {
      setState(() {
        _pancardpath = photo.path;
      });
    } else {
      print(photo.path);
      setState(() {
        _profilepath = photo.path;
      });
      print(_profilepath);
    }
  }

  _docimgFromGallery(doctype) async {
    final ImagePicker _picker = ImagePicker();
    XFile image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (doctype.toString() == "gstcertificate") {
      print("gst us here");
      setState(() {
        _gstcertificatepath = image.path;
      });
      print(_gstcertificatepath);
    } else if (doctype.toString() == "Agriculture") {
      setState(() {
        _agriculturelicensepath = image.path;
      });
    } else if (doctype.toString() == "pancard") {
      setState(() {
        _pancardpath = image.path;
      });
    } else {
      setState(() {
        _profilepath = image.path;
      });
    }
  }

  Future<List<ProfileResponse>> _updateprofile() async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    // print(json.encode({
    //   "name": name,
    //   "email": email,
    //   "business_name": "",
    //   "gst_no": "",
    //   "address": address,
    //   "pan_no": "",
    //   "upload_photo": "",
    //   "upload_gst_certificate": "",
    //   "upload_agriculture_license": "",
    //   "upload_pancard": ""
    // }));
    var requestMulti =
        http.MultipartRequest('POST', Uri.parse(BASE_URL + updateprofile));
    requestMulti.headers['authorization'] = 'Bearer $mytoken';
    requestMulti.fields["name"] = name;
    requestMulti.fields["address"] = address;
    requestMulti.fields["email"] = email;
    requestMulti.fields["gst_no"] = gstno;
    requestMulti.fields["pan_no"] = panno;
    //requestMulti.fields["upload_gst_certificate"] = "";
    //requestMulti.fields["upload_agriculture_license"] = "";
    //requestMulti.fields["upload_pancard"] = "";

    if (_profilepath != "") {
      requestMulti.files
          .add(await http.MultipartFile.fromPath('upload_photo', _profilepath));
    }

    if (_gstcertificatepath != "") {
      requestMulti.files.add(await http.MultipartFile.fromPath(
          'upload_gst_certificate', _gstcertificatepath));
    }
    if (_agriculturelicensepath != "") {
      requestMulti.files.add(await http.MultipartFile.fromPath(
          'upload_agriculture_license', _agriculturelicensepath));
    }
    if (_pancardpath != "") {
      requestMulti.files.add(
          await http.MultipartFile.fromPath('upload_pancard', _pancardpath));
    }

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
}
