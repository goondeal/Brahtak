import 'package:Bra7tk/ui/pages/lang_init.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:Bra7tk/models/app_state_model.dart';
import 'package:Bra7tk/services/all_translations.dart';
import 'package:Bra7tk/services/user_repository.dart';
import 'package:Bra7tk/ui/pages/home.dart';
import 'package:Bra7tk/ui/pages/registration_fork_page.dart';
import 'package:Bra7tk/ui/res/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppStateModel model;

  @override
  void initState() {
    super.initState();
    allTranslations.init();
    model = AppStateModel()..loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => allTranslations..init()),
        ChangeNotifierProvider(
            create: (context) => UserRepository()..checkIfKeepedLoggedIn()),
        ChangeNotifierProvider(create: (context) => model),
      ],
      child: Consumer<GlobalTranslations>(
        builder: (context, translation, _) => MaterialApp(
          title: 'Bra7tak',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('ar', 'AE'),
            const Locale('en', 'UK'),
          ],
          locale: translation.locale ?? Locale("ar", "AE"),
          theme: ThemeData(
            primaryColor: primary,
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: GoogleFonts.cairo(),
                  bodyText2: GoogleFonts.cairo(),
                  button: GoogleFonts.cairo(),
                  headline1: GoogleFonts.cairo(),
                  headline2: GoogleFonts.cairo(),
                  headline3: GoogleFonts.cairo(),
                  headline4: GoogleFonts.cairo(),
                  headline5: GoogleFonts.cairo(),
                  headline6: GoogleFonts.cairo(),
                ),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }),
          ),
          home: Consumer<UserRepository>(
            builder: (context, userRepository, _) {
              return allTranslations.savedLang == null
                  ? LangInit()
                  : userRepository.keepedLoggedIn
                      ? Home()
                      : RegisterOrSignIn();
            },
          ),
        ),
      ),
    );
  }
}
