import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:driver_panel/utils/constants.dart';
import 'package:get/get.dart';
import '../model/license_model.dart';

class LicenseService {
  final dio.Dio _dio = dio.Dio();

    Future<DrivingLicenseModel?> saveLicense({String? licenceNo, String? expireDate, File? frontImage, File? backImage, String? frontImageUrl, String? backImageUrl, required bool save}) async {
    // try {
      var data;
      if(frontImage != null && backImage != null){
        data = dio.FormData.fromMap({
          'licenceNo': licenceNo,
          'expireDate': expireDate,
          'frontImg': await dio.MultipartFile.fromFile(frontImage.path),
          'backImg': await dio.MultipartFile.fromFile(backImage.path),
        });
      }else{
        data = dio.FormData.fromMap({
          'licenceNo': licenceNo,
          'expireDate': expireDate,
          'frontImg': frontImageUrl,
          'backImg': backImageUrl,
        });
      }

    final response = save == true ? await _dio.post(
      'http://localhost/driver/auth/driving-licence',
      options: dio.Options(
        method: 'POST',
        headers: {
          'Authorization': 'Bearer ${Constants.userData!.token}',
        },
      ),
      data: data,
    ) : await _dio.put(
      'http://localhost/driver/auth/driving-licence',
      options: dio.Options(
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer ${Constants.userData!.token}',
        },
      ),
      data: data,
    );
    if (response.statusCode == 201) {
      final serviceAreaData = DrivingLicenseModel.fromJson(response.data['data']);
      Constants.drivingLicense = serviceAreaData;
      showMessage('Saved', 'Saved Successfully');
      return serviceAreaData;
    } else if (response.statusCode == 200) {
      var data;
      if (response.data['data'] is List) {
        data = response.data['data'][0];
      } else if (data is Map<String, dynamic>) {
        data = response.data['data'];
      }
      final licenseData = DrivingLicenseModel.fromJson(data);
      Constants.drivingLicense = licenseData;
      showMessage('Updated', 'Updated Successfully');
      return licenseData;
    }
    else {
      showMessage('Error', 'Failed to save service area');
      return null; // Return null when failed
    }
    // } catch (e) {
    //   print(e);
    //   Get.snackbar('Error', 'An error occurred while saving');
    //   return null; // Return null in case of an exception
    // }
  }
}
