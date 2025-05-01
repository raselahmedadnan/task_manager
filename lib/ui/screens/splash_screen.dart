import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/utils/assets_path.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _gotoNextScreen();
  }

  Future<void> _gotoNextScreen()async{
    await Future.delayed(Duration(seconds: 2));
    final bool isLogged = await AuthController.checkUserLoggenIn();
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => isLogged ? MainBottomNavScreen() : LoginScreen()));
    Get.off( isLogged ? MainBottomNavScreen() : LoginScreen());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(child: Center(
        child: SvgPicture.asset(AssetsPath.logoSvg,width: 120,),
      ))


    );
  }
}
