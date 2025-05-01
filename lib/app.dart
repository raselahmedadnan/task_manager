import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:task_manager/controller_binder.dart';
import 'ui/screens/splash_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {



    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: TaskManagerApp.navigatorKey,
      initialBinding: ControllerBinder(),
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: const TextStyle(
            fontSize: 25,fontWeight: FontWeight.w600,
          ),

        ),

        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey,
            fontWeight: FontWeight.w400
          ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            border: _zeroBorder(),
          enabledBorder: _zeroBorder(),
          errorBorder: _zeroBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(double.maxFinite),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
          )
        )
      ),
    home: SplashScreen(),
    );
  }
  OutlineInputBorder _zeroBorder(){
    return const OutlineInputBorder(
        borderSide: BorderSide.none
    );
  }
}
