import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:driver_panel/utils/constants.dart';
import 'package:driver_panel/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class InputField extends StatefulWidget {
  InputField({this.label, this.controller, this.hintText, this.onChanged, this.validator, this.textInputType, this.maxLength});
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hintText;
  final String? label;
  final int? maxLength;
  final Function? onChanged;
  final String? Function(String?)? validator;
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      validator: widget.validator,
      onChanged: widget.onChanged as void Function(String?)?,
      maxLength: widget.maxLength,
      cursorColor: ColorRefer.kPrimaryColor,
      style: TextStyle(fontSize: 12, color: ColorRefer.kTextColor),
      decoration: StyleRefer.kLoginTextFieldDecoration.copyWith(
        hintText: widget.hintText,
      ),
      // onTap: (){
      //   if(widget.controller?.selection == TextSelection.fromPosition(TextPosition(offset: widget.controller!.text.length -1))){
      //     setState(() {
      //       widget.controller?.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller!.text.length));
      //     });
      //   }
      // },
    );
  }
}

class PasswordInputField extends StatefulWidget {
  PasswordInputField({super.key, this.label, this.controller, this.hintText, this.suffixIcon, this.onChanged, this.validator, this.textInputType, this.obscureText});
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hintText;
  final String? label;
  bool? obscureText;
  final IconButton? suffixIcon;
  final Function? onChanged;
  final String? Function(String?)? validator;
  @override
  // ignore: library_private_types_in_public_api
  _PasswordInputFieldState createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  void _togglePasswordStatus() {
    setState(() {
      widget.obscureText = !widget.obscureText! ;
    });
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText!,
      controller: widget.controller,
      keyboardType: widget.textInputType,
      validator: widget.validator,
      cursorColor: ColorRefer.kPrimaryColor,
      onChanged: widget.onChanged as void Function(String?)?,
      style: TextStyle(fontSize: 12, color: ColorRefer.kTextColor),
      decoration: StyleRefer.kLoginTextFieldDecoration.copyWith(
        contentPadding: const EdgeInsets.only(top: 15),
        hintText: widget.hintText,
        suffixIcon: InkWell(
          child: Icon(widget.obscureText! ? Icons.visibility : Icons.visibility_off,  color: ColorRefer.kTextColor),
          onTap: _togglePasswordStatus,

        ),
      ),
    );
  }
}

class SelectDateField extends StatelessWidget {

  const SelectDateField({super.key, this.hint, this.label, this.onChanged, this.controller,});
  final String? hint;
  final String? label;
  final Function? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Theme(
          data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(primary: ColorRefer.kPrimaryColor)
          ),
          child: DateTimePicker(
            controller: controller,
            type: DateTimePickerType.date,
            dateMask: 'dd MMM yyyy',
            use24HourFormat: false,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            style: const TextStyle(fontSize: 13,color: Colors.black45),
            decoration: StyleRefer.kLoginTextFieldDecoration.copyWith(
              hintText: hint,
              suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_month_sharp, color: Colors.black45), onPressed: () {}),
            ),
            selectableDayPredicate: (date) {
              return true;
            },
            onChanged: onChanged as void Function(String?)?,
            validator: (val) {
              print(val);
              return null;
            },
            onSaved: (val) => print(val),
          ),
        ),),
      Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 20),
        child: Text(
          label!,
          style: const TextStyle(
              fontSize: 13,
              color: Colors.black45,
              fontFamily: FontRefer.Roboto,
              backgroundColor: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    ]);
  }
}

class DropdownField extends StatefulWidget {
  const DropdownField({
    Key? key,
    this.label,
    this.controller,
    this.hintText,
    this.items, // Add list of dropdown items
    this.onChanged,
    this.validator,
    this.textInputType,
    this.value,
    this.onTap,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hintText;
  final String? label;
  final String? value;
  final List<String>? items; // List of dropdown items
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;

  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.value;
  }

  @override
  void didUpdateWidget(DropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _selectedItem) {
      setState(() {
        _selectedItem = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: widget.onTap!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: FontRefer.Roboto,
              ),
            ),
          ),
          DropdownButtonFormField(
            value: _selectedItem,
            hint: Text(widget.hintText!, style: TextStyle(fontSize: 14, color: ColorRefer.kLabelColor),),
            items: widget.items?.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value.split('_')[0],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45, // Customize item text size
                  ),
                ),
              );
            }).toList(),
            onChanged: widget.items?.isEmpty ?? true
                ? null
                : (String? newValue) {
              setState(() {
                _selectedItem = newValue;
                widget.onChanged?.call(newValue);
              });
            },
            decoration: StyleRefer.kTextFieldDecoration,
            // onTap: widget.onTap!,
            dropdownColor: Colors.white, // Customize dropdown menu color
            icon: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_drop_down, color: Colors.black45),
            ), // Customize dropdown icon color
            iconEnabledColor: Colors.blue, // Customize dropdown icon enabled color
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}



