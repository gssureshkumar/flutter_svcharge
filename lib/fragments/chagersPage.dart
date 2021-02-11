
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/navigationDrawer/navigationDrawer.dart';

class chargerPage extends StatelessWidget {
  static const String routeName = '/chargerPage';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(


          title: Text("Charger"),
        ),
        drawer: navigationDrawer(),

        body: Center(child: Text("This is home page")));
  }
}