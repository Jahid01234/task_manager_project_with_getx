import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager_project_with_getx/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager_project_with_getx/ui/controllers/completed_task_controller.dart';
import 'package:task_manager_project_with_getx/ui/controllers/email_verification_controller.dart';
import 'package:task_manager_project_with_getx/ui/controllers/in_progress_task_controller.dart';
import 'package:task_manager_project_with_getx/ui/controllers/new_task_controller.dart';
import 'package:task_manager_project_with_getx/ui/controllers/pin_verification_controller.dart';
import 'package:task_manager_project_with_getx/ui/controllers/reset_password_controller.dart';
import 'package:task_manager_project_with_getx/ui/controllers/sign_in_controller.dart';
import 'package:task_manager_project_with_getx/ui/controllers/sign_up_controller.dart';
import 'package:task_manager_project_with_getx/ui/controllers/update_profile_controller.dart';

class ControllerBinder extends Bindings{

  @override
  void dependencies() {
    // All dependency injection here....

     Get.lazyPut(() => SignInController());
     //Get.lazyPut(() => SignUpController());

     //fenix: true to ensure it is recreated if removed from memory
     Get.lazyPut(() => SignUpController(), fenix: true);
     Get.lazyPut(() => EmailVerificationController());
     Get.lazyPut(() => PinVerificationController());
     Get.lazyPut(() => ResetPasswordController(), fenix: true);
     Get.lazyPut(() => AddNewTaskController());
     Get.lazyPut(() => CancelledTaskController());
     Get.lazyPut(() => CompletedTaskController());
     Get.lazyPut(() => InProgressTaskController());
     Get.lazyPut(() => UpdateProfileController());
     Get.lazyPut(() => NewTaskController());
  }

}