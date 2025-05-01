import 'package:get/get.dart';
import 'package:task_manager/data/model/task_list_model.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';

class CancelledTaskListController extends GetxController{
 bool _getCancelledInProgress = false;
 List<TaskModel> _cancelledList = [];
 String? _errorMessage;


 bool get getCancelledInProgress => _getCancelledInProgress;
 List<TaskModel> get cancelledList => _cancelledList;
 String? get errorMessage => _errorMessage;


  Future<bool> getAllCancelledTaskList() async {
  bool isSuccess = false;

  _getCancelledInProgress = true;
    update();

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.cancelledTaskListUrl,
    );

    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});

      _cancelledList = taskListModel.taskList;

      isSuccess = true;
      _errorMessage = null;

    } else {
      _errorMessage = response.errorMessage;
    }
  _getCancelledInProgress = false;
    update();

    return isSuccess;
  }

}