import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sc_charge/fragments/chargeFleetPage.dart';
import 'package:sc_charge/navigationDrawer/navigationDrawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class optimizedPage extends StatelessWidget {
  static const String routeName = '/optimizedPage';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0F123F),
          actions: <Widget>[
            new GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new chargeFleetPage()));
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: SvgPicture.asset('assets/small_app_icon.svg',
                        height: 30, width: 30, color: Colors.white))),
          ],
        ),
        drawer: navigationDrawer(),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/work_in_progress.png', width: 260, height: 150),
          Center(
            child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(20),
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    child: Text('Work in Progress. We are Coming Soon!!',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 15),
                        )))),
          )
        ]));
  }
}
