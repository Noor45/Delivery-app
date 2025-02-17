import 'package:driver_panel/model/order_model.dart';
import 'package:driver_panel/screens/store_list_screen.dart';
import 'package:flutter/material.dart';
import '../cards/delivery_status_card.dart';
import '../utils/colors.dart';
import '../widgets/appbar_card.dart';
import '../widgets/empty_widget.dart';
import '../widgets/show_toast_dialog.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart' as dio;
import '../utils/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'google_navigation_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<dynamic> order = [];
  bool _loading = false;
  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  Future<void> fetchOrders() async {
    setState(() {
      _loading = true;
    });
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
        setState(() {
          order = response.data['data']
              .where((order) =>
          order['status'] == 'Accepted' ||
              order['status'] == 'Pending' ||
              order['status'] == 'Shipped')
              .map((order) => order as Map<String, dynamic>)
              .toList();
          _loading = false;
        });
      }
    // } catch (e) {
    //   print("Error fetching orders: $e");
    //   setState(() {
    //     _loading = false;
    //   });
    // }
  }

  void removeOrder(String orderId) {
    try{
      setState(() {
        order.removeWhere((e) => e['id'].toString() == orderId);
      });
    }
    catch(e){
      print(e);
    }
  }

  checkAllPicked(List<dynamic> orderShippingFees) {
    return orderShippingFees.every((fee) => fee['deliveryStatus'] == 'Prepared');
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
      appBar: appBar(title: 'Order'),
      body: _loading ?
      Skeletonizer(
          enabled: _loading,
          child: const LoadingCard()
      )
     : order.isEmpty ? emptyWidget('No Order to show', context) :
      ListView.builder(
        itemCount: order.length,
        itemBuilder: (context, index) {
          final data = order[index];
          data['order']['_id'] = data['id'];
          data['order']['status'] = data['status'];
          data['order']['startTime'] = data['startTime'];
          data['order']['endTime'] = data['endTime'];
          data['order']['date'] = data['date'];
          final OrderModel latestPendingOrder = OrderModel.fromJson(data['order']);
          final List<dynamic> orderShippingFees = data['order']['orderShippingFees'];
          final bool allPicked = checkAllPicked(orderShippingFees);

          return OrderCard(
            latestPendingOrder: latestPendingOrder,
            orderData: data,
            orderShippingFees: orderShippingFees,
            allPicked: allPicked,
            onOrderStatusChanged: (String status, String orderId) {
              if (status == "Rejected" || status == "Completed") {
                removeOrder(orderId);
                setState(() {});
              }
            },
          );
        },
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final OrderModel? latestPendingOrder;
  List<dynamic>? orderShippingFees;
  final Map<String, dynamic>? orderData;
  bool? allPicked;
  Function(String, String)? onOrderStatusChanged;

  OrderCard({
    super.key,
     this.latestPendingOrder,
     this.orderData,
     this.orderShippingFees,
    this.allPicked,
     this.onOrderStatusChanged,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late List<dynamic> orderShippingFees;
  late OrderModel? order;
  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  @override
  void initState() {
    super.initState();
    order = widget.latestPendingOrder;
  }

  Future<void> updateOrderStatus(String orderId, String status, String comment) async {
    ShowToastDialog.showLoader("Please wait");
    final url = "http://localhost/driver/order/status";
    final data = dio.FormData.fromMap({
      'driverOrderId': orderId,
      'status': status,
      'statusKeyNotes': comment,
    });

    try {
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

      ShowToastDialog.closeLoader();

      if (response.statusCode == 200) {
        if (status == "Rejected") {
          showMessage('Rejected', 'You have successfully rejected the ride.');
        } else {
          setState(() {
            widget.latestPendingOrder!.status = "Accepted";
          });
          showMessage('Accepted', 'You have successfully accepted the ride.');
        }
        widget.onOrderStatusChanged!(status, orderId);
      } else {
        print("Failed to update order status");
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      print("Error updating order status: $e");
    }
  }

  String calculateDuration(String startTime, String endTime, String date) {
    final start = DateTime.parse('$date $startTime:00');
    final end = DateTime.parse('$date $endTime:00');
    final duration = end.difference(start);
    return "${(duration.inHours).abs()} hours";
  }

  Future<void> fetchOrderStatus(String orderId) async {
    // try {
      ShowToastDialog.showLoader("Please wait");
      final url = "http://localhost/driver/order/fetch/$orderId";
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
        setState(() {
          response.data['data']['order']['_id'] = response.data['data']['id'];
          response.data['data']['order']['status'] = response.data['data']['status'];
          order = OrderModel.fromJson(response.data['data']['order']);
          orderShippingFees = response.data['data']['order']['orderShippingFees'];
          widget.allPicked = checkAllPicked(orderShippingFees);
          ShowToastDialog.closeLoader();
          // _loading = false;
        });
      }
    // } catch (e) {
    //   ShowToastDialog.closeLoader();
    //   print("Error fetching order status: $e");
    // }
  }

  checkAllPicked(List<dynamic> orderShippingFees) {
    return orderShippingFees.every((fee) => fee['deliveryStatus'] == 'Prepared' || fee['deliveryStatus'] == 'Delivered');
  }

  Future<void> proceedToDelivery() async {
    await fetchOrderStatus(order!.id.toString());
    print(order!.status);
    if(widget.allPicked == true){
      if (order!.status == 'Accepted') {

        // final result = await Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => NavigationScreen(
        //       id: order!.id.toString(),
        //       data: widget.orderData,
        //     ),
        //   ),
        // );
        // if (result == true) {
        //   widget.onOrderStatusChanged!('Shipped', order!.id.toString());
        // }

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StoreListScreen(
              id: order!.orderId.toString(),
            ),
          ),
        );
      }
      else if (order!.status == 'Prepared') {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NavigationScreen(
              id: order!.id.toString(),
              data: widget.orderData,
            ),
          ),
        );
        if (result == true) {
          widget.onOrderStatusChanged!('Shipped', order!.id.toString());
        }
      } else if (order!.status == 'Shipped') {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CompleteOrderScreen(data: widget.orderData),
          ),
        );
        if (result == true) {
          widget.onOrderStatusChanged!('Completed', order!.id.toString());
        }
      }
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StoreListScreen(
            id: order!.orderId.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (order == null) return const SizedBox.shrink();
    return Card(
      color: const Color(0xFFEEF6F8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Order Id : ${widget.latestPendingOrder!.orderId}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time_outlined, size: 20),
                SizedBox(width: 8),
                Text(calculateDuration(widget.latestPendingOrder!.startTime, widget.latestPendingOrder!.endTime, widget.latestPendingOrder!.date),
                    style: TextStyle(fontSize: 14, color: Colors.black54))
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined),
                SizedBox(width: 5),
                Expanded(
                  flex: 3,
                  child: Text(widget.latestPendingOrder!.address, style: TextStyle(fontSize: 14, color: Colors.black54)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (order!.status == 'Accepted' || order!.status == 'Shipped')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 2, width: 2,),
                  ElevatedButton(
                    onPressed: proceedToDelivery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorRefer.kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Proceed to Delivery', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            if (order!.status == 'Pending')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showRejectOrderDialog(context, (comment) {
                          updateOrderStatus(order!.id.toString(), "Rejected", comment);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF5F5F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        updateOrderStatus(order!.id.toString(), "Accepted", '');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRefer.kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Accept', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
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

}

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Card(
        color: Color(0xFFEEF6F8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Order Id : 1', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time_outlined, size: 20),
                  SizedBox(width: 8),
                  Text('2 hours',
                      style: TextStyle(fontSize: 14, color: Colors.black54))
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 3,
                    child: Text('Sahiwal District, Punjab, Pakistan', style: TextStyle(fontSize: 14, color: Colors.black54)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffF5F5F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Cancel', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRefer.kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Accept', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
