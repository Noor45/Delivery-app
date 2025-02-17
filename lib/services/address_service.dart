import 'package:dio/dio.dart' as dio;
import 'package:driver_panel/utils/constants.dart';
import '../model/driver_address_model.dart';
import '../widgets/show_toast_dialog.dart';

class AddressService {
  final dio.Dio _dio = dio.Dio();
   Future<DriverAddressModel?> saveDriverAddress(Map<String, dynamic> address, bool save) async {
    try {
      var data = dio.FormData.fromMap(address);
      final response = save == true ? await _dio.post(
        'http://localhost/driver/auth/driver-address',
        options: dio.Options(
          method: 'POST',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
        data: data,
      ) : await _dio.put(
        'http://localhost/driver/auth/driver-address',
        options: dio.Options(
          method: 'PUT',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
        data: data,
      );

      if (response.statusCode == 201) {
        final driverAddress = DriverAddressModel.fromJson(response.data['data']);
        Constants.driverAddress = driverAddress;
        showMessage('Saved', 'Saved Successfully');
        return driverAddress;
      } else if (response.statusCode == 200) {
        var data;
        if (response.data['data'] is List) {
          data = response.data['data'][0];
        } else if (data is Map<String, dynamic>) {
          data = response.data['data'];
        }
        final driverAddress = DriverAddressModel.fromJson(data);
        Constants.driverAddress = driverAddress;
        showMessage('Updated', 'Updated Successfully');
        return driverAddress;
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
