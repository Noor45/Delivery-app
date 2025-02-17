// import 'dart:io';
// import 'package:flutter/material.dart';
// import '../utils/colors.dart';
// import '../utils/constants.dart';
// import '../../widgets/input_filed.dart';
// import '../widgets/ImagePicker.dart';
// import '../widgets/round_btn.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class ProfileScreen extends StatefulWidget {
//   static String ID = "/profile_screen";
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   File? image;
//   final picker = ImagePicker();
//   void pickImage(ImageSource imageSource) async {
//     XFile? galleryImage = await picker.pickImage(source: imageSource);
//     setState(() {
//       image = File(galleryImage!.path);
//     });
//   }
//
//   @override
//   void initState() {
//     _dateController.text = Constants.userData!.dob!;
//     _firstNameController.text = Constants.userData!.firstName!;
//     _lastNameController.text = Constants.userData!.lastName!;
//     _emailController.text = Constants.userData!.email!;
//     _dateController.text = Constants.userData!.dob!;
//     _phoneController.text = Constants.userData!.phone!;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Upper Background
//           Container(
//             height: 250,
//             decoration: BoxDecoration(
//               color: ColorRefer.kPrimaryColor,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(50),
//                 bottomRight: Radius.circular(50),
//               ),
//             ),
//           ),
//           // Scrollable Profile Content
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 150),
//               child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 20),
//                 padding: EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Center(
//                       child: InkWell(
//                         onTap: () {
//                           showImageDialogBox();
//                         },
//                         child: Stack(
//                           clipBehavior: Clip.none,
//                           children: [
//                             Container(
//                               height: 125,
//                               width: 125,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                               ),
//                               child: image != null
//                                   ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(65),
//                                 child: Image.file(image!, fit: BoxFit.cover),
//                               ) : Constants.userData!.image != null
//                                   && Constants.userData!.image!.isEmpty == false  ?
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(65),
//                                 child: FadeInImage.assetNetwork(
//                                   image: 'http://localhost/${Constants.userData!.image as String}',
//                                   fit: BoxFit.cover,
//                                   placeholder: 'assets/images/user.png',
//                                 ),
//                               ) : Image.asset('assets/images/user.png'),
//                             ),
//                             Positioned(
//                               left: 90,
//                               bottom: 10,
//                               child: SvgPicture.asset(
//                                 'assets/icons/camera.svg',
//                                 width: 30,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     // Profile Picture
//                     // CircleAvatar(
//                     //   radius: 50,
//                     //   backgroundColor: Colors.grey[200],
//                     //   child: Icon(Icons.person, size: 60, color: ColorRefer.kPrimaryColor),
//                     // ),
//                     SizedBox(height: 10),
//                     ProfileTextField(
//                       readonly: false,
//                       controller: _firstNameController,
//                       textInputType: TextInputType.text,
//                       onChanged: (value){},
//                       label: 'First Name',
//                       hintText: '',
//                       suffixIcon: SizedBox(),
//                     ),
//                     SizedBox(height: 20),
//                     ProfileTextField(
//                       readonly: false,
//                       controller: _lastNameController,
//                       textInputType: TextInputType.text,
//                       onChanged: (value){},
//                       label: 'Last Name',
//                       hintText: '',
//                       suffixIcon: SizedBox(),
//                     ),
//                     SizedBox(height: 20),
//                     ProfileTextField(
//                       readonly: false,
//                       controller: _emailController,
//                       textInputType: TextInputType.text,
//                       onChanged: (value){},
//                       label: 'Email',
//                       hintText: '',
//                       suffixIcon: SizedBox(),
//                     ),
//                     SizedBox(height: 20),
//                     ProfileTextField(
//                       readonly: false,
//                       controller: _phoneController,
//                       textInputType: TextInputType.text,
//                       onChanged: (value){},
//                       label: 'Phone',
//                       hintText: '',
//                       suffixIcon: SizedBox(),
//                     ),
//                     SizedBox(height: 20),
//                     ProfileTextField(
//                       readonly: true,
//                       controller: _dateController,
//                       textInputType: TextInputType.text,
//                       onChanged: (value){},
//                       label: 'Date of Birth',
//                       hintText: '',
//                       onTap: () async {
//                         DateTime? pickedDate = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2000),
//                           lastDate: DateTime(2101),
//                           builder: (BuildContext context, Widget? child) {
//                             return Theme(
//                               data: ThemeData.light().copyWith(
//                                 primaryColor: ColorRefer.kPrimaryColor, // Header background color
//                                 colorScheme: const ColorScheme.light(
//                                   primary: ColorRefer.kPrimaryColor, // Selection color
//                                   onPrimary: Colors.white,
//                                   surface:  Colors.white,  // Background color of the picker
//                                   onSurface: Colors.black, // Text color on surface
//                                 ),
//                                 dialogBackgroundColor: Colors.white, // Background color of the dialog
//                               ),
//                               child: child!,
//                             );
//                           },
//                         );
//
//                         if (pickedDate != null) {
//                           setState(() {
//                             _dateController.text =
//                             "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
//                           });
//                         }
//                       },
//                       suffixIcon: SizedBox(),
//                     ),
//                     // Profile Information Form
//                     // TextFormField(
//                     //   decoration: InputDecoration(
//                     //     labelText: 'First Name',
//                     //     // hintText: 'Aaron',
//                     //   ),
//                     // ),
//                     // TextFormField(
//                     //   decoration: InputDecoration(
//                     //     labelText: 'Last Name',
//                     //     // hintText: 'Graham',
//                     //   ),
//                     // ),
//                     // TextFormField(
//                     //   decoration: InputDecoration(
//                     //     labelText: 'Email',
//                     //     // hintText: 'aarong@gmail.com',
//                     //   ),
//                     // ),
//                     // GestureDetector(
//                     //   onTap: () {
//                     //     // Handle Date of Birth selection
//                     //   },
//                     //   child: AbsorbPointer(
//                     //     child: TextFormField(
//                     //       decoration: InputDecoration(
//                     //         labelText: 'Birth',
//                     //         // hintText: 'Select Date',
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                     // GestureDetector(
//                     //   onTap: () {
//                     //     // Handle Gender selection
//                     //   },
//                     //   child: AbsorbPointer(
//                     //     child: TextFormField(
//                     //       decoration: InputDecoration(
//                     //         labelText: 'Gender',
//                     //         hintText: 'Select Gender',
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                     SizedBox(height: 40),
//                     // Change Password Button
//                     // ElevatedButton.icon(
//                     //   onPressed: () {
//                     //     // Handle Change Password action
//                     //   },
//                     //   icon: Icon(Icons.lock),
//                     //   label: Text('Change Password'),
//                     //   style: ElevatedButton.styleFrom(
//                     //     backgroundColor: Colors.black,
//                     //     shape: RoundedRectangleBorder(
//                     //       borderRadius: BorderRadius.circular(20),
//                     //     ),
//                     //     padding: EdgeInsets.symmetric(vertical: 16),
//                     //   ),
//                     // ),
//                     // SizedBox(height: 10),
//                     RoundedButton(
//                       title: 'SAVE',
//                       buttonRadius: 10,
//                       colour: ColorRefer.kPrimaryColor,
//                       height: 48,
//                       onPressed: () async {
//                       },
//                     ),
//                     // Logout Button
//                     // TextButton.icon(
//                     //   onPressed: () {
//                     //     // Handle Logout action
//                     //   },
//                     //   icon: Icon(Icons.logout, color: Colors.red),
//                     //   label: Text(
//                     //     'Logout',
//                     //     style: TextStyle(color: Colors.red),
//                     //   ),
//                     //   style: TextButton.styleFrom(
//                     //     padding: EdgeInsets.symmetric(vertical: 16),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // Back Button
//           Positioned(
//             top: 50,
//             left: 20,
//             child: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   showImageDialogBox() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           color: Color(0xFF737373),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).canvasColor,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               ),
//             ),
//             child: CameraGalleryBottomSheet(
//               cameraClick: () => pickImage(ImageSource.camera),
//               galleryClick: () => pickImage(ImageSource.gallery),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
import 'dart:convert';  // For json encoding
import 'package:dio/dio.dart' as dio;
import 'package:driver_panel/utils/constants.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/profile_service.dart';
import '../widgets/ImagePicker.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../../widgets/input_filed.dart';
import '../widgets/round_btn.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/vehicle_info_service.dart';
import '../widgets/show_toast_dialog.dart';

