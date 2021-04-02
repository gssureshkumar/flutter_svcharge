


class SmartChargeData {
  bool _success;
  String _message;
  Data _data;

  SmartChargeData({bool success, String message, Data data}) {
    this._success = success;
    this._message = message;
    this._data = data;
  }

  bool get success => _success;
  set success(bool success) => _success = success;
  String get message => _message;
  set message(String message) => _message = message;
  Data get data => _data;
  set data(Data data) => _data = data;

  SmartChargeData.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data.toJson();
    }
    return data;
  }
}

class Data {
  List<TimeStampArray> _timeStampArray;
  TimeStampArray _startTime;

  Data({List<TimeStampArray> timeStampArray, TimeStampArray startTime}) {
    this._timeStampArray = timeStampArray;
    this._startTime = startTime;
  }

  List<TimeStampArray> get timeStampArray => _timeStampArray;
  set timeStampArray(List<TimeStampArray> timeStampArray) =>
      _timeStampArray = timeStampArray;
  TimeStampArray get startTime => _startTime;
  set startTime(TimeStampArray startTime) => _startTime = startTime;

  Data.fromJson(Map<String, dynamic> json) {
    if (json['timeStampArray'] != null) {
      _timeStampArray = new List<TimeStampArray>();
      json['timeStampArray'].forEach((v) {
        _timeStampArray.add(new TimeStampArray.fromJson(v));
      });
    }
    _startTime = json['startTime'] != null
        ? new TimeStampArray.fromJson(json['startTime'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._timeStampArray != null) {
      data['timeStampArray'] =
          this._timeStampArray.map((v) => v.toJson()).toList();
    }
    if (this._startTime != null) {
      data['startTime'] = this._startTime.toJson();
    }
    return data;
  }
}

class TimeStampArray {
  String _label;
  String _value;

  TimeStampArray({String label, String value}) {
    this._label = label;
    this._value = value;
  }

  String get label => _label;
  set label(String label) => _label = label;
  String get value => _value;
  set value(String value) => _value = value;

  TimeStampArray.fromJson(Map<String, dynamic> json) {
    _label = json['label'];
    _value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this._label;
    data['value'] = this._value;
    return data;
  }
}