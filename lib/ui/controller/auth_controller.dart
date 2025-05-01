import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/model/user_model.dart';

class AuthController extends GetxController{
static String? token;
static UserModel? userModel;

static String _tokenKey = 'token';
static String _userDataKey = 'user-data';


  //Save user Information
 static Future<void> saveUserInformation(String accessToken, UserModel user)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(_tokenKey, accessToken);
  sharedPreferences.setString(_userDataKey, jsonEncode(user.toJson()));

  token = accessToken;
  userModel = user;
  }

  static Future<void> getUserInformation()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(_tokenKey);
    String? saveUserModelString = sharedPreferences.getString(_userDataKey);

    if(saveUserModelString != null){
      UserModel saveUserModel = UserModel.fromJson(jsonDecode(saveUserModelString));
      userModel = saveUserModel;
    }
    token = accessToken;
  }

  static Future<bool> checkUserLoggenIn()async{
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   String ? accessUserToken = sharedPreferences.getString(_tokenKey);

   if(accessUserToken != null){
     await getUserInformation();
     return true;
   }
   return false;
  }

  static Future<void> clearUserData()async{
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   sharedPreferences.clear();

   token = null;
   userModel = null;

  }



}