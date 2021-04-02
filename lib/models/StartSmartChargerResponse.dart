

class StartSmartChargerResponse {
  bool success;
  String message;
  Data data;

  StartSmartChargerResponse({this.success, this.message, this.data});

  StartSmartChargerResponse.fromJson(Map<String, dynamic> json) {
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
  List<Schedule> schedule;
  String status;
  String sId;
  String deviceId;
  String type;
  String starttime;
  String endtime;
  String priceSignal;
  String serialNumber;
  int hour;
  String createdAt;
  String updatedAt;
  int iV;

  Data(
      {this.schedule,
        this.status,
        this.sId,
        this.deviceId,
        this.type,
        this.starttime,
        this.endtime,
        this.priceSignal,
        this.serialNumber,
        this.hour,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['schedule'] != null) {
      schedule = new List<Schedule>();
      json['schedule'].forEach((v) {
        schedule.add(new Schedule.fromJson(v));
      });
    }
    status = json['status'];
    sId = json['_id'];
    deviceId = json['deviceId'];
    type = json['type'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    priceSignal = json['priceSignal'];
    serialNumber = json['serialNumber'];
    hour = json['hour'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.schedule != null) {
      data['schedule'] = this.schedule.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['deviceId'] = this.deviceId;
    data['type'] = this.type;
    data['starttime'] = this.starttime;
    data['endtime'] = this.endtime;
    data['priceSignal'] = this.priceSignal;
    data['serialNumber'] = this.serialNumber;
    data['hour'] = this.hour;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Schedule {
  String sId;
  String signal;
  double price;
  String startTime;
  String endTime;

  Schedule({this.sId, this.signal, this.price, this.startTime, this.endTime});

  Schedule.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    signal = json['signal'];
    price = json['price'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['signal'] = this.signal;
    data['price'] = this.price;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}