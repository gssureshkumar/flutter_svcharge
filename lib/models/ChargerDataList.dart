

class ChargerDataList {
  bool success;
  String message;
  List<ChargerData> data;

  ChargerDataList({this.success, this.message, this.data});

  ChargerDataList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<ChargerData>();
      json['data'].forEach((v) {
        data.add(new ChargerData.fromJson(v));
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

class ChargerData {
  String sId;
  String name;
  String serialNumber;
  String status;

  ChargerData({this.sId, this.name, this.serialNumber, this.status});

  ChargerData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    serialNumber = json['serialNumber'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['serialNumber'] = this.serialNumber;
    data['status'] = this.status;
    return data;
  }
}