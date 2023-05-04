import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:passbook_core/AccountOpen/AccountOpening.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AccountNoModel.dart';

class AccountOpenHome extends StatefulWidget {
  // const AccountOpenHome({Key key}) : super(key: key);

  String AccType;

  AccountOpenHome(this.AccType) : super();

  @override
  _AccountOpenHomeState createState() => _AccountOpenHomeState();
}

class _AccountOpenHomeState extends State<AccountOpenHome> {
  @override
  void initState() {
    loadData();
    super.initState();
    getAccNo();
  }

  SharedPreferences preferences;
  var languageId = "";

  var _fruits = <AccountNumber>[];
  var _selectedAccNo;
  String str_accNo;
  var balance = "";
  String userId;

  List<String> accOpenList = [
    "Account Open",
    "Compte ouvert",
    "Cuenta abierta",
    "Conta aberta"
  ];
  List<String> selectAccNoList = [
    "Select Account No",
    "Sélectionnez le numéro d'accès",
    "Seleccionar número de cuenta",
    "Selecione o número da conta"
  ];
  List<String> accBalList = [
    "Account Balance",
    "Solde du compte",
    "Saldo de la cuenta",
    "Saldo da conta"
  ];
  List<String> plsSelectAccNoList = [
    "Please Select Account No",
    "Veuillez sélectionner le numéro de compte",
    "Seleccione el número de cuenta",
    "Selecione o número da conta"
  ];

  /*String url = "http://Azure-demo2.safeandsmartbank.com:6544/DebitAccOpen_T_Select";
  String balance_url = "http://Azure-demo2.safeandsmartbank.com:6544/AccNoByAccBal_T_Select";*/

  String url = "${APis.DebitAccOpen}";
  String balance_url = "${APis.AccNoByAccBal}";

  List<AccountNumber> getAccount = [];
  bool _isLoadingAccNo = false;
  bool _isBalance = false;

  Future<List<AccountNumber>> getAccNo() async {
    preferences = StaticValues.sharedPreferences;

    setState(() {
      _isLoadingAccNo = true;
      userId = preferences?.getString(StaticValues.custID) ?? "";
      print("USERID" + userId);
    });

    var response = await http.post(Uri.parse(url), headers: {
      "Accept": "Application/json"
    }, body: {
      //  "Cust_Id": "1"
      "Cust_Id": userId
    });
    //  var listItem  = json.decode(response.body);
    // var data = listItem[0];
    //  print(data);
    setState(() {
      getAccount = accountNumberFromJson(response.body);
      // print(getAccount);
      _fruits.addAll(getAccount);
      // print(_fruits);
      _isLoadingAccNo = false;
    });
    return getAccount;
  }

  Future<String> getBalance() async {
    setState(() {
      _isBalance = true;
    });
    var accBalance = await http.post(Uri.parse(balance_url), headers: {
      "Accept": "application/json",
    }, body: {
      //  "Acc_No": "101001000000001"

      "Acc_No": str_accNo
    });
    var listData = json.decode(accBalance.body);
    setState(() {
      balance = listData[0]["AccBal"];
      print(balance);
      _isBalance = false;
    });
  }

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Account Open ${widget.AccType}"),
        title: Text("${accOpenList[int.parse(languageId)]} ${widget.AccType}"),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                border: Border.all(
                    style: BorderStyle.solid,
                    width: 0.80,
                    color: Theme.of(context).secondaryHeaderColor),
              ),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<AccountNumber>(
                      // hint: _isLoadingAccNo ? Center(child: CircularProgressIndicator()) : Text('Select Acc No'),
                      hint: _isLoadingAccNo
                          ? Center(child: CircularProgressIndicator())
                          : Text(
                              selectAccNoList[int.parse(languageId)],
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                      icon: Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      value: _selectedAccNo,
                      items: _fruits.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Container(
                              child: Text(
                            item.accNo,
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          )),
                        );
                      }).toList(),
                      onChanged: (selectedItem) {
                        str_accNo = selectedItem.accNo;
                        print(selectedItem.accNo);
                        setState(() => _selectedAccNo = selectedItem);
                        getBalance();
                        // print("LIJITH"+_selectedAccNo);
                      })),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 13, 00, 00),
              height: 40.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                border: Border.all(
                    style: BorderStyle.solid,
                    width: 0.80,
                    color: Theme.of(context).secondaryHeaderColor),
              ),
              // child: _isBalance ? Center(child: CircularProgressIndicator()) :Text(balance == ""?"Account Balance" : balance,)),
              child: _isBalance
                  ? Center(child: CircularProgressIndicator())
                  : Text(
                      balance == ""
                          ? accBalList[int.parse(languageId)]
                          : balance,
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor),
                    ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).secondaryHeaderColor,
                          onPressed: () {
                            if (str_accNo == "" || balance == "") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                // content: Text("Please Select Account No"),
                                content: Text(
                                    plsSelectAccNoList[int.parse(languageId)]),
                              ));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountOpening(
                                          str_accNo, balance, widget.AccType)));
                            }
                          },
                          // child: Text("Account Open ${widget.AccType}",
                          child: Text(
                            "${accOpenList[int.parse(languageId)]} ${widget.AccType}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
