import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/data/utilities/urls.dart';

class EmailVerificationController extends GetxController{

  bool _emailVerificationInProgress = false;
   String _errorMessage = '';

  bool get emailVerificationInProgress => _emailVerificationInProgress;
  String get errorMessage => _errorMessage;

  // Email verification api method
  Future<bool> emailVerification(String email) async {
    bool isSuccess = false;
    _emailVerificationInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
      Urls.recoverVerifyEmail(email),
    );

    if (response.isSuccess && response.responseData['status'] == 'success') {

      isSuccess = true;
    } else {
          _errorMessage = response.errorMessage ?? 'Email verification failed! Try again';
    }
    _emailVerificationInProgress = false;
    update();
    return isSuccess;
  }

}