import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/appbar_card.dart';
import '../widgets/empty_widget.dart';
import 'order_history_detail_screen.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart' as dio;
import '../utils/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _loading = false;
  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  List<Map<String, dynamic>> orders = [];

  Future<void> fetchOrders() async {
    final url = "http://localhost/driver/classification/order";
    setState(() {
      _loading = true;
    });
    try {
      final response = await _dio.get(
        url,
        options: dio.Options(
          method: 'GET',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
      );
     if (response.statusCode == 200 && response.data['code'] == 200) {
      final List<dynamic> fetchedOrders = response.data['data'];
      List<Map<String, dynamic>> loadedOrders = fetchedOrders.map((orderData) {
        final Map<String, dynamic> orderMap = orderData as Map<String, dynamic>;
        final originData = jsonDecode(orderMap['order']['origin']);
        final fromLocation = originData['location'];
        final toLocation = orderMap['order']['address'];
        final String fromDateRaw = orderMap['date']; // "2024-11-07"
        final DateTime parsedFromDate = DateTime.parse(fromDateRaw);
        final String fromDate = DateFormat('dd MMM yyyy').format(parsedFromDate);
        final toDate = orderMap['order']['date'];
        final status = orderMap['status'];
        final data = orderData;
        int currentProgress = 0;

        if (status == 'Shipped') {
          currentProgress = 0;
          if (checkAllPicked(orderMap['order']['orderShippingFees'])) {
            currentProgress = 1;
          }
        }
        else if (status == 'Completed') {
          currentProgress = 2;
        }

        return {
          'orderId': orderMap['orderId'].toString(),
          'fromLocation': fromLocation,
          'toLocation': toLocation,
          'fromDate': fromDate,
          'toDate': toDate,
          'status': status,
          'currentProgress': currentProgress,
          'data': data
        };
      }).toList();

      setState(() {
        orders = loadedOrders;
        _loading = false;
      });
    }
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  bool checkAllPicked(List orderShippingFees) {
    return orderShippingFees.every((fee) => fee['deliveryStatus'] == 'Prepared' || fee['deliveryStatus'] == 'Delivered');
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(title: 'History'),
      body: _loading ?
      Skeletonizer(
        enabled: _loading,
        child: Container(
          height: 250,
          child: OrderCard(
            orderId: '23454',
            cargoDetails: 'Cargo details here',
            fromLocation: 'Sahiwal District, Punjab, Pakistan',
            toLocation: 'Madhali road, Sahiwal, Sahiwal District, Punjab, Pakistan',
            fromDate: '07 Nov 2024',
            toDate: '07 Nov 2024',
            status: 'On the Way',
            currentProgress: 2,
            onTap: () {},
          ),
        ),
      ) : orders.isEmpty ? emptyWidget('No Order to show', context) :
      ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
            final order = orders[index];
            print(order['status']);
            print(order['currentProgress']);
            return OrderCard(
              orderId: order['orderId'],
              cargoDetails: 'Cargo details here', // Placeholder, customize as needed
              fromLocation: order['fromLocation'],
              toLocation: order['toLocation'],
              fromDate: order['fromDate'],
              toDate: order['toDate'],
              status: order['status'],
              currentProgress: order['currentProgress'],
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        OrderHistoryDetailScreen(
                          data: order['data'],
                        )
                    )
                );
                // Navigator.pushNamed(context, OrderDetailScreen.ID);
              },
            );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderId;
  final String cargoDetails;
  final String fromLocation;
  final String toLocation;
  final String fromDate;
  final String toDate;
  final String status;
  final int currentProgress;
  final Function onTap;

  OrderCard({
    required this.orderId,
    required this.cargoDetails,
    required this.fromLocation,
    required this.toLocation,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.currentProgress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap.call();
      },
      child: Card(
        color: Color(0xFFEEF6F8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order ID #${orderId}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: orderId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Icon(Icons.copy, color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                fromDate,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fromLocation,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        // SizedBox(height: 4),
                        // Text(
                        //   fromDate,
                        //   style: TextStyle(fontSize: 14, color: Colors.black54),
                        // ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_forward_ios_rounded, color: ColorRefer.kPrimaryColor, size: 20),
                      Icon(Icons.arrow_forward_ios_rounded, color: ColorRefer.kPrimaryColor.withOpacity(0.9), size: 20),
                      Icon(Icons.arrow_forward_ios_rounded, color: ColorRefer.kPrimaryColor.withOpacity(0.7), size: 20),
                      Icon(Icons.arrow_forward_ios_rounded, color: ColorRefer.kPrimaryColor.withOpacity(0.4), size: 20),
                    ],
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          toLocation,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        // SizedBox(height: 4),
                        // Text(
                        //   toDate,
                        //   style: TextStyle(fontSize: 14, color: Colors.black54),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                height: 5,
                color: currentProgress >= 2 ? ColorRefer.kPrimaryColor : Colors.grey[400],
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 5,
                  color: ColorRefer.kPrimaryColor,
                  width: (MediaQuery.of(context).size.width - 40) * ((currentProgress + 1) / 3),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusStep('Accepted', 0),
                  _buildStatusStep('On the way', 1),
                  _buildStatusStep('Delivered', 2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusStep(String label, int step) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: currentProgress >= step ? ColorRefer.kPrimaryColor : Colors.grey,
          ),
        ),
      ],
    );
  }
}


