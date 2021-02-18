import 'package:flutter_app/models/LoginInputData.dart';
import 'package:flutter_app/models/LoginSuccessResponse.dart';
import 'package:flutter_app/networking/api_base_helper.dart';

class LoginRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<LoginSuccessResponse> callDoLogin(LoginInputData inputDatal) async {
    final response = await _helper.post("user/login", inputDatal);
    return LoginSuccessResponse.fromJson(response);
  }
}
