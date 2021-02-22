

class StatusLogsData {
  bool success;
  String message;
  List<SLogsData> data;

  StatusLogsData({this.success, this.message, this.data});

  StatusLogsData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<SLogsData>();
      json['data'].forEach((v) {
        data.add(new SLogsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SLogsData {
  String chargerId;
  String action;
  String timeStamp;
  String name;
  String duration;
  int consumption;

  SLogsData(
      {this.chargerId,
        this.action,
        this.timeStamp,
        this.name,
        this.duration,
        this.consumption});

  SLogsData.fromJson(Map<String, dynamic> json) {
    chargerId = json['chargerId'];
    action = json['action'];
    timeStamp = json['timeStamp'];
    name = json['name'];
    duration = json['duration'];
    consumption = json['consumption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chargerId'] = this.chargerId;
    data['action'] = this.action;
    data['timeStamp'] = this.timeStamp;
    data['name'] = this.name;
    data['duration'] = this.duration;
    data['consumption'] = this.consumption;
    return data;
  }
}