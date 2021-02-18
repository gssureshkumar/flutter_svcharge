import 'dart:io';
import 'package:flutter_app/networking/api_exceptions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class ApiBaseHelper {
  final String _baseUrl = "https://betaserver.scnordic.com/api/app/";

  Future<dynamic> get(String url) async {
    print('Api Get, url $url');
    var responseJson;
    try {
      String token = await _getToken();
      final response = await http.get(_baseUrl + url,headers: {HttpHeaders.authorizationHeader: token});
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api get recieved!');
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body) async {
    print('Api Post, url ' +json.encode(body));
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url, body: json.encode(body), headers:
          {"Content-Type": "application/json"});
          responseJson = _returnResponse(response);
          } on SocketException {
          print('No net');
          throw FetchDataException('No Internet connection');
          }
          print('api post.');
      return responseJson;
    }

    Future<dynamic> put(String url, dynamic body) async {
      print('Api Put, url $url');
      var responseJson;
      try {
        final response = await http.put(_baseUrl + url, body: body);
        responseJson = _returnResponse(response);
      } on SocketException {
        print('No net');
        throw FetchDataException('No Internet connection');
      }
      print('api put.');
      print(responseJson.toString());
      return responseJson;
    }

    Future<dynamic> delete(String url) async {
      print('Api delete, url $url');
      var apiResponse;
      try {
        final response = await http.delete(_baseUrl + url);
        apiResponse = _returnResponse(response);
      } on SocketException {
        print('No net');
        throw FetchDataException('No Internet connection');
      }
      print('api delete.');
      return apiResponse;
    }
  }

  dynamic _returnResponse(http.Response response) {
    // switch (response.statusCode) {
    //   case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      // case 400:
      //   throw BadRequestException(response.body.toString());
      // case 401:
      // case 403:
      //   throw UnauthorisedException(response.body.toString());
      // case 500:
      // default:
      //   throw FetchDataException(
      //       'Error occured while Communication with Server with StatusCode : ${response
      //           .statusCode}');
    // }
  }

Future<String> _getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token');
}