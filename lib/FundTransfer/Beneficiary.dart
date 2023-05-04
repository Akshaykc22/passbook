import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passbook_core/FundTransfer/FundTransfer.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/REST/app_exceptions.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Beneficiary extends StatefulWidget {
  @override
  _BeneficiaryState createState() => _BeneficiaryState();
}

class _BeneficiaryState extends State<Beneficiary> {
  SharedPreferences preferences;
  var languageId = "";

  List<String> enterOTPList = [
    "Enter OTP",
    "Entrez OTP",
    "Ingresar OTP",
    "Digite OTP"
  ];
  List<String> addBeneficiaryList = [
    "Add Beneficiary",
    "Ajouter un bénéficiaire",
    "Añadir Beneficiario",
    "Adicionar Beneficiário"
  ];
  List<String> otpMissMatchList = [
    "OTP Miss Match",
    "Match manqué OTP",
    "Partido perdido de OTP",
    "Correspondência perdida OTP"
  ];
  List<String> somethingWrongList = [
    "Something went wrong",
    "Quelque chose s'est mal passé",
    "Algo salió mal",
    "algo deu errado"
  ];
  List<String> fieldsMandatoryList = [
    "All fields are mandatory",
    "Tous les champs sont obligatoires",
    "Todos los campos son obligatorios",
    "Todos os campos são obrigatórios"
  ];
  List<String> enterReceiverNameList = [
    "Enter Receiver Name",
    "Entrez le nom du destinataire",
    "Ingrese el nombre del receptor",
    "Digite o nome do destinatário"
  ];
  List<String> nameInvalidList = [
    "Name is invalid",
    "El nombre no es válido",
    "El nombre no es válido",
    "O nome é inválido"
  ];
  List<String> enterReceiverMobileList = [
    "Enter Receiver Mobile no.",
    "Entrez le numéro de mobile du récepteur.",
    "Ingrese el número de móvil del receptor",
    "Insira o número do celular do receptor"
  ];
  List<String> numberInvalidList = [
    "Number is invalid",
    "Le numéro est invalide",
    "El número no es válido",
    "O número é inválido"
  ];
  List<String> enterMFIList = [
    "Enter MFI",
    "Entrer MFI",
    "Ingresar MFI",
    "Digite MFI"
  ];
  List<String> mfiInvalidList = [
    "MFI is invalid",
    "L'MFI n'est pas valide",
    "MFI no es válida",
    "MFI é inválido"
  ];
  List<String> checkList = ["Check", "Vérifier", "Controlar", "Verificar"];
  List<String> enterAccNoList = [
    "Enter Account Number",
    "Entrez le numéro de compte.",
    "Ingrese el número de cuenta",
    "Insira o nº da conta"
  ];
  List<String> accNoInvalidList = [
    "Account number is invalid",
    "Le numéro de compte est invalide",
    "El número de cuenta no es válido",
    "O número da conta é inválido"
  ];
  List<String> enterBankNameList = [
    "Enter Bank Name",
    "Entrez le nom de la banque",
    "Ingrese el nombre del banco",
    "Digite o nome do banco"
  ];
  List<String> bankNameInvalidList = [
    "Bank Name is invalid",
    "Le nom de la banque n'est pas valide",
    "Le nom de la banque n'est pas valide",
    "El nombre del banco no es válido"
  ];
  List<String> enterBankAddressList = [
    "Enter Bank Address",
    "Entrez l'adresse de la banque",
    "Ingrese la dirección del banco",
    "Digite o endereço do banco"
  ];
  List<String> bankAddressInvalidList = [
    "Bank Address is invalid",
    "L'adresse de la banque n'est pas valide",
    "La dirección del banco no es válida",
    "O endereço do banco é inválido"
  ];

  TextEditingController rName = TextEditingController(),
      rMob = TextEditingController(),
      ifsc = TextEditingController(),
      accNo = TextEditingController(),
      bankName = TextEditingController(),
      bankAddress = TextEditingController();
  bool rNameVal = false,
      rMobVal = false,
      ifscVal = false,
      accNoVal = false,
      bankNameVal = false,
      bankAddressVal = false,
      addBeneficbool = false,
      otpLoading = false;
  String mobileNo, str_Otp, strBankName = "";

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool _isLoading = false;
  var isLoading = false;

  TextInputType changeKeyboardAppearence() {
    return ifsc.text.length < 5 ? TextInputType.text : TextInputType.number;
  }

  // SharedPreferences preferences = StaticValues.sharedPreferences;

  @override
  void setState(VoidCallback fn) {
    mobileNo = preferences?.getString(StaticValues.mobileNo) ?? "";
    // TODO: implement setState
    super.setState(fn);
  }

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

