import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/completed_task_list_controller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

CompletedTaskListController completedTaskListController = Get.find<CompletedTaskListController>();

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
        child: GetBuilder<CompletedTaskListController>(
          builder: (controller) {
            return Visibility(
              visible: controller.completedInProgress == false,
              replacement: Center(child: CircularProgressIndicator()),
              child: controller.completedList.isEmpty ? Center(child: Text("Empty Data"),) : ListView.separated(
                itemCount: controller.completedList.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskStatus: TaskStatus.completed,
                    taskModel: controller.completedList[index],
                    reloadScreen: _getAllCompletedTaskList,


                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 8),
              ),
            );
          }
        ),
      ),
    );
  }

  Future<void> _getAllCompletedTaskList() async {
    bool isSuccess = await completedTaskListController.getAllCompletedTaskList();


    if (!isSuccess) {
    showSnackBarMessage(context, completedTaskListController.errorMessage!,true);
    }

  }
}
