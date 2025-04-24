import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailTextEConroller = TextEditingController();
  final TextEditingController _fastNameTextEConroller = TextEditingController();
  final TextEditingController _lastNameTextEConroller = TextEditingController();
  final TextEditingController _mobileNumberTextEConroller = TextEditingController();
  final TextEditingController _passwordTextEConroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late  bool _passwordVisible = false;
  bool _registrationInProgress = false;




  String mobilePattern = r"^01[3-9]\d{8}$";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Text(
                    "Join With Us",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _emailTextEConroller,
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
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _fastNameTextEConroller,
                    decoration: InputDecoration(hintText: "First Name"),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _lastNameTextEConroller,
                    decoration: InputDecoration(hintText: "Last Name"),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.phone,
                    controller: _mobileNumberTextEConroller,
                    decoration: InputDecoration(hintText: "Mobile Number"),
                    validator: (String? value) {
                      String phone = value?.trim() ?? '';
                      if (RegExp(mobilePattern).hasMatch(phone) == false) {
                        return 'Enter a valid mobile number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordTextEConroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(hintText: "Password",
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
                  SizedBox(height: 30),
                  Visibility(
                    visible: _registrationInProgress == false,
                    replacement: Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: _onTabSubmitButton,
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                      ),
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
                          TextSpan(text: "Already have an Account?  "),
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()..onTap = _onTabSingIn,
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
      ),
    );
  }

  void _onTabSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _registerUser();
    }
  }

  Future<void> _registerUser() async {
    _registrationInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTextEConroller.text.trim(),
      "firstName": _fastNameTextEConroller.text.trim(),
      "lastName": _lastNameTextEConroller.text.trim(),
      "mobile": _mobileNumberTextEConroller.text.trim(),
      "password": _passwordTextEConroller.text,
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.registrationUrl,
      body: requestBody,
    );
    _registrationInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _clearTextFields();
      showSnackBarMessage(context, "User Register successfully");
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }
  void _clearTextFields() {
    _emailTextEConroller.clear();
    _fastNameTextEConroller.clear();
    _lastNameTextEConroller.clear();
    _mobileNumberTextEConroller.clear();
    _passwordTextEConroller.clear();
  }

  void _onTabSingIn() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTextEConroller.dispose();
    _fastNameTextEConroller.dispose();
    _lastNameTextEConroller.dispose();
    _mobileNumberTextEConroller.dispose();
    _passwordTextEConroller.dispose();
    super.dispose();
  }
}
