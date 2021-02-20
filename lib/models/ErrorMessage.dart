


class ErrorMessage {
  bool success;
  String message;

  ErrorMessage(bool success, String message){
    this.success = success;
    this.message = message;
  }

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}