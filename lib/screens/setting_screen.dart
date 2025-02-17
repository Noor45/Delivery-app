import 'package:driver_panel/screens/auth/login.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/appbar_card.dart';
import '../widgets/dialogs.dart';
import '../widgets/show_toast_dialog.dart';
import 'document_screen.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:driver_panel/screens/profile_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        title: 'Profile',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Card(
              color: Color(0xffCCDFE3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: ColorRefer.kPrimaryColor, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Constants.userData!.image != null && Constants.userData!.image!.isEmpty == false  ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: FadeInImage.assetNetwork(
                        image: 'http://localhost/${Constants.userData!.image as String}',
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                        placeholder: 'assets/images/user.png',
                      ),
                    ) : Image.asset('assets/images/user.png'),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${Constants.userData!.firstName!} ${Constants.userData!.lastName!}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.phone, color: Colors.red),
                              SizedBox(width: 8),
                              Text(Constants.userData!.phone!, style: TextStyle(color: Colors.black)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.email, color: Colors.red),
                              SizedBox(width: 8),
                              Expanded(child: Text(Constants.userData!.email!, style: TextStyle(color: Colors.black))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Menu Options
            Expanded(
              child: ListView(
                children: [
                  ProfileOption(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    iconColor: ColorRefer.kPrimaryColor,
                    onTap: () async {
                      var updatedUserData = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                      if (updatedUserData != null) {
                        setState(() {
                          Constants.userData = updatedUserData;
                        });
                      }
                      setState(() {});
                    },

                  ),
                  ProfileOption(
                    icon: Icons.file_copy_outlined,
                    title: 'Documents',
                    iconColor: ColorRefer.kPrimaryColor,
                    onTap: (){
                      Navigator.pushNamed(context, DocumentVerificationScreen.ID);
                    },
                  ),
                  ProfileOption(
                    icon: Icons.headset_mic_outlined,
                    title: 'Support',
                    iconColor: ColorRefer.kPrimaryColor,
                    onTap: () async{
                    },
                  ),
                  ProfileOption(
                    icon: Icons.help_outline,
                    title: 'FAQ',
                    iconColor: ColorRefer.kPrimaryColor,
                    onTap: (){},
                  ),
                  ProfileOption(
                    icon: Icons.article_outlined,
                    title: 'Terms & Conditions',
                    iconColor: ColorRefer.kPrimaryColor,
                    onTap: (){},
                  ),
                  ProfileOption(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy',
                    iconColor: ColorRefer.kPrimaryColor,
                    onTap: (){},
                  ),
                  ProfileOption(
                    icon: Icons.logout,
                    title: 'Log Out',
                    iconColor: Colors.red,
                    onTap: () async {
                      showDialogAlert(
                        context: context,
                        title: 'Logout',
                        message: 'Are you sure you want to logout now?',
                        actionButtonTitle: 'Logout',
                        cancelButtonTitle: 'Cancel',
                        actionButtonTextStyle: const TextStyle(
                          color: Colors.red,
                        ),
                        cancelButtonTextStyle: const TextStyle(
                          color: Colors.black45,
                        ),
                        actionButtonOnPressed: () async {
                          ShowToastDialog.showLoader("Please wait");
                          clear();
                          await SessionManager().remove("user");
                          ShowToastDialog.closeLoader();
                          Navigator.pushNamedAndRemoveUntil(context, SignInScreen.signInScreenID, (Route<dynamic> route) => false);
                        },
                        cancelButtonOnPressed: (){
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Function onTap;

  ProfileOption({required this.icon, required this.onTap, required this.title, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFEEF6F8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: ColorRefer.kPrimaryColor),
        onTap: () {
          onTap.call();
          // Handle tap
        },
      ),
    );
  }
}

