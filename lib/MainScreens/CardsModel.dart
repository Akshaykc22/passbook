import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passbook_core/Account/Model/AccountsDepositModel.dart';
import 'package:passbook_core/Account/Model/AccountsLoanModel.dart';
import 'package:passbook_core/Passbook/Model/PassbookListModel.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

double _height = 200.0;

BoxDecoration _boxDecoration(
        {@required BuildContext context, bool shadowDisabled = false}) =>
    BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.5, 0.9],
          colors: [
            // Theme.of(context).primaryColor,
            // Theme.of(context).accentColor,
            Theme.of(context).secondaryHeaderColor,
            Theme.of(context).disabledColor,
          ],
        ),
        boxShadow: shadowDisabled
            ? null
            : [
                BoxShadow(
                    color: Colors.black45,
                    offset: Offset(1.5, 1.5), //(x,y)
                    blurRadius: 5.0,
                    spreadRadius: 2.0),
              ]);

class DepositCardModel extends StatefulWidget {
  final AccountsDepositTable accountsDeposit;
  final Function onPressed;

  const DepositCardModel({Key key, this.accountsDeposit, this.onPressed})
      : super(key: key);

  @override
  _DepositCardModelState createState() => _DepositCardModelState();
}

class _DepositCardModelState extends State<DepositCardModel> {
  SharedPreferences preferences;
  var languageId = "";
  // En, Fr, Es, Pr
  List<String> nomineeList = ["Nominee", "candidat", "candidato", "candidato"];
  List<String> maturityDateList = [
    "Maturity Date",
    "Date d'échéance",
    "Fecha de vencimiento",
    "Data de Vencimento"
  ];
  List<String> dueDateList = [
    "Due Date",
    "Date d'échéance",
    "Fecha de vencimiento",
    "Data de vencimento"
  ];
  // List<String> List = ["","","",""];

