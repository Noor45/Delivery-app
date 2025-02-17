import 'package:driver_panel/screens/notification_screen.dart';
import 'package:driver_panel/screens/order_screen.dart';
import 'package:driver_panel/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as dio;
import '../../utils/colors.dart';
import '../../widgets/navBar.dart';
import 'dashboard_screen.dart';
import 'order_history_screen.dart';
import 'earning_screen.dart';
import 'setting_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  static String ID = "/main_screen";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool loading = false;
  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  int notificationCount = 0;

  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  final List<dynamic> tabs = Constants.userData!.type == 'commission' ?
  [
     DashboardScreen(),
     OrderScreen(),
     OrderHistoryScreen(),
     EarningScreen(),
     SettingScreen(),
  ] : [
    DashboardScreen(),
    OrderScreen(),
    OrderHistoryScreen(),
    SettingScreen(),
  ];

  String getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Have a good day';
    } else if (hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  void initState() {
    fetchNotificationCount();
    super.initState();
  }

  Future<void> updateOrderStatus() async {
    final url = "http://localhost/driver/notifications";
    final response = await _dio.put(
      url,
      options: dio.Options(
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer ${Constants.userData!.token}',
        },
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        notificationCount = 0;
      });
    }
  }

  Future<void> fetchNotificationCount() async {
    setState(() {
      loading = true;
    });
    final url = "http://localhost/driver/notifications/count";
    try {
      final response = await _dio.post(
        url,
        options: dio.Options(
          method: 'POST',
          headers: {
            'Authorization': 'Bearer ${Constants.userData!.token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          notificationCount = response.data['notifications'];
          loading = false;
        });
      }
    } catch (e) {
      print("Error fetching stats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(Constants.userData!.type);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorRefer.kBackgroundColor,
      body: tabs[_selectedIndex],
      appBar: _selectedIndex == 0
          ? PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 50, left: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      // Constants.employeeDetail?.image != null && Constants.employeeDetail?.image!.isEmpty == false
                      // ? CircleAvatar(
                      //     radius: 32.5,
                      //     backgroundImage: NetworkImage('${StringRefer.imagesPath}${Constants.employeeDetail!.image!}'),
                      //     onBackgroundImageError: (_, __) => const Icon(Icons.error),
                      // ) :
                      Constants.userData!.image != null && Constants.userData!.image!.isEmpty == false  ?
                      ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: FadeInImage.assetNetwork(
                          image: 'http://localhost/${Constants.userData!.image as String}',
                          fit: BoxFit.cover,
                          height: 60,
                          width: 60,
                          placeholder: 'assets/images/user.png',
                        ),
                      ) : Image.asset('assets/images/user.png'),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, ${Constants.userData!.firstName!}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(getGreetingMessage(),
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                ],
              ),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_none, color: Colors.grey, size: 25,),
                    onPressed: () {
                      updateOrderStatus();
                      Navigator.pushNamed(context, NotificationScreen.ID);
                    },
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      right: 8,
                      top: 12,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$notificationCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10, // Adjusted font size for readability
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.grey),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ],
          ),
      )
          : null,
      endDrawer:
      _selectedIndex == 0 ? NavDrawer(scaffoldKey: _scaffoldKey) : null,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
          primaryColor: ColorRefer.kPrimaryColor,
        ),
        child: BottomNavigationBar(
          key: globalKey,
          currentIndex: _selectedIndex,
          unselectedItemColor: ColorRefer.kGreyColor,
          selectedItemColor: ColorRefer.kPrimaryColor,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: Constants.userData!.type == 'commission' ?
          [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Icon(Icons.home,
                      color: _selectedIndex == 0
                          ? ColorRefer.kPrimaryColor
                          : ColorRefer.kGreyColor),
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Icon(FontAwesomeIcons.truckFast,
                      color: _selectedIndex == 1
                          ? ColorRefer.kPrimaryColor
                          : ColorRefer.kGreyColor),
                ),
                label: 'Order'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Icon(FontAwesomeIcons.history,
                      color: _selectedIndex == 2
                          ? ColorRefer.kPrimaryColor
                          : ColorRefer.kGreyColor),
                ),
                label: 'History'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Icon(FontAwesomeIcons.moneyBill1Wave,
                      color: _selectedIndex == 3
                          ? ColorRefer.kPrimaryColor
                          : ColorRefer.kGreyColor),
                ),
                label: 'Earnings'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Icon(Icons.person,
                      color: _selectedIndex == 4
                          ? ColorRefer.kPrimaryColor
                          : ColorRefer.kGreyColor),
                ),
                label: 'Profile'),
          ] :
          [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Icon(Icons.home,
                      color: _selectedIndex == 0
                          ? ColorRefer.kPrimaryColor
                          : ColorRefer.kGreyColor),
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Icon(FontAwesomeIcons.truckFast,
                      color: _selectedIndex == 1
                          ? ColorRefer.kPrimaryColor
                          : ColorRefer.kGreyColor),
                ),
                label: 'Order'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Icon(FontAwesomeIcons.history,
                      color: _selectedIndex == 2
                          ? ColorRefer.kPrimaryColor
                          : ColorRefer.kGreyColor),
                ),
                label: 'History'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Icon(Icons.person,
                      color: _selectedIndex == 3
                          ? ColorRefer.kPrimaryColor
                          : ColorRefer.kGreyColor),
                ),
                label: 'Profile'),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      // floatingActionButton: _selectedIndex == 2
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, ApplyLeave.ID);
      //         },
      //         backgroundColor: ColorRefer.kPrimaryColor,
      //         tooltip: 'Apply Requests',
      //         elevation: 4.0,
      //         child: const Icon(Icons.add, color: Colors.white),
      //       )
      //     : null,
    );
  }
}
