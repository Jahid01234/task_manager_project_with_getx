import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/models/task_list_wrapper_model.dart';
import 'package:task_manager_project_with_getx/data/models/task_model.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/data/utilities/urls.dart';

class CompletedTaskController extends GetxController{
  bool _getCompletedTasksInProgress = false;
  List<TaskModel> _completedTasks = [];
  String _errorMessage = '';

  bool get getCompletedTasksInProgress => _getCompletedTasksInProgress;
  String get errorMessage => _errorMessage;
  List<TaskModel> get completedTasks => _completedTasks;

  //create Completed Task  api method
  Future<bool> getCompletedTasks() async {

    bool isSuccess = false;
    _getCompletedTasksInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(Urls.completedTasks);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel = TaskListWrapperModel.fromJson(response.responseData);
      _completedTasks = taskListWrapperModel.taskList ?? [];

      isSuccess = true;
    } else {
        _errorMessage = response.errorMessage ?? 'Get completed task failed! Try again';
    }
    _getCompletedTasksInProgress = false;
    update();

    return isSuccess;
  }
}