import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/cancelled_task_list_controller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

final CancelledTaskListController cancelledTaskListController = Get.find<CancelledTaskListController>();
  @override
  void initState() {
    super.initState();
    _getAllCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: GetBuilder<CancelledTaskListController>(
          builder: (controller) {
            return Visibility(
              visible: controller.getCancelledInProgress == false,
              replacement: Center(child: CircularProgressIndicator()),
              child: controller.cancelledList.isEmpty ? Center(child: Text("Empty Data"),) : ListView.separated(
                itemCount: controller.cancelledList.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskStatus: TaskStatus.cancelled,
                    taskModel: controller.cancelledList[index],
                    reloadScreen: _getAllCancelledTaskList,
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

  Future<void> _getAllCancelledTaskList() async {
    bool isSuccess = await Get.find<CancelledTaskListController>().getAllCancelledTaskList();

    if (!isSuccess) {
      showSnackBarMessage(context, cancelledTaskListController.errorMessage!,true);
    }
  }
}
