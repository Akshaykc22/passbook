import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passbook_core/MainScreens/Login.dart';
import 'package:passbook_core/MainScreens/home_page.dart';
import 'package:passbook_core/MainScreens/sub_page.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:passbook_core/passbook_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreApp extends StatelessWidget {
//  final Widget _defaultScreen = Receipt(accFrom: "339202010056217",accTo: "1234567890123",amount: "10000",paidTo: "Dithesh Vishalakshan",transID: "PS/258160/200/50041/280PM",);
  final Widget defaultScreen;
  final String apiGateway;
  final SharedPreferences sharedPreferences;
  final TitleDecoration titleDecoration;
  final String extDownloadPath;
  final HomePageConfiguration homePageConfiguration;
  final ThemeData themeData;

  const CoreApp(
      {Key key,
      this.defaultScreen,
      this.apiGateway,
      this.sharedPreferences,
      this.titleDecoration,
      this.homePageConfiguration,
      this.themeData,
      this.extDownloadPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent, // transparent status bar
    //   systemNavigationBarColor: Colors.transparent, // transparent navigation bar
    //   statusBarIconBrightness: Brightness.dark, // dark status bar icons
    //   systemNavigationBarIconBrightness:
    //   Brightness.dark, // dark navigation bar icons
    // ));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent.withOpacity(0.3)));
    StaticValues.themeData = themeData;
    StaticValues.apiGateway = apiGateway;
    StaticValues.titleDecoration = titleDecoration;
    StaticValues.sharedPreferences = sharedPreferences;
    return MaterialApp(
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child);
        },
        title: StaticValues.titleDecoration.label,
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: Scaffold(
          body: defaultScreen,
        ),
        routes: <String, WidgetBuilder>{
          "/SubPage": (BuildContext context) => SubPage(),
          "/LoginPage": (BuildContext context) => Login(),
          "/HomePage": (BuildContext context) => HomePage(
                homePageConfiguration: homePageConfiguration,
              ),
        });
  }
}
