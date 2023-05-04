import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SaveMpinModel.dart';

class MpinGenerate extends StatefulWidget {
  const MpinGenerate({Key key}) : super(key: key);

  @override
  _MpinGenerateState createState() => _MpinGenerateState();
}

class _MpinGenerateState extends State<MpinGenerate> {
  TextEditingController mpinCtrl = TextEditingController();
  TextEditingController reMpinCtrl = TextEditingController();
  bool mPin = false;
  bool reMpin = false;
  bool currentMpin = false;
  List<SaveMpin> mPinResponse = [];
  String str_Ststus;
  int strStatusCode;
  SharedPreferences pref;
  String MPin;
  SharedPreferences sharedPreferences = StaticValues.sharedPreferences;
  var languageId = "";

  List<String> mpinMissMatchList = [
    "MPIN Miss Match",
    "Match manqué MPIN",
    "Partido perdido de MPIN",
    "Correspondência perdida MPIN"
  ];
  List<String> mpinLengthList = [
    "MPIN length should be 4",
    "La longueur de l'MPIN doit être de 4",
    "La longitud de MPIN debe ser 4",
    "O comprimento do MPIN deve ser 4"
  ];
  List<String> saveList = ["Save", "Sauver", "salvar", "Salve"];
  List<String> updateList = [
    "Update",
    "Mise à jour",
    "Actualizar",
    "Atualizar"
  ];
  List<String> noList = ["No", "non", "no", "não"];
  List<String> yesList = ["Yes", "oui", "si", "sim"];
  List<String> areYouSureDeleteMpinList = [
    "Are you sure want to delete MPin?",
    "Êtes-vous sûr de vouloir supprimer MPin?",
    "Estás seguro de que quieres eliminar MPin?",
    "Tem certeza que deseja excluir MPin?"
  ];
  List<String> deleteMpinList = [
    "Delete MPIN",
    "Supprimer MPIN",
    "Borrar MPIN",
    "Excluir MPIN"
  ];
  List<String> setMpinList = [
    "Set MPIN",
    "Ensemble MPIN",
    "Establecer MPIN",
    "Definir MPIN"
  ];
  List<String> setList = ["Set", "Ensemble", "Establecer", "Definir"];
  // List<String> List = ["","","",""];

