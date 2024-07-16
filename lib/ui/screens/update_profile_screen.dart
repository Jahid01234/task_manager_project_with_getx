import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/ui/controllers/update_profile_controller.dart';
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
                    enabled: false,
                  ),
                  const SizedBox(height: 15),

                  GetBuilder<UpdateProfileController>(
                      builder: (updateProfileController){
                        return Visibility(
                          visible: updateProfileController.updateProfileInProgress==false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            onPressed: _onTapUpdateScreen,
                            child: const Text('Update'),
                          ),
                        );
                      }
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
    return GetBuilder<UpdateProfileController>(
        builder: (updateProfileController){
          return GestureDetector(
            onTap: updateProfileController.pickProfileImage,
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
                    child: Text(updateProfileController.selectedImage?.name ?? 'No selected image.',
                      maxLines: 1,
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),

            ),
          );
        }
    );
  }



  Future<void> _onTapUpdateScreen() async {

      final bool result = await Get.find<UpdateProfileController>().
      updateProfile(
          _emailTEController.text,
          _firstNameTEController.text,
          _lastNameTEController.text,
          _mobileTEController.text,
          _passwordTEController.text
      );

      if (result) {
        Get.offAll(() => const MainBottomNavScreen());
        if(mounted) {
          showSnackBarMessage(context, "Update profile successfully.");
        }
      } else {
        if (mounted) {
          showSnackBarMessage(context, Get.find<UpdateProfileController>().errorMessage);
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