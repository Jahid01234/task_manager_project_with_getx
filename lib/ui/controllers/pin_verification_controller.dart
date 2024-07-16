
import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/data/utilities/urls.dart';

class PinVerificationController extends GetxController{

  bool _pinVerificationInProgress = false;
  String _errorMessage = '';

  bool get pinVerificationInProgress => _pinVerificationInProgress;
  String get errorMessage => _errorMessage;


  // pin verification api method
  Future<bool> pinVerification(String email, String otp) async {

    bool isSuccess = false;
    _pinVerificationInProgress = true;
     update();

    NetworkResponse response = await NetworkCaller.getRequest(
      Urls.recoverVerifyOTP(email,otp),
    );

    if (response.isSuccess && response.responseData['status'] == 'success') {
       isSuccess = true;
    } else {
        _errorMessage = response.errorMessage ?? 'Failed to send verification pin.';

    }
    _pinVerificationInProgress = false;
    update();
    return isSuccess;

  }


}