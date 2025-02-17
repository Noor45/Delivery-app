class DriverAddressModel {
  final int? id;
  final int? driverId;
  final String? addressLine1;
  final String? addressLine2;
  final String? postalCode;
  final String? state;
  final String? city;
  final String? phoneNumber;
  final double? lat;
  final double? lng;
  final String? status;

  DriverAddressModel({
     this.id,
     this.driverId,
     this.addressLine1,
     this.addressLine2,
     this.postalCode,
     this.state,
     this.city,
     this.phoneNumber,
     this.lat,
     this.lng,
     this.status,
  });

  factory DriverAddressModel.fromJson(Map<String, dynamic> json) {
    return DriverAddressModel(
      id: json['id'],
      driverId: json['driverId'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      postalCode: json['postalCode'],
      state: json['state'],
      city: json['city'],
      phoneNumber: json['phoneNumber'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "postalCode": postalCode,
      "state": state,
      "city": city,
      "phoneNumber": phoneNumber,
      "lat": lat,
      "lng": lng,
    };
  }
}
