

class StartSmartChargerRequest {
  String startTime;
  String endTime;
  String chargingHours;
  String type;

  StartSmartChargerRequest(
      {this.startTime, this.endTime, this.chargingHours, this.type});

  StartSmartChargerRequest.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    chargingHours = json['chargingHours'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['chargingHours'] = this.chargingHours;
    data['type'] = this.type;
    return data;
  }
}