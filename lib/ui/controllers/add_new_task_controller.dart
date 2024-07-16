import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/data/utilities/urls.dart';

class AddNewTaskController extends GetxController{
  bool _addNewTaskInProgress = false;
  String _errorMessage = '';

  bool get addNewTaskInProgress => _addNewTaskInProgress;
  String get errorMessage => _errorMessage;


  // crate new task Api calling here
  Future<bool> addNewTask(String title, String description) async {
    bool isSuccess = false;
    _addNewTaskInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      "title": title,
      "description": description,
      'createdDate': DateTime.now().toString(),
      "status": "New",
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      Urls.createTask,
      body: requestData,
    );


    if (response.isSuccess) {
         isSuccess = true;
    } else {
        _errorMessage = response.errorMessage ?? 'New task add failed! Try again.';
    }
    _addNewTaskInProgress = false;
    update();

    return isSuccess;
  }

}