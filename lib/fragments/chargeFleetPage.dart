import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/ChargerDataList.dart';
import 'package:flutter_app/models/StationDataList.dart';
import 'package:flutter_app/navigationDrawer/navigationDrawer.dart';
import 'package:flutter_app/repository/ChargerRepository.dart';
import 'package:flutter_app/widget/ProgressDialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class chargeFleetPage extends StatefulWidget {
  static const String routeName = '/chargeFleetPage';

  @override
  _DynamicListViewScreenState createState() => _DynamicListViewScreenState();
}

class _DynamicListViewScreenState extends State<chargeFleetPage> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<ChargerData> chargerDataList = new List<ChargerData>();
  List<Charger> statusList = new List<Charger>();
  String lableName;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  bool showAvg = false;
  String pickerValue = 'Station 1';
  String monthValue = 'December 1';
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _modalBottomSheetMenu(lableName);
        Navigator.pop(context);
      });
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }

  void _modalBottomSheetMenu(String label) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/charger.png",
                            fit: BoxFit.cover,
                            color: Color(0xff14AE39),
                            width: 20,
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: Text(label,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 14)),
                          )
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            height: 40,
                            width: 150,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Color(0xff14AF38))),
                              color: Color(0xff14AF38),
                              child: Text('Start',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 13)),
                              onPressed: () {},
                            )),
                        Container(
                            height: 40,
                            width: 150,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Color(0xffFF4646))),
                              color: Color(0xffFF4646),
                              child: Text('Stop',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 13)),
                              onPressed: () {},
                            )),
                      ],
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(20),
                        child: FlatButton(
                            onPressed: () {
                              _modalBottomSheetMenu(label);
                              Navigator.pop(context);
                            },
                            child: Text('Consumption',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff000000),
                                      fontSize: 15),
                                )))),
                    Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                                  value: pickerValue,
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
                                      pickerValue = newValue;
                                      print(pickerValue);
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
                            Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffF4F7FC),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                alignment: Alignment.center,
                                child: new GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 15, 30, 15),
                                        child: Text(
                                          "${selectedDate.toLocal()}"
                                              .split(' ')[0],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 13),
                                        )))),
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Stack(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 1.70,
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(18),
                                  ),
                                  color: Color(0xff232d37)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 18.0,
                                    left: 12.0,
                                    top: 24,
                                    bottom: 12),
                                child: LineChart(
                                  showAvg ? avgData() : mainData(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            height: 34,
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  showAvg = !showAvg;
                                });
                              },
                              child: Text(
                                'avg',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: showAvg
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      alignment: Alignment.center,
                      child: Text("Logs",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 15)),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      padding: EdgeInsets.all(15.0),
                      child: new ListView.builder(
                          itemCount: statusList.length,
                          itemBuilder: (BuildContext ctxt, int index) =>
                              buildStatusBody(ctxt, index)),
                    )
                  ],
                ),
              ],
            ));
      },
    );
  }

  // A Separate Function called from itemBuilder
  Widget buildStatusBody(BuildContext ctxt, int index) {
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
                            child: SvgPicture.asset('assets/bus_image.svg',
                                height: 30, width: 60)),
                        Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: new Text(statusList[index].chargerUnit,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff0F123F),
                                      fontSize: 18),
                                ))),
                        Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: new Text(statusList[index].chargerName,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff818E94),
                                      fontSize: 14),
                                ))),
                      ])))
            ])));
  }

  List<Charger> addStatusData() {
    int i = 1;

    while (i <= 100) {
      var charger = new Charger();
      charger.chargerId = "CHA $i";
      charger.chargerName = "- Bus Connected $i";
      charger.chargerIcon = "";
      charger.chargerUnit = "12:00";
      statusList.add(charger);
      i++;
    }
    return statusList;
  }

// A Separate Function called from itemBuilder
  Widget buildBody(BuildContext ctxt, int index) {
    return new Card(
        child: new InkResponse(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 200,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/charger.png",
                                  fit: BoxFit.cover,
                                  color: Color(0xff14AE39),
                                  width: 20,
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: Text(chargerDataList[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 14)),
                                )
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 40,
                                  width: 150,
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                            color: Color(0xff14AF38))),
                                    color: Color(0xff14AF38),
                                    child: Text('Start',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: 13)),
                                    onPressed: () {},
                                  )),
                              Container(
                                  height: 40,
                                  width: 150,
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                            color: Color(0xffFF4646))),
                                    color: Color(0xffFF4646),
                                    child: Text('Stop',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: 13)),
                                    onPressed: () {},
                                  )),
                            ],
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: FlatButton(
                                  onPressed: () {
                                    lableName = chargerDataList[index].name;
                                    Navigator.pop(context);
                                    _modalBottomSheetMenu(
                                        chargerDataList[index].name);
                                  },
                                  child: Text(
                                      'View More' ,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff0F123F),
                                            fontSize: 13),
                                      ))))
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: new Column(children: <Widget>[
              Expanded(
                  child: Align(
                      alignment: FractionalOffset.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(20.0),
                                alignment: Alignment.center,
                                child: SvgPicture.asset('assets/bus_image.svg',
                                    height: 50, width: 100)),
                            Container(
                                padding: EdgeInsets.all(10.0),
                                alignment: Alignment.center,
                                child: new Text(chargerDataList[index].name,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff000000),
                                          fontSize: 13),
                                    ))),
                          ])))
            ])));
  }

  @override
  void initState() {
    super.initState();
    // ProgressDialogs.showLoadingDialog(context, _keyLoader); //invoking login
    fetchStationList();
    addStatusData();
  }

  String dropdownValue;

  List<Groups> _stationGroup = [];

  fetchStationList() async {
    try {
      StationDataList response =
          await new ChargerRepository().fetchStationList();
      setState(() {
        print(response.data.groups.length);
        if (response.success && response.data.groups.length > 0) {
          _stationGroup = response.data.groups;
          dropdownValue = response.data.groups[0].name;
          ProgressDialogs.showLoadingDialog(
              context, _keyLoader);
          fetchChargerList(response.data.groups[0].sId);
        }
        print(dropdownValue);
      });
    } catch (e) {
      print(e);
    }
  }

  fetchChargerList(String chargerId) async {
    try {
      ChargerDataList response =
      await new ChargerRepository().fetchChargerList(chargerId);
      setState(() {
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
        print(response.data.length);
        if (response.success) {
          chargerDataList = response.data;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0F123F),
          actions: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: SvgPicture.asset('assets/small_app_icon.svg',
                    height: 30, width: 30, color: Colors.white))
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
                                child: new Text("Chargers",
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
                                    });
                                    ProgressDialogs.showLoadingDialog(context, _keyLoader);
                                    for (var i = 0; i < _stationGroup.length; i++) {
                                      if(_stationGroup[i].name.endsWith(newValue)){
                                        fetchChargerList(_stationGroup[i].sId);
                                      }
                                    }
                                  },
                                  items: _stationGroup
                                      .map<DropdownMenuItem<String>>(
                                          (Groups value) {
                                    return DropdownMenuItem<String>(
                                      value: value.name,
                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                              'assets/station_icon.svg',
                                              color: Color(0xff14AE39),
                                              width: 20,
                                              height: 20),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(value.name,
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
                    Expanded(
                      child: new GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: chargerDataList.length,
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
