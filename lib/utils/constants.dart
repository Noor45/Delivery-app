import 'package:driver_panel/model/user_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../model/driver_address_model.dart';
import '../model/license_model.dart';
import '../model/servicearea_model.dart';
import '../model/vehicle_info_model.dart';
import 'colors.dart';

class Constants {
  static int? userId;
  static UserDataModel? userData;
  static String? userToken;
  static String? companyToken;
  static String? token = '';
  static ServiceAreaModel? serviceArea;
  static VehicleInfoModel? vehicleInfo;
  static DriverAddressModel? driverAddress;
  static DrivingLicenseModel? drivingLicense;
}

clear() {
  Constants.userId = null;
  Constants.token = '';
  Constants.userData = null;
  Constants.userToken = null;
  Constants.companyToken = null;
  Constants.token = '';
  Constants.serviceArea = null;
  Constants.vehicleInfo = null;
  Constants.driverAddress = null;
  Constants.drivingLicense = null;
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (this.isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}


showMessage(String? title, String? message){
  return Get.snackbar(
    title!,
    message!,
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 3),
    margin: EdgeInsets.all(16),
    backgroundColor: ColorRefer.kPrimaryColor,
    snackStyle: SnackStyle.FLOATING,
    overlayBlur: 0.4,
    colorText: Colors.white,
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Icon(Icons.cancel, color: Colors.white),
    ),
  );
}