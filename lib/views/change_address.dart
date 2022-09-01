import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/components/general.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/add_address.dart';
import 'package:tayal/views/cart_screen.dart';

class ChangeAddressPage extends StatefulWidget {
  @override
  _ChangeAddressPageState createState() => _ChangeAddressPageState();
}

class _ChangeAddressPageState extends State<ChangeAddressPage> {
  final _formKey = GlobalKey<FormState>();
  Future _addressList;
  int id;
  bool _loading = false;
  bool _buttonDisabled = true;

  @override
  void initState() {
    super.initState();
    _getUserAddresses();
  }

  void dispose() {
    super.dispose();
  }

  void _defaultAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _loading = true;
      });

      final body = {
        "address_id": id,
      };
      var response = await http.post(Uri.parse(BASE_URL + defaultaddress),
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
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => CartScreen()));
        } else {
          showAlertDialog(context, "Alert", errorMessage);
        }
      }
    }
  }

  _getUserAddresses() async {
    setState(() {
      _addressList = _futureAddress();
    });
  }

  Future _futureAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + addresslist),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Widget _addressBuilder() {
    return FutureBuilder(
      future: _futureAddress(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _addNewButton(),
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: RadioListTile(
                          activeColor: appbarcolor,
                          groupValue: id,
                          title: snapshot.data[index]['is_default'] == 1
                              ? Text(
                                  snapshot.data[index]['name'] + ' (Default)')
                              : Text(snapshot.data[index]['name']),
                          subtitle: Text(snapshot.data[index]['address']),
                          //subtitle: snapshot.data[index]['city'].toString() != "" || snapshot.data[index]['city'].toString() != null || snapshot.data[index]['city'].toString() != "null" ? Text(snapshot.data[index]['address'].toString() + ', ' + snapshot.data[index]['city'].toString() + ', ' + snapshot.data[index]['state'].toString() + ' , PIN Code: ' + snapshot.data[index]['pincode'].toString()) : Text(snapshot.data[index]['address']),
                          value: snapshot.data[index]['id'],
                          secondary: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.27,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddAddressPage(
                                                    addressid: snapshot
                                                        .data[index]['id']
                                                        .toString(),
                                                  )));
                                    },
                                    icon: Icon(Icons.edit_outlined,
                                        size: 20, color: Colors.grey)),
                                IconButton(
                                    onPressed: () {
                                      showdeleteaddressAlertDialog(
                                          context,
                                          snapshot.data[index]['id']
                                              .toString());
                                    },
                                    icon: Icon(Icons.delete_outline,
                                        size: 20, color: Colors.grey))
                              ],
                            ),
                          ),
                          onChanged: (val) {
                            if (snapshot.data[index]['is_servicable'] == 0) {
                              showAlertDialog(context, "Alert",
                                  "We don't provide service at this pincode.");
                            } else {
                              setState(() {
                                id = val;
                                _buttonDisabled = false;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                  _submitButton(),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _addNewButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddAddressPage(
                      addressid: null,
                    )));
      },
      child: Ink(
        color: Colors.white,
        child: const ListTile(
          leading: Icon(
            Icons.add,
            color: Colors.indigo,
          ),
          title: Text("Add New Address"),
        ),
      ),
    );
  }

  showdeleteaddressAlertDialog(BuildContext context, String addressid) {
    Widget cancelButton = FlatButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: const Text("Delete"),
      onPressed: () {
        Navigator.pop(context);
        _deleteAddress(addressid);
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Address"),
      content: const Text("Are you sure to delete this address"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future _deleteAddress(String addressid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "address_id": int.parse(addressid),
    };
    var response = await http.post(Uri.parse(BASE_URL + deleteaddress),
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
        showToast('Your address deleted successfully');
      } else {
        showAlertDialog(context, "Alert", errorMessage);
      }
    }
  }

  Widget _submitButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      child: Align(
        alignment: Alignment.center,
        child: ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          child: RaisedButton(
            onPressed: _buttonDisabled ? null : _defaultAddress,
            color: Colors.indigo,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Text(
              "SUBMIT",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Change Address'),
          backgroundColor: appbarcolor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              //Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: _addressBuilder(),
        ));
  }
}
