import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/colors.dart';
import '../widgets/appbar_card.dart';

class OrderHistoryDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  OrderHistoryDetailScreen({super.key, required this.data});

  @override
  State<OrderHistoryDetailScreen> createState() => _OrderHistoryDetailScreenState();
}

class _OrderHistoryDetailScreenState extends State<OrderHistoryDetailScreen> {
  String getOrderStatus() {
    List<dynamic> shippingFees = widget.data['order']['orderShippingFees'] ?? [];
    if (widget.data['status'] == 'Completed') return 'Completed';
    if (widget.data['status'] == 'Shipped') return 'Shipped';
    if (shippingFees.every((fee) => fee['deliveryStatus'] == 'Prepared')) {
      return 'On the way';
    }
    if (shippingFees.any((fee) => fee['deliveryStatus'] == 'Prepared')) {
      return 'Loaded';
    }
    return 'Accepted';
  }

  @override
  Widget build(BuildContext context) {
    var order = widget.data['order'];
    var driver = widget.data['driver'];
    var buyer = order['buyer'];
    var address = jsonDecode(order['origin']);
    String orderStatus = getOrderStatus();
    bool isAccepted = orderStatus == 'Accepted' ||
        orderStatus == 'Loaded' ||
        orderStatus == 'On the way' ||
        orderStatus == 'Shipped' ||
        orderStatus == 'Completed';

    bool isLoaded = orderStatus == 'Loaded' ||
        orderStatus == 'On the way' ||
        orderStatus == 'Shipped' ||
        orderStatus == 'Completed';

    bool isOnTheWay = orderStatus == 'On the way' ||
        orderStatus == 'Shipped' ||
        orderStatus == 'Completed';

    bool isDelivered = orderStatus == 'Shipped' ||
        orderStatus == 'Completed';

    bool isCompleted = orderStatus == 'Completed';

    return Scaffold(
      appBar: appBar(
        title: 'Order Detail',
        leadingWidget: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        decoration: BoxDecoration(
          color: ColorRefer.kSecondaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order ID #${order['id']}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: order['id'].toString()));
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
            SizedBox(height: 16),
            Text(
              // 'Origin',
              orderStatus,
              style: TextStyle(
                color: Colors.black26,
                fontSize: 12,
              ),
            ),
            LocationSection(
              locationName: '${driver['firstName']} ${driver['lastName']}',
              phone: driver['phone'],
              address: '${address['location']}',
            ),
            SizedBox(height: 16),

            ShipmentStatus(
              status: 'Accepted',
              isActive: isAccepted,
              isFirst: true,
            ),
            ShipmentStatus(
              status: 'Loaded',
              isActive: isLoaded,
            ),
            ShipmentStatus(
              status: 'On the way',
              isActive: isOnTheWay,
            ),
            ShipmentStatus(
              status: 'Delivered',
              isActive: isDelivered,
            ),
            ShipmentStatus(
              status: 'Completed',
              isActive: isCompleted,
            ),
            SizedBox(height: 16),

            // Driver's Origin Info
            Text(
              'Destination',
              style: TextStyle(
                color: Colors.black26,
                fontSize: 12,
              ),
            ),
            LocationSection(
              locationName: '${order['name']}',
              phone: order['number'],
              address: order['address'],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class LocationSection extends StatelessWidget {
  final String locationName;
  final String address;
  final String phone;

  LocationSection({required this.locationName, required this.address, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locationName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                phone,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              Text(
                address,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.location_on, color: ColorRefer.kPrimaryColor),
      ],
    );
  }
}

class ShipmentStatus extends StatelessWidget {
  final String status;
  final bool isActive;
  final bool isFirst;

  ShipmentStatus({
    required this.status,
    required this.isActive,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (isFirst)
              Container(
                width: 2,
                height: 30,
                color: isActive ? ColorRefer.kPrimaryColor : Colors.grey,
              ),
            Icon(
              Icons.radio_button_checked,
              color: isActive ? ColorRefer.kPrimaryColor : Colors.grey,
              size: 16,
            ),
            Container(
              width: 2,
              height: 30,
              color: isActive ? ColorRefer.kPrimaryColor : Colors.grey,
            ),
          ],
        ),
        SizedBox(width: 8),
        Padding(
          padding: EdgeInsets.only(top: isFirst ? 25 : 0),
          child: Text(
            status,
            style: TextStyle(
              color: isActive ? ColorRefer.kPrimaryColor : Colors.grey,
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
