class VehicleInfoModel {
  final int id;
  final int driverId;
  final String vehicle;
  final String vehicleNo;
  final String registrationDate;
  final String vehicleType;
  final String vehicleColor;
  final String totalSeats;
  final String status;

  VehicleInfoModel({
    required this.id,
    required this.driverId,
    required this.vehicle,
    required this.vehicleNo,
    required this.registrationDate,
    required this.vehicleType,
    required this.vehicleColor,
    required this.totalSeats,
    required this.status,
  });

  factory VehicleInfoModel.fromJson(Map<String, dynamic> json) {
    return VehicleInfoModel(
      id: json['id'],
      vehicle: json['vehicle'],
      driverId: json['driverId'],
      vehicleNo: json['vehicleNo'],
      registrationDate: json['registartionDate'],
      vehicleType: json['vehicleType'],
      vehicleColor: json['vehicleColor'],
      totalSeats: json['totalSeats'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'vehicle': vehicle,
      'vehicleNo': vehicleNo,
      'registartionDate': registrationDate,
      'vehicleType': vehicleType,
      'vehicleColor': vehicleColor,
      'totalSeats': totalSeats,
      'status': status,
    };
  }
}
