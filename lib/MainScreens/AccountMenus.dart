import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passbook_core/Account/Model/AccountsDepositModel.dart';
import 'package:passbook_core/Account/Model/AccountsLoanModel.dart';
import 'package:passbook_core/MainScreens/CardsModel.dart';
import 'package:passbook_core/MainScreens/bloc/bloc.dart';
import 'package:passbook_core/Passbook/ChittyTransaction.dart';
import 'package:passbook_core/Passbook/LoanTransaction.dart';
import 'package:passbook_core/Passbook/Model/PassbookListModel.dart';
import 'package:passbook_core/Passbook/PassbookDPSH.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountMenus extends StatefulWidget {
  const AccountMenus({
    Key key,
  }) : super(key: key);

  @override
  _AccountMenusState createState() => _AccountMenusState();
}

class _AccountMenusState extends State<AccountMenus>
    with TickerProviderStateMixin {
  SharedPreferences preferences;
  var userId = "", acc = "", name = "", address = "", languageId = "";

  List<AccountsLoanTable> _accLoanTableModel = List();
  List<AccountsDepositTable> _accDepositModel = List();
  List<PassbookTable> _chittyModel = List(), _shareModel = List();
  double _pageViewHeight = 200;
  HomeBloc _homeBloc = HomeBloc();

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

    _homeBloc.add(AccDepositEvent(userId));
    _homeBloc.add(AccLoanEvent(userId));
    _homeBloc.add(ChittyEvent(userId));
    _homeBloc.add(ShareEvent(userId));
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  @override
  void dispose() {
    _homeBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                centerTitle: true,
                pinned: true,
                stretch: true,
                title: TextView(
                  // "Account",
                  accList[int.parse(languageId)],
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
              SliverSafeArea(
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    BlocListener<HomeBloc, HomeState>(
                      bloc: _homeBloc,
                      listener: (context, snapshot) {
                        if (snapshot is AccDepositResponse) {
                          setState(() {
                            _accDepositModel =
                                snapshot.accountsDepositModel.table;
                          });
                        }
                        if (snapshot is AccLoanResponse) {
                          setState(() {
                            _accLoanTableModel =
                                snapshot.accountsLoanModel.table;
                          });
                        }
                        if (snapshot is ChittyResponse) {
                          setState(() {
                            _chittyModel = snapshot.chittyListModel.table;
                          });
                        }
                        if (snapshot is ShareResponse) {
                          setState(() {
                            _shareModel = snapshot.shareListModel.table;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextView(
                          // "Deposit",
                          depositList[int.parse(languageId)],
                          size: 24.0,
                          fontWeight: FontWeight.bold,
                          // color: Color(0xff707070),
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _pageViewHeight,
                      child: BlocBuilder<HomeBloc, HomeState>(
                          bloc: _homeBloc,
                          builder: (context, snapshot) {
                            if (snapshot is AccDepositLoading) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (_accDepositModel.length > 0) {
                              return PageView.builder(
                                  itemCount: _accDepositModel.length,
                                  scrollDirection: Axis.horizontal,
                                  controller:
                                      PageController(viewportFraction: .95),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: DepositCardModel(
                                        accountsDeposit:
                                            _accDepositModel[index],
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PassbookDPSH(
                                                        type: "DP",
                                                      )));
                                        },
                                      ),
                                    );
                                  });
                            }
                            return Center(
                              // child: TextView("You don't have a deposit in this bank"),
                              child: TextView(
                                  dontHaveDepositList[int.parse(languageId)]),
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextView(
                        // "Loan",
                        loanList[int.parse(languageId)],
                        size: 24.0,
                        fontWeight: FontWeight.bold,
                        // color: Color(0xff707070),
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    SizedBox(
                      height: _pageViewHeight,
                      child: BlocBuilder<HomeBloc, HomeState>(
                          bloc: _homeBloc,
                          builder: (context, snapshot) {
                            if (snapshot is AccLoanLoading) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (_accLoanTableModel.length > 0) {
                              return PageView.builder(
                                  controller:
                                      PageController(viewportFraction: .95),
                                  itemCount: _accLoanTableModel.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: LoanCardModel(
                                        accountsLoanTable:
                                            _accLoanTableModel[index],
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoanTransaction(
                                                        accNo:
                                                            _accLoanTableModel[
                                                                    index]
                                                                .loanNo,
                                                      )));
                                        },
                                      ),
                                    );
                                  });
                            }
                            return Center(
                              // child: TextView("You don't have a loan in this bank"),
                              child: TextView(
                                  dontHaveLoanList[int.parse(languageId)]),
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                        visible: false,
                        child: TextView(
                          "Chitty",
                          size: 24.0,
                          fontWeight: FontWeight.bold,
                          // color: Color(0xff707070),
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: SizedBox(
                        height: _pageViewHeight,
                        child: BlocBuilder<HomeBloc, HomeState>(
                            bloc: _homeBloc,
                            builder: (context, snapshot) {
                              if (snapshot is ChittyLoading) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (_chittyModel.length > 0) {
                                return PageView.builder(
                                    controller:
                                        PageController(viewportFraction: .95),
                                    itemCount: _chittyModel.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ChittyCardModel(
                                          chittyListTable: _chittyModel[index],
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChittyTransaction(
                                                          accNo: _chittyModel[
                                                                  index]
                                                              .accNo,
                                                        )));
                                          },
                                        ),
                                      );
                                    });
                              }
                              return Center(
                                child: TextView(
                                    "You don't have a chitty in this bank"),
                              );
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextView(
                        // "Share",
                        shareList[int.parse(languageId)],
                        size: 24.0,
                        fontWeight: FontWeight.bold,
                        // color: Color(0xff707070),
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    SizedBox(
                      height: _pageViewHeight,
                      child: BlocBuilder<HomeBloc, HomeState>(
                          bloc: _homeBloc,
                          builder: (context, snapshot) {
                            if (snapshot is ShareLoading) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (_shareModel.length > 0) {
                              return PageView.builder(
                                  controller:
                                      PageController(viewportFraction: .95),
                                  itemCount: _shareModel.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ShareCardModel(
                                        shareListTable: _shareModel[index],
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PassbookDPSH(
                                                        type: "SH",
                                                      )));
                                        },
                                      ),
                                    );
                                  });
                            }
                            return Center(
                              // child: TextView("You don't have a share in this bank"),
                              child: TextView(
                                  dontHaveShareList[int.parse(languageId)]),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    /*     Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          "assets/safesoftware_logo.png",
                          width: 200,
                        )),*/
                  ]),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
