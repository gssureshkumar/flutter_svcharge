import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/fragments/busesPage.dart';
import 'package:flutter_app/fragments/chagersPage.dart';
import 'package:flutter_app/fragments/chargeFleetPage.dart';
import 'package:flutter_app/fragments/optimizedPage.dart';
import 'package:flutter_app/fragments/statusPage.dart';
import 'package:flutter_app/widget/createDrawerBodyCornerItem.dart';
import 'package:flutter_app/widget/createDrawerBodyDownItem.dart';
import 'package:flutter_app/widget/createDrawerBodyNoItem.dart';
import 'package:flutter_app/widget/createDrawerBodyUpItem.dart';
import 'package:flutter_app/widget/createDrawerHeader.dart';
import 'package:flutter_app/widget/createDrawerBodyItem.dart';
import 'package:flutter_app/routes/pageRoute.dart';
import 'package:flutter_svg/flutter_svg.dart';

class navigationDrawer extends StatelessWidget {
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
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: SvgPicture.asset('assets/logo_nav_icon.svg',
                                alignment: Alignment.center,
                                color: Colors.white)),
                        createDrawerBodyCornerItem(
                            icon: 'assets/charger_fleet.png',
                            text: 'Charge Fleet Management'),
                        createDrawerBodyNoItem(
                            icon: 'assets/charger.png',
                            text: 'Chargers',
                            onTap: () => Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new chargeFleetPage()))),

                        createDrawerBodyItem(
                            icon: 'assets/status.png',
                            text: 'Status',
                            onTap: () => Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new statusPage()))),

                        createDrawerBodyItem(
                            icon: 'assets/buses.png',
                            text: 'Buses',
                            onTap: () => Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new busesPage()))),
                        createDrawerBodyUpItem(
                            icon: 'assets/optimized.png',
                            text: 'Optimized',
                            onTap: () => Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        new optimizedPage()))),
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
              )),
        ]));
  }
}
