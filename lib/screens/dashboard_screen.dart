import 'package:driver_panel/screens/store_list_screen.dart';
import 'package:flutter/material.dart';
import '../cards/delivery_status_card.dart';
import '../model/current_order_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:dio/dio.dart' as dio;
import 'package:collection/collection.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/show_toast_dialog.dart';
import 'google_navigation_screen.dart';

class DashboardScreen extends StatefulWidget {
  static String ID = "/dashboard_screen";
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var orderData;
  Map<String, dynamic> statsData = {};
  CurrentOrderModel? latestPendingOrder;
  bool allPicked = false;
  bool loading = false;
  List<dynamic> orderShippingFees = [];
  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  void checkAllPicked() {
    allPicked = orderShippingFees.every((fee) => fee['deliveryStatus'] == 'Confirmed');
  }

  @override
  void initState() {
    fetchStats();
    // fetchOrders();
    super.initState();
  }

  Future<void> fetchStats() async {
    setState(() {
      loading = true;
    });
    final url = "http://localhost/driver/classification/stats";
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
      if (response.statusCode == 200) {
        setState(() {
          statsData = response.data;
          loading = false;
        });
      }
    } catch (e) {
      print("Error fetching stats: $e");
    }
  }

  Future<void> fetchOrders() async {
    final url = "http://localhost/driver/order/fetch/";
    // try {
      final response = await _dio.get(
        url,
        options: dio.Options(
          method: 'GET',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        List<CurrentOrderModel> orders = (data['data'] as List).map((e) => CurrentOrderModel.fromJson(e)).toList();
        orders.sort((a, b) => b.id.compareTo(a.id));
        final CurrentOrderModel? pendingOrder = orders.firstWhereOrNull(
              (order) => order.status == "Pending" || order.status == "Accepted" || order.status == "Shipped",
        );
        setState(() {
          latestPendingOrder = pendingOrder;
          orderShippingFees = response.data['data'][0]['order']['orderShippingFees'];
          orderData = response.data['data'][0];
          checkAllPicked();
        });
      }
    // } catch (e) {
    //   print("Error fetching orders: $e");
    // }
  }

  Future<void> updateOrderStatus(String orderId, String status, String comment) async {
    ShowToastDialog.showLoader("Please wait");
    final url = "http://localhost/driver/order/status";
    var data = dio.FormData.fromMap({
      'driverOrderId': orderId,
      'status': status,
      'statusKeyNotes': comment,
    });
    // try {
      final response = await _dio.put(
        url,
        data: data,
        options: dio.Options(
          method: 'PUT',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        print("Order status updated to $status");
        if (status == "Rejected") {
          setState(() {
            latestPendingOrder = null;
          });
          showMessage('Rejected', 'You have been rejected the ride successfully');
        } else {
          showMessage('Accepted', 'You have been accept the ride successfully');
          fetchOrders(); // Refresh orders if status is "Accepted"
        }
      } else {
        ShowToastDialog.closeLoader();
        print("Failed to update order status");
      }
    // } catch (e) {
    //   ShowToastDialog.closeLoader();
    //   print("Error updating order status: $e");
    // }
  }

  String calculateDuration(String startTime, String endTime, String date) {
    final start = DateTime.parse('$date $startTime:00');
    final end = DateTime.parse('$date $endTime:00');
    final duration = end.difference(start);
    return "${(duration.inHours).abs()} hours";
  }

  void _showRejectOrderDialog(BuildContext context, Function(String) onReject) {
    final TextEditingController _commentController = TextEditingController();
    bool isButtonEnabled = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Please provide a reason to reject this order:',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      cursorColor: ColorRefer.kPrimaryColor,
                      controller: _commentController,
                      maxLines: 6,
                      onChanged: (value) {
                        setState(() {
                          isButtonEnabled = value.trim().isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Add a comment',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: const BorderSide(color: ColorRefer.kPrimaryColor),
                          borderRadius: BorderRadius.circular(8),
                        )
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel', style: TextStyle(color: ColorRefer.kPrimaryColor),),
                        ),
                        ElevatedButton(
                          onPressed: isButtonEnabled
                              ? () {
                            onReject(_commentController.text.trim());
                            Navigator.of(context).pop();
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRefer.kPrimaryColor,
                            disabledBackgroundColor: ColorRefer.kPrimaryColor.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Reject Order',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    ShowToastDialog.closeLoader();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if (latestPendingOrder != null)
              // Card(
              //     color: Color(0xFFEEF6F8),
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              //     child: Padding(
              //       padding: const EdgeInsets.all(16.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: <Widget>[
              //           Text('Order Id : ${latestPendingOrder!.orderId}',
              //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              //           SizedBox(height: 8),
              //           Row(
              //             children: [
              //               Icon(Icons.access_time_outlined, size: 20),
              //               SizedBox(width: 8),
              //               Text(calculateDuration(latestPendingOrder!.startTime, latestPendingOrder!.endTime, latestPendingOrder!.date),
              //                   style: TextStyle(fontSize: 14, color: Colors.black54))
              //             ],
              //           ),
              //           SizedBox(height: 8),
              //           Row(
              //             children: [
              //               Icon(Icons.location_on_outlined),
              //               SizedBox(width: 5),
              //               Expanded(
              //                 flex: 3,
              //                 child: Text(latestPendingOrder!.address, style: TextStyle(fontSize: 14, color: Colors.black54)),
              //               ),
              //             ],
              //           ),
              //           SizedBox(height: 16),
              //           if(latestPendingOrder != null && (latestPendingOrder!.status == 'Accepted' || latestPendingOrder!.status == 'InPreparation'))
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               SizedBox(height: 2, width: 2,),
              //               ElevatedButton(
              //                 onPressed: () async {
              //                   if(allPicked == true){
              //                     if(latestPendingOrder!.status == 'Accepted'){
              //                       final result = await Navigator.of(context).push(
              //                           MaterialPageRoute(builder: (context) =>
              //                               NavigationScreen(
              //                                 id: latestPendingOrder!.id.toString(),
              //                                 data: orderData,
              //                               )
              //                           )
              //                       );
              //                        if(result == true){
              //                          setState(() {
              //                            latestPendingOrder = null;
              //                          });
              //                        }
              //                       fetchOrders();
              //                     } else if (latestPendingOrder!.status == 'InPreparation'){
              //                      final result = await Navigator.of(context).push(
              //                           MaterialPageRoute(
              //                               builder: (context) =>
              //                                   CompleteOrderScreen(data: orderData)
              //                           )
              //                       );
              //                       if(result == true){
              //                         setState(() {
              //                           latestPendingOrder = null;
              //                         });
              //                       }
              //                       // fetchOrders();
              //                     }
              //                   }
              //                   else{
              //                     await Navigator.of(context).push(
              //                         MaterialPageRoute(builder: (context) =>
              //                             StoreListScreen(
              //                                 id: latestPendingOrder!.id.toString()
              //                             )
              //                         )
              //                     );
              //                     fetchOrders();
              //                   }
              //                 },
              //                 style: ElevatedButton.styleFrom(
              //                   backgroundColor: ColorRefer.kPrimaryColor,
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                   ),
              //                 ),
              //                 child: Text('Proceed to Delivery', style: TextStyle(color: Colors.white)),
              //               ),
              //             ],
              //           ),
              //           if(latestPendingOrder != null && latestPendingOrder!.status == 'Pending')
              //           Row(
              //             children: [
              //               Expanded(
              //                 child: ElevatedButton(
              //                   onPressed: () {
              //                     _showRejectOrderDialog(context, (comment) {
              //                       updateOrderStatus(latestPendingOrder!.id.toString(), "Rejected", comment);
              //                     });
              //                   },
              //                   style: ElevatedButton.styleFrom(
              //                     backgroundColor: Color(0xffF5F5F6),
              //                     shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(8),
              //                     ),
              //                   ),
              //                   child: Text('Cancel', style: TextStyle(color: Colors.black)),
              //                 ),
              //               ),
              //               SizedBox(width: 8),
              //               Expanded(
              //                 child: ElevatedButton(
              //                   onPressed: () {
              //                     updateOrderStatus(latestPendingOrder!.id.toString(), "Accepted", '');
              //                   },
              //                   style: ElevatedButton.styleFrom(
              //                     backgroundColor: ColorRefer.kPrimaryColor,
              //                     shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(8),
              //                     ),
              //                   ),
              //                   child: Text('Accept', style: TextStyle(color: Colors.white)),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // if (latestPendingOrder != null)
              // SizedBox(height: 16),
              Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: loading ?
                      Skeletonizer(enabled: loading, child: buildStatCard('Accepted Orders', '0')) :
                      buildStatCard('Accepted Orders', '${statsData['AcceptedOrder'] ?? 0}')
                  ),
                  SizedBox(width: 8),
                  Expanded(
                      child: loading ?
                      Skeletonizer(enabled: loading, child: buildStatCard('Rejected Orders', '0')) :
                      buildStatCard('Rejected Orders', '${statsData['RejectedOrder'] ?? 0}')
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: loading ?
                      Skeletonizer(enabled: loading, child: buildStatCard('Completed Orders', '0')) :
                      buildStatCard('Completed Orders', '${statsData['CompletedOrder'] ?? 0}')
                  ),
                  SizedBox(width: 8),
                  Expanded(
                      child: loading ?
                      Skeletonizer(enabled: loading, child: buildStatCard('Pending Orders', '0')) :
                      buildStatCard('Pending Orders', '${statsData['PendingOrder'] ?? 0}')
                  ),
                ],
              ),
              Constants.userData!.type == 'commission' ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text('Earnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                          child: loading ?
                          Skeletonizer(enabled: loading, child: buildStatCard('Weekly\nProfit', '0')) :
                          buildStatCard('Weekly\nProfit', '\$${statsData['totalWeekProfit'] ?? 0}')
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                          child: loading ?
                          Skeletonizer(enabled: loading, child: buildStatCard('Monthly\nProfit', '0')) :
                          buildStatCard('Monthly\nProfit', '\$${statsData['totalMonthProfit'] ?? 0}')
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                      child: loading ?
                      Skeletonizer(enabled: loading, child: buildStatCard('Total\nEarnings', '0')) :
                      buildStatCard('Total\nEarnings', '\$${statsData['totalEarnings'] ?? 0}')
                  ),
                ],
              ) : const SizedBox(),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatCard(String title, String value) {
    return Card(
      color: Color(0xFFEEF6F8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            SizedBox(
                width: MediaQuery.of(context).size.width/3.5,
                child: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black54))),
          ],
        ),
      ),
    );
  }
}
