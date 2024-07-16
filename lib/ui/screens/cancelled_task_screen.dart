import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/ui/controllers/cancelled_task_controller.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_item.dart';


class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {


  @override
  void initState() {
    super.initState();
    Get.find<CancelledTaskController>().getCancelledTasks();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: GetBuilder<CancelledTaskController>(
        builder: (cancelledTaskController){
          return RefreshIndicator(
            onRefresh: ()async{
              await cancelledTaskController.getCancelledTasks();
            },
            child: Visibility(
              visible: cancelledTaskController.getCancelledTasksInProgress == false,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: ListView.builder(
                itemCount: cancelledTaskController.cancelledTasks.length,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: cancelledTaskController.cancelledTasks[index],
                    onUpdateTask: () {  },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }


}