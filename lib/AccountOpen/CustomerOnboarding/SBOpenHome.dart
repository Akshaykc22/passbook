import 'package:flutter/material.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SBOpenHome extends StatefulWidget {
  String strName,strMobNo;
  SBOpenHome({Key key,@required this.strName,@required this.strMobNo}) : super(key: key);

  @override
  _SBOpenHomeState createState() => _SBOpenHomeState();
}

class _SBOpenHomeState extends State<SBOpenHome> {

  bool check1 = false;
  bool _isLoading = false;

  SharedPreferences preferences;
  var languageId = "";

  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> openSBAccList = ["Open SB Account","Ouvrir un compte SB","Abrir cuenta SB","Abrir Conta SB"];
  List<String> dearList = ["Dear","Cher","Estimado","Querido"];
  List<String> iAcceptTermsConditionsList = ["I Accept the terms and conditions","J'accepte les termes et conditions","Acepto los términos y condiciones","Eu aceito os termos e condições"];
  List<String> openZeroBalSavingsAccList = ["Open your Zero Balance Saving Bank account with Prima Finance, Please Confirm to Proceed with Account Opening","Ouvrez votre compte Zero Balance Saving Bank avec Prima Finance, veuillez confirmer pour procéder à l'ouverture du compte","Abra su cuenta Zero Balance Saving Bank con Prima Finance, confirme para continuar con la apertura de la cuenta","Abra sua conta bancária de poupança de saldo zero com a Prima Finance, confirme para prosseguir com a abertura da conta"];
  List<String> confirmList = ["Confirm","Confirmer","Confirmar","Confirmar"];
  // List<String> List = ["","","",""];
  // List<String> List = ["","","",""];
  // List<String> List = ["","","",""];

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

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Open SB Account"),
        title: Text(openSBAccList[int.parse(languageId)]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topLeft,
              // child: Text("Dear ${widget.strName}",
              child: Text("${dearList[int.parse(languageId)]} ${widget.strName}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),),
            ),
            SizedBox(
              height: 8,
            ),
            // Text("Open your Zero Balance Saving Bank account with Prima Finance, Please Confirm to Proceed with Account Opening",
            Text(openZeroBalSavingsAccList[int.parse(languageId)],

              style: TextStyle(
                fontSize: 16,

              ),),
            SizedBox(
              height: 12,
            ),
            CheckboxListTile(
              value: check1,
              controlAffinity: ListTileControlAffinity.leading, //checkbox at left
              onChanged: (bool value) {
                setState(() {
                  check1 = value;
                  print(check1.toString());
                });
              },
              // title: Text("I Accept the terms and conditions"),
              title: Text(iAcceptTermsConditionsList[int.parse(languageId)]),
            ),
            SizedBox(
              height: 12,
            ),
            Visibility(
              visible: check1,
              child: ElevatedButton(onPressed: () async {
                setState(() {
                  _isLoading =true;
                });
                var response = await RestAPI().get(APis.openSBAccount(widget.strMobNo));
                print(response.toString());
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/LoginPage', (Route<dynamic> route) => false);
              }, child: _isLoading?CircularProgressIndicator(
                color: Colors.white,
              // ):Text("Confirm"),
              ):Text(confirmList[int.parse(languageId)]),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),),
            ),

          ],
        ),
      ),
    );
  }
}
