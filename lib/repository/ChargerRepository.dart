

import 'package:flutter_app/models/ChargerDataList.dart';
import 'package:flutter_app/models/StationDataList.dart';
import 'package:flutter_app/networking/api_base_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChargerRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<StationDataList> fetchStationList() async {
    String chargerId = await _getChargerId();
    final response = await _helper.get("depot/read-depots/"+chargerId);
    return StationDataList.fromJson(response);
  }

  Future<ChargerDataList> fetchChargerList(String chargerId) async {
    final response = await _helper.get("device/read-devices/"+chargerId);
    return ChargerDataList.fromJson(response);
  }
}

Future<String> _getChargerId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('charger_id');
}