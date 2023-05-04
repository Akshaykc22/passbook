import 'package:flutter/material.dart';
import 'package:passbook_core/Passbook/ChittyTransaction.dart';
import 'package:passbook_core/Passbook/LoanTransaction.dart';
import 'package:passbook_core/Passbook/Model/PassbookListModel.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../REST/RestAPI.dart';

class ChittyLoan extends StatefulWidget {
  ///if [type] is null it will show loan details. if it is "MMBS" it show chitty details.
  final String type;

  ///if [isAccount] is true it will not show view details button.
  final bool isAccount;

  const ChittyLoan({Key key, this.type, this.isAccount = true})
      : super(key: key);

  @override
  _ChittyLoanState createState() => _ChittyLoanState();
}

class _ChittyLoanState extends State<ChittyLoan> {
  SharedPreferences preferences;
  var languageId = "";
  bool isShare;

  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> balList = ["Balance", "équilibre", "balance", "Equilíbrio"];
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
  List<String> typeList = ["Type", "Taper", "Tipo", "Tipo"];
  List<String> accBranchList = [
    "Account Branch",
    "Succursale du compte",
    "Sucursal de cuenta",
    "Filial da conta"
  ];
  List<String> accList = ["Account", "Compte", "Cuenta", "Conta"];
  List<String> viewDetailsList = [
    "View Details",
    "Voir les détails",
    "Ver detalles",
    "Ver detalhes"
  ];
  List<String> depositList = ["Deposit", "Dépôt", "Depósito", "Depósito"];
  List<String> loanList = ["Loan", "prêter", "Préstamo", "empréstimo"];
  List<String> shareList = ["Share", "Partager", "Cuota", "Compartilhar"];
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

  Future<List<PassbookTable>> getChittyShare() async {
    SharedPreferences pref = StaticValues.sharedPreferences;
    Map res = await RestAPI().get(
        "${APis.otherAccListInfo}${pref.getString(StaticValues.custID)}&Acc_Type=${widget.type ?? "LN"}");
    PassbookListModel _transactionModel = PassbookListModel.fromJson(res);
    return _transactionModel.table;
  }

  static const double spaceBetween = 3.0;

  Widget accountDetailWidget(PassbookTable passbookTable) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FractionColumnWidth(.40),
                1: FractionColumnWidth(.10),
                2: FractionColumnWidth(.50)
              },
              children: <TableRow>[
                TableRow(children: <Widget>[
                  TableCell(
                    ///To give a space between each row
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: spaceBetween),
                      child: TextView(
                        // "Balance ${StaticValues.rupeeSymbol}",
                        "${balList[int.parse(languageId)]} ${StaticValues.rupeeSymbol}",
                        size: 12.0,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ),
                  TableCell(child: TextView(":")),
                  TableCell(
                    child: TextView(
                      "${passbookTable.balance.toStringAsFixed(2)}",
                      size: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
                TableRow(children: <Widget>[
                  TableCell(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: spaceBetween),
                      child: TextView(
                        // "Account Number",
                        accNoList[int.parse(languageId)],
                        size: 12.0,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ),
                  TableCell(child: TextView(":")),
                  TableCell(
                      child: TextView(
                    "${passbookTable.accNo}",
                    size: 12.0,
                  )),
                ]),
                TableRow(children: <Widget>[
                  TableCell(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: spaceBetween),
                      child: TextView(
                        // isShare == null ? "Loan" : isShare ? "Share Type" : "Chitty Type",
                        isShare == null
                            ? loanList[int.parse(languageId)]
                            : isShare
                                ? shareTypeList[int.parse(languageId)]
                                : "Chitty ${typeList[int.parse(languageId)]}",
                        size: 12.0,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ),
                  TableCell(child: TextView(":")),
                  TableCell(
                      child: TextView(
                    "${passbookTable.schName}",
                    size: 12.0,
                  )),
                ]),
                TableRow(children: <Widget>[
                  TableCell(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: spaceBetween),
                      child: TextView(
                        // "Account Branch",
                        accBranchList[int.parse(languageId)],
                        size: 12.0,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ),
                  TableCell(child: TextView(":")),
                  TableCell(
                      child: TextView(
                    "${passbookTable.depBranch}",
                    size: 12.0,
                  )),
                ]),
              ],
            ),
            Visibility(
              visible: !widget.isAccount,
              child: InkWell(
                borderRadius: BorderRadius.circular(100.0),
                splashColor: Theme.of(context).primaryColor,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => isShare == null
                        ? LoanTransaction(
                            accNo: passbookTable.accNo,
                          )
                        : ChittyTransaction(
                            accNo: passbookTable.accNo,
                          ))),
                child: Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0)),
                  color: Theme.of(context).secondaryHeaderColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextView(
                      // "view details",
                      viewDetailsList[int.parse(languageId)],
                      size: 12.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
    });
  }

  @override
  void initState() {
    loadData();
    isShare = widget.type == null ? null : widget.type.toLowerCase() == "sh";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        centerTitle: true,
        title: Text(
          // isShare == null ? "Loan" : isShare ? "Share" : "Chitty",
          isShare == null
              ? loanList[int.parse(languageId)]
              : isShare
                  ? shareList[int.parse(languageId)]
                  : "Chitty",
        ),
      ),
      body: FutureBuilder<List<PassbookTable>>(
        future: getChittyShare(),
        builder: (context, snapshot) {
          print("LJT : ${snapshot.data.toString()}");
          if (!snapshot.hasData) {
            return Stack(
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            );
          } else {
            if (snapshot.data.length > 0)
              return SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextView(
                                // "lijith",
                                snapshot.data[0].custName,
                                size: 16.0,
                              ),
                              Text(
                                snapshot.data[0].address.split(",").join(","),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            snapshot.data[0].brName,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return accountDetailWidget(snapshot.data[index]);
                            }),
                      ],
                    ),
                  ),
                ),
              );
            else
              return Stack(
                children: [
                  Center(
                    // child: TextView("You don't have a ${widget.type==null?'loan':'chitty'} in this bank"),
                    child: TextView(
                        "${youDontHaveAList[int.parse(languageId)]} ${widget.type == null ? loanList[int.parse(languageId)] : 'chitty'} ${inThisBankList[int.parse(languageId)]}"),
                  )
                ],
              );
          }
        },
      ),
    );
  }
}
