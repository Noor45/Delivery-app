import 'package:driver_panel/model/user_model.dart';

class LoginResponse {
  int? code;
  UserDataModel? data;

  LoginResponse({this.code, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? UserDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}