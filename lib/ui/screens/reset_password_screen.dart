import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/reset_password_controller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
   ResetPasswordScreen({super.key,required this.email, required this.otp});

  String email;
  String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController =
      TextEditingController();
  final TextEditingController _conformPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late  bool _passwordVisible = false;

  ResetPasswordController resetPasswordController = Get.find<ResetPasswordController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 120),
                Text(
                  "Set Password",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 5),
                Text(
                  "Set a new password minimum length of 6 letters",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 20),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _newPasswordTEController,
                  decoration: InputDecoration(hintText: "New Password",

                  ),
                  validator: (String? value) {
                    if ((value?.trim().isEmpty ?? true) || value!.length < 6) {
                      return 'Enter your password mor than 6 letters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: !_passwordVisible,
                  controller: _conformPasswordTEController,
                  decoration: InputDecoration(hintText: "Confirm Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  validator: (String? value) {
                    if ((value?.trim().isEmpty ?? true) || value!.length < 6) {
                      return 'Enter your password mor than 6 letters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onTabSetPassword,
                  child: Text("Confirm"),
                ),
                SizedBox(height: 32),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),

                      children: [
                        TextSpan(text: "Don't have Account? "),
                        TextSpan(
                          text: "Sign in",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer:
                              TapGestureRecognizer()..onTap = _onTabSignIn,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTabSetPassword() async {

    bool isSuccess = await resetPasswordController.setPasswordApiPassData(
        widget.email,
        widget.otp,
        _newPasswordTEController.text,
        _conformPasswordTEController.text);

        if(isSuccess){
          showSnackBarMessage(context, "Password Successfully changed. Plz Login again");
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (context) => const LoginScreen()),
          //       (pre) => false,
          // );

          Get.offAll(LoginScreen(),predicate: (pre) => false);

      }else{
        showSnackBarMessage(context, "Password not match. Plz check your password");
      }





  }

  void _onTabSignIn() {
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => const LoginScreen()),
    //   (pre) => false,
    // );

    Get.offAll(LoginScreen(),predicate: (pre) => false);



  }

  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _conformPasswordTEController.dispose();
    super.dispose();
  }

  void clearTextController(){
    _newPasswordTEController.clear();
    _conformPasswordTEController.clear();
  }

}
