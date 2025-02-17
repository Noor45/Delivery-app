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
import '../widgets/appbar_card.dart';
import '../widgets/dialogs.dart';
import '../cards/delivery_status_card.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import '../widgets/show_toast_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:driver_panel/utils/map.dart';

LatLngBounds getBounds(List<LatLng> coordinates) {
  double southWestLat = coordinates.map((e) => e.latitude).reduce((a, b) => a < b ? a : b);
  double southWestLng = coordinates.map((e) => e.longitude).reduce((a, b) => a < b ? a : b);
  double northEastLat = coordinates.map((e) => e.latitude).reduce((a, b) => a > b ? a : b);
  double northEastLng = coordinates.map((e) => e.longitude).reduce((a, b) => a > b ? a : b);

  return LatLngBounds(
    southwest: LatLng(southWestLat, southWestLng),
    northeast: LatLng(northEastLat, northEastLng),
  );
}

List<LatLng> decodePolyline(String encoded) {
  List<LatLng> polyline = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    polyline.add(LatLng(lat / 1E5, lng / 1E5));
  }

  return polyline;
}

Widget buildContactInfo({
  required String name,
  required String address,
  required String phone,
  required String tag,
  required IconData addressIcon,
  required VoidCallback onCallPressed,
  bool isExpanded = false,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tag,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.phone, color: ColorRefer.kPrimaryColor, size: 15),
                SizedBox(width: 10),
                Text(phone, style: TextStyle(fontSize: 12)),
              ],
            ),
            SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Icon(addressIcon, color: ColorRefer.kPrimaryColor, size: 15),
                ),
                SizedBox(width: 10),
                Expanded(child: Text(address, style: TextStyle(fontSize: 12))),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

