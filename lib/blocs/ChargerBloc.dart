


import 'dart:async';

import 'package:flutter_app/models/LoginInputData.dart';
import 'package:flutter_app/models/LoginSuccessResponse.dart';
import 'package:flutter_app/models/StationDataList.dart';
import 'package:flutter_app/networking/api_response.dart';
import 'package:flutter_app/repository/ChargerRepository.dart';
import 'package:flutter_app/repository/LoginRepository.dart';

class ChargerBloc{

  ChargerRepository chargerRepository;

  StreamController _chargerController;

  StreamSink<ApiResponse<StationDataList>> get chargerSink =>
      _chargerController.sink;

  Stream<ApiResponse<StationDataList>> get chargerStream =>
      _chargerController.stream;

  ChargerBloc() {
    _chargerController = StreamController<ApiResponse<StationDataList>>();
    chargerRepository = ChargerRepository();
    fetchStationList();
  }


  fetchStationList() async {
    chargerSink.add(ApiResponse.loading('Fetching Movies'));
    try {
      StationDataList stationDataList = await chargerRepository.fetchStationList();
      chargerSink.add(ApiResponse.completed(stationDataList));
    } catch (e) {
      chargerSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }
  dispose() {
    _chargerController?.close();
  }

}