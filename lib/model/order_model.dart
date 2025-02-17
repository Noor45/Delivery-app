class OrderModel {
  final int orderId;
  final int id;
  final String startTime;
  final String date;
  var driver;
  var order;
  final String endTime;
  String status;
  final String address;

  OrderModel({
    required this.orderId,
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.date,
    // required this.instructions,
    required this.driver,
    required this.order,
    required this.status,
    required this.address,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['id'],
      id: json['_id'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      // instructions: json['instructions'],
      status: json['status'],
      driver: json['driver'],
      order: json['order'],
      address: json['address'], // Extracting address from nested order object
    );
  }
}
