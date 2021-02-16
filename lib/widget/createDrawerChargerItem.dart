import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/MyConstants.dart';

Widget createDrawerChargerItem(
    {String icon, String text, GestureTapCallback onTap}) {
  return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: new GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: MyConstants.navPosition != 1
                  ? Color(0xff47496B)
                  : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(0))),
          child: Row(
            children: <Widget>[
              Image.asset(
                icon,
                fit: BoxFit.cover,
                width: 20,
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(text,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 13)),
              )
            ],
          ),
        ),
      ));
}
