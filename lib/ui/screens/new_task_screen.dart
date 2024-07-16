import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/ui/controllers/new_task_controller.dart';
import '../utility/app_colors.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summary_card.dart';
import 'add_new_task_screen.dart';


class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {


  @override
  void initState() {
    super.initState();
    _initialCall();
  }

  Future<void> _initialCall() async{
    await Get.find<NewTaskController>().getTaskCountByStatus();
    await Get.find<NewTaskController>().getNewTasks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Column(
          children: [
            _buildSummarySection(),
            const SizedBox(height: 5),
            Expanded(
              child: GetBuilder<NewTaskController>(
                builder: (newTaskController){
                  return RefreshIndicator(
                    onRefresh: () async {
                      await _initialCall();
                    },
                    child: Visibility(
                      visible: newTaskController.getNewTasksInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ListView.builder(
                        itemCount: newTaskController.newTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskItem(
                            taskModel: newTaskController.newTaskList[index],
                            onUpdateTask: () async{
                              await _initialCall();
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.themeColor,
          onPressed: _onTapAddButton,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)
          ),
          child: const  Icon(Icons.add,color: Colors.white,)
      ),
    );
  }

  void _onTapAddButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
  }

  Widget _buildSummarySection() {
    return GetBuilder<NewTaskController>(
        builder: (taskController){
          return Visibility(
            visible: taskController.getTaskCountByStatusInProgress == false,
            replacement: const SizedBox(
              height: 100,
              child:  Center(
                child: CircularProgressIndicator(),
              ),
            ),
            child:  SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: taskController.taskCountByStatusList.map((e) {
                  return TaskSummaryCard(
                    title: (e.sId ?? 'Unknown').toUpperCase(),
                    count: e.sum.toString(),
                  );
                }).toList(),
              ),
            ),
          );
        }
    );
  }
}