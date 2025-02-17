import 'package:driver_panel/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import '../utils/constants.dart';
import '../widgets/appbar_card.dart';
import '../widgets/empty_widget.dart';
import 'earning_detail_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EarningScreen extends StatefulWidget {
  static String ID = "/payment_detail_screen";
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  bool _loading = false;
  double totalEarnings = 0.0;
  List<Map<String, dynamic>> orders = [];

  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  Future<void> fetchOrders() async {
    final url = "http://localhost/driver/classification/history";
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
        final data = response.data;
        totalEarnings = data['totalEarnings']?.toDouble() ?? 0.0;
        orders = (data['history'] as List).map((historyItem) {
          final order = historyItem['order'];
          return {
            'orderId': historyItem['orderId'].toString(),
            'location': order['address'] ?? 'No Address',
            'profit': historyItem['profit']?.toString() ?? '0',
            'orderCompletionImage': order['orderCompletionImage'],
            'data': historyItem
          };
        }).toList();
      }
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        title: 'Earnings',
      ),
      body: _loading
          ? Skeletonizer(
            enabled: _loading,
            child: EarningEmptyCard()
          ) : orders.isEmpty ? emptyWidget('No Order to show', context)
          : Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AmountCard(totalEarnings: totalEarnings),
                  SizedBox(height: 10),
                  Text(
                    'Order List',
                    style: TextStyle(
                      color: ColorRefer.kPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final color = index % 2 == 0
                            ? Color(0xFFEEF6F8)
                            : Color(0xFFCCDFE3);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                    EarningDetailsScreen(
                                      data: {
                                        'orderCompletionImage': order['data']['order']['orderCompletionImage'],
                                        'buyerName': order['data']['order']['buyer']['name'],
                                        'date': order['data']['date'],
                                        'totalProductFees': order['data']['order']['totalProductFees'],
                                        'totalShippingFees': order['data']['order']['totalShippingFees'],
                                        'total': order['data']['order']['total'],
                                        'profit': order['data']['profit'],
                                        'orderId': order['data']['orderId'],
                                      },

                                    )
                                )
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              children: [
                                order['orderCompletionImage'] != null ?
                                FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/product.png',
                                  image: 'http://localhost/${order['orderCompletionImage']}',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ) : Image.asset(
                                  'assets/images/product.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order ID #${order['orderId']}',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        order['location'],
                                        style: TextStyle(fontSize: 12, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$ ${order['profit']}/-',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class AmountCard extends StatelessWidget {
  final double totalEarnings;

  const AmountCard({Key? key, required this.totalEarnings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFEEF6F8), // Light background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL AMOUNT',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '\$ ${totalEarnings.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class EarningEmptyCard extends StatelessWidget {
  List users = [
    {'orderId': '1', 'location': 'South Delhi', 'price': '49', 'color': '#EEF6F8'},
    {'orderId': '2', 'location': 'Sector 15, Noida', 'price': '99', 'color': '#EEF6F8'},
    {'orderId': '3', 'location': 'Sector 18, Noida', 'price': '99', 'color': '#EEF6F8'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AmountCard(
              totalEarnings: 400.0,
            ),
            SizedBox(height: 10),
            Text(
              'Order List',
              style: TextStyle(color: ColorRefer.kPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        color: Color(int.parse(users[index]['color']!.substring(1, 7), radix: 16) + 0xFF000000),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order ID #${users![index]['orderId']!}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                users![index]['location']!,
                                style: TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$ ${users![index]['price']}/-',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
