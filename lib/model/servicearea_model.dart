import 'dart:convert';

class ServiceAreaModel {
  final int id;
  final int driverId;
  final String timeAvailability;
  final String time;
  final String totalDays;
  final List<String> days;
  final String status;

  ServiceAreaModel({
    required this.id,
    required this.driverId,
    required this.timeAvailability,
    required this.time,
    required this.totalDays,
    required this.days,
    required this.status,
  });

  // Factory method to create a ServiceAreaResponse from JSON
  factory ServiceAreaModel.fromJson(Map<String, dynamic> json) {
    return ServiceAreaModel(
      id: json['id'],
      driverId: json['driverId'],
      timeAvailability: json['timeAvailability'],
      time: json['time'],
      totalDays: json['totalDays'],
      days: (json['days'] is String)
          ? List<String>.from(jsonDecode(json['days']).map((item) => item.toString()))
          : List<String>.from(json['days'].map((item) => item.toString())), // Convert to List<String>
      status: json['status'],
    );
  }

  // Convert the response back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'timeAvailability': timeAvailability,
      'time': time,
      'totalDays': totalDays,
      'days': jsonEncode(days), // Ensure 'days' is encoded as a JSON string
      'status': status,
    };
  }
}
