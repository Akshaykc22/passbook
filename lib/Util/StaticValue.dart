import 'package:flutter/material.dart';
import 'package:passbook_core/configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticValues {
  static String custID = "cust_id";
  static String accNumber = "acc_number";
  static String accName = "acc_name";
  static String userPass = "cust_pass";
  static String address = "address";
  static String rupeeSymbol = "XAF";
  static String schemeCode = "Sch_Code";
  static String branchCode = "Br_Code";
  static String Mpin = "Mpin";
  static String mobileNo = "Mobile";
  static String ifsc = "Ifsc";
  static String accountNo = "AccountNumber";
  static String languageId = "languageId";

  static Color _primaryColor = Color(0xff005b96);
  static Color _backgroundColor = Color(0xffffffff);
 /* static Color _accentColor = Color(0xff03396c);
  static Color _buttonColor = Color(0xff011f4b);*/
  static Color _accentColor = Color(0xff3F51B5);
  static Color _buttonColor = Color(0xff26316D);

  static Color _textColor = Colors.black;

  static TitleDecoration titleDecoration;
  static String apiGateway = "";
  static String externalDownloadPath = "";
  static SharedPreferences sharedPreferences;
  static ThemeData themeData = ThemeData(
      fontFamily: 'Roboto',
      accentColor: _accentColor,
      primaryColor: _primaryColor,
      backgroundColor: _backgroundColor,
      canvasColor: _backgroundColor,
      buttonColor: _buttonColor,
      textTheme: TextTheme(
          bodyText1: TextStyle(
        color: Colors.black,
      )),
      appBarTheme: AppBarTheme(color: _primaryColor, brightness: Brightness.dark),
      hintColor: Colors.black,
      buttonTheme: ButtonThemeData(
        buttonColor: _accentColor,
      ),
      visualDensity: VisualDensity.comfortable);
}

