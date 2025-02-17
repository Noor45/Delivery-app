import 'package:flutter/material.dart';
import '../model/driver_address_model.dart';
import '../services/address_service.dart';
import '../utils/constants.dart';
import '../widgets/input_filed.dart';
import '../widgets/round_btn.dart';
import '../utils//colors.dart';
import '../widgets/appbar_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/show_toast_dialog.dart';

class PrimaryAddressScreen extends StatefulWidget {
  static String ID = "/primary_address_screen";

  @override
  _PrimaryAddressScreenState createState() => _PrimaryAddressScreenState();
}

class _PrimaryAddressScreenState extends State<PrimaryAddressScreen> {
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  AddressService service = AddressService();

  LatLng? _pickedLocation;
  GoogleMapController? _mapController;
  String googleAPIKey = "YOUR KEY HERE";

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    _updateLocation(position);
  }

  void _updateLocation(Position position) {
    setState(() {
      _pickedLocation = LatLng(position.latitude, position.longitude);
      _locationController.text = "${position.latitude}, ${position.longitude}";
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_pickedLocation!),
        );
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_pickedLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(_pickedLocation!),
      );
    }
  }

  void _pickLocation(LatLng location) {
    setState(() {
      _pickedLocation = location;
      _locationController.text = "${location.latitude}, ${location.longitude}";
    });
  }

  @override
  void initState() {
    super.initState();
    if (Constants.driverAddress != null) {
      _populateFields(Constants.driverAddress!);
    }
    _determinePosition();
  }

  void _populateFields(DriverAddressModel address) {
    _addressLine1Controller.text = address.addressLine1!;
    _addressLine2Controller.text = address.addressLine2!;
    _postalCodeController.text = address.postalCode!;
    _stateController.text = address.state!;
    _cityController.text = address.city!;
    _phoneNumberController.text = address.phoneNumber!;
    _locationController.text = "${address.lat}, ${address.lng}";
    _pickedLocation = LatLng(address.lat!, address.lng!);
  }

  Future<void> _saveOrUpdateAddress() async {
    ShowToastDialog.showLoader('Please wait');
    final address = {
      'addressLine1': _addressLine1Controller.text,
      'addressLine2': _addressLine2Controller.text,
      'postalCode': _postalCodeController.text,
      'state': _stateController.text,
      'city': _cityController.text,
      'phoneNumber': _phoneNumberController.text,
      'lat': _pickedLocation?.latitude ?? 0,
      'lng': _pickedLocation?.longitude ?? 0,
      'status': "NotVerified",
    };
    await service.saveDriverAddress(address, Constants.driverAddress != null ? false : true);
    ShowToastDialog.closeLoader();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    ShowToastDialog.closeLoader();
    return Scaffold(
      appBar: appBar(
          title: 'Primary Address',
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
            children: [
              // Address Line 1
              DocumentTextField(
                readonly: false,
                controller: _addressLine1Controller,
                label: 'Address Line 1',
                hintText: 'Enter Address Line 1',
                onTap: (){},
                onChanged: (value){
                  setState(() {
                    _addressLine1Controller.text = value;

                  });
                },
                suffixIcon: SizedBox(),
              ),
              SizedBox(height: 10),

              // Address Line 2
              DocumentTextField(
                readonly: false,
                controller: _addressLine2Controller,
                label: 'Address Line 2',
                hintText: 'Enter Address Line 2',
                onTap: (){},
                onChanged: (value){
                  setState(() {
                    _addressLine2Controller.text = value;

                  });
                },
                suffixIcon: SizedBox(),
              ),
              SizedBox(height: 10),

              // Postal Code
              DocumentTextField(
                readonly: false,
                controller: _postalCodeController,
                label: 'Postal Code',
                hintText: 'Enter Postal Code',
                textInputType: TextInputType.number,
                onTap: (){},
                onChanged: (value){
                  setState(() {
                    _postalCodeController.text = value;
                  });
                },
                suffixIcon: SizedBox(),
              ),
              SizedBox(height: 10),

              // State
              DocumentTextField(
                readonly: false,
                controller: _stateController,
                label: 'State',
                hintText: 'Enter State',
                onTap: (){},
                onChanged: (value){
                  setState(() {
                    _stateController.text = value;
                  });
                },
                suffixIcon: SizedBox(),
              ),
              SizedBox(height: 10),

              // City
              DocumentTextField(
                readonly: false,
                controller: _cityController,
                label: 'City',
                hintText: 'Enter City',
                onTap: (){},
                onChanged: (value){
                  setState(() {
                    _cityController.text = value;
                  });
                },
                suffixIcon: SizedBox(),
              ),
              SizedBox(height: 10),

              // Phone Number
              DocumentTextField(
                readonly: false,
                controller: _phoneNumberController,
                label: 'Phone Number',
                hintText: 'Enter Phone Number',
                textInputType: TextInputType.phone,
                onTap: (){},
                onChanged: (value){
                  setState(() {
                    _phoneNumberController.text = value;
                  });
                },
                suffixIcon: SizedBox(),
              ),
              SizedBox(height: 20),

              // Google Map
              Container(
                height: 200,
                width: double.infinity,
                child: _pickedLocation == null
                    ? Center(child: CircularProgressIndicator())
                    : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _pickedLocation!,
                    zoom: 14.0,
                  ),
                  onMapCreated: _onMapCreated,
                  markers: {
                    Marker(
                      markerId: MarkerId("picked-location"),
                      position: _pickedLocation!,
                    ),
                  },
                  onTap: _pickLocation,
                ),
              ),
              SizedBox(height: 10),

              // Display Picked Location Coordinates
              DocumentTextField(
                controller: _locationController,
                label: 'Location',
                hintText: 'Selected Location',
                readonly: true,
                suffixIcon: SizedBox(),
                onTap: (){},
                onChanged: (value){
                  setState(() {
                    // _phoneNumberController.text = value;
                  });
                },
              ),
              SizedBox(height: 20),
              RoundedButton(
                title: Constants.driverAddress != null ? 'UPDATE' : 'SAVE',
                buttonRadius: 10,
                colour: ColorRefer.kPrimaryColor,
                height: 48,
                onPressed: () async {
                  _saveOrUpdateAddress();
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
