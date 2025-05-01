
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/new_task_controller.dart';
import 'package:task_manager/ui/controller/task_status_count_controller.dart';
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

  final NewTaskController newTaskController = Get.find<NewTaskController>();
  final TaskStatusCountController taskStatusCountController = Get.find<TaskStatusCountController>();



  @override
  void initState() {
    super.initState();
    _getAllTaskStatusCount();
    _getAllNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child:  Column(
            children: [
              GetBuilder<TaskStatusCountController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.getStatusCountInProgress == false,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: _buildSummerySection(),

                  );
                }
              ),
              GetBuilder<NewTaskController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.getNewTaskInProgress == false,
                    replacement: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),

                    child:controller.newTaskList.isEmpty ? Center(child: Text("Empty Data"),) :

                    ListView.separated(
                      itemCount: controller.newTaskList.length,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskStatus: TaskStatus.sNew,
                          taskModel: controller.newTaskList[index],
                          reloadScreen: _reloadScreen,


                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                    ),
                  );
                }
              ),
            ],
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
              itemCount: taskStatusCountController.taskStatusCountList.length,
              itemBuilder: (context, index) {
                return SammeryCard(
                  title: taskStatusCountController.taskStatusCountList[index].status,
                  count: taskStatusCountController.taskStatusCountList[index].count,
                );
              },


        ),
      ),
    );

  }

  void _onTabAddScreen() {
    Get.to(AddScreen());
  }

  Future<void> _getAllTaskStatusCount() async {
    bool isSuccess = await taskStatusCountController.getAllTaskStatusCount();
    if (!isSuccess) {
      showSnackBarMessage(context, taskStatusCountController.errorMessage!, true);
    }

  }

  Future<void> _getAllNewTaskList() async {
  bool isSuccess = await newTaskController.getAllNewTaskList();

    if (!isSuccess){
      showSnackBarMessage(context, newTaskController.errorMessage!, true);
    }

  }

  void _reloadScreen(){
    _getAllNewTaskList();
    _getAllTaskStatusCount();
  }

}
