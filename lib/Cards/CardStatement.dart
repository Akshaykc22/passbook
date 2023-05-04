import 'package:flutter/material.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CardStatementModel.dart';

class CardStatement extends StatefulWidget {
  const CardStatement({Key key}) : super(key: key);

  @override
  _CardStatementState createState() => _CardStatementState();
}


class _CardStatementState extends State<CardStatement> {

  List<CardTransTable> cardTransactionList = List();
  bool _isLoading;
  String strMsg;
  SharedPreferences preferences;
  var languageId = "";


  List<String> cardStatementList = ["Card Statement","Relevé de carte","Extracto de la tarjeta","Extrato do cartão"];
  List<String> voucherTypeList = ["Voucher Type","Type de bon","Tipo de vale","Tipo de voucher"];
  List<String> balList = ["Balance","Équilibre","Balance","Equilíbrio"];
  List<String> narrationList = ["Narration","Narration","Narración","Narração"];

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
    getCardStatement();
  }

 Future<void> getCardStatement() async{
   preferences = StaticValues.sharedPreferences;
   _isLoading = true;
    var response = await RestAPI().post(APis.getCardStatement,params: {
    "strAgentMobileNo": preferences?.getString(StaticValues.mobileNo) ?? ""
   //   "strAgentMobileNo":"9650712712"
    });

    CardStatementModel cardStatementModel = CardStatementModel.fromJson(response);



    setState(() {

      cardTransactionList = cardStatementModel.data;
      print("LIJU: $cardTransactionList");
      strMsg = cardStatementModel.successMessage;
      _isLoading = false;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strMsg)));
    });

    return;


 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Card Statement"),
        title: Text(cardStatementList[int.parse(languageId)]),
      ),
      body: _isLoading?Center(child: CircularProgressIndicator()):ListView.builder(
          itemCount: cardTransactionList.length,
          itemBuilder: (context, index){
            return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cardTransactionList[index].dtTransactionDate,
                      style: TextStyle(
                        fontSize: 16.0,
                          fontWeight: FontWeight.bold
                      ),),
                      Text(cardTransactionList[index].amount,
                      style: TextStyle(
                        color: Colors.green,
                            fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text("Voucher Type : ${cardTransactionList[index].strVoucherType}",
                      Text("${voucherTypeList[int.parse(languageId)]} : ${cardTransactionList[index].strVoucherType}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                      // Text("Balance : ${cardTransactionList[index].availableBalance.toString()}",
                      Text("${balList[int.parse(languageId)]} : ${cardTransactionList[index].availableBalance.toString()}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  // Text("Narration : ${cardTransactionList[index].strNarration}")
                  Text("${narrationList[int.parse(languageId)]} : ${cardTransactionList[index].strNarration}")
                ],
              ),
            ),
            );
          }),
    );
  }
}
