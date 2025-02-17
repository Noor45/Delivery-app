import 'dart:io';
import 'package:driver_panel/screens/auth/forget_password.dart';
import 'package:driver_panel/screens/auth/login.dart';
import 'package:driver_panel/screens/auth/splash_screen.dart';
import 'package:driver_panel/screens/add_driving_licence_screen.dart';
import 'package:driver_panel/screens/document_screen.dart';
import 'package:driver_panel/screens/earning_detail_screen.dart';
import 'package:driver_panel/screens/google_navigation_screen.dart';
import 'package:driver_panel/screens/main_screen.dart';
import 'package:driver_panel/screens/notification_screen.dart';
import 'package:driver_panel/screens/primary_address_screen.dart';
import 'package:driver_panel/screens/service_area_screen.dart';
import 'package:driver_panel/screens/store_list_screen.dart';
import 'package:driver_panel/screens/vehicle_information_screen.dart';
import 'package:driver_panel/screens/profile_screen.dart';
import 'package:driver_panel/services/localization_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.requestPermission();
  if (Platform.isAndroid) {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  }
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _showNotification(message);
}

Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    importance: Importance.max,
    priority: Priority.max,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Driver Panel',
      debugShowCheckedModeBanner: false,
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.locale,
      translations: LocalizationService(),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
      routes: {
        ForgetPasswordScreen.ID: (_) => const ForgetPasswordScreen(),
        SignInScreen.signInScreenID: (context) => const SignInScreen(),
        MainScreen.ID: (context) => const MainScreen(),
        PrimaryAddressScreen.ID: (context) => PrimaryAddressScreen(),
        VehicleRegistrationScreen.ID: (context) => VehicleRegistrationScreen(),
        ServiceAreaScreen.ID: (context) => ServiceAreaScreen(),
        LicenseForm.ID: (context) => LicenseForm(),
        NotificationScreen.ID: (context) => NotificationScreen(),
        DocumentVerificationScreen.ID: (context) => const DocumentVerificationScreen(),
        NavigationScreen.ID: (context) => NavigationScreen(),
        ProfileScreen.ID: (context) => ProfileScreen(),
        StoreListScreen.ID: (context) => StoreListScreen(),
      },
    );
  }
}
