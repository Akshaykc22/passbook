import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AccNoModel.dart';
import 'DepositSearchModel.dart';

class AccountSearch extends StatefulWidget {
  final String accType;

  AccountSearch(this.accType) : super();

  @override
  _AccountSearchState createState() => _AccountSearchState();
}

class _AccountSearchState extends State<AccountSearch> {
  var languageId = "";
  SharedPreferences preferences;
  var _fruits = <AccTable>[];
  var _selectedAccNo;
  String str_accNo;
  String str_accType;
  List<AccTable> accTable = List();
  String _mySelection;
  bool _isAccNo = false;
  bool _isAccSearch = false;
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  List<DepositTable> depositTable = List();
  String userId, schemeCode1, branchCode1;
  String url =
      "http://perumannascb.safeandsmartbank.com:6550/Api/Values/get_DepositSearch?Cust_id=31125&Acc_no=0020070001785&Sch_code=007&Br_code=2&Frm_Date=2020-05-14&Todate=2020-11-05";

  var _forkKey = GlobalKey<FormState>();

  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> searchList = ["Search", "Recherche", "Buscar", "Procurar"];
  List<String> searchHomeList = [
    "Search Home",
    "Rechercher Accueil",
    "Buscar Inicio",
    "Pesquisar na página inicial"
  ];
  List<String> selectDateList = [
    "Select Date",
    "Sélectionner une date",
    "Seleccione fecha",
    "Selecione a data"
  ];
  List<String> fromDateList = [
    "From Date",
    "Partir de la date",
    "Partir de la fecha",
    "Da data"
  ];
  List<String> toDateList = [
    "To Date",
    "À ce jour",
    "Hasta la fecha",
    "A data"
  ];
  List<String> fetchDataList = [
    "Fetch Data",
    "Récupérer des données",
    "Obtener datos",
    "Obter dados"
  ];
  List<String> balList = ["Balance", "équilibre", "balance", "Equilíbrio"];
  List<String> typeList = ["Type", "Taper", "Tipo", "Tipo"];
  List<String> accList = ["Account", "Compte", "Cuenta", "Conta"];
  List<String> depositList = ["Deposit", "Dépôt", "Depósito", "Depósito"];
  List<String> loanList = ["Loan", "prêter", "Préstamo", "empréstimo"];
  List<String> shareList = ["Share", "Partager", "Cuota", "Compartilhar"];
  List<String> accNoList = [
    "Account Number",
    "numéro de compte",
    "número de cuenta",
    "número da conta"
  ];
  List<String> shareTypeList = [
    "Share Type",
    "Type de partage",
    "Tipo de recurso compartido",
    "Tipo de compartilhamento"
  ];
  List<String> accBranchList = [
    "Account Branch",
    "Succursale du compte",
    "Sucursal de cuenta",
    "Filial da conta"
  ];
  List<String> viewDetailsList = [
    "View Details",
    "Voir les détails",
    "Ver detalles",
    "Ver detalhes"
  ];
  List<String> passbookList = [
    "Passbook",
    "Livret",
    "Libreta de depósitos",
    "caderneta"
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
    // TODO: implement initState
    loadData();
    super.initState();

    // getSerchList();

    if (widget.accType == "Account") {
      str_accType = "DP";
    } else if (widget.accType == "Loan") {
      str_accType = "LN";
    }

    getAccDeposit();
  }

  Future<void> getAccDeposit() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      _isAccNo = true;
      userId = preferences?.getString(StaticValues.custID) ?? "";
      schemeCode1 = preferences?.getString(StaticValues.schemeCode) ?? "";
      branchCode1 = preferences?.getString(StaticValues.branchCode) ?? "";
    });
    var response = await RestAPI().get(
        APis.getAccNoDeposit({"Cust_id": userId, "Acc_Type": str_accType}));
    GetAccNo _getAccNo = GetAccNo.fromJson(response);

    accTable = _getAccNo.accTable;

    setState(() {
      _isAccNo = false;
    });
    return;
  }

