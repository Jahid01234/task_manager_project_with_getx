import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/data/models/login_model.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/data/utilities/urls.dart';
import 'package:task_manager_project_with_getx/ui/controllers/auth_controller.dart';


class SignInController extends GetxController {
  // private variable does not access other class
  bool _signInApiInProgress = false;
  String _errorMessage = '';

  bool get signInApiInProgress => _signInApiInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {

    bool isSuccess = false;
    _signInApiInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      'email': email,
      'password': password,
    };

    final NetworkResponse response =
    await NetworkCaller.postRequest(Urls.login, body: requestData);

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveUserAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userModel!);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Login failed! Try again';
    }

    _signInApiInProgress = false;
    update();

    return isSuccess;
  }
}