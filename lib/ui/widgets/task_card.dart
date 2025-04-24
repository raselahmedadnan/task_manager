import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

enum TaskStatus { sNew, progress, completed, cancelled }

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskStatus,
    required this.taskModel,
    required this.refreshList,
  });
  final TaskStatus taskStatus;
  final TaskModel taskModel;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    final getDate = DateTime.parse(widget.taskModel.createdDate);
    final formattedDate = DateFormat('dd-MMM-yyyy ').format(getDate.toLocal());

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(widget.taskModel.description),
            Text('Date: $formattedDate'),
            // ${taskModel.createdDate}
            Row(
              children: [
                Chip(
                  label: Text(
                    widget.taskModel.status,
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: _getStatusChipColor(),
                  side: BorderSide.none,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                ),
                Spacer(),
                Visibility(
                  visible: _inProgress == false,
                  replacement: Center(child: CircularProgressIndicator()),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _deleteTask,
                        icon: Icon(Icons.delete_outline),
                      ),
                      IconButton(
                        onPressed: _showUpdateStatusAlertDialog,
                        icon: Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusChipColor() {
    late Color color;

    switch (widget.taskStatus) {
      case TaskStatus.sNew:
        color = Colors.blue;
      case TaskStatus.progress:
        color = Colors.purple;
      case TaskStatus.completed:
        color = Colors.green;
      case TaskStatus.cancelled:
        color = Colors.red;
    }
    return color;
  }

  void _showUpdateStatusAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  _popAlertDialog();
                  if (isSelected("New")) return;
                  _onTabChangeUpdateStatus('New');
                },
                title: Text("New"),
                trailing: isSelected('New') ? Icon(Icons.done) : null,
              ),
              ListTile(
                onTap: () {
                  _popAlertDialog();
                  if (isSelected("Progress")) return;
                  _onTabChangeUpdateStatus('Progress');
                },
                title: Text("Progress"),
                trailing: isSelected('Progress') ? Icon(Icons.done) : null,
              ),
              ListTile(
                onTap: () {
                  _popAlertDialog();
                  if (isSelected("Complete")) return;
                  _onTabChangeUpdateStatus('Complete');
                },
                title: Text("Complete"),
                trailing: isSelected('Complete') ? Icon(Icons.done) : null,
              ),
              ListTile(
                onTap: () {
                  _popAlertDialog();
                  if (isSelected("Cancelled")) return;
                  _onTabChangeUpdateStatus('Cancelled');
                },
                title: Text("Cancelled"),
                trailing: isSelected('Cancelled') ? Icon(Icons.done) : null,
              ),
            ],
          ),
        );
      },
    );
  }

  void _popAlertDialog() {
    Navigator.pop(context);
  }

  bool isSelected(String status) => widget.taskModel.status == status;

  Future<void> _onTabChangeUpdateStatus(String status) async {
    _inProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.updateTaskStatusUrl(widget.taskModel.id, status),
    );
    _inProgress = false;
    setState(() {});
    if (response.isSuccess) {
      widget.refreshList();

    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  Future<void> _deleteTask() async {
    _inProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.deleteTaskUrl(widget.taskModel.id),
    );
    _inProgress = false;
    setState(() {});
    if (response.isSuccess) {
      showSnackBarMessage(context, "Your Task Delete Successfully");
      widget.refreshList();
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }
}
