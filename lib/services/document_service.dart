import 'package:dio/dio.dart' as dio;
import 'package:driver_panel/utils/constants.dart';
import 'package:flutter/material.dart';
import '../model/driver_address_model.dart';
import '../model/license_model.dart';
import '../model/servicearea_model.dart';
import '../model/vehicle_info_model.dart';
import '../widgets/show_toast_dialog.dart';

class DocumentService {
  final dio.Dio _dio = dio.Dio();

  fetchAndParseDriverData({BuildContext? context, String? route}) async {
    // try {
    final response = await _dio.get(
      'http://localhost/driver/auth/fetch',
      options: dio.Options(
        method: 'GET',
        headers: {
          'Authorization': 'Bearer ${Constants.userData!.token}',
        },
      ),
    );
    if (response.statusCode == 200 && response.data['code'] == 200) {
      final data = response.data['data'];
      if(data.isNotEmpty) {
        // Constants.serviceArea = data['servicesArea'][0] != [] ? ServiceAreaModel.fromJson(data['servicesArea'][0]) : null;
        Constants.serviceArea = data['servicesArea'].isNotEmpty
            ? ServiceAreaModel.fromJson(data['servicesArea'][0])
            : null;
        Constants.vehicleInfo = data['vehicleInformation'].isNotEmpty
            ? VehicleInfoModel.fromJson(data['vehicleInformation'][0])
            : null;

        Constants.drivingLicense = data['drivingLicence'].isNotEmpty
            ? DrivingLicenseModel.fromJson(data['drivingLicence'][0])
            : null;

        Constants.driverAddress = data['driverAddress'].isNotEmpty
            ? DriverAddressModel.fromJson(data['driverAddress'][0])
            : null;
        ShowToastDialog.closeLoader();
        Navigator.pushNamed(context!, route!);
      } else {
        ShowToastDialog.closeLoader();
        Navigator.pushNamed(context!, route!);
      }
    } else {
      ShowToastDialog.closeLoader();
      showMessage('Failed', 'Failed to load document data');
    }
    // } catch (e) {
    //   print(e);
    //   Get.snackbar('Error', 'An error occurred while saving');
    //   return null; // Return null in case of an exception
    // }
  }

  Future<Map<String, dynamic>> fetchDriverData() async {
    try {
      final response = await _dio.get(
        'http://localhost/driver/auth/status',
        options: dio.Options(
          method: 'GET',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        return responseData['data'];
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

}
