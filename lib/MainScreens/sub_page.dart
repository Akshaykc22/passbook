import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:passbook_core/AccountOpen/AccoutOpenHome.dart';
import 'package:passbook_core/Cards/CardBlock.dart';
import 'package:passbook_core/Cards/CardReset.dart';
import 'package:passbook_core/Cards/CardStatement.dart';
import 'package:passbook_core/Cards/CardTopup.dart';
import 'package:passbook_core/FundTransfer/Beneficiary.dart';
import 'package:passbook_core/FundTransfer/OwnBankTransfer.dart';
import 'package:passbook_core/MainScreens/AccountMenus.dart';
import 'package:passbook_core/MainScreens/PassbookMenus.dart';
import 'package:passbook_core/PayBills/Recharge.dart';
import 'package:passbook_core/Search/SearchHome.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:passbook_core/passbook_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final HomePageConfiguration homePageConfiguration;

  const SubPage({Key key, this.scaffoldKey, this.homePageConfiguration})
      : super(key: key);

  @override
  _SubPageState createState() => _SubPageState();
}

class _SubPageState extends State<SubPage> with TickerProviderStateMixin {
  SharedPreferences preferences;
  var userId = "",
      acc = "",
      ifsc = "",
      name = "",
      address = "",
      languageId = "";
  double _iconSize = 25.0;

  Timer _countdownTimer;

