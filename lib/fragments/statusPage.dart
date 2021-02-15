import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/navigationDrawer/navigationDrawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class statusPage extends StatefulWidget {
  static const String routeName = '/chargeFleetPage';

  @override
  _DynamicListViewScreenState createState() => _DynamicListViewScreenState();
}

class _DynamicListViewScreenState extends State<statusPage> {
  List<Charger> chargerList = new List<Charger>();

  List<Charger> addData() {
    int i = 1;

    while (i <= 100) {
      var charger = new Charger();
      charger.chargerId = "CHA $i";
      charger.chargerName = "- Bus Connected $i";
      charger.chargerIcon = "";
      charger.chargerUnit = "12:00";
      chargerList.add(charger);
      i++;
    }
    return chargerList;
  }

// A Separate Function called from itemBuilder
  Widget buildBody(BuildContext ctxt, int index) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: new Row(children: <Widget>[
              Expanded(
                  child: Align(
                      alignment: FractionalOffset.center,
                      child: Row(children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(20.0),
                            alignment: Alignment.center,
                            child: Image.asset('assets/bus_image.png',
                                height: 20)),
                        Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: new Text(chargerList[index].chargerUnit,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff0F123F),
                                      fontSize: 18),
                                ))),
                        Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: new Text(chargerList[index].chargerName,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff818E94),
                                      fontSize: 14),
                                ))),
                      ])))
            ])));
  }

  @override
  void initState() {
    super.initState();
    addData();
  }

  String dropdownValue = 'Station 1';

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
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                padding: EdgeInsets.all(10.0),
                                alignment: Alignment.center,
                                child: new Text("Status",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff000000),
                                          fontSize: 15),
                                    ))),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                alignment: Alignment.center,
                                child: DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff000000),
                                      fontSize: 13),
                                  underline: Container(
                                    height: 0,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                      print(dropdownValue);
                                    });
                                  },
                                  items: <String>[
                                    'Station 1',
                                    'Station 2',
                                    'Station 3',
                                    'Station 4'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/charger.png",
                                            fit: BoxFit.cover,
                                            color: Color(0xff14AE39),
                                            width: 20,
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(value,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontSize: 13)),
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                )),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/log_icon.png",
                              fit: BoxFit.cover,
                              width: 17,
                              height: 18,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text("Logs",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontSize: 15)),
                            )
                          ],
                        )),
                    Expanded(
                      child: new ListView.builder(
                          itemCount: chargerList.length,
                          itemBuilder: (BuildContext ctxt, int index) =>
                              buildBody(ctxt, index)),
                    )
                  ])),
        ));
  }
}

class Charger {
  String chargerId;
  String chargerName;
  String chargerIcon;
  String chargerUnit;
}