  void loadData() async {
    sharedPreferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = sharedPreferences?.getString(StaticValues.languageId) ?? "0";
    });
  }

  @override
  void initState() {
    loadData();
    setState(() {
      SharedPreferences pref = StaticValues.sharedPreferences;
      MPin = pref.getString(StaticValues.Mpin);
      print("MPIN : $MPin");
      /*usernameCtrl.text = "nira";
      passCtrl.text = "1234";*/
//      usernameCtrl.text = "vidya";
//      passCtrl.text = "123456";
//      usernameCtrl.text = "9895564690";
//      passCtrl.text = "123456";
    });

    super.initState();
  }

  Future<List<SaveMpin>> saveMpin() async {
    pref = StaticValues.sharedPreferences;
    var response = await RestAPI().post(APis.saveMpin, params: {
      "CustID": pref.getString(StaticValues.custID),
      "MPIN": mpinCtrl.text
    });
    setState(() {
      //  mPinResponse = saveMpinFromJson(json.encode(response));
      mPinResponse = saveMpinFromJson(json.encode(response));
      str_Ststus = mPinResponse[0].status;
      strStatusCode = mPinResponse[0].statuscode;
      print("LJT$str_Ststus");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(str_Ststus)));

      if (strStatusCode == 1) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/LoginPage", (_) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text("Set MPIN"),
            Text(setMpinList[int.parse(languageId)]),
            InkWell(
              onTap: () {
                showAlertDialog(context);
                // showCustomAlertDialog(context: context);
              },
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EditTextBordered(
              controller: mpinCtrl,
              hint: "MPIN",
              hintColor: Theme.of(context).secondaryHeaderColor,
              borderColor: Theme.of(context).secondaryHeaderColor,
              keyboardType: TextInputType.number,
              // errorText: mPin ? "MPIN length should be 4" : null,
              errorText: mPin ? mpinLengthList[int.parse(languageId)] : null,
              //   obscureText: true,
              //  showObscureIcon: true,
              onChange: (value) {
                setState(() {
                  mPin = value.trim().length < 4;
                });
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            EditTextBordered(
              controller: reMpinCtrl,
              hint: "Re-enter MPIN",
              hintColor: Theme.of(context).secondaryHeaderColor,
              borderColor: Theme.of(context).secondaryHeaderColor,
              keyboardType: TextInputType.number,
              // errorText: reMpin ? "MPIN length should be 4" : null,
              errorText: reMpin ? mpinLengthList[int.parse(languageId)] : null,
              //   obscureText: true,
              //   showObscureIcon: true,
              onChange: (value) {
                setState(() {
                  reMpin = value.trim().length < 4;
                });
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              height: 40.0,
              child: RaisedButton(
                onPressed: () async {
                  if (mpinCtrl.text == reMpinCtrl.text) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString(StaticValues.Mpin, mpinCtrl.text);

                    // await pref.setString(StaticValues.Mpin, "1111");
                    saveMpin();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        // SnackBar(content: Text("MPIN Miss Match")));
                        SnackBar(
                            content: Text(
                                mpinMissMatchList[int.parse(languageId)])));
                  }

                  /*  if(MPin == null){
                  if(mpinCtrl.text == reMpinCtrl.text){
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString(StaticValues.Mpin, mpinCtrl.text);

                    // await pref.setString(StaticValues.Mpin, "1111");
                    saveMpin();
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mpin Miss Match")));
                  }
                }
                else{
                  if(MPin == currentMpinCtrl.text){
                    if(mpinCtrl.text == reMpinCtrl.text){

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString(StaticValues.Mpin, mpinCtrl.text);

                      // await pref.setString(StaticValues.Mpin, "1111");
                      saveMpin();
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mpin Miss Match")));
                    }
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Current MPin Missmatch")));
                  }
                }*/
                },
                child: Text(
                  // MPin == null ? "Save" : "Update",
                  MPin == null
                      ? saveList[int.parse(languageId)]
                      : updateList[int.parse(languageId)],
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).secondaryHeaderColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  // showCustomAlertDialog({BuildContext context}) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(
  //         "Delete MPin",
  //         style: TextStyle(
  //             color: Theme.of(context).secondaryHeaderColor,
  //             fontWeight: FontWeight.bold),
  //       ),
  //       content: Text("Are you sure want to delete MPin."),
  //       actions: [
  //         TextButton(
  //           onPressed: () async {
  //             SharedPreferences prefs = await SharedPreferences.getInstance();
  //             if (prefs.getString(StaticValues.Mpin) == null) {
  //               ScaffoldMessenger.of(context)
  //                   .showSnackBar(SnackBar(content: Text("No MPin Set")));
  //             } else {
  //               prefs.remove(StaticValues.Mpin);
  //
  //               ScaffoldMessenger.of(context)
  //                   .showSnackBar(SnackBar(content: Text("MPin Deleted")));
  //
  //               Navigator.of(context)
  //                   .pushNamedAndRemoveUntil("/LoginPage", (_) => false);
  //             }
  //             // prefs.setString(StaticValues.Mpin, "");
  //           },
  //           child: Text("Yes"),
  //         ),
  //         SizedBox(
  //           width: 10,
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(
  //               context,
  //             );
  //           },
  //           child: Text("No"),
  //         ),
  //         SizedBox(
  //           width: 10,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  ///Old
  showAlertDialog(BuildContext ctx) {
    // Create button
    Widget okButton = FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (prefs.getString(StaticValues.Mpin) == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "${noList[int.parse(languageId)]} MPin ${setList[int.parse(languageId)]}")));
                // .showSnackBar(SnackBar(content: Text("No MPin Set")));
              } else {
                prefs.remove(StaticValues.Mpin);

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("MPin Deleted")));

                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/LoginPage", (_) => false);
              }
              // prefs.setString(StaticValues.Mpin, "");
            },
            // child: Text("YES"),
            child: Text(yesList[int.parse(languageId)]),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.pop(context);
              },
              // child: Text("NO")),
              child: Text(noList[int.parse(languageId)])),
        ],
      ),
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        // "Delete MPin",
        deleteMpinList[int.parse(languageId)],
        style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
      ),
      // content: Text("Are you sure want to delete MPin."),
      content: Text(areYouSureDeleteMpinList[int.parse(languageId)]),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
