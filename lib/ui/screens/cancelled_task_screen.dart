import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: ListView.separated(
          itemCount: 12,
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return TaskCard(taskStatus: TaskStatus.cancelled,);
          },
          separatorBuilder: (context, index) => SizedBox(height: 8),
        ),
      ),
    );
  }
}
