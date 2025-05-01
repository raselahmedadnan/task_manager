import 'package:get/get.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controller/new_task_controller.dart';
import 'package:task_manager/ui/controller/task_status_count_controller.dart';

class AddNewTaskController extends GetxController{
bool _addNewTaskProgress = false;
bool get addNewTaskProgress => _addNewTaskProgress;

String? _errorMessage;
String? get errorMessage => _errorMessage;



  Future<bool> addNewTask(String title,String description,String date) async {
    bool isSuccess = false;

    _addNewTaskProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      "status": "New",
      "createdDate": date,
    };

    final NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.addNewTaskUrl,
      body: requestBody,
    );


    isSuccess = true;
    _errorMessage = null;

    if (response.isSuccess) {

      Get.find<NewTaskController>().getAllNewTaskList();
      Get.find<TaskStatusCountController>().getAllTaskStatusCount();

    } else{
      _errorMessage = response.errorMessage;
    }
    _addNewTaskProgress = false;
    update();
    return isSuccess;
  }


}