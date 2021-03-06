import 'package:sc_charge/models/ChargerDataList.dart';
import 'package:sc_charge/models/GraphResponseData.dart';
import 'package:sc_charge/models/SingleChargerData.dart';
import 'package:sc_charge/models/SmartChargeData.dart';
import 'package:sc_charge/models/StartSmartChargerRequest.dart';
import 'package:sc_charge/models/StartSmartChargerResponse.dart';
import 'package:sc_charge/models/StationDataList.dart';
import 'package:sc_charge/models/StatusLogsData.dart';
import 'package:sc_charge/models/SuccessResponseData.dart';
import 'package:sc_charge/models/VehicleDetailsResponse.dart';
import 'package:sc_charge/models/VehiclesListData.dart';
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

  Future<SmartChargeData> fetchSmartChargeData(String licenseId,String deviceid) async {
    String chargerId = await _getChargerId();
    final response = await _helper.get("device/smartCharge/" + licenseId+"/"+deviceid);
    return SmartChargeData.fromJson(response);
  }

  Future<StartSmartChargerResponse> startSmartChargeData(StartSmartChargerRequest request,String licenseId,String deviceid) async {
    String chargerId = await _getChargerId();
    final response = await _helper.postWithToken("device/startSmartCharge/" + chargerId+"/"+deviceid,request);
    return StartSmartChargerResponse.fromJson(response);
  }

  Future<ChargerDataList> fetchChargerList(String chargerId) async {
    final response = await _helper.get("device/read-devices/" + chargerId);
    return ChargerDataList.fromJson(response);
  }

  Future<ChargerDataList> backgroundCall(String chargerId) async {
    final response = await _helper.getBackgroundCall("device/read-devices/" + chargerId);
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
    await _helper.postUserWithOutBody("/user/logout/");
    return SuccessResponseData.fromJson(response);
  }

  Future<VehiclesListData> fetchVehicleList() async {
    String chargerId = await _getCFMId();
    final response = await _helper.get("device/vehicle/drop-down/" + chargerId);
    return VehiclesListData.fromJson(response);
  }

  Future<VehicleDetailsResponse> fetchVehicleDetailsList(String startDate, String endDate, String tagID) async {
    String chargerId = await _getCFMId();
    Map<String, String> queryParams = {'idTag': tagID, 'startDate': startDate,'endDate': endDate};
    String queryString = Uri(queryParameters: queryParams).query;
    final response = await _helper.get("device/vehicle/"+ chargerId+"?" + queryString);
    return VehicleDetailsResponse.fromJson(response);
  }
}

Future<String> _getChargerId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('charger_id');
}

Future<String> _getCFMId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('cfm_id');
}


