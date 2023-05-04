import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passbook_core/Passbook/Model/LoanTransModel.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanTransaction extends StatefulWidget {
  final String accNo;

  const LoanTransaction({Key key, this.accNo}) : super(key: key);

  @override
  _LoanTransactionState createState() => _LoanTransactionState();
}

class _LoanTransactionState extends State<LoanTransaction> {
  LoanTransModel _loanTransModel;

  SharedPreferences preferences;
  var languageId = "";

  List<String> dateList = ["Date","Date","Fecha","Data"];
  List<String> amountList = ["Amount","Montante","Cantidad","Quantia"];
  List<String> interestList = ["Interest","Intérêt","Interés","Interesse"];
  List<String> chargesList = ["Charges","Des charges","Cargos","Cobranças"];
  List<String> totalList = ["Total","Totale","Total","Total"];
  List<String> balList = ["Balance","Équilibre","Balance","Equilíbrio"];
  List<String> loanTransactionList = ["Loan Transaction","Opération de prêt","Transacción de préstamo","Transação de Empréstimo"];

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
    });
  }


  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
  }

  List<Widget> header() {
    return [
      TableCell(
          child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
        title: TextView(
          // "Date",
          dateList[int.parse(languageId)],
          textAlign: TextAlign.start,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      )),
      TableCell(
          child: TextView(
        // "Amount",
            amountList[int.parse(languageId)],
        textAlign: TextAlign.end,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      )),
      TableCell(
          child: TextView(
        // "Interest",
        interestList[int.parse(languageId)],
        textAlign: TextAlign.end,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      )),
      TableCell(
          child: TextView(
        // "Charges",
        chargesList[int.parse(languageId)],
        textAlign: TextAlign.end,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      )),
      TableCell(
          child: TextView(
        // "Total",
        totalList[int.parse(languageId)],
        textAlign: TextAlign.end,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      )),
      TableCell(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: TextView(
          // "Balance",
          balList[int.parse(languageId)],
          textAlign: TextAlign.end,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ))
    ];
  }

  List<TableRow> rows(List<LoanTransTable> loanTransTable) {
    List<TableRow> tableRows = List();
    loanTransTable.asMap().forEach((index, item) {
      tableRows
          .add(TableRow(decoration: BoxDecoration(color: index % 2 == 0 ? Colors.black12 : Colors.white), children: [
        TableCell(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: TextView(
            item.trdate.replaceAll("/", "-"),
            textAlign: TextAlign.start,
            size: 14.0,
          ),
        )),
        TableCell(
            child: TextView(
          item.amount.toStringAsFixed(2),
          textAlign: TextAlign.end,
          color: item.drcr.toLowerCase() == "dr" ? Colors.red : Colors.green,
          size: 14.0,
        )),
        TableCell(
            child: TextView(
          item.interest.toStringAsFixed(2),
          textAlign: TextAlign.end,
          size: 14.0,
        )),
        TableCell(
            child: TextView(
          item.charges.toStringAsFixed(2),
          textAlign: TextAlign.end,
          size: 14.0,
        )),
        TableCell(
            child: TextView(
          item.total.toStringAsFixed(2),
          textAlign: TextAlign.end,
          size: 14.0,
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: TextView(
            item.balance.toStringAsFixed(2),
            textAlign: TextAlign.end,
            size: 14.0,
          ),
        ))
      ]));
    });
    return tableRows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        maintainBottomViewPadding: true,
        child: FutureBuilder<Map>(
          future: RestAPI().get("${APis.getLoanPassbook}${widget.accNo}"),
          builder: (context, state) {
            if (!state.hasData || state.hasError) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              _loanTransModel = LoanTransModel.fromJson(state.data);
              return CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  centerTitle: true,
                  // title: Text("Loan Transaction"),
                  title: Text(loanTransactionList[int.parse(languageId)],),
                  floating: true,
                  pinned: true,
                  forceElevated: true,
                  bottom: PreferredSize(
                      child: Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle, children: <TableRow>[
                        TableRow(children: header()),
                      ]),
                      preferredSize: Size.fromHeight(kToolbarHeight)),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: rows(_loanTransModel.table),
                    )
                  ]),
                ),
              ]);
            }
          },
        ),
      ),
    );
  }
}
