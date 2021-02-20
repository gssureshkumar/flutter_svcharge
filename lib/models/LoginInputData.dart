import 'package:sc_charge/models/UserInput.dart';

class LoginInputData {
  UserInput user;

  LoginInputData(UserInput user) {
    this.user = user;
  }

  LoginInputData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new UserInput.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}


