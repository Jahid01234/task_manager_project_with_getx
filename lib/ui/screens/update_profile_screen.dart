import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/network_response.dart';
import '../../data/models/user_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../controllers/auth_controller.dart';
import '../widgets/background_widget.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/snack_bar_message.dart';
import 'main_bottom_nav_screen.dart';


class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateProfileInProgress = false;
  XFile? _selectedImage;


  @override
  void initState() {
    super.initState();
    final userData = AuthController.userData!;
    _emailTEController.text = userData.email ?? '';
    _firstNameTEController.text = userData.firstName ?? '';
    _lastNameTEController.text = userData.lastName ?? '';
    _mobileTEController.text = userData.mobile ?? '';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: profileAppBar(context,true),
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text("Update Profile",style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildPhotoPickerWidget(),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'Email'
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _firstNameTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: 'First Name'
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _lastNameTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: 'Last Name'
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: 'Mobile'
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _passwordTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: 'Password'
                    ),
                  ),
                  const SizedBox(height: 15),
                  Visibility(
                    visible: _updateProfileInProgress==false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      child: const Text('Update'),
                    ),
                  ),
                  const SizedBox(height: 15),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPickerWidget() {
    return GestureDetector(
      onTap: _pickProfileImage,
      child: Container(
        width: double.maxFinite,
        height: 48,
        alignment: Alignment.centerLeft,
        decoration:  BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 48,
              alignment: Alignment.center,
              decoration:  const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),

                  )
              ),
              child: const Text("Photo",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15
              ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(_selectedImage?.name ?? 'No selected image.',
                maxLines: 1,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),

      ),
    );
  }

  // Update profile Api calling
  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    String encodePhoto = AuthController.userData?.photo ?? '';
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text,
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };

    if (_passwordTEController.text.isNotEmpty) {
      requestBody['password'] = _passwordTEController.text;
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
        email: _emailTEController.text,
        photo: encodePhoto,
        firstName: _firstNameTEController.text.trim(),
        lastName: _lastNameTEController.text.trim(),
        mobile: _mobileTEController.text.trim(),
      );
      await AuthController.saveUserData(userModel);
      if (mounted) {
        showSnackBarMessage(context, 'Profile updated!');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainBottomNavScreen(),
          ),
              (route) => false,
        );
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Profile update failed! Try again');
      }
    }
    _updateProfileInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }


  // image picker function
  Future<void> _pickProfileImage()async{
    final imagePicker = ImagePicker();
    final XFile? result = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (result != null) {
      _selectedImage = result;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }

}