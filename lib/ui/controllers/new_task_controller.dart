import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/models/task_by_status_count_wrapper_model.dart';
import 'package:task_manager_project_with_getx/data/models/task_count_by_status_model.dart';
import 'package:task_manager_project_with_getx/data/models/task_list_wrapper_model.dart';
import 'package:task_manager_project_with_getx/data/models/task_model.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/data/utilities/urls.dart';




class NewTaskController extends GetxController {

  // get task api calling /////////////////////
  bool _getNewTasksInProgress = false;
  List<TaskModel> _taskList = [];
  String _errorMessage = '';

  bool get getNewTasksInProgress => _getNewTasksInProgress;
  List<TaskModel> get newTaskList => _taskList;
  String get errorMessage => _errorMessage;

  Future<bool> getNewTasks() async {
    bool isSuccess = false;
    _getNewTasksInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      _taskList = taskListWrapperModel.taskList ?? [];
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Get new task failed! Try again';
    }

    _getNewTasksInProgress = false;
    update();

    return isSuccess;
  }

  // task count api calling //////////////////////////////
  bool _getTaskCountByStatusInProgress = false;
  List<TaskCountByStatusModel> _taskCountByStatusList = [];
  String _errorMessage1 = '';

  bool get getTaskCountByStatusInProgress => _getTaskCountByStatusInProgress;
  List<TaskCountByStatusModel> get taskCountByStatusList => _taskCountByStatusList;
  String get errorMessage1 => _errorMessage1;


  Future<bool> getTaskCountByStatus() async {

    bool isSuccess = false;
    _getTaskCountByStatusInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(Urls.taskStatusCount);

    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
      TaskCountByStatusWrapperModel.fromJson(response.responseData);
      _taskCountByStatusList = taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
      isSuccess = true;
    } else {
       _errorMessage1  = response.errorMessage ?? 'Get task count by status failed! Try again';
    }
    _getTaskCountByStatusInProgress = false;
    update();
    return isSuccess;
  }

}