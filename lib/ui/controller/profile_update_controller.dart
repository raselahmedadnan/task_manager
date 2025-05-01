import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/model/user_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

class ProfileUpdateController extends GetxController {
  bool _updateProgressIndicator = false;
  String? _errorMessage;

  bool get updateProgressIndicator => _updateProgressIndicator;
  String? get errorMessage => _errorMessage;

  final UpdateProfileScreen updateProfileScreen = UpdateProfileScreen();

  Future<bool> profileUpdate(
    String email,
    String firstName,
    String lastName,
    String mobileNumber,
    String password,
    XFile? pickedImage,
  ) async {
    bool isSuccess = false;

    _updateProgressIndicator = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobileNumber,
    };
    if (password.isNotEmpty) {
      requestBody["password"] = password;
    }

    if (pickedImage != null) {
      List<int> imageBytes = await pickedImage!.readAsBytes();
      String encodedImage = base64Encode(imageBytes);
      requestBody['photo'] = encodedImage;
    }

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );
    _updateProgressIndicator = false;
    update();
    if (response.isSuccess) {
      await AuthController.saveUserInformation(
        AuthController.token!,
        UserModel.fromJson(requestBody),
      );

      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    return isSuccess;
  }
}
