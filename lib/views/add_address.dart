import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:tayal/components/general.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/change_address.dart';

class AddAddressPage extends StatefulWidget {
  String addressid;
  AddAddressPage({this.addressid});

  @override
  _AddAddressPageState createState() => _AddAddressPageState(addressid);
}

class _AddAddressPageState extends State<AddAddressPage> {
  String addressid;
  _AddAddressPageState(this.addressid);

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  TextEditingController addressController = TextEditingController()..text;
  final landmarkController = TextEditingController();
  final addresstypeController = TextEditingController();

  var _name;
  var _mobile;
  var _pincode;
  var _city;
  var _state;
  var _address;
  var _landmark;
  var _addresstype;
  bool _loading = false;
  Future _addressData;

  String initialaddresstype = "Home";

  @override
  void initState() {
    super.initState();
    if (addressid != null || addressid != "") {
      _getUser();
    }
  }

  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    addresstypeController.dispose();
    super.dispose();
  }

  _getUser() async {
    _addressData = _myAddressData();
  }

  Future _myAddressData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "address_id": addressid,
    };
    var response = await http.post(Uri.parse(BASE_URL + editaddress),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      var data = json.decode(response.body);
      var errorCode = data['ErrorCode'];
      var errorMessage = data['ErrorMessage'];
      if (errorCode == 0) {
        setState(() {
          _name = data['Response'][0]['name'].toString();
          _mobile = data['Response'][0]['mobile_number'].toString();
          _landmark = data['Response'][0]['landmark'].toString();
          _pincode = data['Response'][0]['pincode'].toString();
          _address = data['Response'][0]['address'].toString();
          _addresstype = data['Response'][0]['address_type'].toString();
          initialaddresstype = data['Response'][0]['address_type'].toString();
        });
      } else {
        //showAlertDialog(context, "Alert", errorMessage);
      }
    }
  }

  Widget _nameTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        initialValue: _initialValue,
        // controller: nameController,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (value) {
          nameController.text = value;
        },
        cursorColor: Colors.blue,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
        onSaved: (String value) {
          nameController.text = value;
        },
        decoration: const InputDecoration(labelText: 'Name*'),
      ),
    );
  }

  Widget _mobileTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        initialValue: _initialValue,
        // controller: mobileController,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          mobileController.text = value;
        },
        cursorColor: Colors.blue,
        maxLength: 10,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter 10 digit mobile number';
          } else if (value.length < 10) {
            return 'Please enter 10 digit mobile number';
          } else if (value.length > 10) {
            return 'Please enter 10 digit mobile number';
          }
          return null;
        },
        onSaved: (String value) {
          mobileController.text = value;
        },
        decoration: InputDecoration(labelText: 'Mobile Number*'),
      ),
    );
  }

  Widget _pincodeTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        initialValue: _initialValue,
        // controller: pincodeController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        onChanged: (value) {
          pincodeController.text = value;
        },
        cursorColor: Colors.blue,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your pincode';
          }
          return null;
        },
        onSaved: (String value) {
          pincodeController.text = value;
        },
        decoration: const InputDecoration(labelText: 'Pin Code*'),
      ),
    );
  }

  Widget _cityTextbox(_initialValue) {
    return Container(
      margin: new EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        initialValue: _initialValue,
        //controller: cityController,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Theme.of(context).accentColor,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your city';
          }
          return null;
        },
        onSaved: (String value) {
          cityController.text = value;
        },
        decoration: const InputDecoration(labelText: 'City*'),
      ),
    );
  }

  Widget _stateTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        initialValue: _initialValue,
        // controller: stateController,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Theme.of(context).accentColor,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your state';
          }
          return null;
        },
        onSaved: (String value) {
          stateController.text = value;
        },
        decoration: const InputDecoration(labelText: 'State*'),
      ),
    );
  }

  Widget _addressTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        controller: addressController,
        initialValue: _initialValue,
        textCapitalization: TextCapitalization.sentences,
        maxLines: 3,
        cursorColor: Theme.of(context).accentColor,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your address';
          }
          return null;
        },
        onSaved: (String value) {
          _address = value;
        },
        decoration: const InputDecoration(labelText: 'Address*'),
      ),
    );
  }

  Widget _addressTextbox2(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        initialValue: _initialValue,
        // controller: stateController,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (value) {
          addressController.text = value;
        },
        cursorColor: Colors.blue,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your address';
          }
          return null;
        },
        onSaved: (String value) {
          addressController.text = value;
        },
        decoration: const InputDecoration(labelText: 'Address*'),
      ),
    );
  }

  Widget _landmarkTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        initialValue: _initialValue,
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          return null;
        },
        onSaved: (String value) {
          landmarkController.text = value;
        },
        onChanged: (value) {
          landmarkController.text = value;
        },
        cursorColor: Colors.blue,
        decoration: const InputDecoration(labelText: 'Landmark (Optional)'),
      ),
    );
  }

  Widget _addresstypeTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        initialValue: _initialValue,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (value) {
          addresstypeController.text = value;
        },
        cursorColor: Colors.blue,
        validator: (value) {
          return null;
        },
        onSaved: (String value) {
          addresstypeController.text = value;
        },
        decoration: const InputDecoration(labelText: 'Address type'),
      ),
    );
  }

  Widget _updateSubmitButton(String address_id) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      child: Align(
        alignment: Alignment.center,
        child: ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          child: RaisedButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                setState(() {
                  _loading = true;
                });
                if (address_id != null || address_id != "") {
                  _updateAddress(
                      addressid,
                      nameController.text.toString(),
                      mobileController.text.toString(),
                      pincodeController.text.toString(),
                      addressController.text.toString(),
                      landmarkController.text.toString(),
                      initialaddresstype.toString()
                      //addresstypeController.text.toString()
                      );
                }
              }
            },
            color: Colors.indigo,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: const Text(
              "SUBMIT",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _addSubmitButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      child: Align(
        alignment: Alignment.center,
        child: ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          child: RaisedButton(
            onPressed: () async {
              _addAddress(
                  nameController.text.toString(),
                  mobileController.text.toString(),
                  pincodeController.text.toString(),
                  addressController.text.toString(),
                  landmarkController.text.toString(),
                  initialaddresstype.toString()
                  //addresstypeController.text.toString()
                  );
            },
            color: Colors.indigo,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: const Text(
              "SUBMIT",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gpsButton() {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: IconButton(
        icon: Icon(Icons.gps_fixed),
        //iconSize: 50,
        color: Colors.indigo,
        splashColor: Colors.white10,
        onPressed: () {
          //_getCurrentLocation();
        },
      ),
    );
  }

  Widget _editAddressBuilder() {
    return FutureBuilder(
      future: _addressData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 5),
                    _name != "" || _name != null
                        ? _nameTextbox(_name)
                        : _nameTextbox(""),
                    _mobile != "" || _mobile != null
                        ? _mobileTextbox(_mobile)
                        : _mobileTextbox(""),
                    _pincode != "" || _pincode != null
                        ? _pincodeTextbox(_pincode)
                        : _pincodeTextbox(""),
                    //_cityTextbox(""),
                    //_stateTextbox(""),
                    _address != "" || _address != null
                        ? _addressTextbox2(_address)
                        : _addressTextbox2(""),
                    _landmark == "" ||
                            _landmark == null ||
                            _landmark.toString() == "null"
                        ? _landmarkTextbox("")
                        : _landmarkTextbox(_landmark),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: DropdownButton<String>(
                        hint: Text("$initialaddresstype",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                        isExpanded: true,
                        underline: Divider(height: 2.0, color: Colors.black),
                        focusColor: Colors.lightBlue,
                        alignment: Alignment.topLeft,
                        items: <String>[
                          'Home',
                          'Office',
                          'Warehouse',
                          'Shop',
                          "Other"
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            initialaddresstype = value.toString();
                            _addresstype = value.toString();
                          });
                        },
                      ),
                    ),
                    //_addresstype != ""  || _addresstype != null ? _addresstypeTextbox(_addresstype) : SizedBox(),
                    addressid == null || addressid == ""
                        ? _addSubmitButton()
                        : _updateSubmitButton(addressid),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
        backgroundColor: appbarcolor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: _editAddressBuilder(),
      ),
    );
  }

  Future _addAddress(String name, String mobile, String pincode, String address,
      String landmark, String addresstype) async {
    if (name == null || name == "" || name.trim().length == 0) {
      showToast("Please enter your name");
      return;
    } else if (mobile == null || mobile == "" || mobile.trim().length == 0) {
      showToast("Please enter mobile number");
      return;
    } else if (pincode == null || pincode == "" || pincode.trim().length == 0) {
      showToast("Please enter your pincode");
      return;
    } else if (address == null || address == "" || address.trim().length == 0) {
      showToast("Please enter your address");
      return;
    }
    /*else if(landmark == null || landmark == "" || landmark.trim().length == 0){
      showToast("Please enter your landmark");
      return;
    }*/
    else if (addresstype == null ||
        addresstype == "" ||
        addresstype.trim().length == 0) {
      showToast("Please enter your address type");
      return;
    } else {
      setState(() {
        _loading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String mytoken = prefs.getString('token').toString();
      print(jsonEncode({
        "name": name,
        "mobile_number": int.parse(mobile),
        "pincode": int.parse(pincode),
        "address": address,
        "landmark": landmark,
        "address_type": addresstype
      }));
      final body = {
        "name": name,
        "mobile_number": int.parse(mobile),
        "pincode": int.parse(pincode),
        "address": address,
        "landmark": landmark,
        "address_type": addresstype
      };
      var response = await http.post(Uri.parse(BASE_URL + addadress),
          body: json.encode(body),
          headers: {
            'Authorization': 'Bearer $mytoken',
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          _loading = false;
        });
        var data = json.decode(response.body);
        var errorCode = data['ErrorCode'];
        var errorMessage = data['ErrorMessage'];
        if (errorCode == 0) {
          showToast(data['Response'].toString());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ChangeAddressPage()));
        } else {
          showAlertDialog(context, "Alert", errorMessage);
        }
      }
    }
  }

  Future _updateAddress(String id, String name, String mobile, String pincode,
      String address, String landmark, String addresstype) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "address_id": id,
      "name": name,
      "mobile_number": mobile,
      "pincode": pincode,
      "address": address,
      "landmark": landmark,
      "address_type": addresstype
    };
    var response = await http.post(Uri.parse(BASE_URL + updateaddress),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      var data = json.decode(response.body);
      var errorCode = data['ErrorCode'];
      var errorMessage = data['ErrorMessage'];
      if (errorCode == 0) {
        showToast('Your address updated successfully');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ChangeAddressPage()));
      } else {
        showAlertDialog(context, "Alert", errorMessage);
      }
    }
  }
}
