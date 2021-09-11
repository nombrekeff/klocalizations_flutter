import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';

abstract class KLocalizationsLoader {
  final String assetPath;

  KLocalizationsLoader({
    required this.assetPath,
  });

  Future<Map<String, dynamic>> loadMapForLocale(Locale locale);
}

class KLocalizationsLoaderJson extends KLocalizationsLoader {
  KLocalizationsLoaderJson({
    required String assetPath,
  }) : super(assetPath: assetPath);

  @override
  Future<Map<String, dynamic>> loadMapForLocale(Locale locale) async {
    var jsonString = await _loadStringForCurrentLocale(locale);
    return json.decode(jsonString);
  }

  Future<String> _loadStringForCurrentLocale(Locale locale) {
    return rootBundle.loadString('$assetPath/${locale.languageCode}.json');
  }
}
