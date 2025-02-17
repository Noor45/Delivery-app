import 'dart:convert';  // For json encoding
import 'package:dio/dio.dart' as dio;
import 'package:driver_panel/utils/constants.dart';
import 'package:get/get.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../responses/login_response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final dio.Dio _dio = dio.Dio();

  Future<LoginResponse?> login({required String email, required String password}) async {
    try {
      var data = dio.FormData.fromMap({
        'emailOrPhone': email,
        'password': password
      });
      final response = await _dio.post(
        'http://localhost/driver/auth/login',
        options: dio.Options(
          method: 'POST',
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        Constants.userData = loginResponse.data;
        var sessionManager = SessionManager();
        await sessionManager.set("user", json.encode(loginResponse.data?.toJson()));
        await updateFCMToken();
        return loginResponse;
      } else {
        Get.back();
        showMessage('Error', 'Login failed with status: ${response.statusCode}');
        return null;
      }
    } on dio.DioException catch (e) {
      Get.back();
      showMessage('Failed', e.response?.data['message'] ?? 'Unknown error occurred');
      return null;
    }
  }

  updateFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print(token);
      var data = dio.FormData.fromMap({
        'token': token,
      });
      await _dio.put(
        'http://localhost/driver/auth/fcm-token',
        options: dio.Options(
          method: 'PUT',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
        data: data,
      );
    } on dio.DioException catch (e) {
      print(e.response?.data['message']);
      return null;
    }
  }
}
