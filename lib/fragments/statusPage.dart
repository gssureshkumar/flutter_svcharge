import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sc_charge/fragments/chargeFleetPage.dart';
import 'package:sc_charge/models/ChargerDataList.dart';
import 'package:sc_charge/models/GraphResponseData.dart';
import 'package:sc_charge/models/SingleChargerData.dart';
import 'package:sc_charge/models/SmartChargeData.dart';
import 'package:sc_charge/models/StartSmartChargerRequest.dart';
import 'package:sc_charge/models/StartSmartChargerResponse.dart';
import 'package:sc_charge/models/StationDataList.dart';
import 'package:sc_charge/models/StatusLogsData.dart';
import 'package:sc_charge/models/SuccessResponseData.dart';
import 'package:sc_charge/navigationDrawer/navigationDrawer.dart';
import 'package:sc_charge/repository/ChargerRepository.dart';
import 'package:sc_charge/widget/CustomSmartChargerAlert.dart';
import 'package:sc_charge/widget/MyConstants.dart';
import 'package:sc_charge/widget/ProgressDialog.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sc_charge/models/bar_chart_model.dart';

class statusPage extends StatefulWidget {
  static const String routeName = '/chargeFleetPage';

  @override
  _DynamicListViewScreenState createState() => _DynamicListViewScreenState();
}

