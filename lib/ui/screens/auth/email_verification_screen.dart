import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project_with_getx/ui/screens/auth/pin_verification_screen.dart';
import 'package:task_manager_project_with_getx/ui/screens/auth/sign_in_screen.dart';

import '../../../data/models/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/urls.dart';
import '../../utility/app_colors.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/snack_bar_message.dart';


class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _emailVerificationInProgress = false;


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
                      "Your Email Address",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "A 6 digits verification pin will be sent to your email address.",
                      style: Theme.of(context).textTheme.titleSmall,textAlign: TextAlign.justify,
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

                    const SizedBox(height: 15),
                    Visibility(
                      visible: _emailVerificationInProgress==false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: _onTapConfirmButton,
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
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

  void _onTapConfirmButton() {
    if(_formKey.currentState!.validate()){
      _emailVerification();
      // _verifyEmail(_emailTEController.text);
    }
  }

  // email verification api method
  Future<void> _emailVerification() async {
    _emailVerificationInProgress = true;
    if(mounted){
      setState(() {});
    }

    NetworkResponse response = await NetworkCaller.getRequest(
      Urls.recoverVerifyEmail(_emailTEController.text),
    );

    if (response.isSuccess && response.responseData['status'] == 'success') {
      if(mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  PinVerificationScreen(email: _emailTEController.text,),
          ),
        );
      }
    } else {
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Failed to send verification email.');
      }
    }
    _emailVerificationInProgress = false;
    if(mounted){
      setState(() {});
    }
  }



  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}