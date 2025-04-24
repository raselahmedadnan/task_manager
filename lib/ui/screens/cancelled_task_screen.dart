import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_list_model.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getcancelledInProgress = false;
  List<TaskModel> _cancelledList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Visibility(
          visible: _getcancelledInProgress == false,
          replacement: Center(child: CircularProgressIndicator()),
          child: _cancelledList.isEmpty ? Center(child: Text("Entey Data"),) : ListView.separated(
            itemCount: _cancelledList.length,
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return TaskCard(
                taskStatus: TaskStatus.cancelled,
                taskModel: _cancelledList[index],
                refreshList: _getAllCancelledTaskList,

              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 8),
          ),
        ),
      ),
    );
  }

  Future<void> _getAllCancelledTaskList() async {
    _getcancelledInProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.cancelledTaskListUrl,
    );

    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});

      _cancelledList = taskListModel.taskList;
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getcancelledInProgress = false;
    setState(() {});
  }
}
