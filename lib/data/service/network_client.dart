import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? data;
  final String errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.errorMessage = 'Something went Wrong',
  });
}

class NetworkClient {
  static final Logger _logger = Logger();

  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {'token': AuthController.token ?? ''};
      _preRequestLog(url, headers);
      Response response = await get(uri, headers: headers);
      _postRequestLog(
        url,
        response.statusCode,
        //headers: response.headers,
        responseBody: response.body,
      );
      if (response.statusCode == 200) {
        final decodeJson = await jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodeJson,
        );
      }else if (response.statusCode == 401){
        _movetoLoginScreen();
        return NetworkResponse(
          isSuccess: false,
          statusCode: -1,
          errorMessage: 'Unauthorized'
        );
      }
      else {
        final decodeJson = await jsonDecode(response.body);
        String errorMessage = decodeJson['data'] ?? 'Something went wrong';
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      _postRequestLog(url, -1, errorMessage: e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        'Content-type': 'Application/json',
        'token': AuthController.token ?? '',
      };
      _preRequestLog(url, body: body, headers);
      Response response = await post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      _postRequestLog(
        url,
        response.statusCode,
        //headers: headers,
        responseBody: response.body,
      );
      if (response.statusCode == 200) {
        final decodeJson = await jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodeJson,
        );
      } else if (response.statusCode == 401){
        _movetoLoginScreen();
        return NetworkResponse(
          isSuccess: false,
          statusCode: -1,
            errorMessage: 'Unauthorized user. Please Login again'
        );
      } else {
        final decodeJson = await jsonDecode(response.body);
        String errorMessage = decodeJson['data'] ?? 'Something went wrong';
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      _logger.e(e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static void _preRequestLog(
    String url,
    Map<String, String> headers, {
    Map<String, dynamic>? body,
  }) {
    _logger.i(
      'URL => $url\nHeaders => $headers'
      'Body: $body',
    );
  }

  static void _postRequestLog(
    String url,
    int statusCode, {
    dynamic responseBody,
    dynamic errorMessage,
  }) {
    if (errorMessage != null) {
      _logger.e(
        "Url => $url\n"
        "Status code: $statusCode\n"
        "ErrorMessage: $errorMessage",
      );
    }
    _logger.i(
      "Url => $url\n"
      "Status code: $statusCode\n"
      "Response: $responseBody",
    );
  }

 static Future<void> _movetoLoginScreen() async {
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(
      TaskManagerApp.navigaorKey.currentContext!,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (predicate) => false,
    );
  }
}