  // En, Fr, Es, Pr
  // List<String> List = ["","","",""];
  List<String> miniStatementList = [
    "Mini Statement",
    "Mini déclaration",
    "Mini Declaración",
    "Mini extrato"
  ];
  List<String> helloList = ["Hello", "Bonjour", "Hola", "olá"];
  List<String> bankingList = ["Banking", "Bancaire", "Bancario", "Bancário"];
  List<String> transferList = [
    "Transfer",
    "Transfert",
    "Transferir",
    "Transferir"
  ];
  List<String> accOpeningList = [
    "Account Opening",
    "Ouverture de compte",
    "Apertura de cuenta",
    "Abertura de conta"
  ];
  List<String> utilPaymentList = [
    "Utility Payments",
    "Paiements des services publics",
    "Pagos de servicios públicos",
    "Pagamentos de serviços públicos"
  ];
  List<String> govPaymentList = [
    "Government Payments",
    "Paiements gouvernementaux",
    "Pagos del gobierno",
    "Pagamentos do governo"
  ];
  List<String> cardTopupList = [
    "Card Topup",
    "Recharge de carte",
    "Recarga de tarjeta",
    "Recarga de cartão"
  ];
  List<String> cardHistoryList = [
    "Card History",
    "Historique de la carte",
    "Historial de la tarjeta",
    "Histórico do Cartão"
  ];
  List<String> newPinList = [
    "New Pin",
    "Nouvelle épingle",
    "Pin nuevo",
    "Novo pino"
  ];
  List<String> cardBlockList = [
    "Card Block",
    "Bloc de carte",
    "Bloque de tarjeta",
    "Bloco de cartão"
  ];
  List<String> accList = ["Account", "Compte", "Cuenta", "Conta"];
  List<String> statementList = [
    "Statement",
    "Déclaration",
    "Declaración",
    "Declaração"
  ];
  List<String> searchList = ["Search", "Rechercher", "Buscar", "Procurar"];
  List<String> addUserList = [
    "Add User",
    "Ajouter un utilisateur",
    "Agregar usuario",
    "Adicionar usuário"
  ];
  List<String> addBeneficiaryList = [
    "Add Beneficiary",
    "Ajouter un bénéficiaire",
    "Añadir Beneficiario",
    "Adicionar Beneficiário"
  ];
  List<String> addAccList = [
    "Add Account",
    "Ajouter un compte",
    "Añadir cuenta",
    "Adicionar Conta"
  ];
  List<String> ownAccList = [
    "Same Bank Transfer",
    "Propre compte",
    "Cuenta propia",
    "Conta própria"
  ];
  List<String> thirdPartyList = [
    "Third Party",
    "Tierce personne",
    "Tercero",
    "Terceiro"
  ];
  List<String> toMobList = [
    "To Mobile No",
    "Vers mobile Non",
    "Al número de móvil",
    "Para Celular Não"
  ];
  List<String> virtualIdList = [
    "Virtual Id",
    "Identifiant virtuel",
    "identificación virtual",
    "Identificação virtual"
  ];
  List<String> fdList = [
    "Fixed Deposit",
    "Compte fixe",
    "Cuenta fija",
    "Conta Fixa"
  ];
  List<String> savingsList = [
    "Recurring Deposit",
    "Compte épargne",
    "Cuenta de ahorros",
    "Conta Poupança"
  ];
  List<String> savingsBankList = [
    "Savings Bank",
    "Caisse d'épargne",
    "Caja de Ahorros",
    "caixa econômica"
  ];
  List<String> dailyList = [
    "Daily Deposit",
    "Dépôt quotidien",
    "Depósito Diario",
    "Depósito diário"
  ];
  List<String> currentAccList = [
    "Current Account",
    "Compte courant",
    "Cuenta actuales",
    "Conta Correntes"
  ];
  List<String> rechargeList = [
    "Recharge",
    "Recharger",
    "Recargar",
    "Recarrega"
  ];
  List<String> dishList = [
    "Dish TV",
    "Télévision parabolique",
    "plato de televisión",
    "TV parabólica"
  ];
  List<String> electricityList = [
    "Electricity",
    "Électricité",
    "Electricidad",
    "Eletricidade"
  ];
  List<String> waterBillList = [
    "Water bill",
    "Facture d'eau",
    "Factura de agua",
    "Conta de água"
  ];
  List<String> shoppingList = ["Shopping", "Achats", "Compras", "Compras"];
  List<String> taxList = ["Taxes", "Impôts", "Impuestos", "impostos"];
  List<String> customPaymentList = [
    "Custom Duties",
    "Droits de douane",
    "Derechos de aduana",
    "Direitos Aduaneiros"
  ];
  List<String> schoolFeeList = [
    "School Fee",
    "Frais scolaires",
    "Cuotas escolares",
    "Taxa Escolar"
  ];
  List<String> hospitalBillList = [
    "Hospital Bills",
    "Factures d'hôpital",
    "Cuentas del hospital",
    "Contas Hospitalares"
  ];
  List<String> rechargePayBillsList = [
    "Recharge & Pay Bills",
    "Rechargez et payez vos factures",
    "Recargar y pagar facturas",
    "Recarregar e pagar contas"
  ];
  List<String> postpaidList = ["Postpaid", "Port payé", "pospago", "pós-pago"];
  List<String> postpaidRechargeList = [
    "Postpaid Recharge",
    "Recharge postpayée",
    "Recarga Pospago",
    "Recarga pós-paga"
  ];
  List<String> notActivatedList = [
    "Not Activated",
    "Non activé",
    "No activada",
    "Não ativado"
  ];
  List<String> mobileRechargeList = [
    "Mobile Recharge",
    "Recharge mobile",
    "Recarga Móvil",
    "Recarga de celular"
  ];
  List<String> waterList = ["Water", "Eau", "Agua", "Água"];
  List<String> cardsList = ["Cards", "Cartes", "Tarjetas", "cartões"];

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      userId = preferences?.getString(StaticValues.custID) ?? "";
      acc = preferences?.getString(StaticValues.accountNo) ?? "";
      ifsc = preferences?.getString(StaticValues.ifsc) ?? "";
      name = preferences?.getString(StaticValues.accName) ?? "";
      address = preferences?.getString(StaticValues.address) ?? "";
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
      print("userName");
      print(userId);
      print(acc);
      print(name);
      print(languageId);
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

/*  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async{
        if(state == AppLifecycleState.paused){
          _countdownTimer = Timer(Duration(seconds: 60), Duration(seconds: 1));
        }
        else if(state == AppLifecycleState.resumed){
          if(_countdownTimer.remaining > Duration(seconds: 0)){
            print("AppLifecycle State timer didnt compleate");
          }
          else{
            print("AppLifecycleState timeout");
          }
          _countdownTimer.cancel();
        }
  }*/

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      setState(() {
        print("In Active");
        Navigator.pop(context);
      });
    } else {
      print(state.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffFBF2F3),
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // Positioned(
          //   left: MediaQuery.of(context).size.width * 0.01,
          //   top: MediaQuery.of(context).size.width * 0.4,
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
          // Positioned(
          //   right: MediaQuery.of(context).size.width * 0.05,
          //   top: MediaQuery.of(context).size.width * 0.7,
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
          //   right: MediaQuery.of(context).size.width * 0.01,
          //   top: MediaQuery.of(context).size.width * 1,
          //   child: Container(
          //     height: MediaQuery.of(context).size.height * 0.25,
          //     width: MediaQuery.of(context).size.width * 0.25,
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
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                automaticallyImplyLeading: false,
                centerTitle: true,
                expandedHeight: MediaQuery.of(context).size.width * .40,
                pinned: false,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  stretchModes: [
                    StretchMode.fadeTitle,
                    StretchMode.blurBackground
                  ],
                  background: Stack(
                    children: <Widget>[
                      Positioned(
                        right: -15,
                        top: 10,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      Positioned(
                        // bottom: -30,
                        // right: 10,
                        top: -35,
                        right: 10,
                        child: Image.asset(
                          "assets/mini-logo.png",
                          width: 150,
                          height: 150,
                          // color: Colors.white10,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextView(
                                // "Hello,",
                                helloList[int.parse(languageId)],
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                size: 24.0,
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextView(
                                    name ?? "",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    size: 16,
                                  ),
                                  TextView(
                                    acc ?? "",
                                    color: Colors.white,
                                    size: 14.0,
                                  ),
                                  TextView(
                                    "MFI Code : $ifsc" ?? "",
                                    color: Colors.white,
                                    size: 14.0,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              ),
                              subtitle: Visibility(
                                visible: false,
                                child: TextView(
                                  address ?? "",
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                              trailing: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).secondaryHeaderColor,
                                backgroundImage:
                                    AssetImage("assets/people.png"),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///Bank Name change here
                      // Align(
                      //   alignment: Alignment.bottomLeft,
                      //   child: ListTile(
                      //     title: TextView(
                      //       StaticValues.titleDecoration.label.toUpperCase(),
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.bold,
                      //       size: 22,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      // color: Colors.white.withOpacity(0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    // "Banking",
                                    bankingList[int.parse(languageId)],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  // Color(0xffD62829),
                                  // Color(0xffE8696E)
                                  Theme.of(context).secondaryHeaderColor,
                                  Theme.of(context).secondaryHeaderColor,
                                  Colors.indigo[300],
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              color: Colors.green,
                            ),
                            height: 40,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          GridView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 50 / 70),
                            children: <Widget>[
                              GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    'assets/account.png',
                                    height: _iconSize,
                                    width: _iconSize,
                                    // color: Theme.of(context).accentColor,
                                    color: Colors.indigo,
                                  ),
                                  name: accList[int.parse(languageId)],
                                  // name: "Account",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccountMenus()))),
                              GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    'assets/passbook.png',
                                    height: _iconSize,
                                    width: _iconSize,
                                    // color: Theme.of(context).accentColor,
                                    color: Colors.indigo,
                                  ),
                                  name:
                                      miniStatementList[int.parse(languageId)],
                                  // name: "Mini Statement",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PassbookMenus()))),

                              widget.homePageConfiguration.search
                                  ? GlobalWidgets().btnWithText(
                                      icon: Image.asset(
                                        'assets/search.png',
                                        height: _iconSize,
                                        width: _iconSize,
                                        // color: Theme.of(context).accentColor,
                                        color: Colors.indigo,
                                      ),
                                      name: searchList[int.parse(languageId)],
                                      // name: "Search",
                                      textColor: Theme.of(context)
                                          .secondaryHeaderColor,
                                      //   onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchHome())),
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchHome())),
                                    )
                                  : SizedBox(),

                              ///Transfer
                              // Visibility(
                              //   visible: false,
                              //   child: GlobalWidgets().btnWithText(
                              //       icon: Image.asset(
                              //         'assets/fundTransfer.png',
                              //         height: _iconSize,
                              //         width: _iconSize,
                              //         color: Theme.of(context).accentColor,
                              //       ),
                              //       name: transferList[int.parse(languageId)],
                              //       // name: "Transfer",
                              //       //  onPressed: () => Navigator.of(context).pushNamed("/HomePage"),
                              //       onPressed: () {
                              //         Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     FundTransfer()));
                              //       }),
                              // ),

                              ///Add Account
                              // Visibility(
                              //   visible: false,
                              //   child: GlobalWidgets().btnWithText(
                              //       icon: Image.asset(
                              //         'assets/account_open.png',
                              //         height: _iconSize,
                              //         width: _iconSize,
                              //         color: Theme.of(context).accentColor,
                              //       ),
                              //       name: addAccList[int.parse(languageId)],
                              //       // name: "Add Account",
                              //       onPressed: () => Navigator.of(context).push(
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   AddAccountHome(
                              //                     // title: "Add Account",
                              //                     title: addAccList[
                              //                         int.parse(languageId)],
                              //                   )))
                              //       /* onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                              //           builder: (context) => KSEBNKWA(
                              //             title: "KWA",
                              //           )))*/
                              //       ),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Card(
                      // color: Colors.white.withOpacity(0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    // "Transfer",
                                    transferList[int.parse(languageId)],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  // Color(0xffD62829),
                                  // Color(0xffE8696E)
                                  Theme.of(context).secondaryHeaderColor,
                                  Theme.of(context).secondaryHeaderColor,
                                  Colors.indigo[300],
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              color: Colors.green,
                            ),
                            height: 40,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          GridView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 50 / 70),
                            children: <Widget>[
                              GlobalWidgets().btnWithText(
                                  icon: Icon(
                                    Icons.add,
                                    size: 30.0,
                                    // color: Theme.of(context).primaryColor,
                                    color: Colors.indigo,
                                  ),
                                  name:
                                      addBeneficiaryList[int.parse(languageId)],
                                  // name: "Add Beneficiary",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Beneficiary()))),
                              GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    "assets/ownBankTransfer.png",
                                    height: 30.0,
                                    width: 30.0,
                                    // color: Theme.of(context).primaryColor,
                                    color: Colors.indigo,
                                  ),
                                  name: ownAccList[int.parse(languageId)],
                                  // name: "Same Bank Transfer",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => OwnBankTransfer(
                                                transferType: "B",
                                              )))),
                              GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    'assets/fundTransfer.png',
                                    height: _iconSize,
                                    width: _iconSize,
                                    // color: Theme.of(context).accentColor,
                                    color: Colors.indigo,
                                  ),
                                  name: thirdPartyList[int.parse(languageId)],
                                  // name: "Third Party",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () {
                                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not Activated")));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(notActivatedList[
                                                int.parse(languageId)])));
                                  }
                                  // onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => FundTransfer()))
                                  /*onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => KSEBNKWA(
                                          title: "KSEB",
                                        )))*/
                                  ),

                              ///To Mobile No
                              // Visibility(
                              //   visible: false,
                              //   child: GlobalWidgets().btnWithText(
                              //       icon: Image.asset(
                              //         'assets/smartphone.png',
                              //         height: _iconSize,
                              //         width: _iconSize,
                              //         color: Theme.of(context).accentColor,
                              //       ),
                              //       name: toMobList[int.parse(languageId)],
                              //       // name: "To Mobile No",
                              //       onPressed: () => Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) => OwnBankTransfer(
                              //                     transferType: "M",
                              //                   )))
                              //       /*onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                              //           builder: (context) => KSEBNKWA(
                              //             title: "KSEB",
                              //           )))*/
                              //       ),
                              // ),

                              ///Virtual Id
                              // Visibility(
                              //   visible: false,
                              //   child: GlobalWidgets().btnWithText(
                              //       icon: Image.asset(
                              //         'assets/mobile_phone.png',
                              //         height: _iconSize,
                              //         width: _iconSize,
                              //         color: Theme.of(context).accentColor,
                              //       ),
                              //       name: virtualIdList[int.parse(languageId)],
                              //       // name: "Virtual Id",
                              //       onPressed: () => Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) => OwnBankTransfer(
                              //                     transferType: "V",
                              //                   )))
                              //       /*onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                              //           builder: (context) => KSEBNKWA(
                              //             title: "KSEB",
                              //           )))*/
                              //       ),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Card(
                      // color: Colors.white.withOpacity(0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    // "Account Opening",
                                    accOpeningList[int.parse(languageId)],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  // Color(0xffD62829),
                                  // Color(0xffE8696E)
                                  Theme.of(context).secondaryHeaderColor,
                                  Theme.of(context).secondaryHeaderColor,
                                  Colors.indigo[300],
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              color: Colors.green,
                            ),
                            height: 40,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          GridView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 50 / 70),
                            children: <Widget>[
                              GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    'assets/fd2.png',
                                    height: _iconSize,
                                    width: _iconSize,
                                    // color: Theme.of(context).accentColor,
                                    color: Colors.indigo,
                                  ),
                                  name: fdList[int.parse(languageId)],
                                  // name: "Fixed Deposit",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccountOpenHome("FD")))),
                              Visibility(
                                visible: true,
                                child: GlobalWidgets().btnWithText(
                                    icon: Image.asset(
                                      'assets/rd.png',
                                      height: _iconSize,
                                      width: _iconSize,
                                      // color: Theme.of(context).accentColor,
                                      color: Colors.indigo,
                                    ),
                                    name: currentAccList[int.parse(languageId)],
                                    // name: "Current Account",
                                    textColor:
                                        Theme.of(context).secondaryHeaderColor,
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AccountOpenHome("CA")))),
                              ),

                              ///Savings Bank
                              // Visibility(
                              //   visible: false,
                              //   child: GlobalWidgets().btnWithText(
                              //       icon: Image.asset(
                              //         'assets/credit-card.png',
                              //         height: _iconSize,
                              //         width: _iconSize,
                              //         color: Theme.of(context).accentColor,
                              //       ),
                              //       name: savingsBankList[int.parse(languageId)],
                              //       // name: "Savings Bank",
                              //       onPressed: () => Navigator.of(context).push(
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   AccountOpenHome("SB")))),
                              // ),

                              ///Daily Deposit
                              // Visibility(
                              //   visible: false,
                              //   child: GlobalWidgets().btnWithText(
                              //       icon: Image.asset(
                              //         'assets/bank_check.png',
                              //         height: _iconSize,
                              //         width: _iconSize,
                              //         color: Theme.of(context).accentColor,
                              //       ),
                              //       name: dailyList[int.parse(languageId)],
                              //       // name:"Daily Deposit",
                              //       onPressed: () => Navigator.of(context).push(
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   AccountOpenHome("DD")))),
                              // ),

                              ///Unnati
                              // Visibility(
                              //   visible: false,
                              //   child: GlobalWidgets().btnWithText(
                              //       icon: Image.asset(
                              //         'assets/credit-card.png',
                              //         height: _iconSize,
                              //         width: _iconSize,
                              //         color: Theme.of(context).accentColor,
                              //       ),
                              //       name: "UNNATI",
                              //       onPressed: () => Navigator.of(context).push(
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   AccountOpenHome("UNNATI")))),
                              // ),

                              ///MIS
                              // Visibility(
                              //   visible: false,
                              //   child: Visibility(
                              //     visible:
                              //         widget.homePageConfiguration.shoppingOption,
                              //     child: GlobalWidgets().btnWithText(
                              //         icon: Image.asset(
                              //           'assets/mis.png',
                              //           height: _iconSize,
                              //           width: _iconSize,
                              //           color: Theme.of(context).accentColor,
                              //         ),
                              //         name: "MIS",
                              //         onPressed: () {
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       AccountOpenHome("MIS")));
                              //         }),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Card(
                      // color: Colors.white.withOpacity(0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    // "Utility Payments",
                                    utilPaymentList[int.parse(languageId)],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  // Color(0xffD62829),
                                  // Color(0xffE8696E)
                                  Theme.of(context).secondaryHeaderColor,
                                  Theme.of(context).secondaryHeaderColor,
                                  Colors.indigo[300],
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              color: Colors.green,
                            ),
                            height: 40,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          GridView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 50 / 70),
                            children: <Widget>[
                              GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    'assets/smartphone.png',
                                    height: _iconSize,
                                    width: _iconSize,
                                    // color: Theme.of(context).accentColor,
                                    color: Colors.indigo,
                                  ),
                                  name: rechargeList[int.parse(languageId)],
                                  // name: "Recharge",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => Recharge(
                                                // title: "Mobile Recharge",
                                                title: mobileRechargeList[
                                                    int.parse(languageId)],
                                              )))),
                              /*  GlobalWidgets().btnWithText(
                                    icon: Image.asset(
                                      'assets/mobile_card.png',
                                      height: _iconSize,
                                      width: _iconSize,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    name: "Postpaid",
                                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => Recharge(
                                          title: "Postpaid Recharge",
                                        )))),*/
                              GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    'assets/dishTv.png',
                                    height: _iconSize,
                                    width: _iconSize,
                                    // color: Theme.of(context).accentColor,
                                    color: Colors.indigo,
                                  ),
                                  name: dishList[int.parse(languageId)],
                                  // name: "Dish TV",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => Recharge(
                                                // title: "DTH Recharge",
                                                title:
                                                    "DTH ${rechargeList[int.parse(languageId)]}",
                                              )))),
                              GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    'assets/electricity.png',
                                    height: _iconSize,
                                    width: _iconSize,
                                    // color: Theme.of(context).accentColor,
                                    color: Colors.indigo,
                                  ),
                                  name: electricityList[int.parse(languageId)],
                                  // name: "Electricity",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => Recharge(
                                                // title: "Electricity",
                                                title: electricityList[
                                                    int.parse(languageId)],
                                              )))
                                  /*onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => KSEBNKWA(
                                          title: "KSEB",
                                        )))*/
                                  ),
                              GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    'assets/water.png',
                                    height: _iconSize,
                                    width: _iconSize,
                                    // color: Theme.of(context).accentColor,
                                    color: Colors.indigo,
                                  ),
                                  name: waterBillList[int.parse(languageId)],
                                  // name: "Water bill",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => Recharge(
                                                // title: "Water",
                                                title: waterList[
                                                    int.parse(languageId)],
                                              )))
                                  /* onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => KSEBNKWA(
                                          title: "KWA",
                                        )))*/
                                  ),
                              Visibility(
                                visible:
                                    widget.homePageConfiguration.shoppingOption,
                                child: GlobalWidgets().btnWithText(
                                    icon: Image.asset(
                                      'assets/shopping.png',
                                      height: _iconSize,
                                      width: _iconSize,
                                      // color: Theme.of(context).accentColor,
                                      color: Colors.indigo,
                                    ),
                                    name: shoppingList[int.parse(languageId)],
                                    // name: "Shopping",
                                    textColor:
                                        Theme.of(context).secondaryHeaderColor,
                                    onPressed: () {
                                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not Activated")));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(notActivatedList[
                                                  int.parse(languageId)])));
                                    }
                                    /* onPressed: () => GlobalWidgets().shoppingPay(
                                        widget.scaffoldKey.currentContext,
                                        setState,
                                        widget.scaffoldKey,
                                        acc,
                                      )*/
                                    ),
                              ),
                              Visibility(
                                visible: false,
                                child: GlobalWidgets().btnWithText(
                                    icon: Image.asset(
                                      'assets/officer.png',
                                      height: _iconSize,
                                      width: _iconSize,
                                      // color: Theme.of(context).accentColor,
                                      color: Colors.indigo,
                                    ),
                                    name: govPaymentList[int.parse(languageId)],
                                    // name: "Govt Payments",
                                    textColor:
                                        Theme.of(context).secondaryHeaderColor,
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text("data")));
                                    }
                                    /*onPressed: () => selectedAccNo == ""?ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Select Account"))):Navigator.of(context).push(MaterialPageRoute(
                                        // builder: (context) => AccountOpenHome("FD")))),

                                          builder: (context) =>  AccountOpening(selectedAccNo,selectedAccBalance,"FD")))*/
                                    ),
                              ),
                              Visibility(
                                visible: false,
                                child: GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    'assets/taxes.png',
                                    height: _iconSize,
                                    width: _iconSize,
                                    // color: Theme.of(context).accentColor,
                                    color: Colors.indigo,
                                  ),
                                  name: taxList[int.parse(languageId)],
                                  // name: "Tax",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  /*onPressed: () =>  selectedAccNo == ""?ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Select Account"))):Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => AccountOpening(selectedAccNo,selectedAccBalance,"RD")))*/
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Card(
                      // color: Colors.white.withOpacity(0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    govPaymentList[int.parse(languageId)],
                                    // "Government Payments",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  // Color(0xffD62829),
                                  // Color(0xffE8696E)
                                  Theme.of(context).secondaryHeaderColor,
                                  Theme.of(context).secondaryHeaderColor,
                                  Colors.indigo[300],
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              color: Colors.green,
                            ),
                            height: 40,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          GridView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 50 / 70),
                            children: <Widget>[
                              GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/taxes.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: taxList[int.parse(languageId)],
                                // name: "Taxes",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () =>
                                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not Activated")))
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(notActivatedList[
                                                int.parse(languageId)]))),
                              ),
                              GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/officer.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: customPaymentList[int.parse(languageId)],
                                // name: "Custom Duties",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () =>
                                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not Activated")))
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(notActivatedList[
                                                int.parse(languageId)]))),
                              ),
                              GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/school.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: schoolFeeList[int.parse(languageId)],
                                // name: "School Fee",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () =>
                                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not Activated")))
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(notActivatedList[
                                                int.parse(languageId)]))),
                              ),
                              Visibility(
                                visible: true,
                                child: GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    'assets/hospital.png',
                                    height: _iconSize,
                                    width: _iconSize,
                                    // color: Theme.of(context).accentColor,
                                    color: Colors.indigo,
                                  ),
                                  name: hospitalBillList[int.parse(languageId)],
                                  // name: "Hospital Bills",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () =>
                                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not Activated"))),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(notActivatedList[
                                                  int.parse(languageId)]))),
                                ),
                              ),
                              Visibility(
                                visible: true,
                                child: Visibility(
                                  visible: widget
                                      .homePageConfiguration.shoppingOption,
                                  child: GlobalWidgets().btnWithText(
                                      icon: Image.asset(
                                        'assets/employee-2.png',
                                        height: _iconSize,
                                        width: _iconSize,
                                        // color: Theme.of(context).accentColor,
                                        color: Colors.indigo,
                                      ),
                                      name: "CNPS/NSIF",
                                      textColor: Theme.of(context)
                                          .secondaryHeaderColor,
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(notActivatedList[
                                                    int.parse(languageId)])));
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not Activated")));
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    // visible: widget.homePageConfiguration.rechargeOption,
                    visible: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextView(
                            // "Cards",
                            cardsList[int.parse(languageId)],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GridView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 50 / 70),
                          children: <Widget>[
                            GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/credit_card.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: cardTopupList[int.parse(languageId)],
                                // name: "Card Topup",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => CardTopup()))),
                            GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/credit_card2.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: cardHistoryList[int.parse(languageId)],
                                // name: "Card History",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CardStatement()))),
                            GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/credit_card3.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: newPinList[int.parse(languageId)],
                                // name: "New Pin",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => CardReset()))
                                /*onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => KSEBNKWA(
                                        title: "KSEB",
                                      )))*/
                                ),
                            GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/credit_block.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: cardBlockList[int.parse(languageId)],
                                // name: "Card Block",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => CardBlock()))
                                /*onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => KSEBNKWA(
                                        title: "KSEB",
                                      )))*/
                                ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    //  visible: widget.homePageConfiguration.rechargeOption,
                    visible: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextView(
                            rechargePayBillsList[int.parse(languageId)],
                            // "Recharge & Pay Bills",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GridView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 50 / 70),
                          children: <Widget>[
                            GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/smartphone.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: rechargeList[int.parse(languageId)],
                                // name: "Recharge",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => Recharge(
                                              // title: "Mobile Recharge",
                                              title: mobileRechargeList[
                                                  int.parse(languageId)],
                                            )))),
                            GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/mobile_card.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: postpaidList[int.parse(languageId)],
                                // name: "Postpaid",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => Recharge(
                                              // title: "Postpaid Recharge",
                                              title: postpaidRechargeList[
                                                  int.parse(languageId)],
                                            )))),
                            GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/dishTv.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: "DTH",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => Recharge(
                                              // title: "DTH Recharge",
                                              title:
                                                  "DTH ${rechargeList[int.parse(languageId)]}",
                                            )))),
                            GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/electricity.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: electricityList[int.parse(languageId)],
                                // name: "Electricity",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => Recharge(
                                              // title: "Electricity",
                                              title: electricityList[
                                                  int.parse(languageId)],
                                            )))
                                /*onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => KSEBNKWA(
                                        title: "KSEB",
                                      )))*/
                                ),
                            GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/water.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: waterList[int.parse(languageId)],
                                // name: "Water",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => Recharge(
                                              // title: "Water",
                                              title: waterList[
                                                  int.parse(languageId)],
                                            )))
                                /* onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => KSEBNKWA(
                                        title: "KWA",
                                      )))*/
                                ),
                            Visibility(
                              visible:
                                  widget.homePageConfiguration.shoppingOption,
                              child: GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    'assets/shopping.png',
                                    height: _iconSize,
                                    width: _iconSize,
                                    // color: Theme.of(context).accentColor,
                                    color: Colors.indigo,
                                  ),
                                  name: shoppingList[int.parse(languageId)],
                                  // name: "Shopping",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () => GlobalWidgets().shoppingPay(
                                        widget.scaffoldKey.currentContext,
                                        setState,
                                        widget.scaffoldKey,
                                        acc,
                                      )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    // visible: widget.homePageConfiguration.rechargeOption,
                    visible: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextView(
                            accOpeningList[int.parse(languageId)],
                            // "Account Opening",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GridView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 50 / 70),
                          children: <Widget>[
                            GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/fd2.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: "FD",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AccountOpenHome("FD")))),
                            GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/rd.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: "RD",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AccountOpenHome("RD")))),
                            GlobalWidgets().btnWithText(
                                icon: Image.asset(
                                  'assets/bank_check.png',
                                  height: _iconSize,
                                  width: _iconSize,
                                  // color: Theme.of(context).accentColor,
                                  color: Colors.indigo,
                                ),
                                name: "DD",
                                textColor:
                                    Theme.of(context).secondaryHeaderColor,
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AccountOpenHome("DD")))),
                            Visibility(
                              visible: false,
                              child: GlobalWidgets().btnWithText(
                                  icon: Image.asset(
                                    'assets/credit-card.png',
                                    height: _iconSize,
                                    width: _iconSize,
                                    //color: Theme.of(context).accentColor,
                                    color: Colors.indigo,
                                  ),
                                  name: "UNNATI",
                                  textColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccountOpenHome("UNNATI")))),
                            ),
                            Visibility(
                              visible: false,
                              child: Visibility(
                                visible:
                                    widget.homePageConfiguration.shoppingOption,
                                child: GlobalWidgets().btnWithText(
                                    icon: Image.asset(
                                      'assets/mis.png',
                                      height: _iconSize,
                                      width: _iconSize,
                                      // color: Theme.of(context).accentColor,
                                      color: Colors.indigo,
                                    ),
                                    name: "MIS",
                                    textColor:
                                        Theme.of(context).secondaryHeaderColor,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountOpenHome("MIS")));
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  /*     Align(
                      alignment: Alignment.bottomCenter,
                      child: Opacity(
                        opacity: .5,
                        child: Image.asset(
                          "assets/safesoftware_logo.png",
                          width: 100,
                        ),
                      ),
                    ),*/
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
