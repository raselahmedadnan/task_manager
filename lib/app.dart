import 'package:flutter/material.dart';

import 'ui/screens/splash_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static final GlobalKey<NavigatorState> navigaorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      navigatorKey: TaskManagerApp.navigaorKey,
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
