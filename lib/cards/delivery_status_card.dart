import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import '../utils/constants.dart';
import '../widgets/appbar_card.dart';
import '../widgets/round_btn.dart';
import 'package:driver_panel/utils/colors.dart';

import '../widgets/show_toast_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'dart:convert';


class DeliveryStatusSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.check_circle_outline),
          title: Text('Order Accepted'),
          onTap: () {
            // Implement action to change status to "Order Accepted"
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.local_shipping),
          title: Text('Pickup for Product'),
          onTap: () {
            // Implement action to change status to "Pickup for Product"
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.directions_car),
          title: Text('On the Way'),
          onTap: () {
            // Implement action to change status to "On the Way"
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Arrived'),
          onTap: () {
            // Implement action to change status to "Arrived"
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.done_all),
          title: Text('Completed'),
          onTap: () async {
            Navigator.pop(context);
            // Navigate to the image upload screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompleteOrderScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CompleteOrderScreen extends StatefulWidget {
  CompleteOrderScreen({this.data});
  var data;

  @override
  _CompleteOrderScreenState createState() => _CompleteOrderScreenState();
}

class _CompleteOrderScreenState extends State<CompleteOrderScreen> {
  // XFile? customerImage;
  XFile? driverImage;
  final ImagePicker _picker = ImagePicker();

  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  Future<void> updateOrderStatus(int orderId, String status) async {
    if (driverImage != null) {
      ShowToastDialog.showLoader("Please wait");
      const url = "http://localhost/driver/order/order/status";

      // try {
        // Create the FormData
        var data = dio.FormData.fromMap({
          'orderCompletionImage': dio.MultipartFile.fromFile(driverImage!.path),
          'OrderId': orderId,
          'status': status,
        });
        print(data.fields);
        // Send the request
        final response = await _dio.put(
          url,
          data: data,
          options: dio.Options(
            headers: {
              'Authorization': 'Bearer ${Constants.userData!.token}',
            },
          ),
        );

        // Check response status
        if (response.statusCode == 200) {
          ShowToastDialog.closeLoader();
          Navigator.pop(context, true);
          showMessage('Completed', 'Your delivery order completed successfully.');
        } else {
          ShowToastDialog.closeLoader();
          showMessage('Error', 'Failed to update order status. Please try again.');
        }

      // } catch (e) {
      //   // Catch and log any exceptions
      //   ShowToastDialog.closeLoader();
      //   print("Error updating order status: $e");
      //
      //   // Display user-friendly error message
      //   showMessage('Server Error', 'There was a problem with the server. Please try again later.');
      // }
    } else {
      ShowToastDialog.closeLoader();
      showMessage('Payment Image', 'Please capture the payment image to complete the order.');
    }
  }

  Future<void> _pickImageForDriver() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      driverImage = pickedFile;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ShowToastDialog.closeLoader();

    return Scaffold(
      appBar: appBar(
          title: 'Complete Order',
          leadingWidget: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white)
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Payment Image'),
              subtitle: driverImage == null
                  ? Text('No image selected.')
                  : Image.file(File(driverImage!.path)),
              onTap: _pickImageForDriver,
            ),
            Spacer(),
            RoundedButton(
              title: 'Order Completed',
              buttonRadius: 10,
              colour: ColorRefer.kPrimaryColor,
              height: 48,
              onPressed: () async {
                updateOrderStatus(widget.data['orderId'], 'Completed');
                // if (driverImage != null) {
                //   Navigator.pop(context);
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text('Please upload images')),
                //   );
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}