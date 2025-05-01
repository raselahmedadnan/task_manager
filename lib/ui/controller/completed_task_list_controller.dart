import 'package:get/get.dart';
import 'package:task_manager/data/model/task_list_model.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';

class CompletedTaskListController extends GetxController{
bool _completedInProgress = false;
 List<TaskModel> _completedList =[];
 String? _errorMessage;


bool get completedInProgress => _completedInProgress;
List<TaskModel> get completedList => _completedList;
String? get errorMessage=> _errorMessage;



  Future<bool> getAllCompletedTaskList() async {
    bool isSuccess = false;

    _completedInProgress = true;
   update();

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.completedTaskListUrl,
    );

    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});

      _completedList = taskListModel.taskList;

      isSuccess = true;
      _errorMessage = null;

    } else {
     _errorMessage =  response.errorMessage;
    }
    _completedInProgress = false;
    update();

    return isSuccess;
  }

}