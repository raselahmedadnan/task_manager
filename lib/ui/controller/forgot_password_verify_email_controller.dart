import 'package:get/get.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';

class ForgotPasswordVerifyEmailController extends GetxController{
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<bool> onTabOtpVerification(String email) async {
    bool isSuccess = false;

    _isLoading = true;
    update();
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.recoveryVerifyEmail(email),
    );


    if(response.isSuccess){

      isSuccess = true;
    }

    _isLoading = false;
    update();

    return isSuccess;
  }
}