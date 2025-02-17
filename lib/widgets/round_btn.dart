import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/fonts.dart';


class RoundedButton extends StatefulWidget {
  RoundedButton(
      {this.title, this.colour, this.height, this.textColor = Colors.white, this.width, this.fontSize, @required this.onPressed, this.buttonRadius});

  final Color? colour;
  final String? title;
  final double? height;
  final double? width;
  final Color? textColor;
  final Function? onPressed;
  final double? buttonRadius;
  final double? fontSize;
  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.onPressed!.call();
      },
      child: Container(
        alignment: Alignment.center,
        width: widget.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: widget.colour,
          borderRadius: BorderRadius.circular(widget.buttonRadius!),
        ),
        height: widget.height,
        child: Text(
          widget.title!,
          style:
          TextStyle(color: widget.textColor, fontSize: widget.fontSize ?? 13, fontFamily: FontRefer.DMSans),
        ),
      ),
    );
  }
}


class ButtonWithIcon extends StatelessWidget {
  ButtonWithIcon({super.key, this.title, this.colour, this.height, this.width, @required this.onPressed, this.buttonRadius});

  final Color? colour;
  final String? title;
  final double? height;
  final double? width;
  final Function? onPressed;
  final double? buttonRadius;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: colour,
      borderRadius: BorderRadius.circular(buttonRadius!),
      child: InkWell(
        onTap: onPressed as void Function()?,
        child: Container(
          width: width ?? MediaQuery.of(context).size.width,
          height: height,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                ' ',
                style: TextStyle(
                  color: ColorRefer.kPrimaryColor,
                ),
              ),
              Text(
                title!,
                style: const TextStyle(color: Colors.white, fontFamily: FontRefer.Roboto),
              ),
              // SizedBox(width: 5)
            ],
          ),
        ),
      ),
    );
  }
}


class CornerButton extends StatefulWidget {
  CornerButton(
      {this.title, this.colour, this.height, this.textColor = Colors.white, this.width, this.fontSize, @required this.onPressed, this.buttonRadius});

  final Color? colour;
  final String? title;
  final double? height;
  final double? width;
  final Color? textColor;
  final Function? onPressed;
  final BorderRadiusGeometry? buttonRadius;
  final double? fontSize;
  @override
  _CornerButtonState createState() => _CornerButtonState();
}

class _CornerButtonState extends State<CornerButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed as void Function()?,
      shape: RoundedRectangleBorder(
        borderRadius: widget.buttonRadius!,
        side: BorderSide(
          color: widget.textColor!,
          width: 2.0,
        ),
      ),
      highlightElevation: 0,
      height: widget.height,
      minWidth: widget.width ?? MediaQuery.of(context).size.width,
      elevation: 0,
      color: widget.colour,
      child: Text(
        widget.title!,
        style:
        TextStyle(color: widget.textColor, fontSize: widget.fontSize ?? 13, fontFamily: FontRefer.DMSans, fontWeight: FontWeight.bold),
      ),
    );
  }
}