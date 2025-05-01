import 'package:get/get.dart';
import 'package:task_manager/data/model/task_list_model.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';

class ProgressTaskListController extends GetxController{
bool _progressInProgress = false;
List<TaskModel> _progressList = [];
String? _errorMessage;

bool get progressInProgress => _progressInProgress;
List<TaskModel> get progressList => _progressList;
String? get errorMessage => _errorMessage;

  Future<bool> getAllProgressTaskList() async {
    bool isSuccess = false;

    _progressInProgress = true;
    update();

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.progressTaskListUrl,
    );

    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});

      _progressList = taskListModel.taskList;

      isSuccess = true;
      _errorMessage = null;


    } else {
      _errorMessage = response.errorMessage;
    }
    _progressInProgress = false;
   update();

   return isSuccess;
  }

}