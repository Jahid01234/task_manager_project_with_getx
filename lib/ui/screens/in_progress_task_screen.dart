import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/ui/controllers/in_progress_task_controller.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/task_item.dart';


class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {


  @override
  void initState() {
    super.initState();
    Get.find<InProgressTaskController>().getProgressTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: GetBuilder<InProgressTaskController>(
        builder: (inProgressTaskController){
          return RefreshIndicator(
            onRefresh: ()async{
              await inProgressTaskController.getProgressTasks();
            },
            child: Visibility(
              visible: inProgressTaskController.getProgressTasksInProgress == false,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: ListView.builder(
                itemCount: inProgressTaskController.progressTasks.length,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel:inProgressTaskController.progressTasks[index],
                    onUpdateTask: () {  },
                  );
                },
              ),
            ),
          );
        },
      )
    );
  }

}