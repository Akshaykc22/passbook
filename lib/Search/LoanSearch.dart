import 'package:flutter/material.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanSearch extends StatefulWidget {
  const LoanSearch({Key key}) : super(key: key);

  @override
  _LoanSearchState createState() => _LoanSearchState();
}

class _LoanSearchState extends State<LoanSearch> {
  SharedPreferences preferences;
  var languageId = "";

  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> loanSearchList = ["Loan Search","recherche de prêt","Búsqueda de préstamo","Pesquisa de Empréstimo"];
  			

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
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Loan Search"),
        title: Text(loanSearchList[int.parse(languageId)]),
      ),
    );
  }
}
