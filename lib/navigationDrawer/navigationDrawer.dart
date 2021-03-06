import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:sc_charge/fragments/vehiclesPage.dart';
import 'package:sc_charge/fragments/chargeFleetPage.dart';
import 'package:sc_charge/fragments/optimizedPage.dart';
import 'package:sc_charge/fragments/statusPage.dart';
import 'package:sc_charge/login_screen.dart';
import 'package:sc_charge/models/SuccessResponseData.dart';
import 'package:sc_charge/repository/ChargerRepository.dart';
import 'package:sc_charge/widget/MyConstants.dart';
import 'package:sc_charge/widget/ProgressDialog.dart';
import 'package:sc_charge/widget/createDrawerBodyCornerItem.dart';
import 'package:sc_charge/widget/createDrawerBusesItem.dart';
import 'package:sc_charge/widget/createDrawerChargerItem.dart';
import 'package:sc_charge/widget/createDrawerOptimizedItem.dart';
import 'package:sc_charge/widget/createDrawerHeader.dart';
import 'package:sc_charge/widget/createDrawerStatusItem.dart';
import 'package:sc_charge/routes/pageRoute.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class navigationDrawer extends StatefulWidget {
  @override
  _navigationDrawerScreenState createState() => _navigationDrawerScreenState();
}

class _navigationDrawerScreenState extends State<navigationDrawer> {
  bool isNavSelected;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String chargeType;

  @override
  void initState() {
    super.initState();
    chargeType ="";
    _getChargerType();
  }

  @override
  Widget build(BuildContext context) {
    _getChargerType();
    return Drawer(
        elevation: 1.5,
        child: new Column(children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  color: Color(0xff0F123F),
                  child: Container(
                      child: Conditional.single(
                    context: context,
                    conditionBuilder: (BuildContext context) =>
                        chargeType.endsWith("Charge Fleet Management"),
                    widgetBuilder: (BuildContext context) => Container(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
                              child: SvgPicture.asset(
                                  'assets/logo_nav_icon.svg',
                                  alignment: Alignment.center,
                                  color: Colors.white)),
                          Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            child: Text('V: 1.0.7',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 10)),
                          ),
                          createDrawerBodyCornerItem(
                              icon: 'assets/charger_fleet.png',
                              text: chargeType),
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
                          createDrawerOptimizedItem(
                              icon: 'assets/buses.png',
                              text: 'Vehicles',
                              onTap: () => {

                                    MyConstants.navPosition = 3,
                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new vehiclesPage()))
                                  }),

                          // createDrawerOptimizedItem(
                          //     icon: 'assets/optimized.png',
                          //     text: 'Optimized',
                          //     onTap: () =>
                          //     {
                          //       print(MyConstants.navPosition),
                          //       MyConstants.navPosition = 4,
                          //       Navigator.pushReplacement(
                          //           context,
                          //           new MaterialPageRoute(
                          //               builder: (context) =>
                          //               new optimizedPage()))
                          //     }),
                        ],
                      ),
                    ),
                    fallbackBuilder: (BuildContext context) => Container(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
                              child: SvgPicture.asset(
                                  'assets/logo_nav_icon.svg',
                                  alignment: Alignment.center,
                                  color: Colors.white)),
                          Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            child: Text('V: 1.0.7',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 10)),
                          ),
                          createDrawerBodyCornerItem(
                              icon: 'assets/charger_fleet.png',
                              text: chargeType),
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
                        ],
                      ),
                    ),
                  )))),
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
                    ProgressDialogs.showLoadingDialog(context, _keyLoader),
                    userLogout(context),
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

  void _getChargerType() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int chargerType = pref.getInt('charger_type');
    setState(() {
      if (chargerType == 1) {
        chargeType = "EV Charging";
      } else {
        chargeType = "Charge Fleet Management";
      }
    });
  }

  userLogout(BuildContext context) async {
    try {
      //invoking login
      SuccessResponseData response = await new ChargerRepository().userLogout();
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      if (response.success) {
        _clearInStatus();
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (context) => new LoginScreen()),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
