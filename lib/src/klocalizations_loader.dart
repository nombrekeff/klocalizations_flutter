import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';

/// Interface for creating a [KLocalizationsLoader]
abstract class KLocalizationsLoader {
  /// The path where the translation assets are located
  final String assetPath;

  KLocalizationsLoader({
    required this.assetPath,
  });

  /// Loads the translations map for a given [Locale]
  Future<Map<String, dynamic>> loadMapForLocale(Locale locale);
}

/// This loader loads translations from json files
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