class _DynamicListViewScreenState extends State<statusPage> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<SLogsData> statusLogsList = new List<SLogsData>();
  List<LogsData> statusGroupLogsList = new List<LogsData>();
  List<ChargerData> statusList = new List<ChargerData>();
  SLogsData chargerData;
  GraphResponseData graphResponseData;
  String pickerValue = 'Power';
  DateTime selectedDate = DateTime.now();
  String dropdownEndTime;
  String dropdownEndTimeValue;
  String dropdownChargingHours = "1";
  String dropdownChargingType = "Split";
  String dropdownValue;
  String licenseId;
  List<Groups> _stationGroup = [];
  List<String> chargingHoursData = [];
  SmartChargeData _smartChargeData;
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


  String minutesToTimeOfDay(int minutes) {
    Duration duration = Duration(minutes: minutes);
    var date = DateTime.fromMillisecondsSinceEpoch(duration.inMilliseconds);
    var formattedDate = DateFormat.yMMMd().add_Hm().format(date);
    return formattedDate;
  }

  String minutesToDateOfDay(int minutes) {
    Duration duration = Duration(minutes: minutes);
    var date = DateTime.fromMillisecondsSinceEpoch(duration.inMilliseconds);
    var formattedDate = DateFormat.Hm().format(date);
    return formattedDate;
  }


  void showBottomSheetMenu(SLogsData chargerData) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 250,
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
                            startCharger(chargerData.chargerId);
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
                            stopCharger(chargerData.chargerId);
                          },
                        )),
                  ],
                ), Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(40, 15, 40, 0),
                  child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      color: Color(0xff0F123F),
                      child: Text("Smart Charge",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 13)),
                      onPressed: () => {
                        fetchSmartCharger(
                            chargerData.chargerId)
                      }),
                ),

                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                        onPressed: () {
                          this.chargerData = chargerData;
                          Navigator.pop(context);
                          fetchDeviceLogs(chargerData);
                        },
                        child: Text('View More ',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  decoration: TextDecoration.underline,
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
  }

  void _modalBottomSheetMenu(SLogsData chargerData) {
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
                                startCharger(chargerData.chargerId);
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
                                stopCharger(chargerData.chargerId);
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
                    Conditional.single(
                      context: context,
                      conditionBuilder: (BuildContext context) =>
                      getLineChartData().length > 0,
                      widgetBuilder: (BuildContext context) => Container(
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
                                  child:  charts.BarChart(getLineChartData(),
                                      animate: true,
                                      primaryMeasureAxis:
                                      new charts.NumericAxisSpec(
                                          renderSpec:
                                          new charts.GridlineRendererSpec(
                                            labelStyle: new charts.TextStyleSpec(
                                                fontSize: 14, // size in Pts.
                                                color: charts.MaterialPalette.white),
                                            // Change the line colors to match text color.
                                            lineStyle: new charts.LineStyleSpec(
                                                color: charts.MaterialPalette.gray.shade800),
                                          )),
                                      domainAxis: new charts.OrdinalAxisSpec(
                                        renderSpec:
                                        new charts.SmallTickRendererSpec(
                                          labelStyle: new charts.TextStyleSpec(
                                              fontSize: 14, // size in Pts.
                                              color:
                                              charts.MaterialPalette.white),
                                          lineStyle: new charts.LineStyleSpec(
                                              color:
                                              charts.MaterialPalette.gray.shade800),
                                        ),
                                        tickProviderSpec:
                                        charts.StaticOrdinalTickProviderSpec(<
                                            charts.TickSpec<String>>[
                                          charts.TickSpec<String>("10:00"),
                                          charts.TickSpec<String>("20:00"),
                                        ]),
                                      ),
                                      behaviors: [
                                        new charts.SeriesLegend(),
                                        // new charts.SlidingViewport(),
                                        new charts.PanAndZoomBehavior(),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      fallbackBuilder: (BuildContext context) =>
                          Text('No Graph found!!!'),
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
                          padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
                          alignment: Alignment.center,
                          child: Text('No Logs found!'),
                        )),
                  ],
                ),
              ],
            ));
      },
    );
  }

  DateTime convertTimeFromHour(String strDate) {
    DateTime todayDate =
    new DateFormat("MM/dd/yyyy, hh:mm:ss a").parse(strDate);
    return todayDate;
  }


  fetchSmartCharger(String deviceid) async {
    try {
      ProgressDialogs.showLoadingDialog(context, _keyLoader);
      _smartChargeData =
      await new ChargerRepository().fetchSmartChargeData(licenseId,deviceid);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      if (_smartChargeData != null && _smartChargeData.success) {
        if (_smartChargeData.data.timeStampArray.isNotEmpty) {
          dropdownEndTime = _smartChargeData.data.timeStampArray[0].label;
          dropdownEndTimeValue = _smartChargeData.data.timeStampArray[0].value;
          var diff = convertTimeFromHour(dropdownEndTime).difference(
              convertTimeFromHour(_smartChargeData.data.startTime.label));
          int inHours = diff.inHours;
          print('diff : $inHours');
          updateChargingHours(inHours);
          _showSmartChargeModel(_smartChargeData, deviceid);
        }
      }else{
        showErrorMessage(_smartChargeData.message);
      }
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
  }

  void updateChargingHours(int maxHours) {
    chargingHoursData = [];
    for (var i = 0; i < maxHours; i++) {
      chargingHoursData.add((i + 1).toString());
    }
  }

  startSmartCharger(String deviceid) async {
    try {
      ProgressDialogs.showLoadingDialog(context, _keyLoader);
      String endTime;
      for (var i = 0; i < _smartChargeData.data.timeStampArray.length; i++) {
        if (_smartChargeData.data.timeStampArray[i].label == dropdownEndTime) {
          endTime = _smartChargeData.data.timeStampArray[i].value;
        }
      }
      StartSmartChargerRequest request = new StartSmartChargerRequest(
          startTime: _smartChargeData.data.startTime.value,
          endTime: endTime,
          chargingHours: dropdownChargingHours,
          type: dropdownChargingType.toLowerCase());
      StartSmartChargerResponse response =
      await new ChargerRepository().startSmartChargeData(request,licenseId, deviceid);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      if (response != null) {
        CustomSmartChargerAlert.showSuccessDialog(context, response.success);
      }
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
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
                                statusGroupLogsList[index].action.toLowerCase(),
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
                        new Column(children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              alignment: Alignment.center,
                              child: new Text(
                                  convertTimeFromString(
                                      statusLogsList[index].timeStamp),
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff0F123F),
                                        fontSize: 14),
                                  ))),
                          Container(
                              alignment: Alignment.center,
                              child: new Text(
                                  convertDateFromString(
                                      statusLogsList[index].timeStamp),
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff818E94),
                                        fontSize: 9),
                                  )))
                        ]),
                        Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: new Text(
                                ' - ' + statusGroupLogsList[index].action,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff818E94),
                                      fontSize: 14),
                                ))),
                      ])))
            ])));
  }

