

class StationDataList {
  bool success;
  String message;
  Data data;

  StationDataList({this.success, this.message, this.data});

  StationDataList.fromJson(Map<String, dynamic> json) {
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
  List<Groups> groups;
  String sId;
  String customerId;
  String type;
  int iV;

  Data({this.groups, this.sId, this.customerId, this.type, this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['groups'] != null) {
      groups = new List<Groups>();
      json['groups'].forEach((v) {
        groups.add(new Groups.fromJson(v));
      });
    }
    sId = json['_id'];
    customerId = json['customerId'];
    type = json['type'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.groups != null) {
      data['groups'] = this.groups.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['customerId'] = this.customerId;
    data['type'] = this.type;
    data['__v'] = this.iV;
    return data;
  }
}

class Groups {
  String sId;
  String licenseId;
  String name;

  Groups({this.sId, this.licenseId, this.name});

  Groups.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    licenseId = json['licenseId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['licenseId'] = this.licenseId;
    data['name'] = this.name;
    return data;
  }
}