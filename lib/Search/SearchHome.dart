import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passbook_core/Util/GlobalWidgets.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AccountSearch.dart';

class SearchHome extends StatefulWidget {
  @override
  _SearchHomeState createState() => _SearchHomeState();
}

class _SearchHomeState extends State<SearchHome> {
  SharedPreferences preferences;
  var languageId = "";

  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> searchHomeList = [
    "Search Home",
    "Rechercher Accueil",
    "Buscar Inicio",
    "Pesquisar na página inicial"
  ];
  List<String> balList = ["Balance", "équilibre", "balance", "Equilíbrio"];
  List<String> typeList = ["Type", "Taper", "Tipo", "Tipo"];
  List<String> accList = ["Account", "Compte", "Cuenta", "Conta"];
  List<String> depositList = ["Deposit", "Dépôt", "Depósito", "Depósito"];
  List<String> loanList = ["Loan", "prêter", "Préstamo", "empréstimo"];
  List<String> shareList = ["Share", "Partager", "Cuota", "Compartilhar"];

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
        // title: Text("Search Home"),
        title: Text(searchHomeList[int.parse(languageId)]),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
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
                      // onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => AccountSearch("Account"))),
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => AccountSearch(
                                  accList[int.parse(languageId)]))),
                    ),
                    GlobalWidgets().gridWidget(
                      context: context,
                      imageName: 'assets/loan.png',
                      // name: "Loan",
                      name: loanList[int.parse(languageId)],
                      // onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => AccountSearch("Loan"))),
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => AccountSearch(
                                  loanList[int.parse(languageId)]))),
                    ),
                    Visibility(
                      visible: false,
                      child: GlobalWidgets().gridWidget(
                        context: context,
                        imageName: 'assets/chitty.png',
                        name: "Chitty",
                        /* onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AccountSearch())),*/
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: GlobalWidgets().gridWidget(
                        context: context,
                        imageName: 'assets/share.png',
                        // name: "Share",
                        name: shareList[int.parse(languageId)],
                        /* onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AccountSearch())),*/
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*   Align(
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
