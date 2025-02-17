import 'dart:convert';  // For json encoding
import 'package:dio/dio.dart' as dio;
import 'package:driver_panel/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../cards/delivery_status_card.dart';
import '../responses/login_response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MapService {
  final dio.Dio _dio = dio.Dio();

  Future<void> markDelivered(String orderId, BuildContext context, var data) async {
    print(orderId);
    final url = "http://localhost/driver/order/status";
    var data = dio.FormData.fromMap({
      'driverOrderId': orderId,
      'status': 'Shipped',
    });
    final response = await _dio.put(
      url,
      options: dio.Options(
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer ${Constants.userData!.token}',
        },
      ),
      data: data,
    );
    if (response.statusCode == 200) {
      showMessage('Order Delivered', 'Kindly capture the image of the payment from the customer');
      Navigator.pop(context);
      final result =  await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  CompleteOrderScreen(data: data)
          )
      );
      Navigator.pop(context, result);
    }
  }

  Future<void> updateOrderStatus(String orderId, String time) async {
    final url = "http://localhost/driver/order/onway/alert";
    var data = dio.FormData.fromMap({
      'remaingTime': time,
      'OrderId': orderId,
    });
    try {
      await _dio.post(
        url,
        data: data,
        options: dio.Options(
          method: 'POST',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
      );
    } catch (e) {
      print("Error updating order status: $e");
    }
  }
}
