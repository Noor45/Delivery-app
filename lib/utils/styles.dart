import 'package:driver_panel/utils/colors.dart';
import 'package:flutter/material.dart';

import 'fonts.dart';


class StyleRefer {
  static var kLoginTextFieldDecoration = InputDecoration(
    counterText: '',
    // labelStyle: const TextStyle(color: Color(0xff212b36)),

    hintStyle: TextStyle(fontSize: 12, color: ColorRefer.kLabelColor),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black45, width: 1.0),
      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black45, width: 2.0),
      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2.0),
      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color:  Colors.black45, width: 2.0),
      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
  );

  static var kTextFieldDecoration = InputDecoration(
    counterText: '',
    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    hintStyle: TextStyle(fontSize: 14, color: ColorRefer.kLabelColor),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0),
      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: ColorRefer.kPrimaryColor, width: 2.0),
      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2.0),
      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: ColorRefer.kPrimaryColor, width: 2.0),
      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
  );

  static var kProfileTextFieldDecoration = InputDecoration(
    counterText: '',
    // contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    hintStyle: TextStyle(fontSize: 14, color: ColorRefer.kLabelColor),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(width: 1.0),
      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: ColorRefer.kPrimaryColor, width: 2.0),
      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2.0),
      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: ColorRefer.kPrimaryColor, width: 2.0),
      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
  );


  static TextStyle kCheckBoxTextStyle =
  TextStyle(fontFamily: FontRefer.Roboto, fontSize: 13.5);
}

