import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: ListView.separated(
          itemCount: 12,
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return TaskCard(taskStatus: TaskStatus.progress,);
          },
          separatorBuilder: (context, index) => SizedBox(height: 8),
        ),
      ),
    );
  }
}
