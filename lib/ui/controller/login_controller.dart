import 'package:get/get.dart';
import 'package:task_manager/data/model/login_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';

class LoginController extends GetxController {
  bool _loginProgress = false;
  bool get loginProgress => _loginProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;

    _loginProgress = true;
    update();

    Map<String, dynamic> requestbody = {"email": email, "password": password};

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.longinUrl,
      body: requestbody,
    );

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.data!);
      AuthController.saveUserInformation(
        loginModel.token,
        loginModel.userModel,
      );

      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _loginProgress = false;
    update();

    return isSuccess;
  }
}
