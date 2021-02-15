import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/navigationDrawer/navigationDrawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class busesPage extends StatelessWidget {
  static const String routeName = '/optimizedPage';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0F123F),
          actions: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(0,0,20,0),
                child:SvgPicture.asset('assets/small_app_icon.svg', height:30, width: 30,color: Colors.white))

          ],
        ),
        drawer: navigationDrawer(),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/work_in_progress.png'),
          Center(
            child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(20),
                child: Text('Work in Progress. We are Coming Soon!!',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 15),
                    ))),
          )
        ]));
  }
}
