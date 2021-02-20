
class GraphResponseData {
  bool success;
  String message;
  Data data;

  GraphResponseData({this.success, this.message, this.data});

  GraphResponseData.fromJson(Map<String, dynamic> json) {
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
  ConsumptionData consumptionData;
  List<LogsData> logsData;

  Data({this.consumptionData, this.logsData});

  Data.fromJson(Map<String, dynamic> json) {
    consumptionData = json['consumptionData'] != null
        ? new ConsumptionData.fromJson(json['consumptionData'])
        : null;
    if (json['logsData'] != null) {
      logsData = new List<LogsData>();
      json['logsData'].forEach((v) {
        logsData.add(new LogsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.consumptionData != null) {
      data['consumptionData'] = this.consumptionData.toJson();
    }
    if (this.logsData != null) {
      data['logsData'] = this.logsData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConsumptionData {
  List<Power> power;
  List<Consumption> consumption;
  List<Soc> soc;

  ConsumptionData({this.power, this.consumption, this.soc});

  ConsumptionData.fromJson(Map<String, dynamic> json) {
    if (json['power'] != null) {
      power = new List<Power>();
      json['power'].forEach((v) {
        power.add(new Power.fromJson(v));
      });
    }
    if (json['consumption'] != null) {
      consumption = new List<Consumption>();
      json['consumption'].forEach((v) {
        consumption.add(new Consumption.fromJson(v));
      });
    }
    if (json['soc'] != null) {
      soc = new List<Soc>();
      json['soc'].forEach((v) {
        soc.add(new Soc.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.power != null) {
      data['power'] = this.power.map((v) => v.toJson()).toList();
    }
    if (this.consumption != null) {
      data['consumption'] = this.consumption.map((v) => v.toJson()).toList();
    }
    if (this.soc != null) {
      data['soc'] = this.soc.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Soc {
  String name;
  List<SocData> data;

  Soc({this.name, this.data});

  Soc.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['data'] != null) {
      data = new List<SocData>();
      json['data'].forEach((v) {
        data.add(new SocData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SocData {
  String x;
  String y;

  SocData({this.x, this.y});

  SocData.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}

class Consumption {
  String name;
  List<ConsumptionSubData> data;

  Consumption({this.name, this.data});

  Consumption.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['data'] != null) {
      data = new List<ConsumptionSubData>();
      json['data'].forEach((v) {
        data.add(new ConsumptionSubData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConsumptionSubData {
  String x;
  String y;

  ConsumptionSubData({this.x, this.y});

  ConsumptionSubData.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}
class Power {
  String name;
  List<PowerData> data;

  Power({this.name, this.data});

  Power.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['data'] != null) {
      data = new List<PowerData>();
      json['data'].forEach((v) {
        data.add(new PowerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PowerData {
  String x;
  String y;

  PowerData({this.x, this.y});

  PowerData.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}

class LogsData {
  String chargerId;
  String action;
  String timeStamp;
  String duration;
  int consumption;

  LogsData(
      {this.chargerId,
        this.action,
        this.timeStamp,
        this.duration,
        this.consumption});

  LogsData.fromJson(Map<String, dynamic> json) {
    chargerId = json['chargerId'];
    action = json['action'];
    timeStamp = json['timeStamp'];
    duration = json['duration'];
    consumption = json['consumption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chargerId'] = this.chargerId;
    data['action'] = this.action;
    data['timeStamp'] = this.timeStamp;
    data['duration'] = this.duration;
    data['consumption'] = this.consumption;
    return data;
  }
}