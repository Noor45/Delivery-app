import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/round_btn.dart';
import 'package:flutter/services.dart';
import '../services/map_service.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/dialogs.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import '../widgets/show_toast_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:driver_panel/utils/map.dart';

class NavigationScreen extends StatefulWidget {
  static String ID = "/navigation_screen";
  NavigationScreen({this.id, this.data});
  final String? id;
  var data;

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  var orderData;
  int? _lastAlertStatus;
  final dio.Dio _dio = dio.Dio();
  late GoogleMapController mapController;
  LatLng _initialPosition = LatLng(0.0, 0.0);
  LatLng _destination = LatLng(0.0, 0.0);
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  FlutterTts flutterTts = FlutterTts();
  MapService _mapService = MapService();
  String transportMode = 'driving';
  BitmapDescriptor? _riderIcon;
  double bottomSheetSize = 0.25;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  bool _showStatusBar = false;
  
  Color _statusBarColor = Colors.green;
  String _statusMessage = 'Success! Operation completed.';
  late IO.Socket socket;
  late Map<String, double> positionObject;
  StreamSubscription<Position>? positionStream;

  void _showStatus({required String message, required Color color}) {
    if (!mounted) return;
    setState(() {
      _statusMessage = message;
      _statusBarColor = color;
      _showStatusBar = true;
    });
  }

  @override
  void initState() {
    super.initState();
    orderData = widget.data['order'];
    var origin = jsonDecode(orderData['origin']);
    _destination = LatLng(orderData['latitude'], orderData['longitude']);
    _initialPosition = LatLng(origin['lat'], origin['lng']);
    positionObject = {'orderId': 0, 'lat': 0.0, 'lng': 0.0};
    fetchData();
    _permission();
  
    _addMarker(_initialPosition);
    _addDestinationMarker();
  
    _initLocationService();
    _initializeSocketConnection();
    flutterTts.speak("Your journey has started.");
  }

  _permission() async {
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
  }

  Future<void> _initLocationService() async {
    _setDestination();
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
        _loadCustomMarkerIcon(position);
      //  _updateRiderLocation(LatLng(position.latitude, position.longitude));
      _checkDistanceAndAlert(currentLocation);
      socket.emit('update_location', {
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    });
  }


