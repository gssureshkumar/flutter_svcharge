import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSmartChargerAlert {
  static bool isSuccess;

  static Future<void> showSuccessDialog(
      BuildContext context, bool success) async {
    isSuccess = success;
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Container(
                      child: Conditional.single(
                        context: context,
                        conditionBuilder: (BuildContext context) => isSuccess,
                        widgetBuilder: (BuildContext context) => Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(10),
                                    child: SvgPicture.asset(
                                        'assets/success_icon.svg')),
                                Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(10),
                                    child: Text('Schedule Created Successfully',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 16),
                                        ))),
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: MaterialButton(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(15.0),
                                      ),
                                      color: Color(0xff0F123F),
                                      child: Text("Okay",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              fontSize: 13)),
                                      onPressed: () =>
                                          {Navigator.pop(context)}),
                                ),
                              ],
                            )),
                        fallbackBuilder: (BuildContext context) => Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(10),
                                    child: SvgPicture.asset(
                                        'assets/un_success_icon.svg')),
                                Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(10),
                                    child: Text('Schedule Creation Unsuccessfull ',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 16),
                                        ))),
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: MaterialButton(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(15.0),
                                      ),
                                      color: Color(0xffFF4646),
                                      child: Text("Try Again",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              fontSize: 13)),
                                      onPressed: () =>
                                          {Navigator.pop(context)}),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ]));
        });
  }
}
