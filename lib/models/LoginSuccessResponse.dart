

class LoginSuccessResponse {
  bool success;
  String message;
  Data data;

  LoginSuccessResponse({this.success, this.message, this.data});

  LoginSuccessResponse.fromJson(Map<String, dynamic> json) {
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
  String token;
  User user;

  Data({this.token, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String sId;
  String email;
  String userRole;
  String contact;
  CustomerId customerId;
  int iV;

  User(
      {this.sId,
        this.email,
        this.userRole,
        this.contact,
        this.customerId,
        this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    userRole = json['userRole'];
    contact = json['contact'];
    customerId = json['customerId'] != null
        ? new CustomerId.fromJson(json['customerId'])
        : null;
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['userRole'] = this.userRole;
    data['contact'] = this.contact;
    if (this.customerId != null) {
      data['customerId'] = this.customerId.toJson();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class CustomerId {
  License license;
  String sId;
  String name;

  CustomerId({this.license, this.sId, this.name});

  CustomerId.fromJson(Map<String, dynamic> json) {
    license =
    json['license'] != null ? new License.fromJson(json['license']) : null;
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.license != null) {
      data['license'] = this.license.toJson();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class License {
  Ventilation ventilation;
  Ventilation cooling;
  Ventilation evCharging;
  Ventilation loadShifting;
  Ventilation outOfHours;
  Ventilation heatPump;

  License(
      {this.ventilation,
        this.cooling,
        this.evCharging,
        this.loadShifting,
        this.outOfHours,
        this.heatPump});

  License.fromJson(Map<String, dynamic> json) {
    ventilation = json['ventilation'] != null
        ? new Ventilation.fromJson(json['ventilation'])
        : null;
    cooling = json['cooling'] != null
        ? new Ventilation.fromJson(json['cooling'])
        : null;
    evCharging = json['evCharging'] != null
        ? new Ventilation.fromJson(json['evCharging'])
        : null;
    loadShifting = json['loadShifting'] != null
        ? new Ventilation.fromJson(json['loadShifting'])
        : null;
    outOfHours = json['outOfHours'] != null
        ? new Ventilation.fromJson(json['outOfHours'])
        : null;
    heatPump = json['heatPump'] != null
        ? new Ventilation.fromJson(json['heatPump'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ventilation != null) {
      data['ventilation'] = this.ventilation.toJson();
    }
    if (this.cooling != null) {
      data['cooling'] = this.cooling.toJson();
    }
    if (this.evCharging != null) {
      data['evCharging'] = this.evCharging.toJson();
    }
    if (this.loadShifting != null) {
      data['loadShifting'] = this.loadShifting.toJson();
    }
    if (this.outOfHours != null) {
      data['outOfHours'] = this.outOfHours.toJson();
    }
    if (this.heatPump != null) {
      data['heatPump'] = this.heatPump.toJson();
    }
    return data;
  }
}

class Ventilation {
  String id;
  bool enabled;

  Ventilation({this.id, this.enabled});

  Ventilation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['enabled'] = this.enabled;
    return data;
  }
}