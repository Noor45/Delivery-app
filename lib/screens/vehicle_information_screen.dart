import 'package:driver_panel/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/vehicle_info_service.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/appbar_card.dart';
import '../widgets/input_filed.dart';
import '../widgets/round_btn.dart';
import '../widgets/show_toast_dialog.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  static String ID = "/vehicle_information_screen";

  @override
  _VehicleRegistrationScreenState createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  final VehicleInfoService _apiService = VehicleInfoService();
  final TextEditingController _vehicleNoController = TextEditingController();
  final TextEditingController _registrationDateController = TextEditingController();
  String? selectedVehicleType;
  String? selectedColor;
  String? selectedSeats;

  final List<String> vehicleTypes = ["Mini", "Sedan", "SUV"];
  final List<String> colors = [
    "Red", "Blue", "Green", "Yellow", "Black", "White", "Gray", "Orange", "Purple", "Pink", "Brown", "Cyan", "Magenta", "Lime", "Teal"
  ];
  final List<String> seats = List.generate(15, (index) => (index + 1).toString());

  String? selectedVehicleCategory;

  @override
  void initState() {
    super.initState();
    if (Constants.vehicleInfo != null) {
      _vehicleNoController.text = Constants.vehicleInfo!.vehicleNo;
      _registrationDateController.text = Constants.vehicleInfo!.registrationDate;
      selectedVehicleType = Constants.vehicleInfo!.vehicleType;
      selectedColor = Constants.vehicleInfo!.vehicleColor;
      selectedSeats = Constants.vehicleInfo!.totalSeats;
      selectedVehicleCategory = Constants.vehicleInfo!.vehicle; // Assuming category from vehicle type
    }
  }

  void _submitVehicleData() async {
    ShowToastDialog.showLoader("Please wait");
    Map<String, dynamic> vehicleData = {
      'vehicleNo': _vehicleNoController.text,
      'registartionDate': _registrationDateController.text,
      'vehicle': selectedVehicleCategory,
      'vehicleType': selectedVehicleType,
      'vehicleColor': selectedColor,
      'totalSeats': selectedSeats,
    };
    await _apiService.createOrUpdateVehicle(vehicleData, Constants.vehicleInfo != null ? false : true);
    setState(() {});
    ShowToastDialog.closeLoader();
  }

  @override
  Widget build(BuildContext context) {
    ShowToastDialog.closeLoader();

    return Scaffold(
      appBar: appBar(
        title: 'Vehicle Registration',
        leadingWidget: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VehicleTypeCard(
                  icon: 'van.svg',
                  label: "Van",
                  isSelected: selectedVehicleCategory == "van",
                  onTap: () {
                    setState(() {
                      selectedVehicleCategory = "van";
                    });
                  },
                ),
                VehicleTypeCard(
                  icon: 'car.svg',
                  label: "Car",
                  isSelected: selectedVehicleCategory == "car",
                  onTap: () {
                    setState(() {
                      selectedVehicleCategory = "car";
                    });
                  },
                ),
                VehicleTypeCard(
                  icon: 'bike.svg',
                  label: "Bike",
                  isSelected: selectedVehicleCategory == "bike",
                  onTap: () {
                    setState(() {
                      selectedVehicleCategory = "bike";
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  DocumentTextField(
                    controller: _vehicleNoController,
                    readonly: false,
                    textInputType: TextInputType.text,
                    onChanged: (value){},
                    label: 'Vehicle Number',
                    hintText: 'Enter vehicle number',
                    suffixIcon: SizedBox(),
                  ),
                  SizedBox(height: 10),
                  DocumentTextField(
                    readonly: true,
                    controller: _registrationDateController,
                    label: 'Registration Date',
                    hintText: 'Enter registration date',
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
                          _registrationDateController.text =
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                        });
                      }
                    },
                    suffixIcon: Icon(Icons.calendar_today),

                  ),
                  SizedBox(height: 10),

                  DropdownField(
                    label: 'Vehicle Type',
                    hintText: 'Select vehicle type',
                    items: vehicleTypes,
                    onTap: (){},
                    onChanged: (value) {
                      setState(() {
                        selectedVehicleType = value;
                      });
                    },
                    value: selectedVehicleType,
                  ),

                  SizedBox(height: 10),
                  DropdownField(
                    label: 'Vehicle Color',
                    hintText: 'Select vehicle color',
                    items: colors,
                    onTap: (){},
                    onChanged: (value) {
                      setState(() {
                        selectedColor = value;
                      });
                    },
                    value: selectedColor,
                  ),
                  SizedBox(height: 10),
                  DropdownField(
                    label: 'How Many Seats',
                    hintText: 'Select Seats',
                    items: seats,
                    onTap: (){},
                    onChanged: (value) {
                      setState(() {
                        selectedSeats = value;
                      });
                    },
                    value: selectedSeats,
                  ),
                  SizedBox(height: 30),
                  // RoundedButton(
                  //   title: 'SAVE',
                  //   buttonRadius: 10,
                  //   colour: ColorRefer.kPrimaryColor,
                  //   height: 48,
                  //   onPressed: () async {
                  //   },
                  // ),
                  RoundedButton(
                    title: Constants.vehicleInfo == null ? 'SAVE' : 'UPDATE',
                    buttonRadius: 10,
                    colour: ColorRefer.kPrimaryColor,
                    height: 48,
                    onPressed: _submitVehicleData,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleTypeCard extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleTypeCard({
    Key? key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 25, 15, 15),
        decoration: BoxDecoration(
          color: isSelected ? ColorRefer.kPrimaryColor : ColorRefer.kSecondaryColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            SvgPicture.asset('assets/icons/$icon', width: 30, height: 30, color: isSelected ? Colors.white : ColorRefer.kTextColor),
            SizedBox(height: 20.0),
            Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontFamily: FontRefer.Roboto, color: isSelected ? Colors.white : ColorRefer.kTextColor)),
          ],
        ),
      ),
    );
  }
}


