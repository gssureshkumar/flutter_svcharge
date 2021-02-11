import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/navigationDrawer/navigationDrawer.dart';
import 'package:google_fonts/google_fonts.dart';

class optimizedPage extends StatelessWidget {
  static const String routeName = '/optimizedPage';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Optimized"),
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
