import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_with_getx/controller_binder.dart';
import 'package:task_manager_project_with_getx/ui/screens/auth/splash_screen.dart';
import 'package:task_manager_project_with_getx/ui/utility/app_colors.dart';


class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}



class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Manager Project',
      navigatorKey: TaskManagerApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: lightThemeData(),
      initialBinding: ControllerBinder(),
    );
  }

  ThemeData lightThemeData() {
    return ThemeData(

      textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
          titleSmall: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              letterSpacing: 0.4
          )
      ),

      inputDecorationTheme:  InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        border: const OutlineInputBorder(
            borderSide: BorderSide.none
        ),
      ),

      elevatedButtonTheme:  ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.themeColor,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          fixedSize: const Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w600
              )
          )
      ),

    );
  }
}