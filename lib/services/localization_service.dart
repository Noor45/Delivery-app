import 'package:driver_panel/lang/app_en.dart';
import 'package:driver_panel/lang/app_fr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  // Default locale set to French
  static const locale = Locale('fr', 'FR');

  static final locales = [
    const Locale('fr'), // French as the default
    const Locale('en'), // English as an alternative
  ];

  // Keys and their translations
  // Only handling French and English translations
  @override
  Map<String, Map<String, String>> get keys => {
    'fr': trFR,
    'en': enUS,
  };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    if (lang == 'fr' || lang == 'en') {
      Get.updateLocale(Locale(lang));
    } else {
      Get.updateLocale(locale); // Fallback to default French if unsupported language
    }
  }
}
