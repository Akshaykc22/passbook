import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passbook_core/MainScreens/Login.dart';
import 'package:passbook_core/Util/GlobalWidgets.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logout extends StatefulWidget {
  const Logout({Key key}) : super(key: key);

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  SharedPreferences preferences;
  var userId = "", acc = "", name = "", address = "", languageId = "";

  // En, Fr, Es, Pr
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

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffE8696E),
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          Positioned(
              left: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: 20,
                color: Theme.of(context).secondaryHeaderColor,
              )),
          Positioned(
              left: 20,
              child: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: 20,
                color: Theme.of(context).primaryColor,
              )),
          // Positioned(
          //   right: MediaQuery.of(context).size.width * 0.1,
          //   top: MediaQuery.of(context).size.width * 0.25,
          //   child: Container(
          //     height: MediaQuery.of(context).size.height * 0.4,
          //     width: MediaQuery.of(context).size.width * 0.4,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Theme.of(context).primaryColor,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.withOpacity(0.5),
          //           spreadRadius: 5,
          //           blurRadius: 7,
          //           offset: Offset(0, 3), // changes position of shadow
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Positioned(
          //   left: MediaQuery.of(context).size.width * 0.18,
          //   bottom: MediaQuery.of(context).size.width * 0.28,
          //   child: Container(
          //     height: MediaQuery.of(context).size.height * 0.3,
          //     width: MediaQuery.of(context).size.width * 0.3,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.indigo,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.withOpacity(0.5),
          //           spreadRadius: 5,
          //           blurRadius: 7,
          //           offset: Offset(0, 3), // changes position of shadow
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Center(
            child: Container(
              height: 300,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                // color: Colors.white.withOpacity(0.8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: GlobalWidgets()
                        .logoWithoutText(context, StaticValues.titleDecoration),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      confirmLogoutList[int.parse(languageId)],
                      // "Are you sure you want to Logout ?",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: InkWell(
                      child: CustomRaisedIndigoButton(
                        // buttonText: "Logout",
                        buttonText: logoutList[int.parse(languageId)],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      userId = preferences?.getString(StaticValues.custID) ?? "";
      acc = preferences?.getString(StaticValues.accNumber) ?? "";
      name = preferences?.getString(StaticValues.accName) ?? "";
      address = preferences?.getString(StaticValues.address) ?? "";
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
      print("userName");
      print(userId);
      print(acc);
      print(name);
    });
  }
}
