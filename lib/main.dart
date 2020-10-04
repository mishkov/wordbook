import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:wordbook/database/database.dart';
import 'package:wordbook/services/theme_controller.dart';
import 'package:wordbook/test_route/test_route.dart';
import 'services/app_localizations.dart';
import 'word_list_route/word_list_route.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Admob.initialize();

  var theme = await DBProvider.db.getSetting('Theme');
  await ThemeController().load(theme);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English, no country code
        const Locale('ru', 'RU'), // Russian, no country code
        // ... other locales the app supports
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          print('supportedLocale.languageCode: ${supportedLocale.languageCode},'
              'locale.languageCode: ${locale.languageCode},'
              'supportedLocale.countryCode: ${supportedLocale.countryCode},'
              'locale.countryCode: ${locale.countryCode}');
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: PureScrollBehavior(),
          child: child,
        );
      },
      onGenerateTitle: (context) =>
          AppLocalizations.of(context).translate('app_name'),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.\
        fontFamily: 'LucidaGrande',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PagesView(),
    );
  }
}

class PagesView extends StatelessWidget {
  final pageIndex;

  PagesView({this.pageIndex = 0});

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        initialIndex: pageIndex,
        child: TabBarView(
          children: <Widget>[
            WordListPage(),
            TestPage(),
          ],
        ),
      );
}
