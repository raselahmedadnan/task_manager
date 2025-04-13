class Urls{
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';

  static const String registrationUrl = '$_baseUrl/Registration';
  static const String longinUrl = '$_baseUrl/Login';
  static  String recoveryVerifyEmail(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static  String recoveryVerifyOtp(String email, otp) => '$_baseUrl/RecoverVerifyOtp/$email/$otp';
  static const String RecoverResetPassword = '$_baseUrl/RecoverResetPassword';
  static const String updateProfileUrl = '$_baseUrl/ProfileUpdate';
  static const String addNewTaskUrl = '$_baseUrl/createTask';


}