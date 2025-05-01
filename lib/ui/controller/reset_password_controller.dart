import 'package:get/get.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';

class ResetPasswordController extends GetxController {
  final String _messages = 'Your password field is empty. Plz enter password';

  String get messages => _messages;

  bool _resetPasswordProgress = false;
  bool get resetPasswordProgress => _resetPasswordProgress;

  Future<bool> setPasswordApiPassData(
    String email,
    String otp,
    String newPassword,
    String conformPassword,
  ) async {

    bool isSuccess = false;

    _resetPasswordProgress = true;
    update();

    if (newPassword.isEmpty || conformPassword.isEmpty) {
       _messages;

    } else {
      if (newPassword == conformPassword) {
        Map<String, dynamic> responseBody = {
          "email": email,
          "OTP": otp,
          "password": conformPassword,
        };

        NetworkResponse response = await NetworkClient.postRequest(
          url: Urls.recoverResetPassword,
          body: responseBody,
        );

        if (response.isSuccess) {

          isSuccess = true;
        }
      }
    }
    _resetPasswordProgress = false;
    update();

    return isSuccess;
  }
}