class QuillField extends StatefulWidget {
  const QuillField({super.key,  this.enable = false, this.autoFocus = false, this.label, this.controller,this.onTaP, this.hintText, this.onChanged, this.validator, this.textInputType, this.maxLength,
    this.borderColor = Colors.black45, this.textColor = Colors.black45, } );
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hintText;
  final String? label;
  final int? maxLength;
  final Function? onChanged;
  final Function? onTaP;
  final bool? enable;
  final Color? borderColor;
  final Color? textColor;
  final bool autoFocus;
  final String? Function(String?)? validator;
  @override
  _QuillFieldState createState() => _QuillFieldState();
}

class _QuillFieldState extends State<QuillField> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextFormField(
          autofocus: widget.autoFocus,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          validator: widget.validator,
          onChanged: widget.onChanged as void Function(String?)?,
          enabled: widget.enable,
          maxLines: 4,
          style: TextStyle(fontSize: 12, color: widget.textColor),
          decoration: StyleRefer.kLoginTextFieldDecoration.copyWith(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: (widget.borderColor)!, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: (widget.borderColor)!, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            ),

            contentPadding: const EdgeInsets.only(left: 15, top: 30),
            hintText: widget.hintText,
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 20),
        child: Text(
          widget.label!,
          style: const TextStyle(
              fontSize: 13,
              color: Colors.black45,
              fontFamily: FontRefer.Roboto,
              backgroundColor: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    ]);
  }
}


class ImageUploadField extends StatefulWidget {
  ImageUploadField({
    this.label,
    this.onImageChanged,
  });

  final String? label;
  final Function(File)? onImageChanged;

  @override
  _ImageUploadFieldState createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  File? _image;

  void _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        if (widget.onImageChanged != null) {
          widget.onImageChanged!(_image!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          _image != null
              ? Image.file(_image!, width: double.infinity, fit: BoxFit.cover)
              : Container(
            color: Colors.grey[200],
            width: double.infinity,
            height: 200,
            child: Icon(Icons.image, size: 50, color: Colors.grey),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: _getImage,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: Text(
              widget.label!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentTextField extends StatelessWidget {
  DocumentTextField({this.label, this.suffixIcon, this.controller, this.onTap, this.readonly, this.hintText, this.onChanged, this.validator, this.textInputType, this.maxLength});
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hintText;
  final String? label;
  final bool? readonly;
  final int? maxLength;
  final Widget? suffixIcon;
  final Function? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            '${label!}',
            style: TextStyle(
              fontSize: 14,
              color: ColorRefer.kTextColor,
              fontFamily: FontRefer.Roboto,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: TextField (
            readOnly: readonly!,
            cursorColor: ColorRefer.kPrimaryColor,
            controller: controller,
            decoration: StyleRefer.kTextFieldDecoration.copyWith(
                hintText: hintText,
                suffixIcon: suffixIcon!,
                suffixIconColor: ColorRefer.kPrimaryColor
            ),
            onTap: onTap,
            keyboardType:textInputType,
            onChanged: onChanged as void Function(String?)?,
            maxLength: maxLength,
            style: TextStyle(fontSize: 12, color: ColorRefer.kTextColor),
          ),
        ),

      ],
    );
  }
}



class ProfileTextField extends StatelessWidget {
  ProfileTextField({this.label, this.suffixIcon, this.controller, this.onTap, this.readonly, this.hintText, this.onChanged, this.validator, this.textInputType, this.maxLength});
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hintText;
  final String? label;
  final bool? readonly;
  final int? maxLength;
  final Widget? suffixIcon;
  final Function? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${label!}',
          style: TextStyle(
            fontSize: 14,
            color: ColorRefer.kTextColor,
            fontFamily: FontRefer.Roboto,
          ),
        ),
        SizedBox(
          height: 30,
          child: TextField (
            readOnly: readonly!,
            cursorColor: ColorRefer.kPrimaryColor,
            controller: controller,
            decoration: StyleRefer.kProfileTextFieldDecoration.copyWith(
                hintText: hintText,
                suffixIcon: suffixIcon!,
                suffixIconColor: ColorRefer.kPrimaryColor
            ),
            onTap: onTap,
            keyboardType:textInputType,
            onChanged: onChanged as void Function(String?)?,
            maxLength: maxLength,
            style: TextStyle(fontSize: 12, color: ColorRefer.kTextColor),
          ),
        ),

      ],
    );
  }
}
