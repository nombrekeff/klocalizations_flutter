# KLocalizations

Wrapper around [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html), adding some extra functionality. 


## Features
* Easy setup
* Parameter Interpolation
* Access translations with dot notation (`home.title`)
* Change locale from anywhere, app reacts
* `LocalizedText` widget, behaves live `Text` but attempts to translate the string.


## Usage

### 1. Create translations files
First files for each supported locale must be created, by default KLocalizations expects them to be in `'assets/translations'`, but can be changed. The configuration files must be in json format.

### 2. Setup

```dart
void main() {
  runApp(
    KLocalizations.asChangeNotifier(
      locale: supportedLocales[0],
      defaultLocale: supportedLocales[0],
      supportedLocales: supportedLocales,
      localizationsAssetsPath: 'assets/translations',
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = KLocalizations.of(context);

    return MaterialApp(
      locale: localizations.locale,
      supportedLocales: localizations.supportedLocales,
      localizationsDelegates: [
        localizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: MyApp(),
    );
  }
}
```
