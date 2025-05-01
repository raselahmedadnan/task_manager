import 'package:get/get.dart';
import 'package:task_manager/ui/controller/add_new_task_controller.dart';
import 'package:task_manager/ui/controller/cancelled_task_list_controller.dart';
import 'package:task_manager/ui/controller/completed_task_list_controller.dart';
import 'package:task_manager/ui/controller/forgot_password_pin_verification_controller.dart';
import 'package:task_manager/ui/controller/login_controller.dart';
import 'package:task_manager/ui/controller/new_task_controller.dart';
import 'package:task_manager/ui/controller/profile_update_controller.dart';
import 'package:task_manager/ui/controller/progress_task_list_controller.dart';
import 'package:task_manager/ui/controller/register_user_controller.dart';
import 'package:task_manager/ui/controller/reset_password_controller.dart';
import 'package:task_manager/ui/controller/status_update_delete_controller.dart';
import 'package:task_manager/ui/controller/task_status_count_controller.dart';

import 'ui/controller/forgot_password_verify_email_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
   Get.put(LoginController());
   Get.put(RegisterUserController());
   Get.put(ProfileUpdateController());
   Get.put(NewTaskController());
   Get.put(TaskStatusCountController());
   Get.put(StatusUpdateDeleteController());
   Get.put(AddNewTaskController());
   Get.put(ForgotPasswordVerifyEmailController());



   Get.lazyPut(() => CancelledTaskListController());
   Get.lazyPut(() => CompletedTaskListController());
   Get.lazyPut(() => ProgressTaskListController());
   Get.lazyPut(() => ForgotPasswordPinVerificationController());
   Get.lazyPut(() => ResetPasswordController());


  }

}