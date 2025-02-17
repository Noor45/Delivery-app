import 'package:driver_panel/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:dio/dio.dart' as dio;
import '../utils/constants.dart';
import '../widgets/appbar_card.dart';
import '../widgets/empty_widget.dart';
import '../widgets/show_toast_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationScreen extends StatefulWidget {
  static String ID = "/notification_screen";
  NotificationScreen({this.id});
  final String? id;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notificationList = [];
  bool loading = false;
  final dio.Dio _dio = dio.Dio();

  var data = {'message': 'You have accepted the order. Please proceed with processing and prepare for shipment soon.', 'seen': 'no', 'createdAt': '2024-11-12T13:38:44.843Z'};

  Future<void> getNotification() async {
    setState(() => loading = true);
    final response = await _dio.get(
      'http://localhost/driver/notifications/',
      options: dio.Options(
        method: 'GET',
        headers: {
          'Authorization': 'Bearer ${Constants.userData!.token}',
        },
      ),
    );
    if (response.statusCode == 200 && response.data != null) {
      setState(() {
        notificationList = response.data['notifications'];
        notificationList = notificationList.reversed.toList();
      });
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ShowToastDialog.closeLoader();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        title: 'Notifications',
        leadingWidget: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: loading
          ? Skeletonizer(child: NotificationCard(notification: data)) :
            notificationList.isEmpty ? emptyWidget('No Notification to show', context)
          : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              reverse: false,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final notification = notificationList[index];
                return NotificationCard(notification: notification);
              },
            ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final dynamic notification;
  NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final message = notification['message'] ?? '';
    final seen = notification['seen'] == 'yes';
    final createdAt = DateTime.parse(notification['createdAt']);
    final timeAgo = timeago.format(createdAt);

    return Card(
      color: seen ? Colors.white : Colors.blue.shade50,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: Icon(
          Icons.notifications,
          color: Colors.grey,
          size: 30,
        ),
        title: Text(
          message,
          style: TextStyle(
            fontSize: 12,
            fontWeight: seen ? FontWeight.normal : FontWeight.bold,
            color: seen ? Colors.black54 : Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            timeAgo,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        trailing: Icon(
          Icons.circle,
          size: 12,
          color: seen ? Colors.blue.shade50 : ColorRefer.kPrimaryColor,
        ),
      ),
    );
  }
}
