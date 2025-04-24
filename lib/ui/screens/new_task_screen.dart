
import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_list_model.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/model/task_status_count_lsit_model.dart';
import 'package:task_manager/data/model/task_status_count_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/add_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../widgets/summery_card.dart';
import '../widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getStatusCountInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];
  bool _getNewTaskInProgress = false;
  List<TaskModel> _newTaskList = [];


  @override
  void initState() {
    super.initState();
    _getAllTaskStatusCount();
    _getAllNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshScreen,
        child: ScreenBackground(
          child: SingleChildScrollView(
            child:  Column(
              children: [
                Visibility(
                  visible: _getStatusCountInProgress == false,
                  replacement: Center(child: CircularProgressIndicator()),
                  child: _buildSummerySection(),

                ),
                Visibility(
                  visible: _getNewTaskInProgress == false,
                  replacement: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                  child:_newTaskList.isEmpty ? Center(child: Text("Empty Data"),) : ListView.separated(
                    itemCount: _newTaskList.length,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskStatus: TaskStatus.sNew,
                        taskModel: _newTaskList[index],
                        refreshList: refreshStatusCountAndNewTaskList,

                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTabAddScreen,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummerySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _taskStatusCountList.length,
          itemBuilder: (context, index) {
            return SammeryCard(
              title: _taskStatusCountList[index].status,
              count: _taskStatusCountList[index].count,
            );
          },
        ),
      ),
    );

  }

  void _onTabAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddScreen()),
    );
  }

  Future<void> _getAllTaskStatusCount() async {
    _getStatusCountInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.taskStatusCountUrl,
    );
    if (response.isSuccess) {
      TaskStatusCountListModel taskStatusCountListModel =
          TaskStatusCountListModel.fromJson(response.data ?? {});

      _taskStatusCountList = taskStatusCountListModel.statusCountList;
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getStatusCountInProgress = false;
    setState(() {});
  }

  Future<void> _getAllNewTaskList() async {
    _getNewTaskInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.newTaskListUrl,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});

      _newTaskList = taskListModel.taskList;
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getNewTaskInProgress = false;
    setState(() {});
  }


  void refreshStatusCountAndNewTaskList(){
    _getAllNewTaskList();
    _getAllTaskStatusCount();
  }

  Future<void> _refreshScreen()async{
    await Future.delayed(Duration());
    setState(() {

    });
  }
}
