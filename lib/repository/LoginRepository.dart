import 'package:sc_charge/models/LoginInputData.dart';
import 'package:sc_charge/models/LoginSuccessResponse.dart';
import 'package:sc_charge/networking/api_base_helper.dart';

class LoginRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<LoginSuccessResponse> callDoLogin(LoginInputData inputDatal) async {
    final response = await _helper.post("user/login", inputDatal);
    return LoginSuccessResponse.fromJson(response);
  }
}
