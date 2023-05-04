import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/GlobalWidgets.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomerCreationHome.dart';
import 'SBOpenHome.dart';

class CustomerChecking extends StatefulWidget {
  const CustomerChecking({Key key}) : super(key: key);

  @override
  _CustomerCheckingState createState() => _CustomerCheckingState();
}

class _CustomerCheckingState extends State<CustomerChecking> {
  SharedPreferences preferences;
  var languageId = "";

  TextEditingController mobNoController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool _mobLoading = false;
  bool _isOtpLoading = false;
  String strOtp, strStatus, strStatusMsg, strName;

  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> mobileNoList = [
    "Mobile Number",
    "Numéro de portable",
    "Número de móvil",
    "Número de celular"
  ];
  List<String> enterOTPList = [
    "Enter OTP",
    "Entrez OTP",
    "Ingresar OTP",
    "Digite OTP"
  ];
  List<String> validateOTPList = [
    "Validate OTP",
    "Valider OTP",
    "Validar OTP",
    "Validar OTP"
  ];
  List<String> validateList = ["Validate", "Valider", "Validar", "Validar"];
  List<String> verifyList = ["Verify", "Vérifier", "Verificar", "Verificar"];
  List<String> verifyMobileNoList = [
    "Verify Customer Mobile Number",
    "Vérifier le mobile du client Non",
    "Verificar número de móvil del cliente",
    "Verifique o número do celular do cliente"
  ];
  List<String> plsEnterMobNoList = [
    "Please Enter Mobile Number",
    "Veuillez entrer le numéro de portable",
    "Ingrese el número de teléfono móvil",
    "Insira o número do celular"
  ];
  List<String> failedList = ["Failed", "Échoué", "Fallido", "Fracassado"];
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(_isOtpLoading?"Validate OTP":"Verify Customer Mobile No"),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(
          _isOtpLoading
              ? validateOTPList[int.parse(languageId)]
              : verifyMobileNoList[int.parse(languageId)],
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width / 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // EditTextBordered(hint: "Mobile Number",
            EditTextBordered(
              hint: mobileNoList[int.parse(languageId)],
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                LengthLimitingTextInputFormatter(10),
              ],
              keyboardType: TextInputType.phone,
              controller: mobNoController,
              borderColor: Theme.of(context).secondaryHeaderColor,
            ),
            SizedBox(
              height: 12,
            ),
            Visibility(
              visible: _isOtpLoading,
              child: EditTextBordered(
                hint: "OTP",
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  // LengthLimitingTextInputFormatter(6),
                ],
                keyboardType: TextInputType.number,
                controller: otpController,
                borderColor: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                if (mobNoController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        // "Please Enter Mobile Number",
                        plsEnterMobNoList[int.parse(languageId)],
                      ),
                      duration: Duration(seconds: 2)));
                } else if (_isOtpLoading == true &&
                    otpController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        // "Please Enter OTP",
                        enterOTPList[int.parse(languageId)],
                      ),
                      duration: Duration(seconds: 2)));
                } else {
                  onSave();
                }
              },
              child: _mobLoading
                  ? CircularProgressIndicator(
                      // color: Colors.white,):Text(_isOtpLoading?"Validate":"Verify"),
                      color: Colors.white,
                    )
                  : Text(
                      _isOtpLoading
                          ? validateList[int.parse(languageId)]
                          : verifyList[int.parse(languageId)],
                    ),
              style: ButtonStyle(
                // backgroundColor: MaterialStateProperty.all(Colors.red),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).secondaryHeaderColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onSave() async {
    setState(() {
      _mobLoading = true;
    });
    if (!_isOtpLoading) {
      var res = await RestAPI().get(APis.checkAcc(mobNoController.text));
      print("RES : $res");
      setState(() {
        _mobLoading = false;
        _isOtpLoading = true;
      });

      setState(() {
        strOtp = res["Table"][0]["OTP"];
        strStatus = res["Table"][0]["Status"];
        strStatusMsg = res["Table"][0]["StatusMsg"];
        strName = res["Table"][0]["Name"];
      });
      if (strStatus == "002") {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/LoginPage', (Route<dynamic> route) => false);
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(strStatusMsg)));
    } else {
      print(strOtp);
      print(otpController.text);
      print(strStatus);
      if (strOtp == otpController.text) {
        if (strStatus == "002") {
          //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strStatusMsg)));
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/LoginPage', (Route<dynamic> route) => false);
        }
        if (strStatus == "003") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => SBOpenHome(
                    strName: strName,
                    strMobNo: mobNoController.text,
                  )));
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strStatusMsg)));
        }
        if (strStatus == "004") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerCreationHome(
                        strMobNo: mobNoController.text,
                      )));
          //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strStatusMsg)));
        }
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed")));
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failedList[int.parse(languageId)])));
      }
    }
  }
}
