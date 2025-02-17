import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../utils/constants.dart';

class ProfileService {
  final dio.Dio _dio = dio.Dio();
  Future<void> updateProfile(firstName, lastName, userName, email, password, phone, dob, id, String imageLink, File? imageFile) async {
    // try {
      FormData formData = FormData.fromMap({
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
        'email': email,
        'password': password,
        'phone': phone,
        'dob': dob,
        'id': id,
        if (imageFile != null) 'images': await MultipartFile.fromFile(imageFile.path),
        if (imageFile == null) 'images': imageLink,
      });
      var response = await _dio.put(
          'http://localhost/driver/auth/update',
          options: dio.Options(
            method: 'POST',
            headers: {
              'Authorization': 'Bearer ${Constants.userData!.token}',
            },
          ),
          data: formData);
      if (response.statusCode == 200) {
        var data = response.data;
        if (data['code'] == 200) {
          Constants.userData!.firstName = data['driver']['firstName'];
          Constants.userData!.lastName = data['driver']['lastName'];
          Constants.userData!.email = data['driver']['email'];
          Constants.userData!.phone = data['driver']['phone'];
          Constants.userData!.dob = data['driver']['dob'];
          Constants.userData!.image = data['driver']['image'];
          var sessionManager = SessionManager();
          await sessionManager.set("user", json.encode(Constants.userData?.toJson()));
          showMessage('Updated', 'Profile updated successfully');
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully")));
        }
      } else {
        showMessage('Failed', 'Failed to update profile');
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update profile")));
      }
    // } catch (e) {
    //   showMessage('Error', 'Error: $e');
    //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    // }
  }
}
