import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/models/user_model.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/ui/controllers/auth_controller.dart';
import '../../data/utilities/urls.dart';

class UpdateProfileController extends GetxController{

  bool _updateProfileInProgress = false;
  String _errorMessage = '';
  XFile? _selectedImage;

  bool get updateProfileInProgress => _updateProfileInProgress;
  String get errorMessage => _errorMessage;
  XFile? get selectedImage =>  _selectedImage;


  // Update profile Api calling
  Future<bool> updateProfile(String email, String firstName, String lastName, String mobile, String password) async {

    bool isSuccess = false;
    _updateProfileInProgress = true;
    String encodePhoto = AuthController.userData?.photo ?? '';
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (password.isNotEmpty) {
      requestBody['password'] = password;
    }

    if (_selectedImage != null) {
      File file = File(_selectedImage!.path);
      encodePhoto = base64Encode(file.readAsBytesSync());
      requestBody['photo'] = encodePhoto;
    }
    final NetworkResponse response =
    await NetworkCaller.postRequest(Urls.updateProfile, body: requestBody);

    if (response.isSuccess && response.responseData['status'] == 'success') {
      UserModel userModel = UserModel(
        email: email,
        photo: encodePhoto,
        firstName: firstName,
        lastName: lastName,
        mobile: mobile
      );
      await AuthController.saveUserData(userModel);
      isSuccess = true;

    } else {
           _errorMessage = response.errorMessage ?? 'Profile update failed! Try again';
    }

    _updateProfileInProgress = false;
    update();

    return isSuccess;
  }

  // image picker function
  Future<void> pickProfileImage()async{
    final imagePicker = ImagePicker();
    final XFile? result = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (result != null) {
      _selectedImage = result;
      update();
    }
  }
}