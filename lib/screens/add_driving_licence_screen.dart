import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/license_service.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/appbar_card.dart';
import '../widgets/input_filed.dart';
import '../widgets/round_btn.dart';
import '../widgets/show_toast_dialog.dart';

class LicenseForm extends StatefulWidget {
  static String ID = "/license_screen";

  @override
  _LicenseFormState createState() => _LicenseFormState();
}

class _LicenseFormState extends State<LicenseForm> {
  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  LicenseService service = LicenseService();
  File? _frontImage;
  File? _backImage;

  String? frontImageUrl;
  String? backImageUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isFront) async {
    final XFile? image = await _picker.pickImage(
      source: await _showPickerDialog(),
    );

    if (image != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(image.path);
        } else {
          _backImage = File(image.path);
        }
      });
    }
  }

  Future<ImageSource> _showPickerDialog() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    ) ?? ImageSource.gallery;
  }

  @override
  void initState() {
    super.initState();
    if (Constants.drivingLicense != null) {
      _licenseNumberController.text = Constants.drivingLicense!.licenceNo;
      _expiryDateController.text = Constants.drivingLicense!.expireDate;
      frontImageUrl = 'http://localhost/${Constants.drivingLicense!.frontImg}';
      backImageUrl = 'http://localhost/${Constants.drivingLicense!.backImg}';
    }
  }

  void _submitDrivingLicence() async {
    ShowToastDialog.showLoader('Please wait');
    if (_frontImage != null && _backImage != null) {
      await service.saveLicense(
          licenceNo: _licenseNumberController.text,
          expireDate: _expiryDateController.text,
          frontImage: _frontImage!,
          backImage: _backImage!,
          save: Constants.drivingLicense != null ? false : true
      );
    } else if (frontImageUrl != null && backImageUrl != null) {
      await service.saveLicense(
          licenceNo: _licenseNumberController.text,
          expireDate: _expiryDateController.text,
          frontImageUrl: frontImageUrl!,
          backImageUrl: backImageUrl!,
          save: Constants.drivingLicense != null ? false : true
      );
    } else {
      showMessage('Error', 'Please provide both front and back images');
    }
    setState(() {});
    ShowToastDialog.closeLoader();
  }

  @override
  Widget build(BuildContext context) {
    ShowToastDialog.closeLoader();
    return Scaffold(
      appBar: appBar(
          title: 'Driving License Form',
          leadingWidget: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white)
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DocumentTextField(
                readonly: false,
                textInputType: TextInputType.text,
                controller: _licenseNumberController,
                onChanged: (value){},
                label: 'Driving License Number',
                hintText: 'Enter Driving License Number',
                suffixIcon: const SizedBox(),
              ),
              SizedBox(height: 16.0),
              DocumentTextField(
                readonly: true,
                controller: _expiryDateController,
                label: 'Expire Date',
                hintText: 'Select Expire Date',
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
                            surface:  Colors.white,
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
                      _expiryDateController.text =
                      "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    });
                  }
                },
                suffixIcon: Icon(Icons.calendar_today),
              ),
              SizedBox(height: 16.0),
              _buildImagePicker('Front Side of Driving License', _frontImage, frontImageUrl, true),
              SizedBox(height: 16.0),
              _buildImagePicker('Back Side of Driving License', _backImage, backImageUrl, false),
              SizedBox(height: 25.0),
              RoundedButton(
                title: Constants.drivingLicense == null ? 'SAVE' : 'UPDATE',
                buttonRadius: 10,
                colour: ColorRefer.kPrimaryColor,
                height: 48,
                onPressed: () async {
                  _submitDrivingLicence();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(String label, File? imageFile, String? networkImageUrl, bool isFront) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () => _pickImage(isFront),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: imageFile != null
                ? Image.file(imageFile, fit: BoxFit.cover, width: MediaQuery.of(context).size.width,)
                : networkImageUrl != null
                ? Image.network(networkImageUrl, fit: BoxFit.cover, width: MediaQuery.of(context).size.width,)
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add_a_photo, size: 50),
                        SizedBox(height: 8.0),
                        Text('Add photo'),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
