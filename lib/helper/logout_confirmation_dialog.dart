import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/views/login_screen.dart';
import 'package:tayal/views/splash_screen.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
        height: 190,
        decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 24,
            ),
            Text(
              'Are you sure?',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16, left: 16),
              child: Text(
                'Do you really want to logout from application?',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                    color: Colors.green,
                    textColor: Colors.white),
                const SizedBox(width: 8),
                RaisedButton(
                    onPressed: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.clear().then((value) {
                        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                      });
                    },
                    child: const Text('Yes'),
                    color: Colors.red,
                    textColor: Colors.white)
              ],
            )
          ],
        ),
      );
}
