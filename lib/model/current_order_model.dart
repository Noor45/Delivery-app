class CurrentOrderModel {
  final int id;
  final int orderId;
  final String startTime;
  final String date;
  final String instructions;
  var driver;
  var order;
  final String endTime;
  final String status;
  final String address;

  CurrentOrderModel({
    required this.id,
    required this.orderId,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.instructions,
    required this.driver,
    required this.order,
    required this.status,
    required this.address,
  });

  factory CurrentOrderModel.fromJson(Map<String, dynamic> json) {
    return CurrentOrderModel(
      id: json['id'],
      orderId: json['orderId'],
      date: json['date'],
      startTime: json['order']['startTime'],
      endTime: json['order']['endTime'],
      instructions: json['instructions'],
      status: json['status'],
      driver: json['driver'],
      order: json['order'],
      address: json['order']['address'], // Extracting address from nested order object
    );
  }
}
