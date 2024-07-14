import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_project_with_getx/ui/controllers/auth_controller.dart';
import 'package:task_manager_project_with_getx/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_project_with_getx/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_project_with_getx/ui/utility/asset_paths.dart';
import 'package:task_manager_project_with_getx/ui/widgets/background_widget.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveNextScreen();
  }

  Future<void> _moveNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    bool isUserLoggedIn = await AuthController.checkAuthState();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isUserLoggedIn
              ? const MainBottomNavScreen()
              : const  SignInScreen(),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: SvgPicture.asset(
            AssetPaths.appLogoSvg,
            width: 140,
          ),
        ),
      ),
    );
  }
}