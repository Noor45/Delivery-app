import 'package:driver_panel/widgets/appbar_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EarningDetailsScreen extends StatefulWidget {
  EarningDetailsScreen({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<EarningDetailsScreen> createState() => _EarningDetailsScreenState();
}

class _EarningDetailsScreenState extends State<EarningDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    final orderData = widget.data;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        title: 'Earning Details',
        leadingWidget: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: orderData['orderCompletionImage'] != null ?
              FadeInImage.assetNetwork(
                placeholder: 'assets/images/product.png',
                image: 'http://localhost/${orderData['orderCompletionImage']}',
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ) : Image.asset(
                'assets/images/product.png',
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Completed',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            buildDetailRow('Order Number', '#${orderData['orderId']}'),
            buildDetailRow('Ordered By', orderData['buyerName']),
            buildDetailRow('Delivery Date', DateFormat('dd MMM yyyy').format(DateTime.parse(orderData['date']))),
            buildDetailRow('Product Price', '\$${orderData['totalProductFees']}'),
            buildDetailRow('Shipping Fees', '\$${orderData['totalShippingFees']}'),
            buildDetailRow('Total Price', '\$${orderData['total']}'),
            buildDetailRow('Ride Profit', '\$${orderData['profit']}'),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
