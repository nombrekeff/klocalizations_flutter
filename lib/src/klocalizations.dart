import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:klocalizations_flutter/src/utils.dart';
import 'package:provider/provider.dart';

import 'klocalizations_delegate.dart';

/// This is the clase you will use to setup and consume localizations, refer to the [README]() for more detailed info.
class KLocalizations extends ChangeNotifier {
  /// Creates [KLocalizations] wrapped in a [ChangeNotifierProvider]
  /// After we can get access to [KLocalizations] by calling [KLocalizations.of(context)]
  static ChangeNotifierProvider<KLocalizations> asChangeNotifier({
    required List<Locale> supportedLocales,
    required Locale locale,
    required Locale defaultLocale,
    String? localizationsAssetsPath,
    Widget? child,
  }) {
    return ChangeNotifierProvider(
      create: (context) => KLocalizations(
        locale: locale,
        defaultLocale: defaultLocale,
        supportedLocales: supportedLocales,
        localizationsAssetsPath: localizationsAssetsPath ?? 'assets/translations',
      ),
      child: child,
    );
  }

  /// Obtains the nearest [KLocalizations] up its widget tree and returns its value.
  static KLocalizations of(BuildContext context) {
    return Provider.of<KLocalizations>(context);
  }

  /// Defines the current locale that is being used in the App
  Locale locale;

  /// Defines the default locale
  final Locale defaultLocale;

  /// The location of the translation files, by default 'assets/translations'
  final String localizationsAssetsPath;

  /// List of available locales, can be used by [localeResolutionCallback], to determine whether a locale is supported or not
  final List<Locale> supportedLocales;

  KLocalizationsDelegate? _delegate;

  /// Returns the delegate for [KLocalizations]
  get delegate {
    _delegate ??= KLocalizationsDelegate(this);
    return _delegate;
  }

  /// Returns the supported locale names
  get supportedLocaleNames => supportedLocales.map((locale) => locale.languageCode);

  /// Returns [TextDirection] for the current locale if specified, otherwise returns [TextDirection.ltr]
  TextDirection get textDirection {
    var localeConfigDirection = translate('_config.textDirection');
    switch (localeConfigDirection) {
      case 'rtl':
        return TextDirection.rtl;
      case 'ltr':
      default:
        return TextDirection.ltr;
    }
  }

  Map<String, dynamic> _localizedStrings = <String, dynamic>{};

  KLocalizations({
    required this.locale,
    required this.defaultLocale,
    required this.supportedLocales,
    this.localizationsAssetsPath = 'assets/translations',
  }) : assert(supportedLocales.isNotEmpty, 'At least a locale must be provided');

  /// Searches for a given [languageCode] in the list of [supportedLocales], if there is a match the [Locale] is returned.
  /// Oherwise [orElse] is called if provided. If [orElse] is not provided, default value will be the first supported locale.
  Locale getLocaleByLanguageCode(String? languageCode, {Locale Function()? orElse}) {
    return supportedLocales.firstWhere(
      (lang) => lang.languageCode == languageCode,
      orElse: orElse ?? () => supportedLocales.first,
    );
  }

  /// Searches for a given [countryCode] in the list of [supportedLocales], if there is a match the [Locale] is returned.
  /// Oherwise [orElse] is called if provided. If [orElse] is not provided, default value will be the first supported locale.
  Locale getLocaleByCountryCode(String? countryCode, {Locale Function()? orElse}) {
    return supportedLocales.firstWhere(
      (lang) => lang.countryCode == countryCode,
      orElse: orElse ?? () => supportedLocales.first,
    );
  }

  /// Set the locale
  /// If locale is not supported it will fallback to [supportedLocales.first]
  void setLocale(Locale locale) {
    this.locale = locale;
    notifyListeners();
  }

  /// Main method, given a [key] and a set of [params],
  /// return the translated for the current [locale]
  String translate(String key, {Map<String, dynamic>? params}) {
    String? translation;

    if (key.contains('.')) {
      translation = getValueFromPath(key, _localizedStrings);
    } else {
      translation = _localizedStrings[key];
    }

    // var translation = _localizedStrings[key] ?? key;
    if (params != null && translation != null) {
      translation = interpolate(translation, params: params);
    }

    return translation ?? key;
  }

  /// Loads translations for current locale
  Future<bool> load() async {
    var jsonMap = await _loadMapForLocale();
    _localizedStrings = jsonMap.map(_mapEntry);

    return true;
  }

  MapEntry<String, dynamic> _mapEntry(String key, value) => MapEntry(key, value);

  Future<String> _loadStringForCurrentLocale() {
    return rootBundle.loadString('$localizationsAssetsPath/${locale.languageCode}.json');
  }

  Future<Map<String, dynamic>> _loadMapForLocale() async {
    var jsonString = await _loadStringForCurrentLocale();
    return json.decode(jsonString);
  }
}
