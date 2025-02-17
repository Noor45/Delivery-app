// import 'package:flutter/material.dart';
// import '../utils/colors.dart';
// import '../widgets/appbar_card.dart';
// import '../widgets/round_btn.dart';
// import '../widgets/show_toast_dialog.dart';
//
// class StoreListScreen extends StatefulWidget {
//   static String ID = "/store_list_screen";
//   @override
//   _StoreListScreenState createState() => _StoreListScreenState();
// }
//
// class _StoreListScreenState extends State<StoreListScreen> {
//   final List<Map<String, dynamic>> users = [
//     {
//       'name': 'Sophiya Korynets',
//       'location': 'Lviv, Ukraine',
//       'action': 'Picked',
//       'image': 'assets/images/user.png',
//     },
//     {
//       'name': 'Nataliya Sambir | LINKUP ST...',
//       'location': 'Lviv, Ukraine',
//       'action': 'Items',
//       'image': 'assets/images/user.png',
//     },
//     {
//       'name': 'Alex Bogitsoi',
//       'location': 'Romania',
//       'action': 'Picked',
//       'image': 'assets/images/user.png',
//     },
//     {
//       'name': 'Linkup Studio',
//       'location': 'Ukraine',
//       'action': 'Items',
//       'image': 'assets/images/user.png',
//       'isPro': true,
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     ShowToastDialog.closeLoader();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Pickup'),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 10),
//               child: ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   final user = users[index];
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: AssetImage(user['image']),
//                       radius: 24,
//                     ),
//                     title: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             user['name'],
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     subtitle: Row(
//                       children: [
//                         const Icon(Icons.location_on, size: 20, color: ColorRefer.kPrimaryColor),
//                         const SizedBox(width: 2),
//                         Text(
//                           user['location'],
//                           style: TextStyle(color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                     trailing: ElevatedButton(
//                       onPressed: () {
//                         if(user['action'] == 'Items'){
//                           _showBottomSheet(context, user);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: user['action'] == 'Picked'
//                             ? ColorRefer.kPrimaryColor
//                             : Colors.grey[200],
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                       ),
//                       child: Text(
//                         user['action'],
//                         style: TextStyle(
//                           color: user['action'] == 'Picked'
//                               ? Colors.white
//                               : Colors.black,
//                         ),
//                       ),
//                     ),
//                     onTap: () {
//                       if(user['action'] == 'Items'){
//                         _showBottomSheet(context, user);
//                       }
//                     }, // Show Bottom Sheet on tap
//                   );
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: RoundedButton(
//               title: 'All Orders Picked',
//               buttonRadius: 10,
//               colour: ColorRefer.kPrimaryColor,
//               height: 48,
//               onPressed: () async {
//                 // Add your onPressed logic here
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Function to show the Bottom Sheet
//   // void _showBottomSheet(BuildContext context, Map<String, dynamic> user) {
//   //   showModalBottomSheet(
//   //     context: context,
//   //     shape: RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//   //     ),
//   //     builder: (BuildContext context) {
//   //       return Padding(
//   //         padding: const EdgeInsets.all(16.0),
//   //         child: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             // Display user details or any other information as needed
//   //             Text(
//   //               user['name'],
//   //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//   //             ),
//   //             SizedBox(height: 8),
//   //             Text(user['location']),
//   //             SizedBox(height: 16),
//   //             // Add the RoundedButton as specified
//   //             RoundedButton(
//   //               title: 'Mark Picked',
//   //               buttonRadius: 10,
//   //               colour: ColorRefer.kPrimaryColor,
//   //               height: 48,
//   //               onPressed: () async {
//   //                 // Add your onPressed logic here
//   //               },
//   //             ),
//   //           ],
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//   void _showBottomSheet(BuildContext context, Map<String, dynamic> user) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 user['name'],
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 5),
//               Row(
//                 children: [
//                   const Icon(Icons.location_on, size: 20, color: ColorRefer.kPrimaryColor),
//                   const SizedBox(width: 5),
//                   Text(user['location']),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Expanded(
//                 child: ListView(
//                   children: [
//                     _buildItem(
//                         image: 'assets/images/user.png',
//                         title: 'iPhone 5s Gold',
//                         description: '32GB SIM-Free (GSM)',
//                         price: '\$749.00'
//                     ),
//                     _buildItem(
//                         image: 'assets/images/user.png',
//                         title: 'Beats Solo HD',
//                         description: 'Drenched in Black',
//                         price: '\$169.95'
//                     ),
//                     _buildItem(
//                         image: 'assets/images/user.png',
//                         title: 'Gaming Controller',
//                         description: 'SteelSeries Stratus (Wireless)',
//                         price: '\$79.95'
//                     ),
//                     _buildItem(
//                         image: 'assets/images/user.png',
//                         title: 'Enzo Ferrari Car',
//                         description: 'Bluetooth Remote Control',
//                         price: '\$79.95'
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               // Add the RoundedButton
//               RoundedButton(
//                 title: 'Mark Picked',
//                 buttonRadius: 10,
//                 colour: ColorRefer.kPrimaryColor,
//                 height: 48,
//                 onPressed: () async {
//                   // Add your onPressed logic here
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildItem({required String image, required String title, required String description, required String price}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Image.asset(image, width: 50, height: 50, fit: BoxFit.cover),
//           SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 4),
//                 Text(description, style: TextStyle(color: Colors.grey)),
//                 SizedBox(height: 8),
//                 Text(price, style: TextStyle(fontSize: 16, color: Colors.green)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }
import 'package:driver_panel/screens/google_navigation_screen.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'package:dio/dio.dart' as dio;
import '../widgets/round_btn.dart';
import '../widgets/show_toast_dialog.dart';

class StoreListScreen extends StatefulWidget {
  static String ID = "/store_list_screen";
  StoreListScreen({this.id});
  final String? id;

  @override
  _StoreListScreenState createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  List<dynamic> orderShippingFees = [];
  List<dynamic> orderProductFees = [];
  bool allPicked = false;
  final dio.Dio _dio = dio.Dio();
  var data;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    setState(() {
      ShowToastDialog.showLoader("Please wait");
    });
    final url = "http://localhost/driver/order/fetch/";
    // try {
    final response = await _dio.get(
      url,
      options: dio.Options(
        headers: {
          'Authorization': 'Bearer ${Constants.userData!.token}',
        },
      ),
    );
    if (response.statusCode == 200) {
      ShowToastDialog.closeLoader();
      final List responseData = response.data['data'];
      setState(() {
         responseData.forEach((e){
          if(e['orderId'].toString() == widget.id.toString()){
            data = e;
          }
        });
        orderShippingFees = data['order']['orderShippingFees'];
        orderProductFees = data['order']['orderProduct'];
        checkAllPicked();
      });
    }else{
      ShowToastDialog.closeLoader();
    }
  }

  void checkAllPicked() {
    allPicked = orderShippingFees.every((fee) => fee['deliveryStatus'] == 'Prepared');
  }

  Future<void> markPicked(int index, String OrderStoreId, String status) async {
    setState(()  {
      orderShippingFees[index]['deliveryStatus'] = 'Prepared';
      checkAllPicked();
    });
    var data = dio.FormData.fromMap({
      'OrderStoreId': OrderStoreId,
      'status': status,
    });
    final response = await _dio.put(
      'http://localhost/driver/order/order/store/status',
      options: dio.Options(
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer ${Constants.userData!.token}',
        },
      ),
      data: data,
    );
    if (response.statusCode == 200) {
      showMessage('Marked', 'Pick Items Successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    ShowToastDialog.closeLoader();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Pickup'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: orderShippingFees.length,
                itemBuilder: (context, index) {
                  final shippingFee = orderShippingFees[index];
                  final isAdminOrder = shippingFee['admin'] != null;
                  final isPicked = shippingFee['deliveryStatus'] == 'Prepared';
                  String name = isAdminOrder
                      ? "Admin"
                      : shippingFee['store']?['storeName'] ?? 'Unknown Store';
                  String location = shippingFee['location'] ?? 'No Address';
                  String imageUrl = isAdminOrder
                      ? 'assets/images/user.png'
                      : shippingFee['store']?['logo'] ?? 'assets/images/user.png';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(imageUrl),
                      radius: 24,
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: const Icon(Icons.location_on, size: 20, color: ColorRefer.kPrimaryColor),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          flex: 3,
                          child: Text(
                            location,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        if (!isPicked) {
                          _showBottomSheet(context, index);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPicked
                            ? ColorRefer.kPrimaryColor
                            : Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        isPicked ? 'Picked' : 'Items',
                        style: TextStyle(
                          color: isPicked ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoundedButton(
              title: 'All Orders Picked',
              buttonRadius: 10,
              colour: allPicked ? ColorRefer.kPrimaryColor : Colors.grey,
              height: 48,
              onPressed: allPicked ? () async {
               await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        NavigationScreen(
                            id: data['id'].toString(),
                            data: data,
                        )
                    )
                );
               Navigator.pop(context);
              } : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, int index) {
    final shippingFee = orderShippingFees[index];
    final productList = orderProductFees.any((p) => p['product']['productOwner'] == 'admin')
        ? orderProductFees.where((p) => p['product']['adminId'] != null).toList()
        : orderProductFees.where((p) => p['product']['storeId'] == shippingFee['storeId']).toList();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shippingFee['store']?['storeName'] ?? 'Admin',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 20, color: ColorRefer.kPrimaryColor),
                  const SizedBox(width: 5),
                  Text(shippingFee['location'] ?? 'No Address'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (context, idx) {
                    final product = productList[idx]['product'];
                    final productImage = product['primaryImage'] ?? 'assets/images/product.png';
                    final productName = product['productName'] ?? 'Product';
                    final productPrice = productList[idx]['price'].toString();
                    final productQuantity = productList[idx]['quantity'] ?? 1;

                    return _buildItem(
                      image: productImage,
                      title: productName,
                      description: 'Quantity: $productQuantity',
                      price: '\$${productPrice}',
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              RoundedButton(
                title: 'Mark Picked',
                buttonRadius: 10,
                colour: ColorRefer.kPrimaryColor,
                height: 48,
                onPressed: () async{
                  ShowToastDialog.showLoader("Please wait");
                  await markPicked(index, shippingFee['id'].toString(), 'Prepared')
                      .then((onValue){
                    Navigator.pop(context);
                    ShowToastDialog.closeLoader();
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem({required String image, required String title, required String description, required String price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInImage.assetNetwork(
              image: 'http://localhost/$image',
              width: 50, height: 50, fit: BoxFit.cover,
              placeholder: 'assets/images/product.png',
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(price, style: const TextStyle(fontSize: 16, color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
