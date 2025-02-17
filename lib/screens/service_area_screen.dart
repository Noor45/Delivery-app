import 'package:driver_panel/utils/constants.dart';
import 'package:flutter/material.dart';
import '../services/servicearea_service.dart';
import '../utils/colors.dart';
import '../widgets/appbar_card.dart';
import '../widgets/input_filed.dart';
import '../widgets/round_btn.dart';
import '../widgets/show_toast_dialog.dart';

class ServiceAreaScreen extends StatefulWidget {
  static String ID = "/service_area_screen";
  @override
  _ServiceAreaScreenState createState() => _ServiceAreaScreenState();
}

class _ServiceAreaScreenState extends State<ServiceAreaScreen> {
  final TextEditingController _timeController = TextEditingController();
  final AreaService _areaService = AreaService();
  final formKey = GlobalKey<FormState>();
  String? selectedAvailability;
  String? selectedDays;
  TimeOfDay? selectedTime;
  List<String> workingDays = [];
  final List<String> weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> daysOptions = List.generate(7, (index) => (index + 1).toString());

  Future<void> saveServiceArea() async {
    if (!formKey.currentState!.validate()) return;
    ShowToastDialog.showLoader("Please wait");
    await _areaService.serviceAreaResponse(
       selectedAvailability: selectedAvailability,
       selectedDays: selectedDays,
       time: _timeController.text,
       days: workingDays,
       save: Constants.serviceArea != null ? false : true
    );
    setState(() {});
    ShowToastDialog.closeLoader();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: ColorRefer.kPrimaryColor, // Header background color
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white, // Background color of the time picker
              hourMinuteColor: WidgetStateColor.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? ColorRefer.kPrimaryColor
                  : Colors.grey.shade200), // Selected hour/minute background color
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? Colors.white
                  : Colors.black), // Selected hour/minute text color
              dialHandColor: ColorRefer.kPrimaryColor, // Dial hand color
              dialBackgroundColor: Colors.white, // Background color of the dial
              entryModeIconColor: ColorRefer.kPrimaryColor, // Icon color for entry mode
            ),
            colorScheme: const ColorScheme.light(
              primary: ColorRefer.kPrimaryColor, // Header and selected text color
              onPrimary: Colors.white, // Text color on the header
              surface: Colors.white, // Surface background color
              onSurface: Colors.black, // Text color on the surface
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _timeController.text = selectedTime!.format(context);
      });
    }

  }

  @override
  void initState() {
    setState(() {
      selectedAvailability = Constants.serviceArea!.timeAvailability;
      selectedDays = Constants.serviceArea!.totalDays;
      _timeController.text = Constants.serviceArea!.time;
      workingDays = Constants.serviceArea!.days;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ShowToastDialog.closeLoader();
    return Scaffold(
      appBar: appBar(
          title: 'Service Detail',
          leadingWidget: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white))),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownField(
                  label: 'Time Availability',
                  hintText: 'Select time availability',
                  items: const ["Morning", "Evening"],
                  onTap: () {},
                  onChanged: (value) {
                    setState(() {
                      selectedAvailability = value;
                    });
                  },
                  value: selectedAvailability,
                ),
                const SizedBox(height: 10),
                DocumentTextField(
                  readonly: true,
                  controller: _timeController,
                  label: 'Select Timing',
                  hintText: 'Select Time',
                  onTap: () async {
                    _selectTime(context);
                  },
                  suffixIcon: const Icon(Icons.access_time_outlined),
                ),
                const SizedBox(height: 10),
                DropdownField(
                  label: 'Select Days',
                  hintText: 'Select days',
                  items: daysOptions,
                  onTap: () {},
                  onChanged: (value) {
                    setState(() {
                      selectedDays = value;
                    });
                  },
                  value: selectedDays,
                ),
                const SizedBox(height: 10),
                MultiSelectChip(
                  weekDays,
                  onSelectionChanged: (selectedList) {
                    setState(() {
                      workingDays = selectedList;
                    });
                  },
                  // Preselect if service area exists
                  selectedChoices: workingDays,
                ),
                const SizedBox(height: 20),
                RoundedButton(
                  title: Constants.serviceArea != null ? 'UPDATE' : 'SAVE',
                  buttonRadius: 10,
                  colour: ColorRefer.kPrimaryColor,
                  height: 48,
                  onPressed: () async {
                    await saveServiceArea();
                    // Get.snackbar(
                    //   'Error',
                    //   'Failed to save service area',
                    //   snackPosition: SnackPosition.BOTTOM,
                    //   duration: Duration(seconds: 3),
                    //   margin: EdgeInsets.all(16),
                    //   backgroundColor: ColorRefer.kPrimaryColor,
                    //   snackStyle: SnackStyle.FLOATING,
                    //   overlayBlur: 0.4,
                    //   colorText: Colors.white,
                    //   mainButton: TextButton(
                    //     onPressed: () {
                    //       Get.back(); // Dismiss the snackbar
                    //     },
                    //     child: Icon(Icons.cancel, color: Colors.white), // Cancel icon
                    //   ),
                    // );


                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final List<String> selectedChoices;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.reportList, {required this.onSelectionChanged, required this.selectedChoices,});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(5.0),
        child: ChoiceChip(
          label: Text(item),
          selected: widget.selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              widget.selectedChoices.contains(item)
                  ?  widget.selectedChoices.remove(item)
                  :  widget.selectedChoices.add(item);
              widget.onSelectionChanged(widget.selectedChoices);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}