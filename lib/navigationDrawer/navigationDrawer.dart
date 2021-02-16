import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/fragments/busesPage.dart';
import 'package:flutter_app/fragments/chargeFleetPage.dart';
import 'package:flutter_app/fragments/optimizedPage.dart';
import 'package:flutter_app/fragments/statusPage.dart';
import 'package:flutter_app/login_screen.dart';
import 'package:flutter_app/widget/MyConstants.dart';
import 'package:flutter_app/widget/createDrawerBodyCornerItem.dart';
import 'package:flutter_app/widget/createDrawerBusesItem.dart';
import 'package:flutter_app/widget/createDrawerChargerItem.dart';
import 'package:flutter_app/widget/createDrawerOptimizedItem.dart';
import 'package:flutter_app/widget/createDrawerHeader.dart';
import 'package:flutter_app/widget/createDrawerStatusItem.dart';
import 'package:flutter_app/routes/pageRoute.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class navigationDrawer extends StatelessWidget {
  bool isNavSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 1.5,
        child: new Column(children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  color: Color(0xff0F123F),
                  child: Container(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 60, 20, 40),
                            child: SvgPicture.asset('assets/logo_nav_icon.svg',
                                alignment: Alignment.center,
                                color: Colors.white)),
                        createDrawerBodyCornerItem(
                            icon: 'assets/charger_fleet.png',
                            text: 'Charge Fleet Management'),
                        createDrawerChargerItem(
                            icon: 'assets/charger.png',
                            text: 'Chargers',
                            onTap: () => {
                                  print(MyConstants.navPosition),
                                  MyConstants.navPosition = 1,
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new chargeFleetPage()))
                                }),
                        createDrawerStatusItem(
                            icon: 'assets/status.png',
                            text: 'Status',
                            onTap: () => {
                                  print(MyConstants.navPosition),
                                  MyConstants.navPosition = 2,
                                  Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new statusPage()))
                                }),
                        createDrawerBusesItem(
                            icon: 'assets/buses.png',
                            text: 'Buses',
                            onTap: () => {
                                  print(MyConstants.navPosition),
                                  MyConstants.navPosition = 3,
                                  Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new busesPage()))
                                }),
                        createDrawerOptimizedItem(
                            icon: 'assets/optimized.png',
                            text: 'Optimized',
                            onTap: () => {
                                  print(MyConstants.navPosition),
                                  MyConstants.navPosition = 4,
                                  Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new optimizedPage()))
                                }),
                      ],
                    ),
                  ))),
          Container(
              padding: EdgeInsets.all(30.0),
              color: Color(0xff0F123F),
              // This align moves the children to the bottom
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                // This container holds all the children that will be aligned
                // on the bottom and should not scroll with the above ListView
                child: new GestureDetector(
                  onTap: () => {
                    _clearInStatus(),
                    Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new LoginScreen()),
                    )
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'assets/logout.png',
                        fit: BoxFit.cover,
                        width: 20,
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("Logout",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 13)),
                      )
                    ],
                  ),
                ),
              )),
        ]));
  }

  // Sets the login status
  void _clearInStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
