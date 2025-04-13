import 'package:flutter/material.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tmappbar.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _discriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addNewTaskProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Add New Task",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: "Subject"),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter your title";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 08),
                  TextFormField(
                    maxLines: 8,
                    decoration: InputDecoration(hintText: "Description"),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter your Description";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Visibility(
                    visible: _addNewTaskProgress == false,
                    replacement: Center(child: CircularProgressIndicator(),),
                    child: ElevatedButton(
                      onPressed: _onTabSubmitButton,
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTabSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    _addNewTaskProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "title": _titleTEController.text.trim(),
      "description": _discriptionTEController.text.trim(),
      "status": "New",
    };

    final NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.addNewTaskUrl,
      body: requestBody,
    );
    _addNewTaskProgress = false;
    setState(() {});

    if(response.isSuccess){
      _clearTextField();
      showSnackBarMessage(context, 'Your new task add successfully');
    }else{
      showSnackBarMessage(context, response.errorMessage);
    }
  }
  void _clearTextField(){
    _titleTEController.clear();
    _discriptionTEController.clear();
  }

  @override
  void dispose() {
   _titleTEController.dispose();
   _discriptionTEController.dispose();
    super.dispose();
  }
}
