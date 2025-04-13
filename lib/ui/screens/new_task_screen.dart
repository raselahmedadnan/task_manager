import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/add_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../widgets/summery_card.dart';
import '../widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSummerySection(),
              ListView.separated(
                itemCount: 12,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TaskCard(taskStatus: TaskStatus.sNew);
                },
                separatorBuilder: (context, index) => SizedBox(height: 8),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SammeryCard(title: 'New', count: 38),
            SammeryCard(title: 'Progress', count: 24),
            SammeryCard(title: 'Completed', count: 12),
            SammeryCard(title: 'Cancelled', count: 16),
          ],
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
}