class ProfileScreen extends StatefulWidget {
  static String ID = "/profile_screen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _apiService = ProfileService();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _dateController.text = Constants.userData!.dob!;
    _firstNameController.text = Constants.userData!.firstName!;
    _lastNameController.text = Constants.userData!.lastName!;
    _emailController.text = Constants.userData!.email!;
    _phoneController.text = Constants.userData!.phone!;
  }

  void pickImage(ImageSource imageSource) async {
    XFile? galleryImage = await picker.pickImage(source: imageSource);
    setState(() {
      image = File(galleryImage!.path);
    });
  }

  Future<void> updateProfile() async {
    ShowToastDialog.showLoader("Please wait");
    await _apiService.updateProfile(
      _firstNameController.text,
      _lastNameController.text,
      Constants.userData!.userName!,
      _emailController.text,
      Constants.userData!.password!,
      _phoneController.text,
      _dateController.text,
      Constants.userData!.id.toString(),
      Constants.userData!.image.toString(),
      image,
    );
    ShowToastDialog.closeLoader();
  //   var uri = Uri.parse("http://localhost/driver/auth/update");
  //   var request = http.MultipartRequest("PUT", uri);
  //
  //   request.fields['firstName'] = _firstNameController.text;
  //   request.fields['lastName'] = _lastNameController.text;
  //   request.fields['userName'] = Constants.userData!.userName!;
  //   request.fields['email'] = _emailController.text;
  //   request.fields['password'] = Constants.userData!.password!;
  //   request.fields['phone'] = _phoneController.text;
  //   request.fields['dob'] = _dateController.text;
  //   request.fields['id'] = Constants.userData!.id.toString();
  //
  //   if (image != null) {
  //     request.files.add(await http.MultipartFile.fromPath('images', image!.path));
  //   }
  //
  //   var response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     var responseBody = await response.stream.bytesToString();
  //     var data = jsonDecode(responseBody);
  //
  //     if (data['code'] == 200) {
  //       // Update Constants.userData with the new profile data
  //       Constants.userData!.firstName = data['driver']['firstName'];
  //       Constants.userData!.lastName = data['driver']['lastName'];
  //       Constants.userData!.email = data['driver']['email'];
  //       Constants.userData!.phone = data['driver']['phone'];
  //       Constants.userData!.dob = data['driver']['dob'];
  //       Constants.userData!.image = data['driver']['image'];
  //
  //       // Save updated data in session
  //       var sessionManager = SessionManager();
  //       await sessionManager.set("user", json.encode(Constants.userData?.toJson()));
  //
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully")));
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update profile")));
  //   }
  }

  @override
  Widget build(BuildContext context) {
    ShowToastDialog.closeLoader();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, Constants.userData); // Send Constants.userData when user pops back
        return false; // Prevents default back navigation to ensure we control the return data
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Upper Background
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: ColorRefer.kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
            // Scrollable Profile Content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            showImageDialogBox();
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 125,
                                width: 125,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: image != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(65),
                                  child: Image.file(image!, fit: BoxFit.cover),
                                )
                                    : Constants.userData!.image != null &&
                                    Constants.userData!.image!.isNotEmpty
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(65),
                                      child: FadeInImage.assetNetwork(
                                        image: 'http://localhost/${Constants.userData!.image!}',
                                        fit: BoxFit.cover,
                                        placeholder: 'assets/images/user.png',
                                      ),
                                )
                                    : Image.asset('assets/images/user.png'),
                              ),
                              Positioned(
                                left: 90,
                                bottom: 10,
                                child: SvgPicture.asset(
                                  'assets/icons/camera.svg',
                                  width: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ProfileTextField(
                        readonly: false,
                        controller: _firstNameController,
                        textInputType: TextInputType.text,
                        onChanged: (value) {},
                        label: 'First Name',
                        hintText: '',
                        suffixIcon: SizedBox(),
                      ),
                      SizedBox(height: 20),
                      ProfileTextField(
                        readonly: false,
                        controller: _lastNameController,
                        textInputType: TextInputType.text,
                        onChanged: (value) {},
                        label: 'Last Name',
                        hintText: '',
                        suffixIcon: SizedBox(),
                      ),
                      SizedBox(height: 20),
                      ProfileTextField(
                        readonly: true,
                        controller: _emailController,
                        textInputType: TextInputType.text,
                        onChanged: (value) {},
                        label: 'Email',
                        hintText: '',
                        suffixIcon: SizedBox(),
                      ),
                      SizedBox(height: 20),
                      ProfileTextField(
                        readonly: false,
                        controller: _phoneController,
                        textInputType: TextInputType.text,
                        onChanged: (value) {},
                        label: 'Phone',
                        hintText: '',
                        suffixIcon: SizedBox(),
                      ),
                      SizedBox(height: 20),
                      ProfileTextField(
                        readonly: true,
                        controller: _dateController,
                        textInputType: TextInputType.text,
                        onChanged: (value) {},
                        label: 'Date of Birth',
                        hintText: '',
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: ColorRefer.kPrimaryColor,
                                  colorScheme: const ColorScheme.light(
                                    primary: ColorRefer.kPrimaryColor,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                  dialogBackgroundColor: Colors.white,
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (pickedDate != null) {
                            setState(() {
                              _dateController.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                            });
                          }
                        },
                        suffixIcon: SizedBox(),
                      ),
                      SizedBox(height: 40),
                      RoundedButton(
                        title: 'SAVE',
                        buttonRadius: 10,
                        colour: ColorRefer.kPrimaryColor,
                        height: 48,
                        onPressed: () async {
                          await updateProfile();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  showImageDialogBox() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Color(0xFF737373),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: CameraGalleryBottomSheet(
              cameraClick: () => pickImage(ImageSource.camera),
              galleryClick: () => pickImage(ImageSource.gallery),
            ),
          ),
        );
      },
    );
  }
}
