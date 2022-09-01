import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tayal/themes/constant.dart';

class ExitConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
    height: 250,
    decoration: const BoxDecoration(
        color: kPrimaryColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12))
    ),
    child: Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('assets/images/logo.png', height: 60, width: 60, fit: BoxFit.fitHeight),
          ),
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
          ),
        ),
        const SizedBox(height: 24),
        const Text('Are you sure?', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
        const SizedBox(height: 8,),
        const Padding(
          padding: EdgeInsets.only(right: 16, left: 16),
          child: Text('Do you really want to exit from application?', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
        ),
        const SizedBox(height: 24,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: const Text('No'),textColor: Colors.white),
            const SizedBox(width: 8),
            RaisedButton(onPressed: (){
              return exit(0);
              //return Navigator.of(context).pop(true);
            }, child: const Text('Yes'), color: Colors.white, textColor: kPrimaryColor)
          ],
        )
      ],
    ),
  );
}