// A Separate Function called from itemBuilder
  Widget buildBody(BuildContext ctxt, int index) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Container(
            padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
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
                                statusLogsList[index].action.toLowerCase(),
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
                        new Column(children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              alignment: Alignment.center,
                              child: new Text(
                                  convertTimeFromString(
                                      statusLogsList[index].timeStamp),
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff0F123F),
                                        fontSize: 14),
                                  ))),
                          Container(
                              alignment: Alignment.center,
                              child: new Text(
                                  convertDateFromString(
                                      statusLogsList[index].timeStamp),
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff818E94),
                                        fontSize: 9),
                                  )))
                        ]),
                        new GestureDetector(
                          onTap: () {
                            chargerData = statusLogsList[index];
                            showBottomSheetMenu(statusLogsList[index]);
                          },
                          child: Container(
                              padding: EdgeInsets.all(10.0),
                              alignment: Alignment.center,
                              child: new Text(statusLogsList[index].name,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff0F123F),
                                        fontSize: 12),
                                  ))),
                        ),
                        Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child:
                            new Text(' - ' + statusLogsList[index].action,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff818E94),
                                      fontSize: 12),
                                )))
                      ])))
            ])));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100)).then((__) {
      ProgressDialogs.showLoadingDialog(context, _keyLoader); //invoking login
    });
    //
    fetchStationList();
  }



  stopCharger(String chargerId) async {
    try {
      ProgressDialogs.showLoadingDialog(context, _keyLoader); //invoking login
      SuccessResponseData response =
      await new ChargerRepository().stopCharger(chargerId);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
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

  startCharger(String chargerId) async {
    try {
      ProgressDialogs.showLoadingDialog(context, _keyLoader); //invoking login
      SuccessResponseData response =
      await new ChargerRepository().startCharger(chargerId);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
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

  fetchDeviceLogs(SLogsData chargerData) async {
    try {
      ProgressDialogs.showLoadingDialog(context, _keyLoader);
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(selectedDate);
      graphResponseData = await new ChargerRepository()
          .fetchGraphLogList(chargerData.chargerId, formatted);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      if (graphResponseData.success) {
        _modalBottomSheetMenu(chargerData);
        setState(() {
          statusGroupLogsList = graphResponseData.data.logsData;
        });
      }
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
  }

  List<charts.Series<BarChartModel, String>> getLineChartData() {
    List<BarChartModel> flSpotList = new List<BarChartModel>();
    if (pickerValue.toLowerCase().endsWith("power")) {
      if (graphResponseData.data.consumptionData.power[0].data.length > 0) {
        for (var i = 0;
        i < graphResponseData.data.consumptionData.power[0].data.length;
        i++) {
          DateTime todayDate = new DateFormat("MM/dd/yyyy, hh:mm:ss a")
              .parse(graphResponseData.data.consumptionData.power[0].data[i].x);
          double yAxis = double.parse(
              graphResponseData.data.consumptionData.power[0].data[i].y);
          flSpotList.add(BarChartModel(getXTitle(todayDate), yAxis));
        }
      } else {
        flSpotList.add(BarChartModel(getXTitle(DateTime.now()), 0));
      }
    } else if (pickerValue.toLowerCase().endsWith("soc")) {
      if (graphResponseData.data.consumptionData.soc[0].data.length > 0) {
        for (var i = 0;
        i < graphResponseData.data.consumptionData.soc[0].data.length;
        i++) {
          DateTime todayDate = new DateFormat("MM/dd/yyyy, hh:mm:ss a")
              .parse(graphResponseData.data.consumptionData.soc[0].data[i].x);
          double yAxis = double.parse(
              graphResponseData.data.consumptionData.soc[0].data[i].y);
          flSpotList.add(BarChartModel(getXTitle(todayDate), yAxis));
        }
      } else {
        flSpotList.add(BarChartModel(getXTitle(DateTime.now()), 0));
      }
    } else if (pickerValue.toLowerCase().endsWith("consumption")) {
      if (graphResponseData.data.consumptionData.consumption[0].data.length >
          0) {
        for (var i = 0;
        i <
            graphResponseData
                .data.consumptionData.consumption[0].data.length;
        i++) {
          DateTime todayDate = new DateFormat("MM/dd/yyyy, hh:mm:ss a").parse(
              graphResponseData.data.consumptionData.consumption[0].data[i].x);
          double yAxis = double.parse(
              graphResponseData.data.consumptionData.consumption[0].data[i].y);
          flSpotList.add(BarChartModel(getXTitle(todayDate), yAxis));
        }
      } else {
        flSpotList.add(BarChartModel(getXTitle(DateTime.now()), 0));
      }
    } else {
      flSpotList.add(BarChartModel(getXTitle(DateTime.now()), 0));
    }

    return [
      charts.Series(
        id: 'Charger',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BarChartModel sales, _) => sales.dateTime,
        measureFn: (BarChartModel sales, _) => sales.charger,
        data: flSpotList,
      )
    ];
  }

  String getXTitle(DateTime dateTime) {
    final String formatter = formatDate(dateTime, [HH, ':', nn]);
    return formatter;
  }
  fetchStationList() async {
    try {
      StationDataList response =
      await new ChargerRepository().fetchStationList();
      setState(() {
        if (response.success && response.data.groups.length > 0) {
          _stationGroup = response.data.groups;
          dropdownValue = response.data.groups[0].name;
          licenseId= response.data.groups[0].licenseId;
          fetchStatusLogList(response.data.groups[0].sId);
        } else {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        }
      });
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
  }

  // fetchSingleChargerData(String serialNum) async {
  //   try {
  //     SingleChargerData response =
  //         await new ChargerRepository().fetchSingleChargerData(serialNum);
  //     setState(() {
  //       showBottomSheetMenu(response);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  String convertTimeFromString(String strDate) {
    DateTime todayDate =
    new DateFormat("dd/MM/yyyy, hh:mm:ss a").parse(strDate);
    return formatDate(todayDate, [HH, ':', nn]);
  }

  String convertDateFromString(String strDate) {
    DateTime todayDate =
    new DateFormat("MM/dd/yyyy, hh:mm:ss a").parse(strDate);
    return formatDate(todayDate, [M, ', ', dd]);
  }

  fetchStatusLogList(String chargerId) async {
    try {
      StatusLogsData response =
      await new ChargerRepository().fetchStatusLogsList(chargerId);
      setState(() {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        if (response.success) {
          statusLogsList = response.data;
        }
      });
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0F123F),
          actions: <Widget>[
            new GestureDetector(
                onTap: () {
                  MyConstants.navPosition = 1;
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new chargeFleetPage()));
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: SvgPicture.asset('assets/small_app_icon.svg',
                        height: 30, width: 30, color: Colors.white)))
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
                            if (_stationGroup.length > 1)
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
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
                                      ProgressDialogs.showLoadingDialog(
                                          context, _keyLoader);
                                      for (var i = 0;
                                      i < _stationGroup.length;
                                      i++) {
                                        if (_stationGroup[i].name == newValue) {
                                          licenseId = _stationGroup[i].licenseId;
                                          fetchStatusLogList(_stationGroup[i].sId);
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
                                                  padding:
                                                  EdgeInsets.only(left: 8.0),
                                                  child: Text(value.name,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w400,
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
                            SvgPicture.asset('assets/log_icon.svg'),
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
                      child: Conditional.single(
                          context: context,
                          conditionBuilder: (BuildContext context) =>
                          statusLogsList.length > 0,
                          widgetBuilder: (BuildContext context) => Container(
                            height:
                            MediaQuery.of(context).size.height * 0.65,
                            padding: EdgeInsets.all(15.0),
                            child: new ListView.builder(
                                itemCount: statusLogsList.length,
                                itemBuilder:
                                    (BuildContext ctxt, int index) =>
                                    buildBody(ctxt, index)),
                          ),
                          fallbackBuilder: (BuildContext context) => Container(
                            padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
                            alignment: Alignment.center,
                            child: Text('No Logs found!'),
                          )),
                    ),
                  ])),
        ));
  }
  void _showSmartChargeModel(SmartChargeData smartChargeData, String deviceid) {
    print(pickerValue);
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context) .size.width * 0.75,
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(30,10,10,10),
                              child: Text('Smart Charge Schedule',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 16),
                                  ))),
                          Container(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.close),
                              )),
                        ],
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text('Start Time',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xff818E94),
                                    fontSize: 12),
                              ))),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffE0E0E0),
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child:
                                SvgPicture.asset('assets/clock_icon.svg')),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child:
                                Text(smartChargeData.data.startTime.label,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xff000000),
                                          fontSize: 13),
                                    ))),
                          ],
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text('End Time',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xff818E94),
                                    fontSize: 12),
                              ))),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffE0E0E0),
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child:
                                SvgPicture.asset('assets/clock_icon.svg')),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: DropdownButton<String>(
                                  value: dropdownEndTime,
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
                                      dropdownEndTime = newValue;
                                    });
                                    var diff =
                                    convertTimeFromHour(dropdownEndTime)
                                        .difference(convertTimeFromHour(
                                        smartChargeData
                                            .data.startTime.label));
                                    int inHours = diff.inHours;
                                    print('diff : $inHours');
                                    updateChargingHours(inHours);
                                    Navigator.pop(context);
                                    _showSmartChargeModel(
                                        smartChargeData, deviceid);
                                  },
                                  items: smartChargeData.data.timeStampArray
                                      .map<DropdownMenuItem<String>>(
                                          (TimeStampArray value) {
                                        return DropdownMenuItem<String>(
                                          value: value.label,
                                          child: new SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.6,
                                              child: Container(
                                                padding: EdgeInsets.only(left: 8.0),
                                                child: Text(value.label,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w400,
                                                        color: Colors.black,
                                                        fontSize: 13)),
                                              )),
                                        );
                                      }).toList(),
                                )),
                          ],
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text('Charging Hours',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xff818E94),
                                    fontSize: 12),
                              ))),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffE0E0E0),
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
                                child: SvgPicture.asset(
                                    'assets/battery_icon.svg')),
                            DropdownButton<String>(
                              value: dropdownChargingHours,
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
                                  dropdownChargingHours = newValue;
                                });
                                Navigator.pop(context);
                                _showSmartChargeModel(
                                    smartChargeData, deviceid);
                              },
                              items: chargingHoursData
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: new SizedBox(
                                          width: MediaQuery.of(context).size.width *
                                              0.6,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 10.0),
                                            child: Text(value,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontSize: 13)),
                                          )),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text('Charge Type',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xff818E94),
                                    fontSize: 12),
                              ))),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffE0E0E0),
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        child: DropdownButton<String>(
                          value: dropdownChargingType,
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
                              dropdownChargingType = newValue;
                            });
                            Navigator.pop(context);
                            _showSmartChargeModel(smartChargeData, deviceid);
                          },
                          items: <String>[
                            'Split',
                            'Consecutive',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.75,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 30.0),
                                    child: Text(value,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 13)),
                                  )),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            color: Color(0xff0F123F),
                            child: Text("Schedule",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 13)),
                            onPressed: () => {
                              Navigator.pop(context),
                              startSmartCharger(deviceid)
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }

  showErrorMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}
