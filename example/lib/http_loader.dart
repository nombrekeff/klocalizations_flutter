import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:klocalizations_flutter/klocalizations_flutter.dart';

class HttpLoader extends KLocalizationsLoader {
  final _client = http.Client();

  HttpLoader()
      : super(
          assetPath:
              'https://raw.githubusercontent.com/nombrekeff/klocalizations_flutter/main/example/assets/translations',
        );

  @override
  Future<Map<String, dynamic>> loadMapForLocale(Locale locale) async {
    var jsonString = await _loadStringForCurrentLocale(locale);
    return json.decode(jsonString);
  }

  Future _loadStringForCurrentLocale(Locale locale) {
    return _client
        .get(Uri.parse(assetPath + '/' + locale.languageCode + '.json'))
        .then(
          (value) => value.body,
        )
        .catchError(print);
  }
}
