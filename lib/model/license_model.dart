class DrivingLicenseModel {
  final int id;
  final int driverId;
  final String licenceNo;
  final String expireDate;
  final String frontImg;
  final String backImg;
  final String status;

  DrivingLicenseModel({
    required this.id,
    required this.driverId,
    required this.licenceNo,
    required this.expireDate,
    required this.frontImg,
    required this.backImg,
    required this.status,
  });

  factory DrivingLicenseModel.fromJson(Map<String, dynamic> json) {
    return DrivingLicenseModel(
      id: json['id'],
      driverId: json['driverId'],
      licenceNo: json['licenceNo'],
      expireDate: json['expireDate'],
      frontImg: json['frontImg'],
      backImg: json['backImg'],
      status: json['status'],
    );
  }
}
