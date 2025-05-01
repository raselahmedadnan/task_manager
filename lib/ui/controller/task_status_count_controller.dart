import 'package:get/get.dart';
import 'package:task_manager/data/model/task_status_count_lsit_model.dart';
import 'package:task_manager/data/model/task_status_count_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';

class TaskStatusCountController extends GetxController {
  bool _getStatusCountInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];
  String? _errorMessage;

  bool get getStatusCountInProgress => _getStatusCountInProgress;
  List<TaskStatusCountModel> get taskStatusCountList => _taskStatusCountList;
  String? get errorMessage => _errorMessage;

  Future<bool> getAllTaskStatusCount() async {
    bool isSuccess = false;

    _getStatusCountInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.taskStatusCountUrl,
    );
    if (response.isSuccess) {
      TaskStatusCountListModel taskStatusCountListModel =
          TaskStatusCountListModel.fromJson(response.data ?? {});

      _taskStatusCountList = taskStatusCountListModel.statusCountList;

      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _getStatusCountInProgress = false;
    update();

    return isSuccess;
  }
}
