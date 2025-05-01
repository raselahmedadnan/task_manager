import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/progress_task_list_controller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  final ProgressTaskListController progressTaskListController = Get.find<ProgressTaskListController>();


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
        child: GetBuilder<ProgressTaskListController>(
          builder: (controller) {
            return Visibility(
              visible: controller.progressInProgress == false,
              replacement: Center(child: CircularProgressIndicator()),
              child: controller.progressList.isEmpty ? Center(child: Text("Empty Data"),) : ListView.separated(
                itemCount: controller.progressList.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskStatus: TaskStatus.progress,
                    taskModel: controller.progressList[index],
                    reloadScreen: _getAllProgressTaskList,

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

  Future<void> _getAllProgressTaskList() async {
   bool isSuccess = await progressTaskListController.getAllProgressTaskList();

    if (!isSuccess) {
      showSnackBarMessage(context, progressTaskListController.errorMessage!,true);
    }
  }
}
