import 'package:get/get.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controller/cancelled_task_list_controller.dart';
import 'package:task_manager/ui/controller/new_task_controller.dart';
import 'package:task_manager/ui/controller/task_status_count_controller.dart';

class StatusUpdateDeleteController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> updateStatus(String id, String status) async {
    bool isSuccess = false;

    _inProgress = true;
    update();
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.updateTaskStatusUrl(id, status),
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }

  Future<bool> deleteTask(String id) async {
    bool isSuccess = false;

    _inProgress = true;
    update();
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.deleteTaskUrl(id),
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
