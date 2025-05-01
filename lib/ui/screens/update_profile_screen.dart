import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/model/user_model.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/controller/profile_update_controller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/tmappbar.dart';
import '../widgets/snack_bar_message.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});


  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTextEConroller = TextEditingController();
  final TextEditingController _fastNameTextEConroller = TextEditingController();
  final TextEditingController _lastNameTextEConroller = TextEditingController();
  final TextEditingController _mobileNumberTextEConroller =
      TextEditingController();
  final TextEditingController _passwordTextEConroller = TextEditingController();
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImage;


  ProfileUpdateController profileUpdateController =
      Get.find<ProfileUpdateController>();

  @override
  void initState() {
    super.initState();
    UserModel userModel = AuthController.userModel!;
    _emailTextEConroller.text = userModel.email;
    _fastNameTextEConroller.text = userModel.firstName;
    _lastNameTextEConroller.text = userModel.lastName;
    _mobileNumberTextEConroller.text = userModel.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(fromProfileScreen: true),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _fromKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                SizedBox(height: 40),
                Text(
                  "Update Profile",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                _buildPhotoPickerWidget(),
                TextFormField(
                  controller: _emailTextEConroller,
                  textInputAction: TextInputAction.next,
                  enabled: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  controller: _fastNameTextEConroller,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: "First Name"),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameTextEConroller,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: "Last Name"),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your last name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _mobileNumberTextEConroller,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(hintText: "Mobile"),
                  validator: (String? value) {
                    String phone = value?.trim() ?? '';
                    if (RegExp(r"^01[3-9]\d{8}$").hasMatch(phone) == false) {
                      return 'Enter a valid mobile number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordTextEConroller,
                  decoration: InputDecoration(hintText: "Password"),
                ),
                SizedBox(height: 20),
                GetBuilder<ProfileUpdateController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.updateProgressIndicator == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: _onTabSubmitButton,
                        child: Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPickerWidget() {
    return GestureDetector(
      onTap: _onTabPhotoPicker,
      child: Container(
        height: 50,
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "Photo",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(_pickedImage?.name ?? "Select Image"),
          ],
        ),
      ),
    );
  }

  void _onTabSubmitButton() {
    if (_fromKey.currentState!.validate()) {
      _profileUpdate();
    }
  }

  Future<void> _profileUpdate() async {
    bool isSuccess = await profileUpdateController.profileUpdate(
      _emailTextEConroller.text.trim(),
      _fastNameTextEConroller.text.trim(),
      _lastNameTextEConroller.text.trim(),
      _mobileNumberTextEConroller.text.trim(),
      _passwordTextEConroller.text,
      _pickedImage
    );

    if (isSuccess) {
      _passwordTextEConroller.clear();
      showSnackBarMessage(context, "Profile Data Update Successfully!");
    } else {
      showSnackBarMessage(context, profileUpdateController.errorMessage!, true);
    }
  }

  Future<void> _onTabPhotoPicker() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _pickedImage = image;
      setState(() {});
    }
  }
}
