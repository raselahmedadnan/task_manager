import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/forgot_password_verify_email_controller.dart';
import 'package:task_manager/ui/screens/forgot_password_pin_verification_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ForgotPasswordVerifyEmail extends StatefulWidget {
  const ForgotPasswordVerifyEmail({super.key});

  @override
  State<ForgotPasswordVerifyEmail> createState() =>
      _ForgotPasswordVerifyEmailState();
}

class _ForgotPasswordVerifyEmailState extends State<ForgotPasswordVerifyEmail> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ForgotPasswordVerifyEmailController forgotPasswordVerifyEmailController = Get.find<ForgotPasswordVerifyEmailController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 120),
                Text(
                  "Your Email Address",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 5),
                Text(
                  "A 6 digit verification pin well be sent to your email",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 20),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTEController,
                  decoration: InputDecoration(hintText: "Email"),
                  validator: (String? value) {
                    String email = value?.trim() ?? '';
                    if (EmailValidator.validate(email) == false) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                GetBuilder<ForgotPasswordVerifyEmailController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.isLoading == false,
                      replacement: Center(child: CircularProgressIndicator(),),
                      child: ElevatedButton(
                        onPressed: _onTabOtpVerification,
                        child: Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
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

  Future<void> _onTabOtpVerification() async {

    bool isSuccess = await forgotPasswordVerifyEmailController.onTabOtpVerification(
        _emailTEController.text.trim()
    );
    if(isSuccess){
      showSnackBarMessage(context, "Check your email we already send 6 digit code on your email");

      Get.to(ForgotPasswordPinVerificationScreen(email: _emailTEController.text));


    }else if(_emailTEController.text.isEmpty){
      showSnackBarMessage(context, "Please enter your email first");
    }
    else{
      showSnackBarMessage(context, "Email Not Match. try difficult email");
    }


  }

  void _onTabSignIn() {
  Get.back();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
