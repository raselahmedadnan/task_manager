import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/register_screen.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ForgotPasswordPinVerificationScreen extends StatefulWidget {
  ForgotPasswordPinVerificationScreen({super.key, required this.email});

  String email;

  @override
  State<ForgotPasswordPinVerificationScreen> createState() =>
      _ForgotPasswordPinVerificationScreenState();
}

class _ForgotPasswordPinVerificationScreenState
    extends State<ForgotPasswordPinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

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
                  "Pin Verification",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 5),
                Text(
                  "A 6 digit verification pin has been sent to your email",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),

                        children: [
                          TextSpan(text: widget.email),
                          TextSpan(
                            text: "  Change Email",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600 ,
                            ),
                            recognizer:
                            TapGestureRecognizer()..onTap = (){
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedColor: Colors.white,
                    inactiveFillColor: Colors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  controller: _pinTEController,
                  appContext: context,
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: isLoading == false,
                  replacement: Center(child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    onPressed: _onTabSubmitButton,
                    child: Text("Verify"),
                  ),
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

  Future<void> _onTabSubmitButton() async {
    isLoading = true;
    setState(() {});
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.recoveryVerifyOtp(widget.email, _pinTEController.text),
    );
    isLoading = false;
    setState(() {});

    if (response.statusCode == 200) {

      showSnackBarMessage(context, "Otp Verify Successfully!");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResetPasswordScreen(
                email: widget.email,
                otp: _pinTEController.text,
              ),
        ),
      );



    } else {
      showSnackBarMessage(context, "Otp Verify fail");
    }
  }

  void _onTabSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (pre) => false,
    );
  }

void dkjf(){
    TextButton(onPressed: (){}, child: Text("data"));
}


}
