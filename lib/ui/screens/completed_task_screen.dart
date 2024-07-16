import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/ui/controllers/completed_task_controller.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/task_item.dart';


class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {


  @override
  void initState() {
    super.initState();
    Get.find<CompletedTaskController>().getCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: GetBuilder<CompletedTaskController>(
        builder: (completedTaskController){
          return RefreshIndicator(
            onRefresh: ()async{
              await completedTaskController.getCompletedTasks();
            },
            child: Visibility(
              visible: completedTaskController.getCompletedTasksInProgress == false,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: ListView.builder(
                itemCount: completedTaskController.completedTasks.length,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: completedTaskController.completedTasks[index],
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