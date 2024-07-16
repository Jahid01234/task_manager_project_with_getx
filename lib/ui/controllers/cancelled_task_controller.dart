import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/models/task_list_wrapper_model.dart';
import 'package:task_manager_project_with_getx/data/models/task_model.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/data/utilities/urls.dart';


class CancelledTaskController extends GetxController{

  bool _getCancelledTasksInProgress = false;
  List<TaskModel> _cancelledTasks = [];
  String _errorMessage = '';

  bool get getCancelledTasksInProgress => _getCancelledTasksInProgress;
  String get errorMessage => _errorMessage;
  List<TaskModel> get cancelledTasks => _cancelledTasks;

  //create Cancelled Task  api method
  Future<bool> getCancelledTasks() async {
    bool isSuccess = false;
    _getCancelledTasksInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(Urls.cancelledTasks);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel = TaskListWrapperModel.fromJson(response.responseData);
      _cancelledTasks = taskListWrapperModel.taskList ?? [];
      isSuccess = true;

    } else {
        _errorMessage = response.errorMessage ?? 'Get cancelled task failed! Try again';
    }

    _getCancelledTasksInProgress = false;
    update();
    return isSuccess;
  }

}