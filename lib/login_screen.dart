import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'fragments/chargeFleetPage.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _emailValidate = false;
  bool _passwordValidate = false;

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
                    image:  AssetImage('assets/bottom_backgroud.png'),
                    fit: BoxFit.none,
                  ),
                ),
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    SvgPicture.asset('assets/image_logo.svg'),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
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
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                            onPressed: () {
                              //forgot password screen
                            },
                            textColor: Color(0xff0F123F),
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff0F123F),
                                    fontSize: 13),
                              ),
                            ))),
                    Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                            print(nameController.text);
                            print(passwordController.text);
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
                              _storeLoggedInStatus(true);
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return chargeFleetPage();
                              }));
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

  // Sets the login status
  void _storeLoggedInStatus(bool isLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLoggedIn', isLoggedIn);
  }
}
