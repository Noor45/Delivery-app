import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:driver_panel/utils/constants.dart';
import '../model/vehicle_info_model.dart';
import '../widgets/show_toast_dialog.dart';

class VehicleInfoService {
  final dio.Dio _dio = dio.Dio();
  Future<VehicleInfoModel?> createOrUpdateVehicle(Map<String, dynamic> vehicleData, bool save) async {
    try {
      var data = dio.FormData.fromMap(vehicleData);
      final response = save == true ? await _dio.post(
        'http://localhost/driver/auth/vehicle-Information',
        options: dio.Options(
          method: 'POST',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
        data: data,
      ) : await _dio.put(
        'http://localhost/driver/auth/vehicle-Information',
        options: dio.Options(
          method: 'PUT',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
        data: data,
      );

      if (response.statusCode == 201) {
        final vehicleInfoData = VehicleInfoModel.fromJson(response.data['data']);
        Constants.vehicleInfo = vehicleInfoData;
        showMessage('Saved', 'Saved Successfully');
        return vehicleInfoData;
      } else if (response.statusCode == 200) {
        final vehicleInfoData = VehicleInfoModel.fromJson(response.data['data']);
        Constants.vehicleInfo = vehicleInfoData;
        showMessage('Updated', 'Updated Successfully');
        return vehicleInfoData;
      }
      else {
        ShowToastDialog.closeLoader();
        showMessage('Error', 'Failed to save service area');
        return null; // Return null when failed
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      print('Error: $e');
      return null;
    }
  }
}
