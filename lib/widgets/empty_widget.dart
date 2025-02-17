import 'package:flutter/material.dart';
import '../../utils/colors.dart';

emptyWidget(String msg, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 50, right: 50),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 1.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/empty_folder.png',
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 6),
              Text(
                msg,
                textAlign: TextAlign.center,
                style: const TextStyle(color: ColorRefer.kGreyColor, fontSize: 14),
              ),
            ],
          ),
        )
      ],
    ),
  );
}