import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_by_status_count_wrapper_model.dart';
import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../utility/app_colors.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summary_card.dart';
import 'add_new_task_screen.dart';


class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  bool _getNewTasksInProgress = false;
  List<TaskModel> newTaskList = [];

  bool _getTaskCountByStatusInProgress = false;
  List<TaskCountByStatusModel> taskCountByStatusList = [];

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
    _getNewTasks();
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
              child: RefreshIndicator(
                onRefresh: () async {
                  _getNewTasks();
                  _getTaskCountByStatus();
                },
                child: Visibility(
                  visible: _getNewTasksInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ListView.builder(
                    itemCount: newTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        taskModel: newTaskList[index],
                        onUpdateTask: () {
                          _getTaskCountByStatus();
                          _getNewTasks();
                        },
                      );
                    },
                  ),
                ),
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
    return Visibility(
      visible: _getTaskCountByStatusInProgress == false,
      replacement: const SizedBox(
        height: 100,
        child:  Center(
          child: CircularProgressIndicator(),
        ),
      ),
      child:  SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: taskCountByStatusList.map((e) {
            return TaskSummaryCard(
              title: (e.sId ?? 'Unknown').toUpperCase(),
              count: e.sum.toString(),
            );
          }).toList(),
        ),
      ),
    );
  }


  //create New Task  api method
  Future<void> _getNewTasks() async {
    _getNewTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel = TaskListWrapperModel.fromJson(response.responseData);
      newTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Get new task failed! Try again');
      }
    }
    _getNewTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  //create Task Count api method
  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
      TaskCountByStatusWrapperModel.fromJson(response.responseData);
      taskCountByStatusList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'Get task count by status failed! Try again',
        );
      }
    }
    _getTaskCountByStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }



}