import 'package:get/get.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart' show Urls;

class ForgotPasswordPinVerificationController extends GetxController{
  bool _isLoading = false;
  bool get isLoading => _isLoading;



  Future<bool> pinVerificationApi(String email,String otp) async {
    bool isSuccess = false;

    _isLoading = true;
    update();

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.recoveryVerifyOtp(email, otp),
    );


    if (response.statusCode == 200) {

      isSuccess = true;

    }

    _isLoading = false;
    update();
    return isSuccess;
  }
}