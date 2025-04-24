import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_list_model.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _completedInProgress = false;
  List<TaskModel> _completedList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Visibility(
          visible: _completedInProgress == false,
          replacement: Center(child: CircularProgressIndicator()),
          child: _completedList.isEmpty ? Center(child: Text("Entey Data"),) : ListView.separated(
            itemCount: _completedList.length,
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return TaskCard(
                taskStatus: TaskStatus.completed,
                taskModel: _completedList[index],
                refreshList: _getAllCompletedTaskList,

              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 8),
          ),
        ),
      ),
    );
  }

  Future<void> _getAllCompletedTaskList() async {
    _completedInProgress = true;
    setState(() {});

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.completedTaskListUrl,
    );

    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});

      _completedList = taskListModel.taskList;
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _completedInProgress = false;
    setState(() {});
  }
}
