import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AccountNoModel.dart';
import 'QrCodeModel.dart';

class QRCodeHome extends StatefulWidget {
  const QRCodeHome({Key key}) : super(key: key);

  @override
  _QRCodeHomeState createState() => _QRCodeHomeState();
}

class _QRCodeHomeState extends State<QRCodeHome> {
  List<AccNoModel> accountList = [];

  String strAccNo = "";
  bool _isLoadingAccNo;
  AccNoModel _selectedAccNo;

  var getUserAccount = <AccNoModel>[];

  List<String> selectAccNoList = [
    "Select Account No",
    "Sélectionnez le numéro d'accès",
    "Seleccionar número de cuenta",
    "Selecione o número da conta"
  ];

  SharedPreferences preferences;
  var languageId = "";

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
    getAccNo();
    // getQrList();
  }

  Future<List<AccNoModel>> getAccNo() async {
    SharedPreferences pref = StaticValues.sharedPreferences;
    _isLoadingAccNo = true;
    var response = await RestAPI().post(APis.accNoQr,
        params: {"Cust_Id": pref.getString(StaticValues.custID)});
    print("RESPONSE$response");
    setState(() {
      accountList = accNoModelFromJson(json.encode(response));
      getUserAccount.addAll(accountList);
      print("LIJITH${accountList[0].accNo}");
      _selectedAccNo = accountList[0];
      strAccNo = accountList[0].accNo;
      _isLoadingAccNo = false;
      //  getQrList();
    });
    return accountList;
  }

  Future<QrCodeModel> getQrList() async {
    if (strAccNo.isNotEmpty) {
      var response1 =
          await RestAPI().post(APis.upiQrCode, params: {"Acc_No": strAccNo});

      List<QrCodeModel> qrCodeList =
          qrCodeModelFromJson(json.encode(response1));
      /* setState(() {
      List<QrCodeModel> qrCodeList = qrCodeModelFromJson(json.encode(response1));
     // str_qrCode = qrCodeList[0].qrCode;

   */ /*   int idx = str_qrCode.indexOf(",");
     // List parts = [str_qrCode.substring(idx+1).trim()];
    str_base64Image = str_qrCode.substring(idx+1).trim();
      print("LIJU${str_base64Image}");*/ /*
    });*/

      return qrCodeList[0];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text("QR Code"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                border: Border.all(style: BorderStyle.solid, width: 0.80),
              ),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<AccNoModel>(
                      hint: _isLoadingAccNo
                          ? Center(
                              child: SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator()))
                          : Text(
                              // 'Select Acc No'),
                              selectAccNoList[int.parse(languageId)]),
                      icon: Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      value: _selectedAccNo,

                      // value: getUserAccount[0].accNo,
                      items: getUserAccount.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Container(child: Text(item.accNo)),
                        );
                      }).toList(),
                      onChanged: (selectedItem) {
                        strAccNo = selectedItem.accNo;
                        print(selectedItem.accNo);
                        setState(() => _selectedAccNo = selectedItem);
                        getQrList();
                      })),
            ),
            SizedBox(
              height: 20.0,
            ),
            FutureBuilder<QrCodeModel>(
              future: getQrList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String imgBase64 = snapshot.data.qrCode.split(",")[1];
                  print("LIJU${snapshot.data.qrCode}");

                  Uint8List _bytesImage = Base64Decoder().convert(imgBase64);
                  print("LIJU${_bytesImage.toString()}");

                  return Container(
                      height: 200.0,
                      width: 200.0,
                      child: Image.memory(_bytesImage));
                } else {
                  return Container(
                      // child: Text("Please Select AccNo"),
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
