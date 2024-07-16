import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/ui/controllers/sign_up_controller.dart';
import 'package:task_manager_project_with_getx/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_project_with_getx/ui/utility/app_colors.dart';
import 'package:task_manager_project_with_getx/ui/widgets/background_widget.dart';
import 'package:task_manager_project_with_getx/ui/widgets/snack_bar_message.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;




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
                    const SizedBox(height: 80),
                    Text("Join With Us",style: Theme.of(context).textTheme.titleLarge,),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _firstNameTEController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          hintText: 'First Name'
                      ),
                      validator: (String? value){
                        if(value== null || value.isEmpty){
                          return "Please enter your first name";
                        }
                        else if(value.length>15){
                          return " The last name will be 15 Character";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _lastNameTEController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          hintText: 'Last Name'
                      ),
                      validator: (String? value){
                        if(value== null || value.isEmpty){
                          return "Please enter your last name";
                        }
                        else if(value.length>15){
                          return " The last name will be 15 Character";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    TextFormField(
                        controller: _mobileTEController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: 'Mobile'
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }

                          if (!RegExp(r'^(\+)|\d{11}$').hasMatch(value)) {
                            return 'Enter a valid mobile number.';
                          }
                          return null;
                        }

                    ),
                    const SizedBox(height: 8),

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
                    const SizedBox(height: 15),

                    GetBuilder<SignUpController>(
                        builder: (signUpController){
                          return Visibility(
                            visible: signUpController.registrationInProgress==false,
                            replacement:const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              onPressed: _onTapNextScreen,
                              child: const Icon(Icons.arrow_circle_right_outlined),
                            ),
                          );
                        }
                    ),


                    const SizedBox(height: 30),
                    _buildBackToSignInSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToSignInSection() {
    return Center(
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
                style: const TextStyle(color: AppColors.themeColor),
                recognizer: TapGestureRecognizer()..onTap= (){
                  _onTapSignInButton();
                }
            ),
          ],
        ),
      ),
    );
  }

Future<void> _onTapNextScreen() async{
  if(_formKey.currentState!.validate()){
    // call registration api
    final bool result = await Get.find<SignUpController>().registerUser(
        _emailTEController.text.trim(),
        _firstNameTEController.text,
        _lastNameTEController.text,
        _mobileTEController.text,
        _passwordTEController.text
    );
    if(result){
      _clearTextField();
      Get.off(()=> const SignInScreen());
      if(mounted) {
        showSnackBarMessage(context, "Sign Up successfully.");
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, Get.find<SignUpController>().errorMessage);
      }
    }
  }
}

  void _clearTextField(){
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  void _onTapSignInButton() {
    Get.off(()=> const SignInScreen());
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