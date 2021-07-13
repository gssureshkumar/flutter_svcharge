class VehiclesListData {
  bool success;
  String message;
  List<VehiclesData> data;

  VehiclesListData({this.success, this.message, this.data});

  VehiclesListData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<VehiclesData>();
      json['data'].forEach((v) {
        data.add(new VehiclesData.fromJson(v));
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

class VehiclesData {
  String label;
  String value;

  VehiclesData({this.label, this.value});

  VehiclesData.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}
