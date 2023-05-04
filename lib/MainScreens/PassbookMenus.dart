import 'package:flutter/material.dart';
import 'package:passbook_core/MainScreens/ChittyLoan.dart';
import 'package:passbook_core/Passbook/PassbookDPSH.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassbookMenus extends StatefulWidget {
  const PassbookMenus({Key key}) : super(key: key);

  @override
  _PassbookMenusState createState() => _PassbookMenusState();
}

class _PassbookMenusState extends State<PassbookMenus> {
  SharedPreferences preferences;
  var languageId = "";

  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> accList = ["Account", "Compte", "Cuenta", "Conta"];
  List<String> depositList = ["Deposit", "Dépôt", "Depósito", "Depósito"];
  List<String> loanList = ["Loan", "prêter", "Préstamo", "empréstimo"];
  List<String> shareList = ["Share", "Partager", "Cuota", "Compartilhar"];
  List<String> passbookList = [
    "Passbook",
    "Livret",
    "Libreta de depósitos",
    "caderneta"
  ];

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        centerTitle: true,
        // title: Text("Passbook"),
        title: Text(passbookList[int.parse(languageId)]),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Stack(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  childAspectRatio: .8,
                  children: <Widget>[
                    GlobalWidgets().gridWidget(
                      context: context,
                      imageName: 'assets/deposit.png',
                      // name: "Deposit",
                      name: depositList[int.parse(languageId)],
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PassbookDPSH(
                                    type: "DP",
                                  ))),
                    ),
                    GlobalWidgets().gridWidget(
                      context: context,
                      imageName: 'assets/loan.png',
                      // name: "Loan",
                      name: loanList[int.parse(languageId)],
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChittyLoan(
                                    type: null,
                                    isAccount: false,
                                  ))),
                    ),
                    GlobalWidgets().gridWidget(
                      context: context,
                      imageName: 'assets/share.png',
                      // name: "Share",
                      name: shareList[int.parse(languageId)],
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PassbookDPSH(
                                    type: "SH",
                                  ))),
                    ),
                    Visibility(
                      visible: false,
                      child: GlobalWidgets().gridWidget(
                        context: context,
                        imageName: 'assets/chitty.png',
                        name: "Chitty",
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChittyLoan(
                                      type: "MMBS",
                                      isAccount: false,
                                    ))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*    Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "assets/safesoftware_logo.png",
                  width: 200,
                ))*/
          ],
        ),
      ),
    );
  }
}
