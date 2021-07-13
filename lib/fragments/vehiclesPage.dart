import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:intl/intl.dart';
import 'package:sc_charge/fragments/chargeFleetPage.dart';
import 'package:sc_charge/models/VehicleDetailsResponse.dart';
import 'package:sc_charge/models/VehiclesListData.dart';
import 'package:sc_charge/navigationDrawer/navigationDrawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sc_charge/repository/ChargerRepository.dart';
import 'package:sc_charge/widget/ProgressDialog.dart';

class vehiclesPage extends StatefulWidget {
  static const String routeName = '/optimizedPage';

  @override
  _DynamicListViewScreenState createState() => _DynamicListViewScreenState();
}

class _DynamicListViewScreenState extends State<vehiclesPage> {
  List<VehiclesData> _vehiclesList = [];
  List<VehicleDetails> vehicleDetailsList = new List<VehicleDetails>();
  String vehiclesDropdownValue;
  String vehiclesValue;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  String selectedFrom;
  String selectedTo;
  dynamic totalKWH = 0;
  dynamic totalCost = "0";

  _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedFromDate)
      setState(() {
        selectedFromDate = picked;
        selectedFrom = DateFormat.MMMd().format(selectedFromDate);
        ProgressDialogs.showLoadingDialog(context, _keyLoader);
        fetchVehiclesDetailsList();
      });
  }

  _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedToDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedToDate)
      setState(() {
        selectedToDate = picked;
        selectedTo = DateFormat.MMMd().format(selectedToDate);
        ProgressDialogs.showLoadingDialog(context, _keyLoader);
        fetchVehiclesDetailsList();
      });
  }

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
                          builder: (context) => new vehiclesPage()));
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("Tag ID",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff818E94),
                                            fontSize: 12),
                                      ))),
                              if (_vehiclesList.length > 1)
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: DropdownButton<String>(
                                      value: vehiclesDropdownValue,
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
                                          vehiclesDropdownValue = newValue;
                                        });
                                        ProgressDialogs.showLoadingDialog(
                                            context, _keyLoader);
                                        fetchVehiclesDetailsList();
                                      },
                                      items: _vehiclesList
                                          .map<DropdownMenuItem<String>>(
                                              (VehiclesData value) {
                                        return DropdownMenuItem<String>(
                                          value: value.label,
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(value.label,
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
                                      // ignore: missing_return
                                    )),
                            ],
                          )),
                      new Container(
                        height: 10,
                        color: Color(0xffF5F5F5),
                      ),
                      Container(
                          padding: EdgeInsets.all(5.0),
                          child: Row(children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: new Text("Start Date",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff818E94),
                                                    fontSize: 12),
                                              ))),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xffF4F7FC),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          alignment: Alignment.center,
                                          child: new GestureDetector(
                                              onTap: () =>
                                                  _selectFromDate(context),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      child: SvgPicture.asset(
                                                          'assets/clander_icon.svg',
                                                          height: 30,
                                                          width: 30)),
                                                  Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              30, 15, 30, 15),
                                                      child: Text(
                                                        selectedFrom,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                            fontSize: 13),
                                                      )),
                                                ],
                                              )))
                                    ]),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: new Text("To",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff818E94),
                                          fontSize: 12),
                                    ))),
                            Expanded(
                                child: Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: new Text("End Date",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff818E94),
                                                  fontSize: 12),
                                            ))),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xffF4F7FC),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        alignment: Alignment.center,
                                        child: new GestureDetector(
                                            onTap: () => _selectToDate(context),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                    child: SvgPicture.asset(
                                                        'assets/clander_icon.svg',
                                                        height: 30,
                                                        width: 30)),
                                                Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            30, 15, 30, 15),
                                                    child: Text(
                                                      selectedTo,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontSize: 13),
                                                    )),
                                              ],
                                            )))
                                  ]),
                            ))
                          ])),
                      new Container(
                        height: 10,
                        color: Color(0xffF5F5F5),
                      ),
                      Expanded(
                        child: Conditional.single(
                          context: context,
                          conditionBuilder: (BuildContext context) =>
                              vehicleDetailsList.length > 0,
                          widgetBuilder: (BuildContext context) => Container(
                            height: MediaQuery.of(context).size.height * 0.65,
                            padding: EdgeInsets.all(15.0),
                            child: new ListView.builder(
                                itemCount: vehicleDetailsList.length,
                                itemBuilder: (BuildContext ctxt, int index) =>
                                    buildVehicleBody(ctxt, index)),
                          ),
                          fallbackBuilder: (BuildContext context) => Container(
                              padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
                              alignment: Alignment.center,
                              child:
                                  SvgPicture.asset('assets/no_data_found.svg')),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                          decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xffF4F7FC),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              padding: EdgeInsets.all(10.0),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Row(children: <Widget>[
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      alignment: Alignment.center,
                                      child: new Text("Total Kwh",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff000000),
                                                fontSize: 14),
                                          ))),
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      alignment: Alignment.center,
                                      child: new Text(totalKWH.toString(),
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff0F123F),
                                                fontSize: 14),
                                          )))
                                ])),
                                new Container(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  height: 20,
                                  width: 1,
                                  color: Color(0xffE0E0E0),
                                ),
                                Expanded(
                                    child: Row(children: <Widget>[
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      alignment: Alignment.center,
                                      child: new Text("Total Cost",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff000000),
                                                fontSize: 14),
                                          ))),
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      alignment: Alignment.center,
                                      child: new Text(totalCost.toString(),
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff0F123F),
                                                fontSize: 14),
                                          )))
                                ])),
                              ])))
                    ]))));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100)).then((__) {
      ProgressDialogs.showLoadingDialog(context, _keyLoader); //invoking login
    });
    selectedToDate = DateTime(
        selectedFromDate.year, selectedFromDate.month+1, 0);
    selectedFromDate = DateTime(
        selectedFromDate.year, selectedFromDate.month, 1);
    selectedFrom = DateFormat.MMMd().format(selectedFromDate);
    selectedTo = DateFormat.MMMd().format(selectedToDate);
    fetchVehiclesList();
  }

  // A Separate Function called from itemBuilder
  Widget buildVehicleBody(BuildContext ctxt, int index) {
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
                      child: Row(children: <Widget>[
                Expanded(
                  child: Column(children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        alignment: Alignment.centerLeft,
                        child: new Text("Date",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff111111),
                                  fontSize: 14),
                            ))),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        alignment: Alignment.centerLeft,
                        child: new Text(vehicleDetailsList[index].date,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff313131),
                                  fontSize: 14),
                            ))),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        alignment: Alignment.centerLeft,
                        child: new Text("Time",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff111111),
                                  fontSize: 14),
                            ))),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        alignment: Alignment.centerLeft,
                        child: new Text(vehicleDetailsList[index].time,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff313131),
                                  fontSize: 14),
                            ))),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        alignment: Alignment.centerLeft,
                        child: new Text("Kwh",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff111111),
                                  fontSize: 14),
                            ))),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        alignment: Alignment.centerLeft,
                        child:
                            new Text(vehicleDetailsList[index].kwh.toString(),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff313131),
                                      fontSize: 14),
                                )))
                  ]),
                ),
                new Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 200,
                  width: 1,
                  color: Color(0xffE0E0E0),
                ),
                Expanded(
                    child: Column(children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      alignment: Alignment.centerLeft,
                      child: new Text("Type",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xff111111),
                                fontSize: 14),
                          ))),
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      alignment: Alignment.centerLeft,
                      child: new Text(vehicleDetailsList[index].type,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff313131),
                                fontSize: 14),
                          ))),
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      alignment: Alignment.centerLeft,
                      child: new Text("Duration",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xff111111),
                                fontSize: 14),
                          ))),
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      alignment: Alignment.centerLeft,
                      child: new Text(vehicleDetailsList[index].duration,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff313131),
                                fontSize: 14),
                          ))),
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      alignment: Alignment.centerLeft,
                      child: new Text("Cost (Dkk)",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xff111111),
                                fontSize: 14),
                          ))),
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      alignment: Alignment.centerLeft,
                      child: new Text(vehicleDetailsList[index].cost.toString(),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff313131),
                                fontSize: 14),
                          )))
                ]))
              ])))
            ])));
  }

  fetchVehiclesList() async {
    try {
      VehiclesListData response =
          await new ChargerRepository().fetchVehicleList();
      print(response);
      if (response.success && response.data.length > 0) {
        setState(() {
          if (response.success && response.data.length > 0) {
            _vehiclesList = response.data;
            vehiclesDropdownValue = response.data[0].label;
            vehiclesValue = response.data[0].value;
          }
        });
        fetchVehiclesDetailsList();
      }
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
  }

  fetchVehiclesDetailsList() async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String startDate = formatter.format(selectedFromDate);
      final String endDate = formatter.format(selectedToDate);
      VehicleDetailsResponse response = await new ChargerRepository()
          .fetchVehicleDetailsList(startDate, endDate, vehiclesValue);
      print(response);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      if (response.success && response.data.data.length > 0) {
        setState(() {
          if (response.success && response.data.data.length > 0) {
            vehicleDetailsList = response.data.data;
            totalKWH = response.data.totalKwh;
            totalCost = response.data.totalCost;
          }
        });
      }
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
  }
}
