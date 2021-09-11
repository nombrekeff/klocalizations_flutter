import 'package:flutter/material.dart';
import 'package:klocalizations_flutter/klocalizations_flutter.dart';

class LanguageSelector extends StatelessWidget {
  final Locale locale;
  final List<Locale> supportedLocales;
  final ValueChanged<Locale?>? onChange;

  const LanguageSelector({
    Key? key,
    required this.locale,
    required this.supportedLocales,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: locale,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      onChanged: onChange,
      items: supportedLocales.map<DropdownMenuItem<Locale>>((Locale locale) {
        return DropdownMenuItem(
          value: locale,
          child: LocalizedText('languages.${locale.languageCode}'),
        );
      }).toList(),
    );
  }
}
