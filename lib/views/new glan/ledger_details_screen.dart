import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../themes/constant.dart';

class LedgerDetailsScreen extends StatefulWidget {
  const LedgerDetailsScreen({Key key}) : super(key: key);

  @override
  State<LedgerDetailsScreen> createState() => _LedgerDetailsScreenState();
}

class _LedgerDetailsScreenState extends State<LedgerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarcolor,
        title: Text(
          "Pending Orders Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
    );
  }
}
