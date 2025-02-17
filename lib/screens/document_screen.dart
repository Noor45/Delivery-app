// import 'package:driver_panel/widgets/appbar_card.dart';
// import 'package:flutter/material.dart';
//
// import '../services/document_service.dart';
// import '../utils/colors.dart';
// import '../widgets/show_toast_dialog.dart';
//
// class DocumentVerificationScreen extends StatefulWidget {
//   static String ID = "/document_screen";
//   const DocumentVerificationScreen({super.key});
//
//   @override
//   State<DocumentVerificationScreen> createState() => _DocumentVerificationScreenState();
// }
//
// class _DocumentVerificationScreenState extends State<DocumentVerificationScreen> {
//   final List<Map<String, String>> documents = [
//     {"name": "Service Area", "status": "Unverified", "route": "/service_area_screen"},
//     {"name": "Vehicle Information", "status": "Unverified", "route": "/vehicle_information_screen"},
//     {"name": "Driving licence", "status": "Unverified", "route": "/license_screen"},
//     {"name": "Primary Address", "status": "Unverified", "route": "/primary_address_screen"},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     ShowToastDialog.closeLoader();
//     return Scaffold(
//       appBar: appBar(
//         title: 'Document Verification',
//         leadingWidget: IconButton(
//             onPressed: (){
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back, color: Colors.white)
//         )
//       ),
//       body: ListView.builder(
//         itemCount: documents.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: ListTile(
//               title: Text(documents[index]['name']!),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//                     decoration: BoxDecoration(
//                       color: ColorRefer.kPrimaryColor,
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Text(
//                       documents[index]['status']!,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16.0),
//                   const Icon(Icons.arrow_forward_ios),
//                 ],
//               ),
//               onTap: () async{
//                 ShowToastDialog.showLoader('Please wait');
//                 await DocumentService().fetchAndParseDriverData(context: context, route: documents[index]['route']!);
//                 ShowToastDialog.closeLoader();
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
import 'package:driver_panel/widgets/appbar_card.dart';
import 'package:flutter/material.dart';
import '../services/document_service.dart';
import '../utils/colors.dart';
import '../widgets/show_toast_dialog.dart';

class DocumentVerificationScreen extends StatefulWidget {
  static String ID = "/document_screen";
  const DocumentVerificationScreen({super.key});

  @override
  State<DocumentVerificationScreen> createState() => _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState extends State<DocumentVerificationScreen> {
  List<Map<String, dynamic>> documents = [
    {"name": "Service Area", "status": "Unverified", "route": "/service_area_screen"},
    {"name": "Vehicle Information", "status": "Unverified", "route": "/vehicle_information_screen"},
    {"name": "Driving Licence", "status": "Unverified", "route": "/license_screen"},
    {"name": "Primary Address", "status": "Unverified", "route": "/primary_address_screen"},
  ];

  @override
  void initState() {
    fetchVerificationStatus();
    super.initState();
  }

  Future<void> fetchVerificationStatus() async {
    ShowToastDialog.showLoader('Loading');
    try {
      final response = await DocumentService().fetchDriverData(); // Assuming this method returns the API data
      setState(() {
        documents[0]['status'] = response['servicesArea'][0]['status'] == "Verified" ? "Verified" : "Unverified";
        documents[1]['status'] = response['vehicleInformation'][0]['status'] == "Verified" ? "Verified" : "Unverified";
        documents[2]['status'] = response['drivingLicence'][0]['status'] == "Verified" ? "Verified" : "Unverified";
        documents[3]['status'] = response['driverAddress'][0]['status'] == "Verified" ? "Verified" : "Unverified";
      });
    } catch (e) {
      ShowToastDialog.showToast("Failed to load verification status.");
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Document Verification',
        leadingWidget: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(documents[index]['name']!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: documents[index]['status'] == "Verified"
                          ? Colors.green
                          : ColorRefer.kPrimaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      documents[index]['status'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: () async {
                ShowToastDialog.showLoader('Please wait');
                await DocumentService().fetchAndParseDriverData(
                  context: context,
                  route: documents[index]['route']!,
                );
                ShowToastDialog.closeLoader();
              },
            ),
          );
        },
      ),
    );
  }
}
