import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passbook_core/Passbook/Model/ChittyTransModel.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChittyTransaction extends StatefulWidget {
  final String accNo;

  const ChittyTransaction({Key key, this.accNo}) : super(key: key);

  @override
  _ChittyTransactionState createState() => _ChittyTransactionState();
}

class _ChittyTransactionState extends State<ChittyTransaction> {
  ChittyTransModel _chittyTransModel;

  SharedPreferences preferences;
  var languageId = "";

  List<String> dateList = ["Date","Date","Fecha","Data"];
  List<String> amountList = ["Amount","Montante","Cantidad","Quantia"];
  List<String> discountList = ["Discount","Rabais","Descuento","Desconto"];
  List<String> intAmtList = ["Interest Amount","Montant des intérêts","Cantidad de interés","Montante de juros"];
  List<String> forfeitList = ["Forfeit","Déclarer forfait","Perder","Perder"];
  List<String> balList = ["Balance","Équilibre","Balance","Equilíbrio"];
  List<String> chittyTransactionList = ["Chitty Transaction","Transaction Chitty","Transacción Chitty","Transação Chitty"];

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
    loadData();
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
        // title: TextView("Date",
            title: TextView(dateList[int.parse(languageId)],
                textAlign: TextAlign.start,
            color: Colors.white, fontWeight: FontWeight.bold),
      )),
      TableCell(
          child: TextView("Inst No",
              textAlign: TextAlign.end, color: Colors.white, fontWeight: FontWeight.bold)),
      TableCell(
          child:
              // TextView("Amount",
          TextView(amountList[int.parse(languageId)],
              textAlign: TextAlign.end, color: Colors.white, fontWeight: FontWeight.bold)),
      TableCell(
          // child: TextView("Discount",
          child: TextView(discountList[int.parse(languageId)],
              textAlign: TextAlign.end, color: Colors.white, fontWeight: FontWeight.bold)),
      TableCell(
          // child: TextView("Int Amount",
          child: TextView(intAmtList[int.parse(languageId)],
              textAlign: TextAlign.end, fontWeight: FontWeight.bold, color: Colors.white)),
      TableCell(
          // child: TextView("Forfeit",
          child: TextView(forfeitList[int.parse(languageId)],
              textAlign: TextAlign.end, fontWeight: FontWeight.bold, color: Colors.white)),
      TableCell(
          child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
        title:
            // TextView("Balance",
        TextView(balList[int.parse(languageId)],
            textAlign: TextAlign.end, color: Colors.white, fontWeight: FontWeight.bold),
      ))
    ];
  }

  List<TableRow> rows(List<ChittyTransTable> chittyTransTable) {
    List<TableRow> tableRows = List();
    chittyTransTable.asMap().forEach((index, item) {
      tableRows.add(TableRow(
          decoration: BoxDecoration(color: index % 2 == 0 ? Colors.black12 : Colors.white),
          children: [
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
              size: 14.0,
            )),
            TableCell(
                child: TextView(
              item.amount.toStringAsFixed(2),
              textAlign: TextAlign.end,
              color: item.drcr.toLowerCase() == "dr" ? Colors.red : Colors.black,
              size: 14.0,
            )),
            TableCell(
                child: TextView(
              item.disc.toStringAsFixed(2),
              textAlign: TextAlign.end,
              size: 14.0,
            )),
            TableCell(
                child: TextView(
              item.intamt.toStringAsFixed(2),
              textAlign: TextAlign.end,
              size: 14.0,
            )),
            TableCell(
                child: TextView(
              item.forfeit.toStringAsFixed(2),
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
          future: RestAPI().get("${APis.getChittyPassbook}${widget.accNo}"),
          builder: (context, state) {
            if (!state.hasData || state.hasError) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              _chittyTransModel = ChittyTransModel.fromJson(state.data);
              return CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  centerTitle: true,
                  // title: Text("Chitty Transaction"),
                  title: Text(chittyTransactionList[int.parse(languageId)]),
                  floating: true,
                  pinned: true,
                  forceElevated: true,
                  bottom: PreferredSize(
                      child: Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(children: header()),
                          ]),
                      preferredSize: Size.fromHeight(kToolbarHeight)),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: rows(_chittyTransModel.table),
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
