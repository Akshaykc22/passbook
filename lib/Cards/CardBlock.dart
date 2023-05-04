import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/GlobalWidgets.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardBlock extends StatefulWidget {
  const CardBlock({Key key}) : super(key: key);

  @override
  _CardBlockState createState() => _CardBlockState();
}

class _CardBlockState extends State<CardBlock> {

  String dropdownValue = 'Active';
  String cardStatus = '1', statusMsg,statusErrorMsg;
  int  statusCode;
  bool _isLoading = false;
  var isLoading = false;
  String str_Otp;
  int count = 0;

  SharedPreferences sharedPreferences = StaticValues.sharedPreferences;
  var languageId = "";

  List<String> activeList = ["Active","Active","Activa","Ativa"];
  List<String> cardStatusChangeList = ["Card Status Change","Modification de l'état de la carte","Cambio de estado de la tarjeta","Mudança de status do cartão"];
  List<String> deactiveList = ["Deactive","Désactiver","Desactivado","Desativado"];
  List<String> updateList = ["Update","Mise à jour","Actualizar","Atualizar"];
  List<String> enterOTPList = ["Enter OTP","Entrez OTP","Ingresar OTP","Digite OTP"];
  List<String> UPDATEList = ["UPDATE","MISE À JOUR","ACTUALIZAR","ATUALIZAR"];
  List<String> otpMissMatchList = ["OTP Miss Match","Match manqué OTP","Partido perdido de OTP","Correspondência perdida OTP"];


  void loadData() async {
    sharedPreferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = sharedPreferences?.getString(StaticValues.languageId) ?? "0";
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> blockCard() async{
    setState(() {
      _isLoading = true;
    });
    var response = await RestAPI().post(APis.cardBlock,params: {
      "strAgentMobileNo" : sharedPreferences.get(StaticValues.mobileNo),
      "intPrepaidCardStatus" : cardStatus
    });

    setState(() {
      _isLoading = false;
      statusCode = response["statusCode"];
      statusMsg = response["successMessage"];
      statusErrorMsg = response["errorMessage"];
    });

    if(statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(statusMsg)));
      Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (route) => false);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(statusErrorMsg)));
      Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (route) => false);
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Card Status Change"),
        title: Text(cardStatusChangeList[int.parse(languageId)]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(10.0, 13, 00, 00),
                height: 40.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  border: Border.all(
                      style: BorderStyle.solid, width: 0.80),
                ),
                child: Text(sharedPreferences.get(StaticValues.mobileNo))),
            SizedBox(
              height: 16.0,
            ),

      Container(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
              style: BorderStyle.solid, width: 0.80),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                if(newValue == "Active"){
                  cardStatus = "1";
                }
                else{
                  cardStatus = "2";
                }
                dropdownValue = newValue;

            //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(cardStatus)));

              });
            },
            // items: <String>['Active', 'Deactive']
            items: <String>['${activeList[int.parse(languageId)]}', '${deactiveList[int.parse(languageId)]}']

                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,0.0,0.0,0.0),
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
      ),
            SizedBox(
              height: 16.0,
            ),
            RaisedButton(onPressed: () async{


              var response = await RestAPI().post(APis.GenerateOTP, params: {
                "MobileNo": sharedPreferences.getString(StaticValues.mobileNo),
                "Amt": "0",
                "SMS_Module":"GENERAL",
                "SMS_Type":"GENERAL_OTP",
                "OTP_Return":"Y"
              });
              print("rechargeResponse::: $response");
              str_Otp = response[0]["OTP"];


              //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(str_Message)));
              //  RestAPI().get(APis.rechargeMobile(params));
              /*    Map response =
                            await RestAPI().get(APis.rechargeMobile(params));*/
              //   getMobileRecharge();
              setState(() {
                isLoading = false;

                Timer(Duration(minutes:5),(){
                  setState(() {
                    str_Otp = "";
                  });
                });
              });

              _blockCardConfirmation();

            },
            child: Container(
              height: 45.0,
              child: _isLoading?Container(

                  child: CircularProgressIndicator()):Center(
                // child: Text("Update",
                child: Text(updateList[int.parse(languageId)],
                style: TextStyle(
                  color: Colors.white
                ),),
              ),
            ),)
          ],
        ),
      ),
    );
  }



  void _blockCardConfirmation() {
    _isLoading = false;
    var _pass;
    GlobalWidgets().validateOTP(
      context,
      getValue: (passVal) {
        setState(() {
          _pass = passVal;
        });
      },
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
            // "Enter OTP",
            enterOTPList[int.parse(languageId)],
            size: 24.0,
          ),
          SizedBox(
            height: 10.0,
          ),


        ],
      ),
      actionButton: StatefulBuilder(
        builder: (context, setState) => CustomRaisedButton(
            loadingValue: _isLoading,
            buttonText: _isLoading
                ? Container(child: CircularProgressIndicator())
                // : "UPDATE",
            : UPDATEList[int.parse(languageId)],
            onPressed: _isLoading
                ? null
                : () async {


              if(_pass == str_Otp){
                count = count+1;
                if(count ==1){
                  blockCard();
                }
                else{
                  return null;
                }

              }
              else{
                Fluttertoast.showToast(
                    // msg: "OTP Miss match",
                  msg: otpMissMatchList[int.parse(languageId)],
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }

            }
        ),
      ),
    );
  }



}






