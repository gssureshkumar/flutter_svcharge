import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sc_charge/models/ChargerDataList.dart';
import 'package:sc_charge/models/GraphResponseData.dart';
import 'package:sc_charge/models/StationDataList.dart';
import 'package:sc_charge/models/SuccessResponseData.dart';
import 'package:sc_charge/navigationDrawer/navigationDrawer.dart';
import 'package:sc_charge/repository/ChargerRepository.dart';
import 'package:sc_charge/widget/ProgressDialog.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class chargeFleetPage extends StatefulWidget {
  static const String routeName = '/chargeFleetPage';

  @override
  _DynamicListViewScreenState createState() => _DynamicListViewScreenState();
}

class _DynamicListViewScreenState extends State<chargeFleetPage> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<ChargerData> chargerDataList = new List<ChargerData>();
  List<LogsData> statusList = new List<LogsData>();
  Timer timer;
  ChargerData chargerData;
  GraphResponseData graphResponseData;
  double maxChargerValue = 10000;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  String pickerValue = 'Power';
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
        Navigator.pop(context);
        fetchDeviceLogs(chargerData);
      });
  }

  LineChartData avgData() {
    getLineChartData();
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
              fontWeight: FontWeight.w400,
              color: Color(0xff67727d),
              fontSize: 12),
          getTitles: (value) {
            switch (value.toInt()) {
              case 4:
                return "04";
              case 8:
                return "08";
              case 12:
                return "12";
              case 16:
                return "16";
              case 20:
                return "20";
            }
            return "";
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xff67727d),
              fontSize: 10),
          getTitles: (value) {
            return value.round().toString();
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 24,
      minY: 0,
      maxY: maxChargerValue,
      lineBarsData: [
        LineChartBarData(
          spots: getLineChartData(),
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

  void _modalBottomSheetMenu(ChargerData chargerData) {
    print(pickerValue);
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.8,
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
                            child: Text(chargerData.name,
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
                              onPressed: () {
                                startCharger(chargerData.serialNumber);
                              },
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
                              onPressed: () {
                                stopCharger(chargerData.serialNumber);
                              },
                            )),
                      ],
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(20),
                        child: Container(
                            alignment: Alignment.center,
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
                                    print(newValue);
                                    setState(() {
                                      pickerValue = newValue;
                                    });
                                    Navigator.pop(context);
                                    _modalBottomSheetMenu(chargerData);
                                  },
                                  items: <String>[
                                    'Power',
                                    'Consumption',
                                    'SoC',
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
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            child: SvgPicture.asset(
                                                'assets/clander_icon.svg',
                                                height: 30,
                                                width: 30)),
                                        Container(
                                            padding: EdgeInsets.fromLTRB(
                                                30, 15, 30, 15),
                                            child: Text(
                                              "${selectedDate.toLocal()}"
                                                  .split(' ')[0],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontSize: 13),
                                            )),
                                      ],
                                    ))),
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
                                  avgData(),
                                ),
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
                    Conditional.single(
                        context: context,
                        conditionBuilder: (BuildContext context) =>
                            statusList.length > 0,
                        widgetBuilder: (BuildContext context) => Container(
                              height: MediaQuery.of(context).size.height * 0.65,
                              padding: EdgeInsets.all(15.0),
                              child: new ListView.builder(
                                  itemCount: statusList.length,
                                  itemBuilder: (BuildContext ctxt, int index) =>
                                      buildStatusBody(ctxt, index)),
                            ),
                        fallbackBuilder: (BuildContext context) => Container(
                              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                              alignment: Alignment.center,
                              child: Text('No Logs found!!!'),
                            )),
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
                          padding: EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          child: ConditionalSwitch.single<String>(
                            context: context,
                            valueBuilder: (BuildContext context) =>
                                statusList[index].action.toLowerCase(),
                            caseBuilders: {
                              'connected': (BuildContext context) => Container(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                      'assets/connected_icon.svg',
                                      height: 30,
                                      width: 30)),
                              'disconnected': (BuildContext context) =>
                                  Container(
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                          'assets/disconnected.svg',
                                          height: 30,
                                          width: 30)),
                              'started charging': (BuildContext context) =>
                                  Container(
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                          'assets/start_charging.svg',
                                          height: 30,
                                          width: 30)),
                            },
                            fallbackBuilder: (BuildContext context) =>
                                Container(
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                        'assets/stop_charging.svg',
                                        height: 30,
                                        width: 30)),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: new Text(
                                convertDateFromString(
                                    statusList[index].timeStamp),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff0F123F),
                                      fontSize: 18),
                                ))),
                        Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: new Text(' - ' + statusList[index].action,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff818E94),
                                      fontSize: 14),
                                ))),
                      ])))
            ])));
  }

  String convertDateFromString(String strDate) {
    DateTime todayDate =
        new DateFormat("dd/MM/yyyy, hh:mm:ss a").parse(strDate);
    return formatDate(todayDate, [HH, ':', nn]);
  }

