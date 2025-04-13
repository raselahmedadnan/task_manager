import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/new_task_screen.dart';
import 'package:task_manager/ui/screens/progress_task_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../widgets/tmappbar.dart';
import 'cancelled_task_screen.dart';
import 'completed_task_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens =[
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    

    return SafeArea(
      child: Scaffold(
        appBar: TMAppBar(),
        body: ScreenBackground(child: _screens[_selectedIndex]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            _selectedIndex = index;
            setState(() {});
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.new_label),
              label: 'New Task',
            ),
            NavigationDestination(
              icon: Icon(Icons.circle_outlined),
              label: 'Progress',
            ),
            NavigationDestination(icon: Icon(Icons.done), label: 'Complete'),
            NavigationDestination(
              icon: Icon(Icons.cancel_outlined),
              label: 'Cancelled',
            ),
          ],
        ),
      ),
    );
  }
}


