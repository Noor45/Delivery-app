import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

PreferredSizeWidget appBar({String? title, List<Widget>? action, Widget? leadingWidget}) {
  return AppBar(
    backgroundColor: ColorRefer.kPrimaryColor,
    centerTitle: true,
    leading: leadingWidget,
    automaticallyImplyLeading: false,
    title: Text(
      title!,
      style:
      const TextStyle(fontFamily: FontRefer.Roboto, color: ColorRefer.kBackgroundColor),
    ),
    actions: action,
  );
}