import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/data/models/login_model.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/data/utilities/urls.dart';
import 'package:task_manager_project_with_getx/ui/controllers/auth_controller.dart';


class ResetPasswordController extends GetxController{
  bool _resetPasswordInProgress = false;
  String _errorMessage = '';

  bool get resetPasswordInProgress => _resetPasswordInProgress;
  String get errorMessage => _errorMessage;


  //Rest password Api calling function
  Future<bool> resetPassword(String email, String otp, String password, String? cPassword) async {
    if (password != cPassword ) {
      Get.snackbar("Warnings" ,"Passwords do not match.");
      //return false;
    }

    bool isSuccess = false;
    _resetPasswordInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      "email":email,
      "OTP": otp,
      "password": password
    };

    final NetworkResponse response =
    await NetworkCaller.postRequest(Urls.recoverResetPass, body: requestData);

    if (response.isSuccess) {
      // Debug: Print response data to ensure password is being reset
      print("Reset Password Response: ${response.responseData}");

      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveUserData(loginModel.userModel!);
      await AuthController.saveUserAccessToken(loginModel.token!);

      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Reset password failed. Try again';

    }

    _resetPasswordInProgress = false;
    update();

     return isSuccess ;
  }

}