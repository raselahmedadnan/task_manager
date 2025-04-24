import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_list_model.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _progressInProgress = false;
  List<TaskModel> _progressList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Visibility(
          visible: _progressInProgress == false,
          replacement: Center(child: CircularProgressIndicator()),
          child: _progressList.isEmpty ? Center(child: Text("Entey Data"),) : ListView.separated(
            itemCount: _progressList.length,
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return TaskCard(
                taskStatus: TaskStatus.progress,
                taskModel: _progressList[index],
                refreshList: _getAllProgressTaskList,
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 8),
          ),
        ),
      ),
    );
  }

  Future<void> _getAllProgressTaskList() async {
    _progressInProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.progressTaskListUrl,
    );

    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});

      _progressList = taskListModel.taskList;
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _progressInProgress = false;
    setState(() {});
  }
}
