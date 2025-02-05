import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/ui/controllers/reset_password_controller.dart';
import 'package:task_manager_project_with_getx/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_project_with_getx/ui/utility/app_colors.dart';
import 'package:task_manager_project_with_getx/ui/widgets/background_widget.dart';
import 'package:task_manager_project_with_getx/ui/widgets/snack_bar_message.dart';


class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword= false;
  bool _showConfirmPassword= false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Set Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Minimum length of password should be more than 6 letters and, combination of numbers and letters',
                      style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      obscureText: _showPassword==false,
                      controller: _passwordTEController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword?Icons.visibility:Icons.visibility_off,
                            color: Colors.cyan,
                          ),
                          onPressed: (){
                            _showPassword = !_showPassword;
                            if(mounted){
                              setState(() {});
                            }
                          },

                        ),
                      ),
                      validator: (String? value){
                        if(value==null || value.isEmpty){
                          return "Please enter your password";
                        }
                        else if(value.length<=7){
                          return " Please enter 8 character";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      obscureText: _showConfirmPassword==false,
                      controller: _confirmPasswordTEController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword?Icons.visibility:Icons.visibility_off,
                            color: Colors.cyan,
                          ),
                          onPressed: (){
                            _showConfirmPassword = !_showConfirmPassword;
                            if(mounted){
                              setState(() {});
                            }
                          },

                        ),
                      ),
                      validator: (String? value){
                        if(value==null || value.isEmpty){
                          return "Please enter your confirm password";
                        }
                        else if(value.length<=7){
                          return " Please enter 8 character";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    GetBuilder<ResetPasswordController>(
                        builder: (resetPasswordController){
                          return Visibility(
                            visible: resetPasswordController.resetPasswordInProgress==false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              onPressed: _onTapConfirmButton,
                              child: const Text("Confirm"),
                            ),
                          );
                        }
                    ),

                    const SizedBox(height: 40),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Have an account? ",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            //letterSpacing:
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: const TextStyle(
                                  color: AppColors.themeColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _onTapSignInButton();
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
    );
  }

 Future<void> _onTapConfirmButton() async{
    if(_formKey.currentState!.validate()){
      final bool result = await Get.find<ResetPasswordController>().
      resetPassword(
          widget.email,
          widget.otp,
          _passwordTEController.text,
        _confirmPasswordTEController.text
      );
      if(result){
        Get.off(()=> const SignInScreen() );
        if(mounted) {
          showSnackBarMessage(context, "Reset password successfully.");
        }
      }else{
        if(mounted) {
          showSnackBarMessage(context, Get.find<ResetPasswordController>().errorMessage);
        }
      }
    }
  }






  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}