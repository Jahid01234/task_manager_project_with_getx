import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project_with_getx/data/models/login_model.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/data/utilities/urls.dart';
import 'package:task_manager_project_with_getx/ui/controllers/auth_controller.dart';
import 'package:task_manager_project_with_getx/ui/screens/auth/email_verification_screen.dart';
import 'package:task_manager_project_with_getx/ui/screens/auth/sign_up_screen.dart';
import 'package:task_manager_project_with_getx/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_project_with_getx/ui/utility/app_colors.dart';
import 'package:task_manager_project_with_getx/ui/widgets/background_widget.dart';
import 'package:task_manager_project_with_getx/ui/widgets/snack_bar_message.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _signInApiInProgress = false;
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
                    const SizedBox(height: 120),
                    Text(
                      "Get Started With",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
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
                    Visibility(
                      visible: _signInApiInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: _onTapNextButton,
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: _onTapForgotPasswordButton,
                            child: const Text("Forget Password?"),
                          ),
                          RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4),
                              children: [
                                TextSpan(
                                  text: 'Sign up',
                                  style: const TextStyle(
                                      color: AppColors.themeColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _onTapSignUpButton();
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
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



  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      // sing In Api calling
      _signIn();
    }
  }

  //login Api calling function
  Future<void> _signIn() async {
    _signInApiInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestData = {
      'email': _emailTEController.text.trim(),
      'password': _passwordTEController.text,
    };

    final NetworkResponse response =
    await NetworkCaller.postRequest(Urls.login, body: requestData);
    _signInApiInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {

      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveUserAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userModel!);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainBottomNavScreen(),
          ),
        );
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ??
              'Email/password is not correct. Try again',
        );
      }
    }
  }




  void _onTapSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _onTapForgotPasswordButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailVerificationScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}