  void loadData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: widget.onPressed,
      child: Container(
        height: _height,
        padding: EdgeInsets.all(10.0),
        decoration: _boxDecoration(
            context: context, shadowDisabled: widget.onPressed == null),
        child: Stack(
          children: [
            Column(
              children: [
                languageId == ""
                    ? SizedBox()
                    : TextView(
                        widget.accountsDeposit.accType,
                        size: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                SizedBox(
                  height: 5.0,
                ),
                languageId == ""
                    ? SizedBox()
                    : TextView(
                        widget.accountsDeposit.accBranch,
                        size: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
              ],
            ),
            Align(
                alignment: Alignment.centerRight,
                child: languageId == ""
                    ? SizedBox()
                    : TextView(
                        //  accountsDeposit.accNo.replaceAllMapped(RegExp(r".{5}"), (match) => "${match.group(0)} "),
                        widget.accountsDeposit.accNo,
                        size: 22,
                        color: Colors.white54,
                      )),
            Align(
              alignment: Alignment.bottomRight,
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      "${StaticValues.rupeeSymbol}${widget.accountsDeposit.balance.toStringAsFixed(2)}",
                      color: Colors.white,
                      size: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        languageId == ""
                            ? SizedBox()
                            : TextView(
                                // "Nominee",
                                nomineeList[int.tryParse(languageId)],
                                textAlign: TextAlign.center,
                                color: Colors.white,
                              ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextView(
                          widget.accountsDeposit.nominee,
                          textAlign: TextAlign.center,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        languageId == ""
                            ? SizedBox()
                            : TextView(
                                // "Maturity Date",
                                maturityDateList[int.tryParse(languageId)],
                                textAlign: TextAlign.center,
                                color: Colors.white,
                              ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextView(
                          widget.accountsDeposit.dueDate,
                          textAlign: TextAlign.center,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoanCardModel extends StatefulWidget {
  final AccountsLoanTable accountsLoanTable;
  final Function onPressed;

  const LoanCardModel({Key key, this.accountsLoanTable, this.onPressed})
      : super(key: key);

  @override
  _LoanCardModelState createState() => _LoanCardModelState();

  static const double spaceBetween = 3.0;
  static const double keySize = 10.0;
  static const double valueSize = 11.0;
}

class _LoanCardModelState extends State<LoanCardModel> {
  List<String> getDate(DateTime createdAt) {
    String s = formatDate(createdAt, [M, '\n', dd, '\n', yyyy]).toString();
    var sp = s.split("\n");
    print("SP:: $sp");
    return sp;
  }

  SharedPreferences preferences;
  var languageId = "";

  List<String> nomineeList = ["Nominee", "candidat", "candidato", "candidato"];
  List<String> maturityDateList = [
    "Maturity Date",
    "Date d'échéance",
    "Fecha de vencimiento",
    "Data de Vencimento"
  ];
  List<String> dueDateList = [
    "Due Date",
    "Date d'échéance",
    "Fecha de vencimiento",
    "Data de vencimento"
  ];
  List<String> balList = ["Balance", "équilibre", "balance", "Equilíbrio"];
  List<String> overdueAmountList = [
    "Overdue Amount",
    "montant en retard",
    "importes vencidos",
    "valor em atraso"
  ];
  List<String> overdueInterestList = [
    "Overdue Interest",
    "Intérêt en retard",
    "intereses vencidos",
    "Juros vencidos"
  ];
  List<String> interestList = ["Interest", "Intérêt", "Interés", "Interesse"];
  List<String> loanIDList = [
    "Loan ID",
    "ID de prêt",
    "identificación de préstamo",
    "ID do empréstimo"
  ];
  List<String> loanTypeList = [
    "Loan Type",
    "type de prêt",
    "tipo de préstamo",
    "tipo de empréstimo"
  ];
  List<String> loanBranchList = [
    "Loan Branch",
    "succursale de prêt",
    "sucursal de préstamo",
    "ramo de empréstimo"
  ];
  List<String> suretyList = ["Surety", "caution", "garantía", "fiador"];
  // List<String> List = ["","","",""];
  // List<String> List = ["","","",""];
  // List<String> List = ["","","",""];

  void loadData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _dateSplit = getDate(
      DateFormat().add_yMd().parse(widget.accountsLoanTable.dueDate),
    );
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: widget.onPressed,
      child: Container(
        height: _height,
        padding: EdgeInsets.all(10.0),
        decoration: _boxDecoration(
            context: context, shadowDisabled: widget.onPressed == null),
        child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            columnWidths: {
              0: FractionColumnWidth(.75),
              1: FractionColumnWidth(.25),
            },
            children: [
              TableRow(children: [
                loanDetailWidget(widget.accountsLoanTable),
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 5.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border:
                                Border.all(width: 1.0, color: Colors.white)),
                        child: CustomText(
                          children: [
                            TextSpan(
                              text: "${_dateSplit[0]}\n",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                            TextSpan(
                              text: "${_dateSplit[1]}\n",
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            TextSpan(
                              text: "${_dateSplit[2]}",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            color: Theme.of(context).primaryColor,
                            child: languageId == ""
                                ? SizedBox()
                                : TextView(
                                    // "Due Date",
                                    dueDateList[int.tryParse(languageId)],
                                    size: LoanCardModel.keySize,
                                    color: Colors.white,
                                  ))),
                  ],
                ),
              ])
            ]),
      ),
    );
  }

  Widget loanDetailWidget(AccountsLoanTable accountsLoanTable) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: FractionColumnWidth(.45),
        1: FractionColumnWidth(.05),
        2: FractionColumnWidth(.50),
      },
      children: <TableRow>[
        TableRow(children: <Widget>[
          TableCell(
            ///To give a space between each row
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: LoanCardModel.spaceBetween),
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      // "Balance ${StaticValues.rupeeSymbol}",
                      "${balList[int.tryParse(languageId)]} ${StaticValues.rupeeSymbol}",
                      size: LoanCardModel.keySize,
                      color: Colors.white,
                    ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
            child: languageId == ""
                ? SizedBox()
                : TextView(
                    "${accountsLoanTable.balance.toStringAsFixed(2)}",
                    size: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
          ),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: LoanCardModel.spaceBetween),
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      // "Overdue Amount ${StaticValues.rupeeSymbol}",
                      "${overdueAmountList[int.tryParse(languageId)]} ${StaticValues.rupeeSymbol}",
                      size: LoanCardModel.keySize,
                      color: Colors.white,
                    ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      "${accountsLoanTable.overdueAmnt}",
                      size: LoanCardModel.valueSize,
                      color: Colors.white,
                    )),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: LoanCardModel.spaceBetween),
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      // "Overdue Interest ${StaticValues.rupeeSymbol}",
                      "${overdueInterestList[int.tryParse(languageId)]} ${StaticValues.rupeeSymbol}",
                      size: LoanCardModel.keySize,
                      color: Colors.white,
                    ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      "${accountsLoanTable.overdueIntrest}",
                      size: LoanCardModel.valueSize,
                      color: Colors.white,
                    )),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: LoanCardModel.spaceBetween),
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      // "Interest @${accountsLoanTable.intrestRate}%",
                      "${interestList[int.tryParse(languageId)]} @${accountsLoanTable.intrestRate}%",
                      size: LoanCardModel.keySize,
                      color: Colors.white,
                    ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      "${accountsLoanTable.intrest}",
                      size: LoanCardModel.valueSize,
                      color: Colors.white,
                    )),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: LoanCardModel.spaceBetween),
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      // "Loan ID",
                      loanIDList[int.tryParse(languageId)],
                      size: LoanCardModel.keySize,
                      color: Colors.white,
                    ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      "${accountsLoanTable.loanNo}",
                      size: LoanCardModel.valueSize,
                      color: Colors.white,
                    )),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: LoanCardModel.spaceBetween),
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      // "Loan Type",
                      loanTypeList[int.tryParse(languageId)],
                      size: LoanCardModel.keySize,
                      color: Colors.white,
                    ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      "${accountsLoanTable.loanType}",
                      color: Colors.white,
                      size: LoanCardModel.valueSize,
                    )),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: LoanCardModel.spaceBetween),
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      // "Loan Branch",
                      loanBranchList[int.tryParse(languageId)],
                      color: Colors.white,
                      size: LoanCardModel.keySize,
                    ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      "${accountsLoanTable.loanBranch}",
                      size: LoanCardModel.valueSize,
                      color: Colors.white,
                    )),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: LoanCardModel.spaceBetween),
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      // "Suerty",
                      suretyList[int.tryParse(languageId)],
                      size: LoanCardModel.keySize,
                      color: Colors.white,
                    ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: languageId == ""
                  ? SizedBox()
                  : TextView(
                      "${accountsLoanTable.suerty}",
                      color: Colors.white,
                      size: LoanCardModel.valueSize,
                    )),
        ]),
      ],
    );
  }
}

