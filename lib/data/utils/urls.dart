class Urls{
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';

  static const String registrationUrl = '$_baseUrl/Registration';
  static const String longinUrl = '$_baseUrl/Login';
  static const String recoverResetPassword = '$_baseUrl/RecoverResetPassword';
  static const String updateProfileUrl = '$_baseUrl/ProfileUpdate';
  static const String addNewTaskUrl = '$_baseUrl/createTask';
  static const String taskStatusCountUrl = '$_baseUrl/taskStatusCount';
  static const String newTaskListUrl = '$_baseUrl/listTaskByStatus/New';
  static const String cancelledTaskListUrl = '$_baseUrl/listTaskByStatus/Cancelled';
  static const String completedTaskListUrl = '$_baseUrl/listTaskByStatus/Complete';
  static const String progressTaskListUrl = '$_baseUrl/listTaskByStatus/Progress';
  static  String updateTaskStatusUrl (String id,status) => '$_baseUrl/updateTaskStatus/$id/$status';
  static  String deleteTaskUrl (String id) => '$_baseUrl/deleteTask/$id';
  static  String recoveryVerifyEmail(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static  String recoveryVerifyOtp(String email, otp) => '$_baseUrl/RecoverVerifyOtp/$email/$otp';



}