// A Separate Function called from itemBuilder
  Widget buildBody(BuildContext ctxt, int index) {
    return new Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: new InkResponse(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                builder: (BuildContext context) {
                  return Container(
                    height: 200,
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
                                    onPressed: () {
                                      startCharger(
                                          chargerDataList[index].serialNumber);
                                    },
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
                                    onPressed: () {
                                      stopCharger(
                                          chargerDataList[index].serialNumber);
                                    },
                                  )),
                            ],
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: FlatButton(
                                  onPressed: () {
                                    chargerData = chargerDataList[index];
                                    Navigator.pop(context);
                                    fetchDeviceLogs(chargerDataList[index]);
                                  },
                                  child: Text('View More',
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
                              padding: EdgeInsets.all(10.0),
                              alignment: Alignment.center,
                              child: ConditionalSwitch.single<String>(
                                context: context,
                                valueBuilder: (BuildContext context) =>
                                    chargerDataList[index].status.toLowerCase(),
                                caseBuilders: {
                                  'offline': (BuildContext context) =>
                                      Container(
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                              'assets/warning_icon.svg',
                                              height: 100,
                                              width: 100)),
                                  'not connected': (BuildContext context) =>
                                      Container(
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                              'assets/not_connected_icon.svg',
                                              height: 100,
                                              width: 100)),
                                  'online': (BuildContext context) => Container(
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                          'assets/tick_icon.svg',
                                          height: 100,
                                          width: 100)),
                                },
                                fallbackBuilder: (BuildContext context) =>
                                    Container(
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                            'assets/bus_image.svg',
                                            height: 50,
                                            width: 100)),
                              ),
                            ),
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
    Future.delayed(Duration(milliseconds: 100)).then((__) {
      ProgressDialogs.showLoadingDialog(context, _keyLoader); //invoking login
    });
    fetchStationList();

  }

  String dropdownValue;
  String chargerValue;

  List<Groups> _stationGroup = [];

  fetchStationList() async {
    try {
      StationDataList response =
          await new ChargerRepository().fetchStationList();
      print(response);
      setState(() {
        if (response.success && response.data.groups.length > 0) {
          _stationGroup = response.data.groups;
          dropdownValue = response.data.groups[0].name;
          chargerValue = response.data.groups[0].sId;
          fetchChargerList(response.data.groups[0].sId);
        }
      });
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
  }

  fetchChargerList(String chargerId) async {
    try {
      ChargerDataList response =
          await new ChargerRepository().fetchChargerList(chargerId);
      setState(() {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        if (response != null) {
          if (response.success) {
            chargerDataList = response.data;
            timer = Timer.periodic(Duration(seconds: 30),
                (Timer t) => backgroundChargerList(chargerValue));
          }
        }
      });
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
  }

  backgroundChargerList(String chargerId) async {
    try {
      ChargerDataList response =
          await new ChargerRepository().backgroundCall(chargerId);
      setState(() {
         if (response != null) {
          if (response.success) {
            chargerDataList = response.data;
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  startCharger(String chargerId) async {
    try {
      ProgressDialogs.showLoadingDialog(context, _keyLoader); //invoking login
      SuccessResponseData response =
          await new ChargerRepository().startCharger(chargerId);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      if (response != null) {
        backgroundChargerList(chargerValue);
        Fluttertoast.showToast(
            msg: response.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
  }

  fetchDeviceLogs(ChargerData chargerData) async {
    try {
      ProgressDialogs.showLoadingDialog(context, _keyLoader);
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(selectedDate);
      graphResponseData = await new ChargerRepository()
          .fetchGraphLogList(chargerData.serialNumber, formatted);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      if (graphResponseData != null && graphResponseData.success) {
        _modalBottomSheetMenu(chargerData);
        setState(() {
          statusList = graphResponseData.data.logsData;
        });
      }
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
  }

  List<FlSpot> getLineChartData() {
    print(pickerValue);
    List<FlSpot> flSpotList = new List<FlSpot>();
    if (pickerValue.toLowerCase().endsWith("power")) {
      if (graphResponseData.data.consumptionData.power[0].data.length > 0) {
        for (var i = 0;
            i < graphResponseData.data.consumptionData.power[0].data.length;
            i++) {
          DateTime todayDate = new DateFormat("dd/MM/yyyy, hh:mm:ss a")
              .parse(graphResponseData.data.consumptionData.power[0].data[i].x);
          final String formatted = formatDate(todayDate, [HH]);
          double yAxis = double.parse(
              graphResponseData.data.consumptionData.power[0].data[i].y);
          flSpotList.add(FlSpot(double.parse(formatted), yAxis));
          if (maxChargerValue < yAxis) {
            maxChargerValue = yAxis + 1000;
          }
        }
      } else {
        flSpotList.add(FlSpot(0.0, 0.0));
      }
    } else if (pickerValue.toLowerCase().endsWith("soc")) {
      if (graphResponseData.data.consumptionData.soc[0].data.length > 0) {
        for (var i = 0;
            i < graphResponseData.data.consumptionData.soc[0].data.length;
            i++) {
          DateTime todayDate = new DateFormat("dd/MM/yyyy, hh:mm:ss a")
              .parse(graphResponseData.data.consumptionData.soc[0].data[i].x);
          final String formatted = formatDate(todayDate, [HH]);
          double yAxis = double.parse(
              graphResponseData.data.consumptionData.soc[0].data[i].y);
          flSpotList.add(FlSpot(double.parse(formatted), yAxis));
          if (maxChargerValue < yAxis) {
            maxChargerValue = yAxis + 1000;
          }
        }
      } else {
        flSpotList.add(FlSpot(0.0, 0.0));
      }
    } else if (pickerValue.toLowerCase().endsWith("consumption")) {
      if (graphResponseData.data.consumptionData.consumption[0].data.length >
          0) {
        for (var i = 0;
            i <
                graphResponseData
                    .data.consumptionData.consumption[0].data.length;
            i++) {
          DateTime todayDate = new DateFormat("dd/MM/yyyy, hh:mm:ss a").parse(
              graphResponseData.data.consumptionData.consumption[0].data[i].x);
          final String formatted = formatDate(todayDate, [HH]);
          double yAxis = double.parse(
              graphResponseData.data.consumptionData.consumption[0].data[i].y);
          flSpotList.add(FlSpot(double.parse(formatted), yAxis));
          if (maxChargerValue < yAxis) {
            maxChargerValue = yAxis + 1000;
          }
        }
      } else {
        flSpotList.add(FlSpot(0.0, 0.0));
      }
    } else {
      flSpotList.add(FlSpot(0.0, 0.0));
    }
    return flSpotList;
  }

  String getXTitle() {
    final String formatter = formatDate(selectedDate, [MM]);
    return formatter;
  }

  stopCharger(String chargerId) async {
    try {
      ProgressDialogs.showLoadingDialog(context, _keyLoader); //invoking login
      SuccessResponseData response =
          await new ChargerRepository().stopCharger(chargerId);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      backgroundChargerList(chargerValue);
      Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0);
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ProgressDialogs.showLoadingDialog(context, _keyLoader);
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
                                    ProgressDialogs.showLoadingDialog(
                                        context, _keyLoader);
                                    for (var i = 0;
                                        i < _stationGroup.length;
                                        i++) {
                                      if (_stationGroup[i]
                                          .name
                                          .endsWith(newValue)) {
                                        chargerValue = _stationGroup[i].sId;
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
                    ),
                  ])),
        ));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
