import 'package:flutter/material.dart';

class ProgressDialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        Image.asset(
                          "assets/loader_spinner.gif",
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ]),
                    )
                  ]));
        });
  }
}