  void _beneficiaryConfirmation() {
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
        builder: (context, setState) => CustomRaisedIndigoButton(
            loadingValue: isLoading,
            // buttonText: isLoading?CircularProgressIndicator():"Add Beneficiary",
            buttonText: isLoading
                ? CircularProgressIndicator()
                : addBeneficiaryList[int.parse(languageId)],
            onPressed: isLoading
                ? null
                : () async {
                    if (_pass == str_Otp) {
                      addBeneficiary();
                    } else {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          // msg: "OTP Miss match",
                          msg: otpMissMatchList[int.parse(languageId)],
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }),
      ),
    );
  }

  Future<void> addBeneficiary() async {
    SharedPreferences preference = StaticValues.sharedPreferences;
    if (rName.text.isNotEmpty &&
        rMob.text.isNotEmpty &&
        ifsc.text.isNotEmpty &&
        accNo.text.isNotEmpty &&
        bankName.text.isNotEmpty &&
        bankAddress.text.isNotEmpty) {
      print("TRUE ::::");
      Map<String, String> params = {
        "CustId": preference.getString(StaticValues.custID),
        "reciever_name": rName.text,
        "reciever_mob": rMob.text,
        "reciever_ifsc": ifsc.text,
        "reciever_Accno": accNo.text,
        "BankName": bankName.text,
        "Receiver_Address": bankAddress.text
      };
      try {
        _isLoading = true;
        Map response = await RestAPI().get(APis.addBeneficiary(params));
        _isLoading = true;
        String status = response["Table"][0]["status"];
        GlobalWidgets().showSnackBar(_scaffoldKey, status);
        if (status == "Success") {
          Navigator.of(context).pop(true);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FundTransfer()));
        }
      } on RestException catch (e) {
        print(e.toString());
        // GlobalWidgets().showSnackBar(_scaffoldKey, "Something went wrong");
        GlobalWidgets().showSnackBar(
            _scaffoldKey, somethingWrongList[int.parse(languageId)]);
      }
    } else {
      print("FALSE ::::");
      // GlobalWidgets().showSnackBar(_scaffoldKey, "All fields are mandatory");
      GlobalWidgets().showSnackBar(
          _scaffoldKey, fieldsMandatoryList[int.parse(languageId)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        centerTitle: true,
        // title: Text("Add Beneficiary"),
        title: Text(addBeneficiaryList[int.parse(languageId)]),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                EditTextBordered(
                    controller: rName,
                    // hint: "Enter Receiver Name",
                    hint: enterReceiverNameList[int.parse(languageId)],
                    hintColor: Theme.of(context).secondaryHeaderColor,
                    borderColor: Theme.of(context).secondaryHeaderColor,
                    // errorText: rNameVal ? "Name is invalid" : null,
                    errorText: rNameVal
                        ? nameInvalidList[int.parse(languageId)]
                        : null,
                    textCapitalization: TextCapitalization.words,
                    onChange: (value) {
                      setState(() {
                        rNameVal = value.trim().length < 3;
                      });
                    }),
                SizedBox(
                  height: 12.0,
                ),
                EditTextBordered(
                    controller: rMob,
                    keyboardType: TextInputType.number,
                    // hint: "Enter Receiver Mobile no.",
                    hint: enterReceiverMobileList[int.parse(languageId)],
                    hintColor: Theme.of(context).secondaryHeaderColor,
                    borderColor: Theme.of(context).secondaryHeaderColor,
                    // errorText: rMobVal ? "Number is invalid" : null,
                    errorText: rMobVal
                        ? numberInvalidList[int.parse(languageId)]
                        : null,
                    onChange: (value) {
                      setState(() {
                        rMobVal = value.trim().length != 10;
                      });
                    }),
                SizedBox(
                  height: 12.0,
                ),
                EditTextBordered(
                    controller: ifsc,
                    keyboardType: changeKeyboardAppearence(),
                    // hint: "Enter MFI",
                    hint: enterMFIList[int.parse(languageId)],
                    hintColor: Theme.of(context).secondaryHeaderColor,
                    borderColor: Theme.of(context).secondaryHeaderColor,
                    // errorText: ifscVal ? "MFI is invalid" : null,
                    errorText:
                        ifscVal ? mfiInvalidList[int.parse(languageId)] : null,
                    textCapitalization: TextCapitalization.characters,
                    onChange: (value) {
                      setState(() {
                        ifscVal = value.trim().length != 11;
                      });
                    }),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      strBankName,
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                    InkWell(
                      onTap: () async {
                        var response = await RestAPI().post(
                            APis.getBeniBankDetails,
                            params: {"IfscCode": ifsc.text});

                        setState(() {
                          strBankName = response[0]["BeniBnkName"];
                        });

                        print("BANKNAME : $strBankName");

                        return;
                      },
                      // child: Text("Check",
                      child: Text(
                        checkList[int.parse(languageId)],
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                EditTextBordered(
                    controller: accNo,
                    keyboardType: TextInputType.number,
                    // hint: "Enter Account no.",
                    hint: enterAccNoList[int.parse(languageId)],
                    hintColor: Theme.of(context).secondaryHeaderColor,
                    borderColor: Theme.of(context).secondaryHeaderColor,
                    // errorText: accNoVal ? "Account number is invalid" : null,
                    errorText: accNoVal
                        ? accNoInvalidList[int.parse(languageId)]
                        : null,
                    onChange: (value) {
                      setState(() {
                        accNoVal = value.trim().length < 8;
                      });
                    }),
                SizedBox(
                  height: 12.0,
                ),
                EditTextBordered(
                    controller: bankName,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    // hint: "Enter Bank Name",
                    hint: enterBankNameList[int.parse(languageId)],
                    hintColor: Theme.of(context).secondaryHeaderColor,
                    borderColor: Theme.of(context).secondaryHeaderColor,
                    errorText: bankNameVal
                        ? bankNameInvalidList[int.parse(languageId)]
                        : null,
                    // errorText: bankNameVal ? "Bank Name is invalid" : null,
                    onChange: (value) {
                      setState(() {
                        bankNameVal = value.trim().length <= 0;
                      });
                    }),
                SizedBox(
                  height: 12.0,
                ),
                EditTextBordered(
                    controller: bankAddress,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    // hint: "Enter Bank Address",
                    hint: enterBankAddressList[int.parse(languageId)],
                    hintColor: Theme.of(context).secondaryHeaderColor,
                    borderColor: Theme.of(context).secondaryHeaderColor,
                    // errorText: bankAddressVal ? "Bank Address is invalid" : null,
                    errorText: bankAddressVal
                        ? bankAddressInvalidList[int.parse(languageId)]
                        : null,
                    onChange: (value) {
                      setState(() {
                        bankAddressVal = value.trim().length <= 0;
                      });
                    }),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: CustomRaisedIndigoButton(
              loadingValue: _isLoading,

              // buttonText:  otpLoading?CircularProgressIndicator():"Add Beneficiary",
              buttonText: otpLoading
                  ? CircularProgressIndicator()
                  : addBeneficiaryList[int.parse(languageId)],
              onPressed: () async {
                otpLoading = true;
                if (rName.text.isNotEmpty &&
                    rMob.text.isNotEmpty &&
                    ifsc.text.isNotEmpty &&
                    accNo.text.isNotEmpty &&
                    bankName.text.isNotEmpty &&
                    bankAddress.text.isNotEmpty) {
                  var response =
                      await RestAPI().post(APis.GenerateOTP, params: {
                    "MobileNo": mobileNo,
                    // "MobileNo": "7904308386",
                    "Amt": "0",
                    "SMS_Module": "GENERAL",
                    "SMS_Type": "GENERAL_OTP",
                    "OTP_Return": "Y"
                  });

                  print("rechargeResponse::: $response");
                  str_Otp = response[0]["OTP"];

                  setState(() {
                    otpLoading = false;
                    Timer(Duration(minutes: 5), () {
                      setState(() {
                        str_Otp = "";
                      });
                    });
                  });

                  _beneficiaryConfirmation();
                } else {
                  print("FALSE ::::");
                  // GlobalWidgets().showSnackBar(_scaffoldKey, "All fields are mandatory");
                  GlobalWidgets().showSnackBar(
                      _scaffoldKey, fieldsMandatoryList[int.parse(languageId)]);
                }

                /*           SharedPreferences preference = StaticValues.sharedPreferences;
                if (rName.text.isNotEmpty &&
                    rMob.text.isNotEmpty &&
                    ifsc.text.isNotEmpty &&
                    accNo.text.isNotEmpty &&
                    bankName.text.isNotEmpty &&
                    bankAddress.text.isNotEmpty) {
                  print("TRUE ::::");
                  Map<String, String> params = {
                    "CustId": preference.getString(StaticValues.custID),
                    "reciever_name": rName.text,
                    "reciever_mob": rMob.text,
                    "reciever_ifsc": ifsc.text,
                    "reciever_Accno": accNo.text,
                    "BankName": bankName.text,
                    "Receiver_Address": bankAddress.text
                  };
                  try {
	                  _isLoading = true;
                    Map response = await RestAPI().get(APis.addBeneficiary(params));
	                  _isLoading = true;
                    String status =  response["Table"][0]["status"];
                    GlobalWidgets().showSnackBar(_scaffoldKey, status);
                    if(status == "Success"){
                      Navigator.of(context).pop(true);
                    }
                  } on RestException catch (e) {
                    print(e.toString());
                    GlobalWidgets().showSnackBar(_scaffoldKey, "Something went wrong");
                  }
                } else {
                  print("FALSE ::::");
                  GlobalWidgets().showSnackBar(_scaffoldKey, "All fields are mandatory");
                }*/
              },
            ),
          ),
        ],
      ),
    );
  }
}
