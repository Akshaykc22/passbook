import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/GlobalWidgets.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardReset extends StatefulWidget {
  const CardReset({Key key}) : super(key: key);

  @override
  _CardResetState createState() => _CardResetState();
}

class _CardResetState extends State<CardReset> {

  SharedPreferences preferences = StaticValues.sharedPreferences;
  bool _resetLoading = false;
  String strMsg;

  int count = 0;
  var isLoading = false;
  String str_Otp;


  var languageId = "";

  List<String> resetCardPinList = ["Reset Card Pin","Réinitialiser la broche de la carte","Restablecer pin de tarjeta","Redefinir PIN do cartão"];
  List<String> resetList = ["Reset","Réinitialiser","Reiniciar","Reiniciar"];
  List<String> updateList = ["Update","Mise à jour","Actualizar","Atualizar"];
  List<String> enterOTPList = ["Enter OTP","Entrez OTP","Ingresar OTP","Digite OTP"];
  List<String> UPDATEList = ["UPDATE","MISE À JOUR","ACTUALIZAR","ATUALIZAR"];
  List<String> otpMissMatchList = ["OTP Miss Match","Match manqué OTP","Partido perdido de OTP","Correspondência perdida OTP"];


  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }


  Future<void> resetCardPin() async{

    setState(() {
      _resetLoading = true;
    });
    var response = await RestAPI().post(APis.cardReset,params: {
      "strAgentMobileNo": preferences.getString(StaticValues.mobileNo)
    //  "strAgentMobileNo": "9315439371"
    });

    setState(() {
      strMsg = response["successMessage"];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strMsg)));

      _resetLoading =false;
      Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (route) => false);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Reset Card Pin"),
        title: Text(resetCardPinList[int.parse(languageId)]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(

                padding: EdgeInsets.fromLTRB(10.0, 13, 00, 00),
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  border: Border.all(
                      style: BorderStyle.solid, width: 0.80),
                ),
                child:Text(preferences.getString(StaticValues.mobileNo))),

            SizedBox(
              height: 16.0,
            ),
            Container(
              height: 50.0,
              child: RaisedButton(onPressed: () async{

                var response = await RestAPI().post(APis.GenerateOTP, params: {
                  "MobileNo": preferences.getString(StaticValues.mobileNo),
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

                _resetCardConfirmation();
               /* setState(() {
                  count = count+1;
                  if( count == 1){
                    resetCardPin();
                  }
                  else{
                    return null;
                  }
                });*/

              },
              child: _resetLoading
                  ?CircularProgressIndicator()
                  // :Text("Reset",
                  :Text(resetList[int.parse(languageId)],
              style: TextStyle(
                color: Colors.white
              ),),),
            )

          ],
        ),
      ),
    );
  }

  void _resetCardConfirmation() {
    isLoading = false;
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
            loadingValue: isLoading,
            buttonText: isLoading
                ?CircularProgressIndicator()
                // :"UPDATE",
            : UPDATEList[int.parse(languageId)],
            onPressed: isLoading
                ? null
                : () async {


              if(_pass == str_Otp){
                count = count+1;
                if(count ==1){
                  resetCardPin();
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
