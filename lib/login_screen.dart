import 'package:sc_charge/widget/ProgressDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sc_charge/models/LoginInputData.dart';
import 'package:sc_charge/models/LoginSuccessResponse.dart';
import 'package:sc_charge/models/LoginSuccessResponse.dart';
import 'package:sc_charge/models/UserInput.dart';
import 'package:sc_charge/networking/api_response.dart';
import 'package:sc_charge/repository/LoginRepository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'fragments/chargeFleetPage.dart';
import 'models/LoginSuccessResponse.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _emailValidate = false;
  bool _passwordValidate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        // ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.bottomLeft,
                    image: AssetImage('assets/bottom_backgroud.png'),
                    fit: BoxFit.none,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: ListView(
                  children: <Widget>[
                    SvgPicture.asset('assets/logo_nav_icon.svg'),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
                        child: Text('Login Please',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 20),
                            ))),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                            'This is a secure system and you will need to provide your login details to access the site.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff818E94),
                                  fontSize: 12),
                            ))),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: TextField(
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 15),
                        ),
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          errorText: _emailValidate
                              ? 'Please enter valid email'
                              : null,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: TextField(
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 15),
                        ),
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          errorText: _passwordValidate
                              ? 'Please enter valid password'
                              : null,
                        ),
                      ),
                    ),
                    Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xff0F123F))),
                          color: Color(0xff0F123F),
                          child: Text('Sign In',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 13)),
                          onPressed: () {
                            if (!isEmail(nameController.text)) {
                              setState(() {
                                _emailValidate = true;
                              });
                            } else if (passwordController.text.isEmpty ||
                                passwordController.text.length < 5) {
                              setState(() {
                                _emailValidate = false;
                                _passwordValidate = true;
                              });
                            } else {
                              _emailValidate = false;
                              _passwordValidate = false;
                              ProgressDialogs.showLoadingDialog(
                                  context, _keyLoader); //invoking login
                              UserInput input = new UserInput(
                                  nameController.text, passwordController.text);
                              LoginInputData inputData =
                                  new LoginInputData(input);
                              callDoLogin(inputData);
                            }
                          },
                        )),
                  ],
                ))
          ],
        ));
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  callDoLogin(LoginInputData inputData) async {
    try {
      LoginSuccessResponse response =
          await new LoginRepository().callDoLogin(inputData);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      loginSuccess(response);
    } catch (e) {
      print(e);
    }
  }

  // Sets the login status
  void _storeLoggedInStatus(bool isLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLoggedIn', isLoggedIn);
  }

  // Sets the login status
  void _storeLoggedInId(String userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('user_id', userId);
  }

  void _storeLoggedInToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('token', 'Bearer ' + token);
  }

  void _storeLoggedInChargerId(String chargerId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('charger_id', chargerId);
  }

  void loginSuccess(LoginSuccessResponse loginSuccessResponse) {
    if (loginSuccessResponse.success &&
        loginSuccessResponse.data.user.customerId.license.evCharging.enabled) {
      _storeLoggedInStatus(true);
      _storeLoggedInId(loginSuccessResponse.data.user.sId);
      _storeLoggedInToken(loginSuccessResponse.data.token);
      _storeLoggedInChargerId(
          loginSuccessResponse.data.user.customerId.license.evCharging.id);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return chargeFleetPage();
      }));
    } else {
      Fluttertoast.showToast(
          msg: loginSuccessResponse.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black12,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }
}
