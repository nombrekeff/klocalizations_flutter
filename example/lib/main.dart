import 'package:example/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:klocalizations_flutter/klocalizations_flutter.dart';

// Define you locales somewhere
const supportedLocales = [
  Locale('en', 'GB'),
  Locale('es', 'ES'),
  Locale('ar', 'AR'),
];

void main() {
  runApp(
    KLocalizations.asChangeNotifier(
      locale: supportedLocales[0],
      defaultLocale: supportedLocales[0],
      supportedLocales: supportedLocales,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final klocalizations = KLocalizations.of(context);

    return MaterialApp(
      title: 'Flutter Demo',
      locale: klocalizations.locale,
      supportedLocales: klocalizations.supportedLocales,
      localizationsDelegates: [
        klocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'home.title'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var klocalizations = KLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: LocalizedText(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LocalizedText(
              'home.welcome',
              style: theme.textTheme.headline5,
            ),
            LanguageSelector(
              locale: klocalizations.locale,
              supportedLocales: klocalizations.supportedLocales,
              onChange: (locale) {
                klocalizations.setLocale(locale ?? klocalizations.defaultLocale);
              },
            ),
            LocalizedText(
              'home.counter',
              params: {
                'count': _counter,
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
