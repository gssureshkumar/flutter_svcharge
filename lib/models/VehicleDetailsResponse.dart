class VehicleDetailsResponse {
  bool success;
  String message;
  Data data;

  VehicleDetailsResponse({this.success, this.message, this.data});

  VehicleDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<VehicleDetails> data;
  dynamic totalKwh;
  dynamic totalCost;

  Data({this.data, this.totalKwh, this.totalCost});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<VehicleDetails>();
      json['data'].forEach((v) {
        data.add(new VehicleDetails.fromJson(v));
      });
    }
    totalKwh = json['totalKwh'];
    totalCost = json['totalCost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['totalKwh'] = this.totalKwh;
    data['totalCost'] = this.totalCost;
    return data;
  }
}

class VehicleDetails {
  String sId;
  String startTime;
  String chargerId;
  int connectorId;
  String idTag;
  dynamic meterStart;
  String action;
  int transactionId;
  String status;
  String date;
  String endTime;
  dynamic meterStop;
  dynamic kwh;
  dynamic cost;
  dynamic type;
  String duration;
  String time;

  VehicleDetails(
      {this.sId,
      this.startTime,
      this.chargerId,
      this.connectorId,
      this.idTag,
      this.meterStart,
      this.action,
      this.transactionId,
      this.status,
      this.date,
      this.endTime,
      this.meterStop,
      this.kwh,
      this.cost,
      this.type,
      this.duration,
      this.time});

  VehicleDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    startTime = json['startTime'];
    chargerId = json['chargerId'];
    connectorId = json['connectorId'];
    idTag = json['idTag'];
    meterStart = json['meterStart'];
    action = json['action'];
    transactionId = json['transactionId'];
    status = json['status'];
    date = json['date'];
    endTime = json['endTime'];
    meterStop = json['meterStop'];
    kwh = json['Kwh'];
    cost = json['cost'];
    type = json['type'];
    duration = json['duration'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['startTime'] = this.startTime;
    data['chargerId'] = this.chargerId;
    data['connectorId'] = this.connectorId;
    data['idTag'] = this.idTag;
    data['meterStart'] = this.meterStart;
    data['action'] = this.action;
    data['transactionId'] = this.transactionId;
    data['status'] = this.status;
    data['date'] = this.date;
    data['endTime'] = this.endTime;
    data['meterStop'] = this.meterStop;
    data['Kwh'] = this.kwh;
    data['cost'] = this.cost;
    data['type'] = this.type;
    data['duration'] = this.duration;
    data['time'] = this.time;
    return data;
  }
}
