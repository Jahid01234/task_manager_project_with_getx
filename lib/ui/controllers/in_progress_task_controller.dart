import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/models/task_list_wrapper_model.dart';
import 'package:task_manager_project_with_getx/data/models/task_model.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/data/utilities/urls.dart';

class InProgressTaskController extends GetxController{

  bool _getProgressTasksInProgress = false;
  List<TaskModel> _progressTasks = [];
  String _errorMessage = '';

  bool get getProgressTasksInProgress => _getProgressTasksInProgress;
  String get errorMessage => _errorMessage;
  List<TaskModel> get progressTasks => _progressTasks;

  //create Progress Task  api method
  Future<bool> getProgressTasks() async {

    bool isSuccess = false;
    _getProgressTasksInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(Urls.progressTasks);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel = TaskListWrapperModel.fromJson(response.responseData);
      _progressTasks = taskListWrapperModel.taskList ?? [];

      isSuccess = true;
    } else {
        _errorMessage = response.errorMessage ?? 'Get progress task failed! Try again';
    }
    _getProgressTasksInProgress = false;
    update();

    return isSuccess;
  }
}