import 'package:get/get.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';

class RegisterUserController extends GetxController{
 bool _registrationInProgress = false;
 String? _errorMessage;

 bool get registrationInProgress => _registrationInProgress;
 String? get errorMessage => _errorMessage;



  Future<bool> registerUser(String email,String firstName, String lastName,String mobileNumber,String password) async {
   bool isSuccess = false;

    _registrationInProgress = true;
    update();


    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobileNumber,
      "password": password,
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.registrationUrl,
      body: requestBody,
    );


    if (response.isSuccess) {

      isSuccess = true;
      _errorMessage = null;

    } else {
     _errorMessage = response.errorMessage;
    }

    _registrationInProgress = false;
    update();

    return isSuccess;
  }

}