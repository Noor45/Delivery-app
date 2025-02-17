import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../widgets/input_filed.dart';
import '../../widgets/round_btn.dart';
import '../../widgets/show_toast_dialog.dart';
import '../main_screen.dart';

class SignInScreen extends StatefulWidget {
  static String signInScreenID = "/sign_in_screen";
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String? email;
  String? password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Delivery person image with food icons
          Image.asset(
            'assets/images/delivery_person.png',
            height: 500,
            width: 500,
          ),
          // Welcome text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  'Hello Delivery Partner !'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: FontRefer.DMSans,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: RoundedButton(
                  title: 'SIGN IN'.tr,
                  buttonRadius: 10,
                  colour: ColorRefer.kPrimaryColor,
                  height: 48,
                  onPressed: () async {
                    showBottomSheet(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:  Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Let's Login to your Account".tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontRefer.DMSans,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Email/Phone'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorRefer.kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontRefer.DMSans,
                        ),
                      ),
                      InputField(
                        controller: emailController,
                        textInputType: TextInputType.emailAddress,
                        label: 'Email/Phone'.tr,
                        hintText: 'user@mail.com',
                        onChanged: (value) => email = value,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Password'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorRefer.kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontRefer.DMSans,
                        ),
                      ),
                      PasswordInputField(
                        controller: passwordController,
                        label: 'Password'.tr,
                        hintText: '• • • • • • • • •',
                        obscureText: true,
                        onChanged: (value) => password = value,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: RoundedButton(
                          title: 'SIGN IN'.tr,
                          buttonRadius: 10,
                          colour: ColorRefer.kPrimaryColor,
                          height: 48,
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;

                            print('Email: $email');  // Debugging print
                            print('Password: $password');  // Debugging print

                            if (email != null && password != null) {
                              ShowToastDialog.showLoader("Please wait".tr);
                              final loginResponse = await _authService.login(
                                email: email!,
                                password: password!,
                              );
                              ShowToastDialog.closeLoader();
                              if (loginResponse != null) {
                                Navigator.pushNamed(context, MainScreen.ID);
                              }
                            } else {
                              Get.back();
                              Get.snackbar('Error', 'Please fill in all fields');
                            }
                          },

                          // onPressed: () async {
                          //   Get.back();
                          //   if (!formKey.currentState!.validate()) return;
                          //   if (email != null && password != null) {
                          //
                          //     ShowToastDialog.showLoader("Please wait".tr);
                          //     final loginResponse = await _authService.login(
                          //       email: email!,
                          //       password: password!,
                          //     );
                          //     if (loginResponse != null) {
                          //       ShowToastDialog.closeLoader();
                          //       Navigator.pushNamed(context, MainScreen.ID);
                          //     }
                          //   } else {
                          //     Get.snackbar('Error', 'Please fill in all fields');
                          //   }
                          // },
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