class ChittyCardModel extends StatelessWidget {
  final PassbookTable chittyListTable;

  final Function onPressed;

  const ChittyCardModel({Key key, this.chittyListTable, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: onPressed,
      child: Container(
        height: _height,
        padding: EdgeInsets.all(10.0),
        decoration:
            _boxDecoration(context: context, shadowDisabled: onPressed == null),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                  chittyListTable.schName,
                  size: 16.0,
                  color: Colors.white,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextView(
                  chittyListTable.depBranch,
                  size: 16.0,
                  color: Colors.white,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Align(
                alignment: Alignment.centerRight,
                child: TextView(
                  //   chittyListTable.accNo.replaceAllMapped(RegExp(r".{5}"), (match) => "${match.group(0)} "),
                  chittyListTable.accNo,
                  size: 22,
                  color: Colors.white54,
                )),
            Align(
              alignment: Alignment.bottomRight,
              child: TextView(
                "${StaticValues.rupeeSymbol}${chittyListTable.balance.toStringAsFixed(2)}",
                color: Colors.white,
                size: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareCardModel extends StatelessWidget {
  final PassbookTable shareListTable;
  final Function onPressed;

  const ShareCardModel({Key key, this.shareListTable, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: onPressed,
      child: Container(
        height: _height,
        padding: EdgeInsets.all(10.0),
        decoration:
            _boxDecoration(context: context, shadowDisabled: onPressed == null),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                  shareListTable.schName,
                  size: 16.0,
                  color: Colors.white,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextView(
                  shareListTable.depBranch,
                  size: 16.0,
                  color: Colors.white,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Align(
                alignment: Alignment.centerRight,
                child: TextView(
                  //  shareListTable.accNo.replaceAllMapped(RegExp(r".{5}"), (match) => "${match.group(0)} "),
                  shareListTable.accNo,
                  size: 22,
                  color: Colors.white54,
                )),
            Align(
              alignment: Alignment.bottomRight,
              child: TextView(
                "${StaticValues.rupeeSymbol}${shareListTable.balance.toStringAsFixed(2)}",
                color: Colors.white,
                size: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
