import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passbook/SliderScreen.dart';
import 'package:passbook_core/Logout.dart';
import 'package:passbook_core/MainScreens/AccountMenus.dart';
import 'package:passbook_core/MainScreens/Login.dart';
import 'package:passbook_core/MainScreens/sub_page.dart';
import 'package:passbook_core/Setting.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:passbook_core/configuration.dart';
import 'package:passbook_core/speechRecognition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PassbookMenus.dart';

class HomePage extends StatefulWidget {
  final HomePageConfiguration homePageConfiguration;

  const HomePage(
      {Key key, @required this.homePageConfiguration, this.defaultScreen})
      : super(key: key);
  final Widget defaultScreen;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  ///Idle State (Session Timeout or Auto Logout)
  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                Login())); // Conservatively set a timer on all three
        break;
    }
  }

  int bottomNavigationIndex = 1;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String acc;

  SharedPreferences preferences;
  var languageId = "";

  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> confirmLogoutList = [
    "Are you sure you want to Logout ?",
    "Êtes-vous sûr de vouloir vous déconnecter?",
    "Estás seguro de que quieres cerrar sesión?",
    "Tem certeza que deseja sair?"
  ];
  List<String> logoutList = [
    "Logout",
    "Se déconnecter",
    "cerrar sesión",
    "sair"
  ];
  List<String> yesList = ["Yes", "oui", "si", "sim"];
  List<String> noList = ["No", "non", "no", "não"];
  List<String> openAccList = [
    "Open Account",
    "Compte ouvert",
    "Cuenta abierta",
    "Conta aberta"
  ];
  List<String> getDetailsList = [
    "Get Details",
    "Obtenir des détails",
    "Obtén detalles",
    "Obter detalhes"
  ];
  List<String> settingsList = [
    "Settings",
    "Paramètres",
    "Ajustes",
    "Configurações"
  ];
  List<String> homeList = ["Home", "Maison", "Hogar", "Lar"];

  @override
  void initState() {
    loadData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show an alert dialog when the user presses the back button
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            // title: Text('Do you want to Logout?'),
            title: Text(confirmLogoutList[int.parse(languageId)]),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).secondaryHeaderColor,
                ),
                onPressed: () => Navigator.pop(context, false),
                // child: Text('No'),
                child: Text(noList[int.parse(languageId)]),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).secondaryHeaderColor,
                ),
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SliderScreen())),
                // child: Text('Yes'),
                child: Text(yesList[int.parse(languageId)]),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.black,
            selectedItemColor: Theme.of(context).primaryColor,
            showUnselectedLabels: true,
            onTap: (index) {
              setState(() {
                bottomNavigationIndex = index;
              });
            },
            currentIndex: bottomNavigationIndex,
            elevation: 6.0,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle:
                TextStyle(color: Theme.of(context).primaryColor),
            items: _bottomNavigationItem()),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            heyBank();
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => VoiceCommander()));
          },
          mini: true,
          child: Icon(Icons.mic),
        ),
        body: SafeArea(
          child: IndexedStack(
            index: bottomNavigationIndex,

            ///BottomNavBar
            children: [
              //Index 0
              Settings(),

              //Index 1
              SubPage(
                scaffoldKey: _scaffoldKey,
                homePageConfiguration: widget.homePageConfiguration,
              ),
              // Container()

              //Index 2
              Logout(),
            ],
          ),
        ),
      ),
    );
  }

  // showAlertDialog(BuildContext context) {
  //
  //   // set up the buttons
  //   Widget cancelButton = TextButton(
  //     child: Text("No"),
  //     onPressed:  () {
  //       Navigator.pop(context);
  //     },
  //   );
  //   Widget continueButton = TextButton(
  //     child: Text("Yes"),
  //     onPressed:  () {
  //       Navigator.of(context).pushNamedAndRemoveUntil("/LoginPage",(_)=>false);
  //     },
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Logout"),
  //     content: Text("Would you like to logout?"),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  List<BottomNavigationBarItem> _bottomNavigationItem() {
    return [
      BottomNavigationBarItem(
          icon: Image.asset(
            "assets/settings.png",
            height: 25.0,
            width: 25.0,
            // color: bottomNavigationIndex == 0 ? Theme.of(context).primaryColor : Colors.black,
            color: bottomNavigationIndex == 0
                ? Theme.of(context).primaryColor
                : Theme.of(context).secondaryHeaderColor,
          ),
          // title: TextView("Settings")),
          title: TextView(settingsList[int.parse(languageId)])),
      BottomNavigationBarItem(
          icon: Image.asset(
            "assets/home.png",
            height: 25.0,
            width: 25.0,
            color: bottomNavigationIndex == 1
                ? Theme.of(context).primaryColor
                : Theme.of(context).secondaryHeaderColor,
          ),
          // title: TextView("Home")),
          title: TextView(homeList[int.parse(languageId)])),
      BottomNavigationBarItem(
          icon: InkWell(
            //    onTap: (){
            // showAlertDialog(context);
            //   //   Navigator.of(context).pushNamedAndRemoveUntil("/LoginPage",(_)=>false);
            //    },
            child: Image.asset(
              "assets/logout.png",
              height: 25.0,
              width: 25.0,
              color: bottomNavigationIndex == 2
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).secondaryHeaderColor,
            ),
          ),
          title: TextView(
            // "Logout",
            logoutList[int.parse(languageId)],
            maxLines: 1,
            textAlign: TextAlign.center,
          )),
    ];
  }

  void heyBank() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return VoiceCommander(
              commands: (String commands) async {
                print(commands);
                // if (commands.contains("Open Account")) {
                if (commands.contains(openAccList[int.parse(languageId)])) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AccountMenus()));
                  // } else if (commands.contains("Get Details")) {
                } else if (commands
                    .contains(getDetailsList[int.parse(languageId)])) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PassbookMenus()));
                } else if (commands.toLowerCase().contains("QR Scan")) {
                  print("scan");
                  Navigator.pop(context);
                  SharedPreferences preferences =
                      StaticValues.sharedPreferences;
                  GlobalWidgets().shoppingPay(context, setState, _scaffoldKey,
                      preferences?.getString(StaticValues.accNumber) ?? "");
                }
              },
            );
          });
        });
  }

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
      print(languageId);
    });
  }
}
