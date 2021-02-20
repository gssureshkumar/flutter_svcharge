import 'package:sc_charge/models/ChargerDataList.dart';
import 'package:sc_charge/models/GraphResponseData.dart';
import 'package:sc_charge/models/SingleChargerData.dart';
import 'package:sc_charge/models/StationDataList.dart';
import 'package:sc_charge/models/StatusLogsData.dart';
import 'package:sc_charge/models/SuccessResponseData.dart';
import 'package:sc_charge/networking/api_base_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChargerRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<StationDataList> fetchStationList() async {
    String chargerId = await _getChargerId();
    final response = await _helper.get("depot/read-depots/" + chargerId);
    return StationDataList.fromJson(response);
  }

  Future<GraphResponseData> fetchGraphLogList(
      String chargerId, String date) async {
    Map<String, String> queryParams = {'date': date, 'chargerId': chargerId};
    String queryString = Uri(queryParameters: queryParams).query;
    final response = await _helper.get("device/deviceData?" + queryString);
    return GraphResponseData.fromJson(response);
  }

  Future<ChargerDataList> fetchChargerList(String chargerId) async {
    final response = await _helper.get("device/read-devices/" + chargerId);
    return ChargerDataList.fromJson(response);
  }

  Future<SingleChargerData> fetchSingleChargerData(String serialNumber) async {
    String chargerId = await _getChargerId();
    final response = await _helper.get("device/readCharger/" + serialNumber+"/"+chargerId);
    return SingleChargerData.fromJson(response);
  }

  Future<StatusLogsData> fetchStatusLogsList(String chargerId) async {
    final response = await _helper.get("device/read-logs/" + chargerId);
    return StatusLogsData.fromJson(response);
  }

  Future<SuccessResponseData> startCharger(String chargerId) async {
    final response =
        await _helper.postWithOutBody("device/startCharging/" + chargerId);
    return SuccessResponseData.fromJson(response);
  }

  Future<SuccessResponseData> stopCharger(String chargerId) async {
    final response =
        await _helper.postWithOutBody("device/stopCharging/" + chargerId);
    return SuccessResponseData.fromJson(response);
  }

  Future<SuccessResponseData> userLogout() async {
    final response =
    await _helper.postWithOutBody("user/logout/");
    return SuccessResponseData.fromJson(response);
  }
}

Future<String> _getChargerId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('charger_id');
}
