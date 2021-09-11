# KLocalizations

Wrapper around [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html), adding some extra functionality. 


## Features
* Easy setup
* Parameter Interpolation
* Access translations with dot notation (`home.title`)
* Change locale from anywhere, app reacts
* `LocalizedText` widget, behaves live `Text` but attempts to translate the string.


## How to use

### 1. Create translations files
The first this we need to do, is to create the files containing our translations for each of the supported languages.

By default KLocalizations expects them to be located under `'assets/translations'`, but can be specified on setup. The configuration files must be in json format.

**Example:**
```json
// assets/translations/es.json
{
  "welcome": "Bienvenido a klocalizations demo!",
  "home": {
    "title": "KLocalizations demo!",
    "counter": "Has clicado {{count}} veces"
  },
}
```


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

#### 2.1. Add assets to pubspec
The path to the translation files assets must be declared in the `pubspec.yml`, so that Flutter let's us access them:
```yml
flutter:
  assets:
    - assets/translations/
```

> The asset path must be the same as the one passed in `localizationsAssetsPath`.

### 3. Translating

Now we are ready to start trasnlating in the app. KLocalizations offers 2 ways of doing this, by using **KLocalizations.translate()** or using the **LocalizedText** widget.

#### KLocalizations.translate()

This method receives a string (or key), and returns the translated string. This is how you would use it: 

```dart
@override
Widget build(BuildContext context) {
  final localizations = KLocalizations.of(context);

  return Column(
    children: [
      Text(localizations.translate('welcome')),
      Text(localizations.translate('home.title')),
      Text(localizations.translate('home.counter', { 'count': 12 })),
    ]
  );
}
```

#### LocalizedText

**KLocalizatons** offers a text widget that behaves exactly like Flutter's **Text** widget, but tries to translate the given string using `KLocalizatons`. It also accepts params for interpolation. Used like this:

```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      LocalizedText('welcome'),
      LocalizedText('home.title'),
      LocalizedText('home.counter', params: { 'count': 12 }),
    ]
  );
}
```

> `LocalizedText` accepts the same arguments as [Text](https://api.flutter.dev/flutter/widgets/Text-class.html)


### 4. Changing locale

Changing locale is not a big deal, we just need to tell **KLocalizatons** to change it:
```dart
klocalizations.setLocale(locale);
```

This will rebuild the widget tree and apply the selected locale across the app.


## Additional info

There is a complete example [here](https://github.com/nombrekeff/klocalizations_flutter/tree/main/example)

If you encounter any problems or fancy a feature to be added please head over to the GitHub [repository](https://github.com/nombrekeff/klocalizations_flutter/) and [drop an issue](https://github.com/nombrekeff/klocalizations_flutter/issues/new).


