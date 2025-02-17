import 'dart:convert'; // for json decode
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../model/user_model.dart';
import '../../utils/constants.dart';
import '../main_screen.dart'; // assuming MainScreen is the dashboard screen
import '../auth/login.dart';// import Constants
import 'package:auto_size_text/auto_size_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // This function will check if the user session exists and navigate accordingly
  Future<void> _initApp() async {
    // Check for existing session
    var sessionManager = SessionManager();
    var userData = await sessionManager.get("user"); // Retrieve user session data

    if (userData != null && userData is Map<String, dynamic>) {
      // If user session exists, cast the data directly to Map<String, dynamic>
      Constants.userData = UserDataModel.fromJson(userData); // Save the user data into Constants
      Navigator.pushReplacementNamed(context, MainScreen.ID); // Navigate to Dashboard
    } else {
      // If no session exists, navigate to SignInScreen
      Navigator.pushReplacementNamed(context, SignInScreen.signInScreenID);
    }
  }

  @override
  void initState() {
    super.initState();
    _initApp(); // Initialize the app and check session on startup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRefer.kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText(
              'Delivery\n Panel'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: ColorRefer.kLightColor,
                fontFamily: FontRefer.Lobster,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
