import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:passbook_core/Passbook/depositTransaction.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../REST/RestAPI.dart';
import 'Model/PassbookListModel.dart';

class PassbookDPSH extends StatefulWidget {
  final String type;

  const PassbookDPSH({Key key, this.type}) : super(key: key);

  @override
  _PassbookDPSHState createState() => _PassbookDPSHState();
}

class _PassbookDPSHState extends State<PassbookDPSH> {
  SharedPreferences preferences;
  var languageId = "";

  PageController _pageController =
      PageController(initialPage: 0, keepPage: true, viewportFraction: .90);
  List<PassbookTable> transactionList = List();
  double currentPage = 0;

  Future<List<PassbookTable>> getTransactions1() async {
    SharedPreferences pref = StaticValues.sharedPreferences;
    Map res = await RestAPI().get(
        "${APis.otherAccListInfo}${pref.getString(StaticValues.custID)}&Acc_Type=${widget.type}");
    PassbookListModel _transactionModel = PassbookListModel.fromJson(res);
    return _transactionModel.table;
  }

  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> accList = ["Account", "Compte", "Cuenta", "Conta"];
  List<String> depositList = ["Deposit", "Dépôt", "Depósito", "Depósito"];
  List<String> dontHaveDepositList = [
    "You don't have a deposit in this bank.",
    "Vous n'avez pas de dépôt dans cette banque.",
    "No tienes un depósito en este banco.",
    "Você não tem um depósito neste banco."
  ];
  List<String> loanList = ["Loan", "prêter", "Préstamo", "empréstimo"];
  List<String> dontHaveLoanList = [
    "You don't have a loan in this bank.",
    "Vous n'avez pas de prêt dans cette banque.",
    "No tienes un préstamo en este banco.",
    "Você não tem um empréstimo neste banco"
  ];
  List<String> shareList = ["Share", "Partager", "Cuota", "Compartilhar"];
  List<String> dontHaveShareList = [
    "You don’t have a share in this bank",
    "Vous n'avez pas de part dans cette banque.",
    "No tienes participación en este banco.",
    "Você não tem uma ação neste banco."
  ];
  List<String> individualSavingsAccList = [
    "Individual Savings Account",
    "compte d'épargne individuel",
    "cuenta de ahorro individual",
    "conta poupança individual"
  ];
  List<String> nomineeList = ["Nominee", "candidat", "candidato", "candidato"];
  List<String> availableBalList = [
    "Available Balance",
    "solde disponible",
    "Saldo disponible",
    "saldo disponível"
  ];
  List<String> youDontHaveAList = [
    "You don't have a",
    "Vous n'avez pas de",
    "no tienes un",
    "você não tem um"
  ];
  List<String> inThisBankList = [
    "in this bank.",
    "dans cette banque.",
    "en este banco",
    "neste banco."
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
        // title: Text(widget.type.toLowerCase() == "dp" ? "Deposit" : "Share"),
        title: Text(widget.type.toLowerCase() == "dp"
            ? depositList[int.parse(languageId)]
            : shareList[int.parse(languageId)]),
      ),
      body: SafeArea(
          child: FutureBuilder<List<PassbookTable>>(
              future: getTransactions1(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Stack(
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  );
                } else {
                  if (snapshot.data.length > 0) {
                    transactionList = snapshot.data;
                    return Column(
                      children: <Widget>[
                        DotsIndicator(
                          dotsCount: transactionList.length,
                          position: currentPage,
                          decorator: DotsDecorator(
                            color: Theme.of(context)
                                .secondaryHeaderColor
                                .withAlpha(80),
                            activeColor: Theme.of(context).secondaryHeaderColor,
                            size: const Size(18.0, 5.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            activeSize: const Size(18.0, 5.0),
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                        Expanded(
                          child: PageView.builder(
                            itemCount: transactionList.length,
                            controller: _pageController,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Theme.of(context).disabledColor,
                                          Theme.of(context).secondaryHeaderColor
                                        ]),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black45,
                                              offset: Offset(1.5, 1.5), //(x,y)
                                              blurRadius: 5.0,
                                              spreadRadius: 2.0),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: ListTile(
                                        title: Column(
                                          children: <Widget>[
                                            ListTile(
                                              dense: true,
                                              isThreeLine: true,
                                              contentPadding:
                                                  EdgeInsets.all(0.0),
                                              title: TextView(
                                                transactionList[index].accNo,
                                                color: Colors.white,
                                                size: 16.0,
                                                fontWeight: FontWeight.bold,
                                                textAlign: TextAlign.start,
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  TextView(
                                                    transactionList[index]
                                                        .schName,
                                                    color: Colors.white,
                                                    textAlign: TextAlign.start,
                                                    size: 12.0,
                                                  ),
                                                  TextView(
                                                    transactionList[index]
                                                        .depBranch,
                                                    color: Colors.white,
                                                    textAlign: TextAlign.start,
                                                    size: 12.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextView(
                                              transactionList[index]
                                                  .balance
                                                  .toStringAsFixed(2),
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                            TextView(
                                              // "Available Balance",
                                              availableBalList[
                                                  int.parse(languageId)],
                                              color: Colors.white,
                                              size: 13,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  DepositShareTransaction(
                                    depositTransaction: transactionList[index],
                                  ),
                                ],
                              );
                            },
                            onPageChanged: (index) {
                              setState(() {
                                currentPage = index.floorToDouble();
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return Stack(
                    children: [
                      Center(
                        child: TextView(
                            // "You don't have a ${widget.type == "DP" ? 'deposit' : 'share'} in this bank"),
                            "${youDontHaveAList[int.parse(languageId)]} ${widget.type == "DP" ? depositList[int.parse(languageId)] : shareList[int.parse(languageId)]} ${inThisBankList[int.parse(languageId)]}"),
                      )
                    ],
                  );
                }
              })),
    );
  }
}
