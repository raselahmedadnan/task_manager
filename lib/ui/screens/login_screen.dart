import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/login_controller.dart';
import 'package:task_manager/ui/screens/forgot_password_verify_email.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screens/register_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEControoler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController _loginController = Get.find<LoginController>();

  late bool _passwordVisible = false;

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
                SizedBox(height: 80),
                Text(
                  "Get Started With",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTEController,
                  decoration: InputDecoration(hintText: "Email"),
                  validator: (String? value) {
                    String email = value?.trim() ?? '';
                    if (EmailValidator.validate(email) == false) {
                      return 'Enter a valid email';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordTEControoler,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
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
                GetBuilder<LoginController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.loginProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_emailTEController.text.isEmpty ||
                              _passwordTEControoler.text.isEmpty) {
                            showSnackBarMessage(
                              context,
                              "Please enter your Email & Password",
                            );
                          } else {
                            _onTabSignInButton();
                          }
                        },
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
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: _onTapForgotPassword,
                        child: Text("Forgot Password ?"),
                      ),
                      SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),

                          children: [
                            TextSpan(text: "Don't have Account? "),
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer:
                                  TapGestureRecognizer()..onTap = _onTabSingUP,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTabSignInButton() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }

  }

  Future<void> _signIn() async {
    bool isSuccess = await _loginController.signIn(
      _emailTEController.text.trim(),
      _passwordTEControoler.text,
    );

    if (isSuccess) {
      Get.offAll(MainBottomNavScreen(), predicate: (pre) => false);

    } else {
      showSnackBarMessage(context, _loginController.errorMessage!,true);
    }
  }

  void _onTapForgotPassword() {

    Get.to(ForgotPasswordVerifyEmail());
  }

  void _onTabSingUP() {

    Get.to(RegisterScreen());

  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEControoler.dispose();
    super.dispose();
  }
}
