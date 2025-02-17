import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:driver_panel/utils/constants.dart';
import 'package:get/get.dart';
import '../model/servicearea_model.dart';

class AreaService {
  final dio.Dio _dio = dio.Dio();

  Future<ServiceAreaModel?> serviceAreaResponse( {String? selectedAvailability, String? selectedDays, String? time, List<String>? days, bool? save}) async {
    // try {
      var data = dio.FormData.fromMap({
        'timeAvailability': selectedAvailability,
        'time': time,
        'totalDays': selectedDays,
        'days': jsonEncode(days),
      });
      print(data.fields);
      final response = save == true ? await _dio.post(
        'http://localhost/driver/auth/services-area',
        options: dio.Options(
          method: 'POST',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
        data: data,
      ) : await _dio.put(
        'http://localhost/driver/auth/services-area',
        options: dio.Options(
          method: 'PUT',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
        data: data,
      );
      if (response.statusCode == 201) {
        final serviceAreaData = ServiceAreaModel.fromJson(response.data['data']);
        Constants.serviceArea = serviceAreaData;
        showMessage('Saved', 'Saved Successfully');
        return serviceAreaData;
      } else if (response.statusCode == 200) {
        print(response.data);
        final dataList = response.data['data'] as List;
        final serviceAreaData = ServiceAreaModel.fromJson(dataList.last);
        Constants.serviceArea = serviceAreaData;
        showMessage('Updated', 'Updated Successfully');
        return serviceAreaData;
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
