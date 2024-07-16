import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/ui/controllers/email_verification_controller.dart';
import 'package:task_manager_project_with_getx/ui/screens/auth/pin_verification_screen.dart';
import 'package:task_manager_project_with_getx/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_project_with_getx/ui/widgets/snack_bar_message.dart';
import '../../utility/app_colors.dart';
import '../../widgets/background_widget.dart';



class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



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
                   GetBuilder<EmailVerificationController>(
                       builder: (emailVerificationController){
                         return  Visibility(
                           visible: emailVerificationController.emailVerificationInProgress==false,
                           replacement: const Center(
                             child: CircularProgressIndicator(),
                           ),
                           child: ElevatedButton(
                             onPressed: _onTapConfirmButton,
                             child: const Icon(Icons.arrow_circle_right_outlined),
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

  Future<void> _onTapConfirmButton() async {
    if(_formKey.currentState!.validate()){
      final bool result = await Get.find<EmailVerificationController>().
      emailVerification(_emailTEController.text);

      if(result){
        Get.off(()=> PinVerificationScreen(email: _emailTEController.text));
        if(mounted) {
          showSnackBarMessage(context, "Email verification successfully.");
        }
      }else{
        if(mounted) {
          showSnackBarMessage(context, Get.find<EmailVerificationController>().errorMessage);
        }
      }
    }
  }





  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}