import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: ListView.separated(
          itemCount: 12,
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return TaskCard(taskStatus: TaskStatus.completed,);
          },
          separatorBuilder: (context, index) => SizedBox(height: 8),
        ),
      ),
    );
  }
}