/*  Future<void> getSerchList() async{

    var response = await RestAPI().get(url);
    DepositSearchModel _depositList = DepositSearchModel.fromJson(response);


    print("Lijith: $depositTable");

    setState(() {
      depositTable = _depositList.depositTable;
    });
    return;
  }*/

  void _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedFromDate)
      setState(() {
        selectedFromDate = picked;

        fromDateController.text =
            DateFormat("yyyy-MM-dd").format(selectedFromDate);
      });
  }

  void _selectedToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedToDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedToDate)
      setState(() {
        selectedToDate = picked;

        toDateController.text = DateFormat("yyyy-MM-dd").format(selectedToDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Form(
          key: _forkKey,
          // child: Text("${widget.accType} Search"),
          child: Text("${widget.accType} ${searchList[int.parse(languageId)]}"),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 40.0,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).secondaryHeaderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: _isAccNo
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButton(
                        // hint: Text("Account No"),
                        hint: Text(
                          accNoList[int.parse(languageId)],
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                        value: _mySelection,
                        items: accTable.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(
                              item.accNo,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            value: item.accNo,
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _mySelection = newVal;
                          });
                        },
                      ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectFromDate(context);
                    },
                    child: Container(
                      height: 40.0,
                      child: TextFormField(
                        enabled: false,
                        controller: fromDateController,
                        validator: (value) {
                          if (value.isEmpty) {
                            // return "Select Date";
                            return selectDateList[int.parse(languageId)];
                          } else {
                            return null;
                          }
                        },
                        // decoration: InputDecoration(labelText: "From Date",
                        decoration: InputDecoration(
                            labelText: fromDateList[int.parse(languageId)],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectedToDate(context);
                    },
                    child: Container(
                      height: 40.0,
                      child: TextFormField(
                        enabled: false,
                        controller: toDateController,
                        validator: (value) {
                          if (value.isEmpty) {
                            // return "Select Date";
                            return selectDateList[int.parse(languageId)];
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            // labelText: "To Date",
                            labelText: toDateList[int.parse(languageId)],
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            Container(
              height: 40.0,
              child: RaisedButton(
                onPressed: () async {
                  if (_forkKey.currentState.validate()) {
                    _isAccSearch = true;
                    // var response = await RestAPI().get(url);
                    var response =
                        await RestAPI().get(APis.getDepositTransactionList({
                      "Cust_id": userId,
                      "Acc_no": _mySelection,
                      "Sch_code": schemeCode1,
                      "Br_code": branchCode1,
                      "Frm_Date": fromDateController.text,
                      "Todate": toDateController.text
                    }));
                    DepositSearchModel _depositList =
                        DepositSearchModel.fromJson(response);

                    print("Lijith: $depositTable");

                    setState(() {
                      depositTable = _depositList.depositTable;
                      _isAccSearch = false;
                    });
                    return;
                  }

                  // getSerchList();
                },
                /* onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StatementDownload()));
                },*/
                child: _isAccSearch
                    ? CircularProgressIndicator()
                    : Text(
                        // "Fetch Data",
                        fetchDataList[int.parse(languageId)],
                        style: TextStyle(color: Colors.white),
                      ),
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: depositTable.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String s = depositTable[index].trDate.toString().substring(
                        0, depositTable[index].trDate.toString().indexOf(' '));
                    return Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //   Text(depositTable[index].trDate.toString()),
                            Text(s),
                            Text(
                              depositTable[index].amount.toString(),
                              style: TextStyle(
                                  color:
                                      depositTable[index].tranType.toString() ==
                                              "C"
                                          ? Colors.red
                                          : Colors.green),
                            ),
                            Text(depositTable[index].tranBalance.toString()),
                          ],
                        ),
                        subtitle: Text(depositTable[index].narration),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
