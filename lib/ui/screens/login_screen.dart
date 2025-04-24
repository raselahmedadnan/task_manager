import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/model/login_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
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

  bool loginProgress = false;

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
                  validator: (String? value){
                    String email = value?.trim() ?? '';
                    if(EmailValidator.validate(email) == false){
                      return 'Enter a valid email';
                    }else{
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
                    if ((value?.trim().isEmpty ?? true) ||
                        value!.length < 6) {
                      return 'Enter your password mor than 6 letters';
                    }
                    return null;
                  },

                ),
                SizedBox(height: 20),
                Visibility(
                  visible: loginProgress == false,
                  replacement: Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      if(_emailTEController.text.isEmpty || _passwordTEControoler.text.isEmpty ){
                        showSnackBarMessage(context, "Please enter your Email & Password");
                      }else{
                        _onTabSignInButton();
                      }
                    },
                    child: Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Colors.white,
                    ),
                  ),
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
    _signIn();
  }

  Future<void> _signIn() async {

    loginProgress = true;
    setState(() {});
    Map<String, dynamic> requestbody = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEControoler.text,
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.longinUrl,
    body: requestbody,
    );
    loginProgress = false;
    setState(() {});

    if(response.isSuccess){
      LoginModel loginModel = LoginModel.fromJson(response.data!);
      AuthController.saveUserInformation(loginModel.token, loginModel.userModel);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainBottomNavScreen()),
            (predicate) => false,
      );
    }else{
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  void _onTapForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordVerifyEmail()),
    );
  }

  void _onTabSingUP() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEControoler.dispose();
    super.dispose();
  }


}
