import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'package:flutter_app/fragments/chargeFleetPage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initialRoute = 'login';

  bool isLoggedIn = await _getLoggedInStatus();

  if (isLoggedIn) {
    initialRoute = 'home';
  }

  runApp(MyApp(initialRoute: initialRoute));
}

// Gets the logged in status
Future<bool> _getLoggedInStatus() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool('isLoggedIn') ?? false;
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({@required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Container(
            child: Stack(
              children: [
                Center(
                  child:  SvgPicture.asset('assets/image_logo.svg',
                alignment: Alignment.center,
                color: Colors.white)),
              ],
            ),
          ),
        ),
        
        initialRoute: initialRoute,
        routes: {
          'login': (context) => LoginScreen(),
          'home': (context) => chargeFleetPage(),
        }
    );
  }
}


  // Sets the login status
  void _storeLoggedInStatus(bool isLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLoggedIn', isLoggedIn);
  }


