import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/data/utilities/urls.dart';

class SignUpController extends GetxController{

  bool  _registrationInProgress = false;
  String _errorMessage = '';

  bool get registrationInProgress => _registrationInProgress;
  String get errorMessage => _errorMessage;

  // post api calling
  Future<bool> registerUser(
      String email,
      String firstName,
      String lastName,
      String mobile,
      String password
      ) async{

    bool isSuccess = false;
    _registrationInProgress = true;
    update();

    // prepare the data
    Map<String, dynamic> requestInput ={
      "email":email,
      "firstName":firstName,
      "lastName":lastName,
      "mobile":mobile,
      "password":password,
      "photo":""
    };

    NetworkResponse response = await NetworkCaller.postRequest(
        Urls.registration,
        body: requestInput
    );

    if(response.isSuccess){
       isSuccess = true;
    }else{
        _errorMessage= response.errorMessage ?? "Registration failed! Please try again.";

    }

    _registrationInProgress = false;
    update();
    return isSuccess;
  }


}