import 'package:flutter/material.dart';

enum TaskStatus{
  sNew,
  progress,
  completed,
  cancelled
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key, required this.taskStatus,
  });
  final TaskStatus taskStatus;



  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title Will be here",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text("Description write here"),
            Text("Date: 23/32/3233"),
            Row(
              children: [
                Chip(
                  label: Text(
                    "statusName",
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
                IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline)),
                IconButton(onPressed: (){}, icon: Icon(Icons.edit_outlined)),

              ],
            ),
          ],
        ),
      ),
    );
  }


  Color _getStatusChipColor(){
    late Color color;

   switch(taskStatus){

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



}