  void _updateRiderLocation(LatLng currentLocation) {
    if (_riderIcon == null) return;
    Marker riderMarker = Marker(
      markerId: MarkerId('rider'),
      position: currentLocation,
      icon: _riderIcon!,
      zIndex: 2,
    );

    setState(() {
      markers.removeWhere((marker) => marker.markerId == MarkerId('rider'));
      markers.add(riderMarker);
    });
    mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));
  }

  Future<void> _loadCustomMarkerIcon(Position position) async {

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
     BitmapDescriptor riderIcon = await _createCustomMarkerIconFromAsset(
      'assets/images/rider.png',
        scale: 0.5
    );
  
    print(LatLng(_destination.latitude, _destination.longitude));
    Marker currentMarker = Marker(
      markerId: MarkerId('rider'),
      position: LatLng(position.latitude, position.longitude),
      icon: riderIcon,
      zIndex: 2,
    );

    setState(() {
      markers.add(currentMarker);
    });
    mapController.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
  }
  void _initializeSocketConnection() async {
    socket = IO.io(
      'http://localhost/driver-location',
      IO.OptionBuilder()
          .setQuery({'orderId': widget.data['orderId'], 'type': 'driver'})
          .setTransports(['websocket'])
          .build(),
    );

    socket.on('connect', (_) async {
      print("Connected to location namespace");
      try {
        socket.emit('join_room', 'Successfully connected to the room by order ${widget.data['orderId']}');
      } catch (e) {
        print("Error sending join_room: $e");
      }
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        if (!socket.connected) {
          timer.cancel();
          print("Socket disconnected, stopping location updates");
          return;
        }
        // try {
          Position position = await Geolocator.getCurrentPosition();
          positionObject = {
            'orderId': double.parse(widget.data['orderId'].toString()),
            'longitude': position.longitude,
            'latitude': position.latitude,
          };
          socket.emit('driverLocation', jsonEncode(positionObject));
          print("driverLocation emitted: $positionObject");
        // } catch (e) {
        //   print("Error fetching location: $e");
        // }
      });
    });

    socket.on('error', (error) {
      print('Socket error: $error');
    });

    socket.on('disconnect', (_) {
      print("Socket disconnected");
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.off('join_room');
    socket.off('driverLocation');
    socket.off('disconnect');
    positionStream?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    setState(() {
      ShowToastDialog.showLoader("Please wait");
    });
    final url = "http://localhost/driver/order/fetch/${widget.id.toString()}";
    final response = await _dio.get(
      url,
      options: dio.Options(
        headers: {
          'Authorization': 'Bearer ${Constants.userData!.token}',
        },
      ),
    );
    if (response.statusCode == 200) {
      ShowToastDialog.closeLoader();
      orderData  = response.data['data']['order'];
      setState(() {
        var origin = jsonDecode(orderData['origin']);
        _destination = LatLng(orderData['latitude'], orderData['longitude']);
        _initialPosition = LatLng(origin['lat'], origin['lng']);
      });
    } else {
      ShowToastDialog.closeLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_destination);
    print(_initialPosition);
    ShowToastDialog.closeLoader();
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            gestureRecognizers: Set()
              ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
              ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
              ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
              ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())),
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12.0,
            ),
            polylines: _polylines,
            markers: markers,
            circles: circles,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
          ),
          DraggableScrollableSheet(
            initialChildSize: bottomSheetSize,
            minChildSize: bottomSheetSize,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return SafeArea(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: Offset(0, -5),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Economy Delivery', style: TextStyle(fontSize: 16)),
                                      Text('Payment via Cash on Pickup', style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                  Text('\$${orderData['total']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Divider(thickness: 1, color: Colors.grey[300]),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              child: buildContactInfo(
                                name: orderData['name'],
                                address: orderData['address'],
                                phone: orderData['number'],
                                tag: orderData['city'],
                                addressIcon: FontAwesomeIcons.houseChimney,
                                onCallPressed: () {},
                                isExpanded: false, // Collapsed
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_showStatusBar)
            Positioned(
              top: kToolbarHeight / 4, // Position below the AppBar
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: _statusBarColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status message
                      Expanded(
                        child: Text(
                          _statusMessage,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      // Cancel icon
                      InkWell(
                        onTap: _hideStatusBar,
                        child: Icon(
                          Icons.close,
                          color: Colors.white.withOpacity(0.6),
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).size.height-90,
            child: SafeArea(
              child: RoundedButton(
                title: 'Marked As Delivered',
                buttonRadius: 2,
                colour: ColorRefer.kPrimaryColor,
                height: 55,
                onPressed: () async {
                  showDialogAlert(
                    context: context,
                    title: 'Marked As Delivered',
                    message: 'Have you delivered the ordered to the destination?',
                    actionButtonTitle: 'Delivered',
                    cancelButtonTitle: 'Cancel',
                    actionButtonTextStyle: const TextStyle(
                      color: ColorRefer.kPrimaryColor,
                    ),
                    cancelButtonTextStyle: const TextStyle(
                      color: Colors.black45,
                    ),
                    actionButtonOnPressed: () async {
                      ShowToastDialog.showLoader("Please wait");
                      await _mapService.markDelivered(widget.data['id'].toString(), context, widget.data);
                      ShowToastDialog.closeLoader();
                      setState(() {});
                    },
                    cancelButtonOnPressed: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _setDestination() async {
    String googleAPIKey = "YOUR KEY HERE";
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${_initialPosition.latitude},${_initialPosition.longitude}&destination=${_destination.latitude},${_destination.longitude}&mode=$transportMode&key=$googleAPIKey";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    if (json['status'] == 'OK') {
      var routes = json['routes'][0];
      var legs = routes['legs'][0];
      var steps = legs['steps'];
      polylineCoordinates.clear();
      for (var step in steps) {
        List<LatLng> stepPolylineCoordinates = decodePolyline(step['polyline']['points']);
        polylineCoordinates.addAll(stepPolylineCoordinates);
        String instruction = step['html_instructions'];
        instruction = instruction.replaceAll(RegExp(r'<[^>]*>'), '');
        await flutterTts.speak(instruction);
      }

      setState(() {
        _polylines.clear();
        _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              visible: true,
              points: polylineCoordinates,
              color: Colors.black,
              width: 2,
            ));
        LatLngBounds bounds = getBounds(polylineCoordinates);
        mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
      });
    } else {
      print("Error fetching directions: ${json['status']}");
    }
  }

  void _hideStatusBar() {
    setState(() {
      _showStatusBar = false;
    });
  }

  Future<BitmapDescriptor> _createCustomMarkerIconFromAsset(String assetPath, {double scale = 1.0}) async {
    return await  BitmapDescriptor.asset(
      ImageConfiguration(devicePixelRatio: 0.5, size: Size(40, 40)), // Scale the marker size by adjusting devicePixelRatio
      assetPath,
    );
  }

  void _addMarker(LatLng position) async {
    BitmapDescriptor customLocationIcon = await _createCustomMarkerIconFromAsset('assets/images/circle.png',
        scale: 0.5
    );
    Marker customLocationMarker = Marker(
      markerId: MarkerId('customLocation'),
      position: position,
      icon: customLocationIcon,
      zIndex: 2,
    );

    setState(() {
      markers.add(customLocationMarker);
    });
  }

  void _addDestinationMarker() async {
    BitmapDescriptor customDestinationIcon = await _createCustomMarkerIconFromAsset('assets/images/circle.png',
        scale: 0.5
    );
    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: _destination,
      icon: customDestinationIcon,
      zIndex: 2,
    );

    setState(() {
      markers.add(destinationMarker);
    });
  }

  void _checkDistanceAndAlert(LatLng currentLocation) async {
    double distance = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      _destination.latitude,
      _destination.longitude,
    );

    double averageSpeed = 16.67; // Speed in meters per second
    double estimatedTimeInSeconds = distance / averageSpeed;
    int estimatedMinutes = (estimatedTimeInSeconds / 60).round();
    int? currentAlertStatus;
    String? alertMessage;
    if (estimatedMinutes <= 15 && estimatedMinutes > 10) {
      currentAlertStatus = 15;
      alertMessage = "15 minutes away from the destination";
    } else if (estimatedMinutes <= 10 && estimatedMinutes > 5) {
      currentAlertStatus = 10;
      alertMessage = "10 minutes away from the destination";
    } else if (estimatedMinutes <= 5 && estimatedMinutes > 0) {
      currentAlertStatus = 5;
      alertMessage = "5 minutes away from the destination";
    } else if (estimatedMinutes <= 0) {
      currentAlertStatus = 0;
      alertMessage = "You have arrived at the destination";
    }

    if (currentAlertStatus != null && _lastAlertStatus != currentAlertStatus) {
      _lastAlertStatus = currentAlertStatus;

      if (alertMessage != null) {
        _showAlert(alertMessage);
      }
      _mapService.updateOrderStatus(widget.data['orderId'].toString(), currentAlertStatus.toString());
      if (currentAlertStatus == 0) {
        positionStream?.cancel();
      }
    }
  }

  void _showAlert(String message) {
    _showStatus(message: message, color: ColorRefer.kPrimaryColor);
  }
}

