import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/GlobalWidgets.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AccountNoModel.dart';
import 'DurationModel.dart';
import 'SchemeModel.dart';

class AccountOpening extends StatefulWidget {
  final String _accNo, _balance, _accType;
  AccountOpening(this._accNo, this._balance, this._accType) : super();

  @override
  _AccountOpeningState createState() => _AccountOpeningState();
}

class _AccountOpeningState extends State<AccountOpening> {
  String str_PrincipalAmnt = "", str_Month = "", str_Day = "";
  String str_Otp = "", mobileNo;
  var isLoading = false;

  var _formKey = GlobalKey<FormState>();

  final dateController = TextEditingController();
  final meturityAmnt = TextEditingController();
  final depositAmntCtrl = TextEditingController();
  // final monthCtrl = TextEditingController();
  var monthCtrl;
  final dayCtrl = TextEditingController();
  final dayCtrl1 = TextEditingController(text: "0");

  var _fruits = <AccountNumber>[];
  var _scheme = <AccountScheme>[];
  var _scheme1 = ["CLOSE ENDED", "OPEN ENDED"];
  var _scheme2;
  var _scheme3 = <String>["36", "60"];
  //items: <String>['12', '24', '60']
  //static const List<String> _scheme3 = <String>["12","24","36","60"];

  // String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = ["12", "24", "36", "60"];
  // String dropdownValue = '12';
  String dropdownValue;

  var _duration = <DurationModel>[];
  var _selectedAccNo, _selectedScheme, _selectedDuration, _accNo;

  bool _isLoadingSave = false;
  bool _isLoadingAccNo = false;
  bool _isLoadingScheme = false;
  bool _isLoadingDuration = false;

  String url1 = "${APis.DebitAccOpen}";

  String str_mnthCtrl = "0", str_dayCtrl = "0";

  String str_Slab = "", str_Period = "", str_IntRate = "";

  String str_accNo,
      str_schemeCode,
      str_schemeName,
      str_duration = "",
      str_accType;

  String url = "${APis.DebitAccOpen}";
  String balance_url = "${APis.AccNoByAccBal}";
  String scheme_url = "${APis.SchCodeBySchemeType}";

// String scheme_intrest_url = "http://Azure-demo2.safeandsmartbank.com:6544/SchCodeByIntRate_T_Select";
  String scheme_intrest_url = "${APis.Fill_FDDepIntRateMatDtMatAmt}";
  String scheme_intrest_rd_url = "${APis.DepSlabChartIntRateMatDtMatAmt}";
  String scheme_intrest_ud_url = "${APis.UTDepIntRateMatDtMatAmt}";
  String scheme_intrest_mis_url = "${APis.MISDepIntRateMatDtMatAmt}";
  String duration_url = "${APis.PickUp_N_Select_All}";
  String save_acc_open_url = "${APis.Save_FD_AccOpen}";
  String save_acc_open_rd_url = "${APis.Save_RD_AccOpen}";
  String save_acc_ud_url = "${APis.Save_UT_AccOpen}";
  String save_acc_mis_url = "${APis.Save_MIS_AccOpen}";
  String save_acc_open_dd_url = "${APis.Save_DD_AccOpen}";
  String get_slab_url = "${APis.FDSlabInterestChart}";
  String get_slab_rd_url = "${APis.DepSlabChartIntRateMatDtMatAmt}";
  String get_slab_ud_url = "${APis.UTSlabInterestChart}";
  String get_slab_mis_url = "${APis.MISSlabInterestChart}";
  String get_otp_accopen = "${APis.GenerateOTP}";

  /* String url = "http://Azure-demo2.safeandsmartbank.com:6544/DebitAccOpen_T_Select";
  String balance_url = "http://Azure-demo2.safeandsmartbank.com:6544/AccNoByAccBal_T_Select";
  String scheme_url = "http://Azure-demo2.safeandsmartbank.com:6544/SchCodeBySchemeType_T_Select";
 // String scheme_intrest_url = "http://Azure-demo2.safeandsmartbank.com:6544/SchCodeByIntRate_T_Select";
 String scheme_intrest_url = "http://Azure-demo2.safeandsmartbank.com:6544/Fill_FDDepIntRateMatDtMatAmt";
 String scheme_intrest_rd_url = "http://Azure-demo2.safeandsmartbank.com:6544/Fill_DepSlabChartIntRateMatDtMatAmt";
 String scheme_intrest_ud_url = "http://Azure-demo2.safeandsmartbank.com:6544/Fill_UTDepIntRateMatDtMatAmt";
 String scheme_intrest_mis_url = "http://Azure-demo2.safeandsmartbank.com:6544/Fill_MISDepIntRateMatDtMatAmt";
  String duration_url = "http://Azure-demo2.safeandsmartbank.com:6544/PickUp_N_Select_All";
  String save_acc_open_url = "http://Azure-demo2.safeandsmartbank.com:6544/Save_FD_AccOpen";
  String save_acc_open_rd_url = "http://Azure-demo2.safeandsmartbank.com:6544/Save_RD_AccOpen";
  String save_acc_ud_url = "http://Azure-demo2.safeandsmartbank.com:6544/Save_UT_AccOpen";
  String save_acc_mis_url = "http://Azure-demo2.safeandsmartbank.com:6544/Save_MIS_AccOpen";
  String save_acc_open_dd_url = "http://Azure-demo2.safeandsmartbank.com:6544/Save_DD_AccOpen";
  String get_slab_url = "http://Azure-demo2.safeandsmartbank.com:6544/Fill_FDSlabInterestChart";
  String get_slab_rd_url = "http://Azure-demo2.safeandsmartbank.com:6544/Fill_DepSlabChartIntRateMatDtMatAmt";
  String get_slab_ud_url = "http://Azure-demo2.safeandsmartbank.com:6544/Fill_UTSlabInterestChart";
  String get_slab_mis_url = "http://Azure-demo2.safeandsmartbank.com:6544/Fill_MISSlabInterestChart";
  String get_otp_accopen = "http://Azure-demo2.safeandsmartbank.com:6544/GenerateOTP";*/

  List<AccountNumber> getAccount = [];
  List<AccountScheme> getSchemeList = [];
  List<DurationModel> getDurationList = [];
  SharedPreferences preferences;

  var balance = "";
  var intr_rate = "";
  var maturity_Date = "";
  var maturity_Amnt = "";
  var interest_Payout = "";
  var principal_Payout = "";
  bool _schemeSelect = true;
  bool monVal = false;

  int _radioSelected = 1;
  String _radioVal = "0";
  bool _accTerms;

  var languageId = "";
  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> enterOTPList = [
    "Enter OTP",
    "Entrez OTP",
    "Ingresar OTP",
    "Digite OTP"
  ];
  List<String> otpMissMatch = [
    "OTP Miss Match",
    "OTP Miss Match",
    "OTP señorita partido",
    "Match manqué OTP"
  ];
  List<String> saveList = ["Save", "Sauver", "salvar", "Salve"];
  List<String> plsFillMissingFieldsList = [
    "Please fill the missing fields",
    "Veuillez remplir les champs manquants",
    "Por favor complete los campos que faltan",
    "Por favor, preencha os campos que faltam"
  ];
  List<String> valueNot0List = [
    "Value not be 0",
    "La valeur ne doit pas être 0",
    "Valor no ser 0	O",
    "valor não pode ser 0"
  ];
  List<String> plsAcceptTermsConditionsList = [
    "Please Accept Terms and Conditions",
    "Veuillez accepter les termes et conditions",
    "Por favor, acepte los términos y condiciones",
    "Aceite os Termos e Condições"
  ];
  List<String> amtShouldLessThanAccBalList = [
    "Amount Should be less than your Account Balance",
    "Le montant doit être inférieur au solde de votre compte",
    "El monto debe ser menor que el saldo de su cuenta",
    "O valor deve ser menor que o saldo da sua conta"
  ];
  List<String> accOpeningList = [
    "Account Opening",
    "Ouverture de compte",
    "Apertura de cuenta",
    "Abertura de conta"
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
  List<String> accNoList = [
    "Account Number",
    "numéro de compte",
    "número de cuenta",
    "número da conta"
  ];
  List<String> openEndedFdMisAllowed6MonthsCloseEndedNotAllowedList = [
    "IN OPEN ENDED FD & MIS PRE CLOSURE ALLOWED ONLY AFTER 6 MONTHS,IN CLOSE ENDED FD & MIS PRE CLOSURE NOT ALLOWED",
    "DANS LA PRÉ-FERMETURE FD & MIS OUVERTE AUTORISÉE UNIQUEMENT APRÈS 6 MOIS, DANS LA PRÉ-FERMETURE FD & MIS FERMÉE NON AUTORISÉE",
    "EN ABIERTO FD Y MIS PRE CIERRE PERMITIDO SÓLO DESPUÉS DE 6 MESES, EN CERRADO FD Y MIS PRE CIERRE NO PERMITIDO",
    "EM FD ABERTO E PRÉ FECHAMENTO MIS PERMITIDO SOMENTE DEPOIS DE 6 MESES, EM FD FECHADO E PRÉ FECHAMENTO MIS NÃO PERMITIDO"
  ];
  List<String> closeEndedProductNotAllowedMaturityList = [
    "CLOSE ENDED PRODUCT PRE CLOSURE NOT ALLOWED BEFORE MATURITY.",
    "PRODUIT FERMÉ LA PRÉ-FERMETURE N'EST PAS AUTORISÉE AVANT L'ÉCHÉANCE.",
    "PRODUCTO CERRADO PRE CIERRE NO PERMITIDO ANTES DEL VENCIMIENTO.",
    "PRÉ FECHAMENTO DE PRODUTO FECHADO NÃO PERMITIDO ANTES DO VENCIMENTO."
  ];
  List<String> schemeList = ["Scheme", "Schème", "Esquema", "Esquema"];
  List<String> selectSchemeList = [
    "Select Scheme",
    "Sélectionnez le régime",
    "Seleccionar esquema",
    "Selecione o Esquema"
  ];
  List<String> slabList = ["Slab", "Dalle", "Losa", "Laje"];
  List<String> periodList = ["Period", "Période", "Período", "Período"];
  List<String> interestRateList = [
    "Interest Rate",
    "Taux d'intérêt",
    "Tasa de interés",
    "Taxa de juro"
  ];
  List<String> depositAmountList = [
    "Deposit Amount",
    "Montant du dépôt",
    "Cantidad del depósito",
    "Valor do depósito"
  ];
  List<String> notEnoughBalList = [
    "Not Enough Balance",
    "Pas assez d'équilibre",
    "No hay suficiente equilibrio",
    "Saldo Insuficiente"
  ];
  List<String> monthList = ["Month", "Mois", "Mes", "Mês"];
  List<String> dayList = ["Day", "Jour", "Día", "Dia"];
  List<String> durationList = ["Duration", "Durée", "Duración", "Duração"];
  List<String> selectDurationList = [
    "Select Duration",
    "Sélectionnez la durée",
    "Seleccionar duración",
    "Selecione a duração"
  ];
  List<String> installmentDateList = [
    "Installment Date",
    "Date de versement",
    "Fecha de pago",
    "Data de parcelamento"
  ];
  List<String> amtShouldLessThanAccBalAmt5000List = [
    "Amount Should be less than your Account Balance & Min FD Amount is 5000",
    "Le montant doit être inférieur au solde de votre compte et le montant minimum FD est de 5000",
    "El monto debe ser menor que el saldo de su cuenta y el monto mínimo de FD es 5000",
    "O valor deve ser menor que o saldo da sua conta e o valor mínimo do FD é 5.000"
  ];
  List<String> noActiveSchemeFoundList = [
    "No Active Scheme Found",
    "Aucun schéma actif trouvé",
    "No se encontró ningún esquema activo",
    "Nenhum Esquema Ativo Encontrado"
  ];
  List<String> fetchMaturityDateAmtList = [
    "Fetch Maturity Date and Amount",
    "Extraire la date d'échéance et le montant",
    "Obtener fecha de vencimiento e importe",
    "Buscar data de vencimento e valor"
  ];
  List<String> standingList = ["Standing", "Debout", "De pie", "De pé"];
  List<String> allowList = ["Allow", "Permettre", "Permitir", "Permitir"];
  List<String> denyList = ["Deny", "Refuser", "Denegar", "Negar"];
  List<String> maturityDateList = [
    "Maturity Date",
    "Date d'échéance",
    "Fecha de vencimiento",
    "Data de Vencimento"
  ];
  List<String> totalAmtPayableList = [
    "Total Amount Payable",
    "Montant total a payer",
    "Importe total a pagar",
    "Valor total a pagar"
  ];
  List<String> maturityAmtList = [
    "Maturity Amount",
    "Montant à l'échéance",
    "Monto de vencimiento",
    "Valor de Vencimento"
  ];
  List<String> interestPayoutList = [
    "Interest Payout",
    "Paiement des intérêts",
    "Pago de intereses",
    "Pagamento de Juros"
  ];
  List<String> monthlyPayoutList = [
    "Monthly Payout",
    "Versement mensuel",
    "Pago Mensual",
    "Pagamento Mensal"
  ];
  List<String> iAcceptTermsConditionsList = [
    "I Accept the terms and conditions",
    "J'accepte les termes et conditions",
    "Acepto los términos y condiciones",
    "Eu aceito os termos e condições"
  ];
  List<String> maturityAmtBeforeTDSList = [
    "Maturity Amount Before TDS",
    "Montant à l'échéance avant TDS",
    "Monto de vencimiento antes de TDS",
    "Valor de vencimento antes do TDS"
  ];
  List<String> tdsDeductIfApplicableList = [
    "TDS will Deduct if Applicable",
    "TDS déduira le cas échéant",
    "TDS deducirá si corresponde",
    "A TDS deduzirá se aplicável"
  ];
  // List<String> List = ["","","",""];
  // List<String> List = ["","","",""];

  void loadData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      // userId = preferences?.getString(StaticValues.custID) ?? "";
      mobileNo = preferences?.getString(StaticValues.mobileNo) ?? "";
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";

      print("MOBNO : $mobileNo");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAccNo();
    //  getBalance();
    getScheme();
    //  getIntrestRate();
    getDuration();
    loadData();

    str_accNo = widget._accNo;
    str_accType = widget._accType;

    _scheme2 = widget._accType == "FD"
        ? <String>["12", "24"]
        : widget._accType == "RD"
            ? <String>["12", "24"]
            : widget._accType == "DD"
                ? <String>["12", "24"]
                : <String>["12", "24"];
    dropdownValue = widget._accType == "FD"
        ? "12"
        : widget._accType == "RD"
            ? "12"
            : widget._accType == "DD"
                ? "12"
                : "12";

    preferences = StaticValues.sharedPreferences;

    setState(() {
      /* mobileNo = preferences?.getString(StaticValues.mobileNo) ?? "";

      print("MOBNO : $mobileNo");*/

      _accTerms = false;
      monthCtrl = str_accType == "UNNATI"
          ? TextEditingController(text: "36")
          : TextEditingController();
    });

    //getIntrestRate();
  }

  Future<List<AccountNumber>> getAccNo() async {
    setState(() {
      _isLoadingAccNo = true;
    });

    var response = await http.post(Uri.parse(url),
        headers: {"Accept": "Application/json"}, body: {"Cust_Id": "1"});
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

  Future<List<DurationModel>> getDuration() async {
    setState(() {
      _isLoadingDuration = true;
    });
    var response1 = await http.post(Uri.parse(duration_url),
        headers: {"Accept": "application/json"},
        body: {"Pkc_Type": "44", "Pkc_ParentId": "0"});

    print("REQ : ${url}");
    setState(() {
      getDurationList = durationModelFromJson(response1.body);
      _duration.addAll(getDurationList);
      _isLoadingDuration = false;
    });
    return getDurationList;
  }

  Future<void> getSlabFD() async {
    /*var response = await http.post(Uri.parse(get_slab_url),
        headers: {
          "Accept" : "application/json"
        },
        body: {
          //  "SchCode": str_schemeCode
          "SchCode": str_schemeCode,
          "Acc_No":str_accNo,
          "Month": monthCtrl.text,
          "Day": dayCtrl.text,

        });*/

    var response = await RestAPI().post(get_slab_url, params: {
      // "SchCode": str_schemeCode,
      "SchCode": "",
      "Acc_No": str_accNo,
      // "Month": monthCtrl.text,
      "Month": dropdownValue,
      //"Day": dayCtrl.text,
      "Day": "",
    });

    setState(() {
      //  var listData = json.decode(response.body);
      var listData = response;

      str_Slab = listData[0]["Slab"];
      str_Period = listData[0]["Period"];
      str_IntRate = listData[0]["IntRate"];

      print("RESPONSE: ${listData.toString()}");
    });
    return;
  }

  Future<void> getSlabRD() async {
    /*var response = await http.post(Uri.parse(get_slab_rd_url),

        headers: {
          "Accept" : "application/json"
        },
        body: {
          //  "SchCode": str_schemeCode
          "Type": str_accType,
          "Acc_No":str_accNo,
          "Amount":depositAmntCtrl.text,
          "PeriodMonth": monthCtrl.text,
          "PeriodDay": dayCtrl.text,



        });*/

    var response = await RestAPI().post(get_slab_rd_url, params: {
      "Type": str_accType,
      "Acc_No": str_accNo,
      "Amount": depositAmntCtrl.text,
      //  "PeriodMonth": monthCtrl.text,
      "PeriodMonth": dropdownValue,
      // "PeriodDay": dayCtrl.text,
      "PeriodDay": "",
    });
    print(get_slab_rd_url);
    print(str_accType);
    print(str_accNo);
    print(depositAmntCtrl.text);
    print(monthCtrl.text);
    print(dayCtrl.text);

    setState(() {
      var listData = response;

      str_Slab = listData[0]["Slab"];
      str_Period = listData[0]["Period"];
      str_IntRate = listData[0]["IntRate"];

      print(str_Period);
    });
    return;
  }

  Future<void> getSlabUD() async {
    /*  var response = await http.post(Uri.parse(get_slab_ud_url),
        headers: {
          "Accept" : "application/json"
        },
        body: {
          //  "SchCode": str_schemeCode

          "Month": monthCtrl.text
          //  "Month": "12"




        });*/
    var response = await RestAPI().post(get_slab_ud_url, params: {
      // "Month": monthCtrl.text
      "Month": dropdownValue
    });
    setState(() {
      var listData = response;

      str_Slab = listData[0]["Slab"];
      str_Period = listData[0]["Period"];
      str_IntRate = listData[0]["IntRate"];

      print("Lijith : ${listData}");
    });
    return;
  }

  Future<void> getSlabMIS() async {
    /* var response = await http.post(Uri.parse(get_slab_mis_url), headers: {
      "Accept": "application/json"
    }, body: {
      //  "SchCode": str_schemeCode

      "Acc_No": str_accNo,
      "SchCode": str_schemeCode,
      "Month": monthCtrl.text

      //  "Month": "12"
    });*/
    var response = await RestAPI().post(get_slab_mis_url, params: {
      "Acc_No": str_accNo,
      // "SchCode": str_schemeCode,
      "SchCode": "",
      //  "Month": monthCtrl.text
      "Month": dropdownValue
    });
    setState(() {
      var listData = response;

      str_Slab = listData[0]["Slab"];
      str_Period = listData[0]["Period"];
      str_IntRate = listData[0]["IntRate"];

      print("Lijith : ${listData}");
    });
    return;
  }

  Future<String> getIntrestRate() async {
    /*  var response = await http.post(Uri.parse(scheme_intrest_url), headers: {
      'Accept': 'application/json',
    }, body: {
      */ /* "SchCode": str_schemeCode,
      "Month": monthCtrl.text,
     // "Day": dayCtrl.text,
     "Day": "1",
      "Principle": depositAmntCtrl.text,*/ /*

      "Acc_No": str_accNo,
      "SchCode": str_schemeCode,
      "Month": monthCtrl.text,
      "Day": dayCtrl.text,
      "Principle": depositAmntCtrl.text,

      */ /*  "SchCode": str_schemeCode,
     // "SchCode": "1111",
       "Month": "12",
       "Day": "1",
       "Principle": "5000"*/ /*
    });*/
    var response = await RestAPI().post(scheme_intrest_url, params: {
      "Acc_No": str_accNo,
      "SchCode": "",
      // "Month": monthCtrl.text,
      "Month": dropdownValue,
      // "Day": dayCtrl.text,
      "Day": "",
      "Principle": depositAmntCtrl.text,
    });
    //  print(response.body);
    setState(() {
      var dataList = response;
      print(dataList.toString());
      intr_rate = dataList[0]["IntRate"];
      maturity_Date = dataList[0]["MaturityDate"];
      maturity_Amnt = dataList[0]["MaturityAmt"];
    });
  }

  Future<String> getIntrestRateRD() async {
    /*var response = await http.post(Uri.parse(scheme_intrest_rd_url), headers: {
      'Accept': 'application/json',
    }, body: {
      "Acc_No": str_accNo,
      "Type": str_accType,
      "Amount": depositAmntCtrl.text,
      "PeriodMonth": monthCtrl.text,
      "PeriodDay": dayCtrl.text
    });
    print(response.body);*/
    var response = await RestAPI().post(scheme_intrest_rd_url, params: {
      "Acc_No": str_accNo,
      "Type": str_accType,
      "Amount": depositAmntCtrl.text,
      // "PeriodMonth": monthCtrl.text,
      "PeriodMonth": dropdownValue,
      // "PeriodDay": dayCtrl.text
      "PeriodDay": ""
    });
    setState(() {
      var dataList = response;
      print(dataList.toString());
      intr_rate = dataList[0]["CalIntRate"];
      maturity_Date = dataList[0]["MaturityDate"];
      maturity_Amnt = dataList[0]["MaturityAmt"];
    });
  }

  Future<String> getIntrestRateUD() async {
    /*  var response = await http.post(Uri.parse(scheme_intrest_ud_url), headers: {
      'Accept': 'application/json',
    }, body: {
      "Acc_No": str_accNo,
      "Principle": depositAmntCtrl.text,
      "Month": monthCtrl.text,
    });*/
    var response = await RestAPI().post(scheme_intrest_ud_url, params: {
      "Acc_No": str_accNo,
      "Principle": depositAmntCtrl.text,
      // "Month": monthCtrl.text,
      "Month": dropdownValue,
    });
    print("REQ : ${Uri.parse(scheme_intrest_ud_url)}");
    print("REQ1 : ${depositAmntCtrl.text}");
    print("REQ2 : ${monthCtrl.text}");
    print(response.body);
    setState(() {
      var dataList = response;
      print(dataList.toString());
      intr_rate = dataList[0]["IntRate"];
      maturity_Date = dataList[0]["MaturityDate"];
      maturity_Amnt = dataList[0]["MaturityAmt"];
      interest_Payout = dataList[0]["TotPayout"];
      // principal_Payout = dataList[0]["TotPayout"];
    });
  }

  Future<String> getIntrestRateMIS() async {
    /*   var response = await http.post(Uri.parse(scheme_intrest_mis_url), headers: {
      'Accept': 'application/json',
    }, body: {
      "Acc_No": str_accNo,
      "SchCode": str_schemeCode,
      "Month": monthCtrl.text,
      "Principle": depositAmntCtrl.text
    });*/
    var response = await RestAPI().post(scheme_intrest_mis_url, params: {
      "Acc_No": str_accNo,
      "SchCode": "",
      // "Month": monthCtrl.text,
      "Month": dropdownValue,
      "Principle": depositAmntCtrl.text
    });
    print(str_accNo +
        "-" +
        str_schemeCode +
        "-" +
        monthCtrl.text +
        "-" +
        depositAmntCtrl.text);
    print(response.body);
    setState(() {
      var dataList = response;
      print(dataList.toString());
      intr_rate = dataList[0]["IntRate"];
      maturity_Date = dataList[0]["MaturityDate"];
      maturity_Amnt = dataList[0]["MaturityAmt"];
      interest_Payout = dataList[0]["IntPayout"];
    });
  }

  Future<List<AccountScheme>> getScheme() async {
    setState(() {
      _isLoadingScheme = true;
    });
    var response = await http.post(Uri.parse(scheme_url), headers: {
      "Accept": "application/json"
    }, body: {
      "SchemeType": widget._accType
      // "SchemeType": "FD"
    });
    print("REQ : ${Uri.parse(scheme_url)}");
    print("REQ1 : ${widget._accType}");
    print("LIJU111 : ${response.body}");
    setState(() {
      monthCtrl.text == "36";
      //  getSchemeList = accountSchemeFromJson(response.body);
      getSchemeList = accountSchemeFromJson(
          "[{\"Sch_Code\":\"1\",\"Sch_Name\":\"OPEN ENDED\"},{\"Sch_Code\":\"2\",\"Sch_Name\":\"CLOSE ENDED\"}]");
      //  _scheme.addAll(getSchemeList);
      _scheme.addAll(getSchemeList);
      _isLoadingScheme = false;
    });
    return getSchemeList;
  }

  Future<String> getBalance() async {
    /* var accBalance = await http.post(Uri.parse(balance_url), headers: {
      "Accept": "application/json",
    }, body: {
      //  "Acc_No": "101001000000001"

      "Acc_No": str_accNo
    });*/
    var accBalance =
        await RestAPI().post(balance_url, params: {"Acc_No": str_accNo});
    var listData = accBalance;
    setState(() {
      balance = listData[0]["AccBal"];
      print(balance);
    });
  }

  Future<String> saveAccountsFD() async {
    setState(() {
      _isLoadingSave = true;

      // str_mnthCtrl = monthCtrl.text == "" ? "0" : monthCtrl.text;
      str_mnthCtrl = dropdownValue == "" ? "0" : dropdownValue;
      str_dayCtrl = dayCtrl.text == "" ? "0" : dayCtrl.text;
    });

    /*   var saveResponse = await http.post(Uri.parse(save_acc_open_url), headers: {
      "Accept": "application/json"
    }, body: {
      "DebitAccNo": str_accNo,
      //  "DebitAccNo": "11111111111",
      "DepAmt": depositAmntCtrl.text,
      "Scheme": str_schemeCode,
      "IntRate": intr_rate,
      "Month": str_mnthCtrl,
      "Day": str_dayCtrl,
      "MatuDate": maturity_Date,
      "MatuAmt": maturity_Amnt,
      "Permit": _radioVal

      */ /*    "DebitAccNo": "11111111111",
        "DepAmt": "5000",
        "Scheme": "111",
        "IntRate": "10",
        "Month": "12",
        "Day": "0",
        "PayMode": "420",
        "MatuDate": "05/16/2022",
        "MatuAmt": "5500"*/ /*
    });*/

    var saveResponse = await RestAPI().post(save_acc_open_url, params: {
      "DebitAccNo": str_accNo,
      //  "DebitAccNo": "11111111111",
      "DepAmt": depositAmntCtrl.text,
      // "Scheme": str_schemeCode,
      "Scheme": "",
      "IntRate": intr_rate,
      "Month": str_mnthCtrl,
      "Day": str_dayCtrl,
      "MatuDate": maturity_Date,
      "MatuAmt": maturity_Amnt,
      "Permit": _radioVal
    });
    print("LIJU" + str_dayCtrl);
    print("LIJU1" + str_mnthCtrl);

    setState(() {
      _isLoadingSave = false;
      var accOpenList = saveResponse;
      var statusCode = accOpenList[0]["STATUSCODE"].toString();
      var status = accOpenList[0]["STATUS"];

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(status),
      ));

      if (statusCode == "1") {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) => AccountOpenHome()));
        /* Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => AccountOpenHome()));*/
        // Navigator.of(context).pushReplacementNamed("/MainPage");
        Navigator.of(context).pushReplacementNamed("/HomePage");
      }

      print("LJTSTATUS" + statusCode);
    });
  }

  Future<String> saveAccountsUD() async {
    setState(() {
      _isLoadingSave = true;

      // str_mnthCtrl = monthCtrl.text == "" ? "0" : monthCtrl.text;
      str_mnthCtrl = dropdownValue == "" ? "0" : dropdownValue;
      str_dayCtrl = dayCtrl.text == "" ? "0" : dayCtrl.text;
    });

    var saveResponse = await http.post(Uri.parse(save_acc_ud_url), headers: {
      "Accept": "application/json"
    }, body: {
      "DebitAccNo": str_accNo,
      //  "DebitAccNo": "11111111111",
      "DepAmt": depositAmntCtrl.text,

      "IntRate": intr_rate,
      "Month": str_mnthCtrl,
      "Day": str_dayCtrl,

      "MatuDate": maturity_Date,
      "MatuAmt": maturity_Amnt,
      "Permit": _radioVal

      /*    "DebitAccNo": "11111111111",
        "DepAmt": "5000",
        "Scheme": "111",
        "IntRate": "10",
        "Month": "12",
        "Day": "0",
        "PayMode": "420",
        "MatuDate": "05/16/2022",
        "MatuAmt": "5500"*/
    });
    print("LIJU" + str_dayCtrl);
    print("LIJU1" + str_mnthCtrl);

    setState(() {
      _isLoadingSave = false;
      var accOpenList = json.decode(saveResponse.body);
      var statusCode = accOpenList[0]["STATUSCODE"].toString();
      var status = accOpenList[0]["STATUS"];

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(status),
      ));

      if (statusCode == "1") {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) => AccountOpenHome()));
        /* Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => AccountOpenHome()));*/
        Navigator.of(context).pushReplacementNamed("/MainPage");
      }

      print("LJTSTATUS" + statusCode);
    });
  }

  Future<String> saveAccountsMIS() async {
    setState(() {
      _isLoadingSave = true;

      // str_mnthCtrl = monthCtrl.text == "" ? "0" : monthCtrl.text;
      str_mnthCtrl = dropdownValue == "" ? "0" : dropdownValue;
      str_dayCtrl = dayCtrl.text == "" ? "0" : dayCtrl.text;
    });

    var saveResponse = await http.post(Uri.parse(save_acc_mis_url), headers: {
      "Accept": "application/json"
    }, body: {
      "DebitAccNo": str_accNo,
      //  "DebitAccNo": "11111111111",
      "DepAmt": depositAmntCtrl.text,
      //  "Scheme": str_schemeCode,
      "Scheme": "",

      "IntRate": intr_rate,
      "Month": str_mnthCtrl,
      "Day": str_dayCtrl,

      "MatuDate": maturity_Date,
      "MatuAmt": maturity_Amnt,
      "Permit": _radioVal

      /*    "DebitAccNo": "11111111111",
        "DepAmt": "5000",
        "Scheme": "111",
        "IntRate": "10",
        "Month": "12",
        "Day": "0",
        "PayMode": "420",
        "MatuDate": "05/16/2022",
        "MatuAmt": "5500"*/
    });
    print("LIJU" + str_dayCtrl);
    print("LIJU1" + str_mnthCtrl);

    setState(() {
      _isLoadingSave = false;
      var accOpenList = json.decode(saveResponse.body);
      var statusCode = accOpenList[0]["STATUSCODE"].toString();
      var status = accOpenList[0]["STATUS"];

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(status),
      ));

      if (statusCode == "1") {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) => AccountOpenHome()));
        /* Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => AccountOpenHome()));*/
        Navigator.of(context).pushReplacementNamed("/MainPage");
      }

      print("LJTSTATUS" + statusCode);
    });
  }

  Future<String> saveAccountsSB() async {
    setState(() {
      _isLoadingSave = true;

      // str_mnthCtrl = monthCtrl.text == "" ? "0" : monthCtrl.text;
      str_mnthCtrl = dropdownValue == "" ? "0" : dropdownValue;
      str_dayCtrl = dayCtrl.text == "" ? "0" : dayCtrl.text;
    });

    var saveResponse = await http.post(Uri.parse(save_acc_mis_url), headers: {
      "Accept": "application/json"
    }, body: {
      "DebitAccNo": str_accNo,
      //  "DebitAccNo": "11111111111",
      "DepAmt": depositAmntCtrl.text,
      //  "Scheme": str_schemeCode,
      "Scheme": "",

      "IntRate": "",
      "Month": "",
      "Day": "",

      "MatuDate": "",
      "MatuAmt": "",
      "Permit": ""

      /*    "DebitAccNo": "11111111111",
        "DepAmt": "5000",
        "Scheme": "111",
        "IntRate": "10",
        "Month": "12",
        "Day": "0",
        "PayMode": "420",
        "MatuDate": "05/16/2022",
        "MatuAmt": "5500"*/
    });
    print("LIJU" + str_dayCtrl);
    print("LIJU1" + str_mnthCtrl);

    setState(() {
      _isLoadingSave = false;
      var accOpenList = json.decode(saveResponse.body);
      var statusCode = accOpenList[0]["STATUSCODE"].toString();
      var status = accOpenList[0]["STATUS"];

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(status),
      ));

      if (statusCode == "1") {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) => AccountOpenHome()));
        /* Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => AccountOpenHome()));*/
        Navigator.of(context).pushReplacementNamed("/MainPage");
      }

      print("LJTSTATUS" + statusCode);
    });
  }

  Future<String> saveAccountsRD() async {
    setState(() {
      _isLoadingSave = true;
    });

    var saveResponse =
        await http.post(Uri.parse(save_acc_open_rd_url), headers: {
      "Accept": "application/json"
    }, body: {
      "DebitAccNo": str_accNo,
      //  "DebitAccNo": "11111111111",
      "DepAmt": depositAmntCtrl.text,
      // "Scheme": str_schemeCode,
      // "IntRate": intr_rate,
      "IntRate": "",
      //  "Month": monthCtrl.text,
      // "Month": dropdownValue,
      "Month": "",
      //  "Day": str_dayCtrl,
      /*"ContDate": dateController.text,
      "MatuDate": maturity_Date,
      "MatuAmt": maturity_Amnt,
      "Permit": _radioVal*/
      "ContDate": "",
      "MatuDate": "",
      "MatuAmt": "",
      "Permit": ""

      /*  "DebitAccNo": "11111111111",
        "DepAmt": "5000",
        "Scheme": "111",
        "IntRate": "10",
        "Month": "12",
        "Day": "0",
        "PayMode": "420",
        "MatuDate": "05/16/2022",
        "MatuAmt": "5500"*/
    });
    //print("LIJU"+str_accNo+"-"+depositAmntCtrl.text+"-"+intr_rate+"-"+str_mnthCtrl+"-"+dateController.text+"-"+maturity_Date+"-"+maturity_Amnt);

    setState(() {
      _isLoadingSave = false;
      var accOpenList = json.decode(saveResponse.body);
      var statusCode = accOpenList[0]["STATUSCODE"].toString();
      var status = accOpenList[0]["STATUS"];

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(status),
      ));

      if (statusCode == "1") {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        /* Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => AccountOpenHome()));*/
        //  Navigator.of(context).pushReplacementNamed("/MainPage");
        Navigator.of(context).pushReplacementNamed("/HomePage");
      }

      print("LJT" + status);
    });
  }

  Future<String> saveAccountsCA() async {
    setState(() {
      _isLoadingSave = true;
    });
    Map<String, String> params = {
      "custId": "",
      "accNo": str_accNo,
      "amount": depositAmntCtrl.text
    };

    var saveResponse = await RestAPI().get(
      APis.saveCAAccount(params),
    );
    /*  await http.post(Uri.parse(save_acc_open_rd_url), headers: {
      "Accept": "application/json"
    }, body: {
      "DebitAccNo": str_accNo,
      //  "DebitAccNo": "11111111111",
      "DepAmt": depositAmntCtrl.text,
      // "Scheme": str_schemeCode,
      // "IntRate": intr_rate,
      "IntRate": "",
      //  "Month": monthCtrl.text,
      // "Month": dropdownValue,
      "Month": "",
      //  "Day": str_dayCtrl,
      */ /*"ContDate": dateController.text,
      "MatuDate": maturity_Date,
      "MatuAmt": maturity_Amnt,
      "Permit": _radioVal*/ /*
      "ContDate": "",
      "MatuDate": "",
      "MatuAmt": "",
      "Permit": ""

      */ /*  "DebitAccNo": "11111111111",
        "DepAmt": "5000",
        "Scheme": "111",
        "IntRate": "10",
        "Month": "12",
        "Day": "0",
        "PayMode": "420",
        "MatuDate": "05/16/2022",
        "MatuAmt": "5500"*/ /*
    });*/
    //print("LIJU"+str_accNo+"-"+depositAmntCtrl.text+"-"+intr_rate+"-"+str_mnthCtrl+"-"+dateController.text+"-"+maturity_Date+"-"+maturity_Amnt);
    print("RES!!! : ${saveResponse.toString()}");
    setState(() {
      _isLoadingSave = false;
      // var accOpenList = json.decode(saveResponse.body);
      var accOpenList = saveResponse["Table"];
      var statusCode = accOpenList[0]["STATUSCODE"].toString();
      var status = accOpenList[0]["STATUS"];

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(status),
      ));

      if (statusCode == "1") {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        /* Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => AccountOpenHome()));*/
        //  Navigator.of(context).pushReplacementNamed("/MainPage");
        Navigator.of(context).pushReplacementNamed("/HomePage");
      }

      print("LJT" + status);
    });
  }

  Future<String> saveAccountsDD() async {
    setState(() {
      _isLoadingSave = true;
    });

    var saveResponse =
        await http.post(Uri.parse(save_acc_open_dd_url), headers: {
      "Accept": "application/json"
    }, body: {
      "DebitAccNo": str_accNo,
      //  "DebitAccNo": "11111111111",
      "DepAmt": depositAmntCtrl.text,
      // "Scheme": str_schemeCode,
      "IntRate": intr_rate,
      // "Month": monthCtrl.text,
      //  "Day": str_dayCtrl,
      //"Day": dayCtrl.text,
      "Day": "",
      "MatuDate": maturity_Date,
      "MatuAmt": maturity_Amnt,
      "Permit": _radioVal

      /*  "DebitAccNo": "11111111111",
        "DepAmt": "5000",
        "Scheme": "111",
        "IntRate": "10",
        "Month": "12",
        "Day": "0",
        "PayMode": "420",
        "MatuDate": "05/16/2022",
        "MatuAmt": "5500"*/
    });
    print("LIJU" +
        str_accNo +
        "-" +
        depositAmntCtrl.text +
        "-" +
        intr_rate +
        "-" +
        dayCtrl.text +
        "-" +
        maturity_Date +
        "-" +
        maturity_Amnt +
        "-" +
        _radioVal);

    setState(() {
      _isLoadingSave = false;
      var accOpenList = json.decode(saveResponse.body);
      var statusCode = accOpenList[0]["STATUSCODE"].toString();
      var status = accOpenList[0]["STATUS"];

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(status),
      ));

      if (statusCode == "1") {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        /* Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => AccountOpenHome()));*/
        //  Navigator.of(context).pushReplacementNamed("/MainPage");
        Navigator.of(context).pushReplacementNamed("/HomePage");
      }

      print("LJT" + status);
    });
  }

  void _rechargeConfirmation() {
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
            // buttonText: isLoading ? CircularProgressIndicator() : "SAVE",
            buttonText: isLoading
                ? CircularProgressIndicator()
                : saveList[int.parse(languageId)],
            onPressed: isLoading
                ? null
                : () async {
                    if (_pass == str_Otp) {
                      accountOpen();
                    } else {
                      Fluttertoast.showToast(
                          // msg: "OTP Miss match",
                          msg: otpMissMatch[int.parse(languageId)],
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

  void accountOpen() {
    if (widget._accType == "FD") {
      if (str_accNo == "" ||
          depositAmntCtrl.text == "" ||
          str_schemeCode == "" ||
          intr_rate == "" ||
          maturity_Date == "" ||
          maturity_Amnt == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: Text("Please Fill All Fields"),
          content: Text(plsFillMissingFieldsList[int.parse(languageId)]),
        ));
      } else {
        if (intr_rate == "0" || maturity_Date == "0" || maturity_Amnt == "0") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // content: Text("Value not be 0"),
            content: Text(valueNot0List[int.parse(languageId)]),
          ));
        } else {
          if (monVal == true) {
            saveAccountsFD();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                // SnackBar(content: Text("Please Accept Terms and Conditions")));
                SnackBar(
                    content: Text(
                        plsAcceptTermsConditionsList[int.parse(languageId)])));
          }
        }
      }
    } else if (widget._accType == "RD") {
      if (str_accNo == "" || depositAmntCtrl.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: Text("Please Fill All Fields"),
          content: Text(plsFillMissingFieldsList[int.parse(languageId)]),
        ));
      } else {
        if (monVal == true) {
          saveAccountsRD();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              // SnackBar(content: Text("Please Accept Terms and Conditions")));
              SnackBar(
                  content: Text(
                      plsAcceptTermsConditionsList[int.parse(languageId)])));
        }
      }
    } else if (widget._accType == "CA") {
      if (str_accNo == "" || depositAmntCtrl.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: Text("Please Fill All Fields"),
          content: Text(plsFillMissingFieldsList[int.parse(languageId)]),
        ));
      }
      if (double.parse(depositAmntCtrl.text) >= double.parse(widget._balance)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              // "Amount Should be less than your Account Balance"),
              amtShouldLessThanAccBalList[int.parse(languageId)]),
        ));
      } else {
        if (monVal == true) {
          print("LIJITh Save CA");
          saveAccountsCA();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              // SnackBar(content: Text("Please Accept Terms and Conditions")));
              SnackBar(
                  content: Text(
                      plsAcceptTermsConditionsList[int.parse(languageId)])));
        }
      }
    }

    /*else if (widget._accType == "RD") {
      if (str_accNo == "" ||
          depositAmntCtrl.text == "" ||
          intr_rate == "" ||
          maturity_Date == "" ||
          maturity_Amnt == "" ||
          str_duration == "" && dateController.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Fill All Fields"),
        ));
      } else {
        if (intr_rate == "0" || maturity_Date == "0" || maturity_Amnt == "0") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Value not be 0"),
          ));
        } else {
          if (monVal == true) {
            saveAccountsRD();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please Accept Terms and Conditions")));
          }
        }
      }
    }*/
    else if (widget._accType == "DD") {
      if (str_accNo == "" ||
          depositAmntCtrl.text == "" ||
          intr_rate == "" ||
          maturity_Date == "" ||
          maturity_Amnt == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: Text("Please Fill All Fields"),
          content: Text(plsFillMissingFieldsList[int.parse(languageId)]),
        ));
      } else {
        if (intr_rate == "0" || maturity_Date == "0" || maturity_Amnt == "0") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // content: Text("Value not be 0"),
            content: Text(valueNot0List[int.parse(languageId)]),
          ));
        } else {
          if (monVal == true) {
            saveAccountsDD();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                // SnackBar(content: Text("Please Accept Terms and Conditions")));
                SnackBar(
                    content: Text(
                        plsAcceptTermsConditionsList[int.parse(languageId)])));
          }
        }
      }
    } else if (widget._accType == "UNNATI") {
      if (str_accNo == "" ||
          depositAmntCtrl.text == "" ||
          intr_rate == "" ||
          maturity_Date == "" ||
          maturity_Amnt == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: Text("Please Fill All Fields"),
          content: Text(plsFillMissingFieldsList[int.parse(languageId)]),
        ));
      } else {
        if (intr_rate == "0" || maturity_Date == "0" || maturity_Amnt == "0") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // content: Text("Value not be 0"),
            content: Text(valueNot0List[int.parse(languageId)]),
          ));
        } else {
          if (monVal == true) {
            saveAccountsUD();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                // SnackBar(content: Text("Please Accept Terms and Conditions")));
                SnackBar(
                    content: Text(
                        plsAcceptTermsConditionsList[int.parse(languageId)])));
          }
        }
      }
    } else if (widget._accType == "MIS") {
      if (str_accNo == "" ||
          depositAmntCtrl.text == "" ||
          intr_rate == "" ||
          maturity_Date == "" ||
          maturity_Amnt == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: Text("Please Fill All Fields"),
          content: Text(plsFillMissingFieldsList[int.parse(languageId)]),
        ));
      } else {
        if (intr_rate == "0" || maturity_Date == "0" || maturity_Amnt == "0") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // content: Text("Value not be 0"),
            content: Text(valueNot0List[int.parse(languageId)]),
          ));
        } else {
          if (monVal == true) {
            saveAccountsMIS();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                // SnackBar(content: Text("Please Accept Terms and Conditions")));
                SnackBar(
                    content: Text(
                        plsAcceptTermsConditionsList[int.parse(languageId)])));
          }
        }
      }
    } else if (widget._accType == "SB") {
      if (str_accNo == "" || depositAmntCtrl.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: Text("Please Fill All Fields"),
          content: Text(plsFillMissingFieldsList[int.parse(languageId)]),
        ));
      } else {
        if (monVal == true) {
          saveAccountsMIS();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              // SnackBar(content: Text("Please Accept Terms and Conditions")));
              SnackBar(
                  content: Text(
                      plsAcceptTermsConditionsList[int.parse(languageId)])));
        }
        /*  if (intr_rate == "0" || maturity_Date == "0" || maturity_Amnt == "0") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Value not be 0"),
          ));
        } else {
          if (monVal == true) {
            saveAccountsMIS();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please Accept Terms and Conditions")));
          }
        }*/
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Account Opening ${widget._accType}"),
        title: Text(
            "${accOpeningList[int.tryParse(languageId)]} ${widget._accType}"),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Visibility(
                  visible: false,
                  child: Container(
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
                            hint: _isLoadingAccNo
                                ? Center(child: CircularProgressIndicator())
                                // : Text('Select Acc No'),
                                : Text(selectAccNoList[int.parse(languageId)]),
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
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                )),
                              );
                            }).toList(),
                            onChanged: (selectedItem) {
                              //  str_accNo = selectedItem.accNo;
                              print(selectedItem.accNo);
                              setState(() => _selectedAccNo = selectedItem);
                              getBalance();
                              print("LIJITH" + _selectedAccNo);
                            })),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Visibility(
                  visible: false,
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10.0, 13, 00, 00),
                      height: 40.0,
                      width: 350.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(
                            style: BorderStyle.solid,
                            width: 0.80,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      child: Text(
                        // balance == "" ? "Account Balance" : balance,
                        balance == ""
                            ? accBalList[int.parse(languageId)]
                            : balance,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                      )),
                ),
                Visibility(
                  visible: false,
                  child: Text(
                    widget._accType == "FD"
                        // ? "IN OPEN ENDED FD & MIS PRE CLOSURE ALLOWED ONLY AFTER 6 MONTHS,IN CLOSE ENDED FD & MIS PRE CLOSURE NOT ALLOWED"
                        ? openEndedFdMisAllowed6MonthsCloseEndedNotAllowedList[
                            int.parse(languageId)]
                        : widget._accType == "RD"
                            // ? "CLOSE ENDED PRODUCT PRE CLOSURE NOT ALLOWED BEFORE MATURITY."
                            ? closeEndedProductNotAllowedMaturityList[
                                int.parse(languageId)]
                            : widget._accType == "DD"
                                // ? "CLOSE ENDED PRODUCT PRE CLOSURE NOT ALLOWED BEFORE MATURITY."
                                ? closeEndedProductNotAllowedMaturityList[
                                    int.parse(languageId)]
                                : widget._accType == "UNNATI"
                                    // ? "CLOSE ENDED PRODUCT PRE CLOSURE NOT ALLOWED BEFORE MATURITY."
                                    ? closeEndedProductNotAllowedMaturityList[
                                        int.parse(languageId)]
                                    // : "IN OPEN ENDED FD & MIS PRE CLOSURE ALLOWED ONLY AFTER 6 MONTHS.IN CLOSE ENDED FD & MIS PRE CLOSURE NOT ALLOWED",
                                    : openEndedFdMisAllowed6MonthsCloseEndedNotAllowedList[
                                        int.parse(languageId)],
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    // Expanded(child: Text("Account Number")),
                    Expanded(
                        child: Text(
                      accNoList[int.parse(languageId)],
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    )),
                    Expanded(
                      child: Container(
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
                          // child: Text("Account Number")),
                          child: Text(
                            widget._accNo,
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    // Expanded(child: Text("Account Balance")),
                    Expanded(
                        child: Text(
                      accBalList[int.parse(languageId)],
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    )),
                    Expanded(
                      child: Container(
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
                          child: Text(
                            widget._balance,
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor),
                          )),
                    ),
                  ],
                ),
                Visibility(
                  /* visible: widget._accType == "RD" || widget._accType == "DD"
                      ? false
                      : true,*/
                  visible: false,
                  child: SizedBox(
                    height: 10.0,
                  ),
                ),
                Visibility(
                  /*  visible: widget._accType == "RD" ||
                          widget._accType == "DD" ||
                          widget._accType == "UNNATI"
                      ? false
                      : true,*/
                  visible: false,
                  child: Row(
                    children: [
                      // Expanded(child: Text("Scheme")),
                      Expanded(child: Text(schemeList[int.parse(languageId)])),
                      Expanded(
                        child: Container(
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
                              child: DropdownButton<AccountScheme>(
                                  hint: _isLoadingScheme
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      // : Text('Select Scheme'),
                                      : Text(selectSchemeList[
                                          int.parse(languageId)]),
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  value: _selectedScheme,
                                  items: _scheme.map((item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child:
                                          Container(child: Text(item.schName)),
                                    );
                                  }).toList(),
                                  onChanged: (selectedItem) {
                                    str_schemeCode = selectedItem.schCode;
                                    str_schemeName = selectedItem.schName;
                                    //  print(selectedItem.schName);
                                    print(str_schemeName);
                                    //   _schemeSelect = false;

                                    //      getSlab();
                                    setState(
                                        () => _selectedScheme = selectedItem);
                                  })),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget._accType == "RD" ||
                          widget._accType == "DD" ||
                          _schemeSelect ||
                          str_Slab == ""
                      ? false
                      : true,
                  child: SizedBox(
                    height: 10.0,
                  ),
                ),
                Visibility(
                  //  visible: widget._accType == "RD" || widget._accType == "DD" || _schemeSelect?false:true,
                  visible: widget._accType == "RD" ||
                          widget._accType == "DD" ||
                          _schemeSelect ||
                          str_Slab == ""
                      ? false
                      : true,
                  child: Container(
                    height: 40.0,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Expanded(child: Text("Slab : " + str_Slab)),
                          Expanded(
                              child: Text(
                                  "${slabList[int.parse(languageId)]} : " +
                                      str_Slab)),
                          // Expanded(child: Text("Period : " + str_Period)),
                          Expanded(
                              child: Text(
                                  "${periodList[int.parse(languageId)]} : " +
                                      str_Period)),
                          Expanded(
                            // child: Text("Interest Rate : " + str_IntRate),
                            child: Text(
                                "${interestRateList[int.parse(languageId)]} : " +
                                    str_IntRate),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    // Expanded(child: Text("Deposit Amount")),
                    Expanded(
                        child: Text(
                      depositAmountList[int.parse(languageId)],
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    )),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          onChanged: (text) {
                            print("LJTAMNT" + text);

                            setState(() {
                              intr_rate = "";
                              maturity_Date = "";
                              maturity_Amnt = "";
                            });
                          },
                          validator: (value) {
                            //  validator: (value) =>
                            //  value.isNotEmpty && double.parse(value) >= 500000
                            if (str_accType == "FD") {
                              /*  if (double.parse(value) < 5000) {
                                return 'Min Amount 5000';
                              }*/
                              if (double.parse(depositAmntCtrl.text) >=
                                  double.parse(widget._balance)) {
                                // return 'Not Enough Balance';
                                return notEnoughBalList[int.parse(languageId)];
                              } else {
                                return null;
                              }
                            }
                            if (str_accType == "UNNATI") {
                              if (value.isEmpty) {
                                // return 'Please Fill Fields';
                                return plsFillMissingFieldsList[
                                    int.parse(languageId)];
                              }
                              /*  if (double.parse(value) < 25000) {
                                return 'Min Amount 25000';
                              }*/
                              if (double.parse(depositAmntCtrl.text) >=
                                  double.parse(widget._balance)) {
                                // return 'Not Enough Balance';
                                return notEnoughBalList[int.parse(languageId)];
                              } else {
                                return null;
                              }
                            }
                            if (str_accType == "MIS") {
                              if (value.isEmpty) {
                                // return 'Please Fill Fields';
                                return plsFillMissingFieldsList[
                                    int.parse(languageId)];
                              }
                              /* if (double.parse(value) < 100000) {
                                return 'Min Amount 100000';
                              }*/
                              if (double.parse(depositAmntCtrl.text) >=
                                  double.parse(widget._balance)) {
                                // return 'Not Enough Balance';
                                return notEnoughBalList[int.parse(languageId)];
                              } else {
                                return null;
                              }
                            }
                          },
                          controller: depositAmntCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintStyle: TextStyle(color: Colors.black12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  //  visible: str_accType == "DD" ? false : true,
                  visible: true,
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Row(
                    children: [
                      // Expanded(child: Text("Month")),
                      Expanded(child: Text(monthList[int.parse(languageId)])),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            enabled: str_accType == "UNNATI" ? false : true,
                            onChanged: (text) {
                              setState(() {
                                intr_rate = "";
                                maturity_Date = "";
                                maturity_Amnt = "";
                                principal_Payout = "";
                                interest_Payout = "";
                              });
                            },
                            controller: monthCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(color: Colors.black12),
                            ),
                            /* validator: (value){
                              if(value.isEmpty){
                                return 'Please Fill Fields';
                              }

                              else{
                                return null;
                              }
                            },*/
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  /*  visible: widget._accType == "RD" ||
                          widget._accType == "DD" ||
                          widget._accType == "UNNATI"
                      ? false
                      : true,*/
                  visible: widget._accType == "CA" ? false : true,
                  child: Row(
                    children: [
                      // Expanded(child: Text("Month")),
                      Expanded(
                          child: Text(
                        monthList[int.parse(languageId)],
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      )),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(
                                style: BorderStyle.solid,
                                width: 0.80,
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              // Step 3.
                              value: dropdownValue,

                              // Step 4.

                              //   items: widget._accType == "FD"?<String>['12', '24', '60']:widget._accType == "RD" ? <String>['36', '60'] : widget._accType == "DD" ? <String>['12', '24', '36', '60'] : <String>[ '24', '36', '60']
                              //  items: <String>['12', '24', '60']

                              items: _scheme2.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor),
                                  ),
                                );
                              }).toList(),
                              // Step 5.
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                  print("LJT : $dropdownValue");
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Visibility(
                  visible: false,
                  child: Row(
                    children: [
                      // Expanded(child: Text("Day")),
                      Expanded(child: Text(dayList[int.parse(languageId)])),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            onChanged: (text) {
                              setState(() {
                                intr_rate = "";
                                maturity_Date = "";
                                maturity_Amnt = "";
                                principal_Payout = "";
                                interest_Payout = "";
                              });
                            },

                            controller: dayCtrl,
                            // controller: TextEditingController(text: "0"),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintStyle: TextStyle(color: Colors.black12),
                            ),
                            /*    validator: (value){
                              if(value.isEmpty){
                                return 'Please Fill Fields';
                              }
                              else{
                                return null;
                              }
                            },*/
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Visibility(
                  //  visible: widget._accType == "FD" || widget._accType == "UD" ? true : false,
                  visible: false,
                  child: Row(
                    children: [
                      // Expanded(child: Text("Duration")),
                      Expanded(
                          child: Text(durationList[int.parse(languageId)])),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(
                                style: BorderStyle.solid,
                                width: 0.80,
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<DurationModel>(
                                  hint: _isLoadingDuration
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      // : Text('Select Duration'),
                                      : Text(selectDurationList[
                                          int.parse(languageId)]),
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  value: _selectedDuration,
                                  items: _duration.map((item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child:
                                          Container(child: Text(item.pkcDesc)),
                                    );
                                  }).toList(),
                                  onChanged: (selectedItem) {
                                    str_duration =
                                        selectedItem.pkcCode.toString();
                                    setState(
                                        () => _selectedDuration = selectedItem);
                                  })),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget._accType == "RD" ? true : false,
                  child: Row(
                    children: [
                      // Expanded(child: Text("Installment Date")),
                      Expanded(
                          child:
                              Text(installmentDateList[int.parse(languageId)])),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            readOnly: true,
                            controller: dateController,
                            onTap: () async {
                              {
                                var date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                var _selectedDate =
                                    DateFormat("dd/MM/yyyy").format(date);

                                //   dateController.text = date.toString().substring(0,10);
                                dateController.text = _selectedDate;
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // hintText: 'Installment Date',
                                hintText:
                                    installmentDateList[int.parse(languageId)],
                                hintStyle: TextStyle(color: Colors.black12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Visibility(
                  visible: widget._accType == "CA" ? false : true,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        print(_radioVal);

                        if (str_accType == "FD" || str_accType == "UNNATI"
                            ? str_schemeCode == "" || depositAmntCtrl.text == ""
                            : depositAmntCtrl.text == "") {
                          //   if(str_accType == "FD" ){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            // content: Text("Please fill all Fields"),
                            content: Text(plsFillMissingFieldsList[
                                int.parse(languageId)]),
                          ));
                        } else {
                          //     str_accType == "FD" || str_accType == "UD"?getIntrestRate():getIntrestRateRD();
                          _schemeSelect = false;
                          if (str_accType == "FD") {
                            if (double.parse(depositAmntCtrl.text) >=
                                double.parse(widget._balance)) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    // "Amount Should be less than your Account Balance & Min FD Amount is 5000"),
                                    amtShouldLessThanAccBalAmt5000List[
                                        int.parse(languageId)]),
                              ));
                            } else {
                              //  if(str_schemeCode == null  || depositAmntCtrl.text == "" || (monthCtrl.text == "" || dayCtrl1.text == "")){
                              /* if(str_schemeCode == null  && depositAmntCtrl.text == "" && (monthCtrl.text == "") || (dayCtrl1.text == "")){
                         // if(depositAmntCtrl.text == "" || monthCtrl.text == "" || dayCtrl1.text == ""){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please fill all Fields"),
                            ));
                          }*/

                              print("SchemeCode${str_schemeCode}");
                              getSlabFD();
                              getIntrestRate();

                              /* if (dayCtrl1.text == "") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Please fill all Fields"),
                                ));
                              } else {
                                print("SchemeCode${str_schemeCode}");
                                getSlabFD();
                                getIntrestRate();
                              }*/
                            }
                          } else if (str_accType == "RD") {
                            if (double.parse(depositAmntCtrl.text) >=
                                double.parse(widget._balance)) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Amount Should be less than your Account Balance"),
                              ));
                            } else {
                              getSlabRD();
                              getIntrestRateRD();
                            }
                          } else if (str_accType == "DD") {
                            if (double.parse(depositAmntCtrl.text) >=
                                double.parse(widget._balance)) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Amount Should be less than your Account Balance"),
                              ));
                            } else {
                              getSlabRD();
                              getIntrestRateRD();
                            }
                          } else if (str_accType == "UNNATI") {
                            if (double.parse(depositAmntCtrl.text) >=
                                double.parse(widget._balance)) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    // "Amount Should be less than your Account Balance"),
                                    amtShouldLessThanAccBalList[
                                        int.parse(languageId)]),
                              ));
                            } else {
                              getSlabUD();
                              getIntrestRateUD();
                            }
                          } else if (str_accType == "MIS") {
                            if (double.parse(depositAmntCtrl.text) >=
                                double.parse(widget._balance)) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    // "Amount Should be less than your Account Balance"),
                                    amtShouldLessThanAccBalList[
                                        int.parse(languageId)]),
                              ));
                            } else {
                              if (str_schemeName == "CLOSE ENDED") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        // content: Text("No Active Scheme Found")));
                                        content: Text(noActiveSchemeFoundList[
                                            int.parse(languageId)])));
                              } else {
                                if (depositAmntCtrl.text == "") {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    // content: Text("Please fill all Fields"),
                                    content: Text(plsFillMissingFieldsList[
                                        int.parse(languageId)]),
                                  ));
                                } else {
                                  print("LJT$str_schemeCode");
                                  getSlabMIS();
                                  getIntrestRateMIS();
                                }
                              }
                            }
                          }
                        }
                      }
                    },
                    child: Text(
                      // "Fetch Maturity Date and Amount",
                      fetchMaturityDateAmtList[int.parse(languageId)],
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Visibility(
                  visible: widget._accType == "CA" ? false : true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        standingList[int.parse(languageId)],
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      // Text("Standing"),
                      Text(allowList[int.parse(languageId)]),
                      // Text('Allow'),
                      Radio(
                        value: 1,
                        groupValue: _radioSelected,
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            _radioSelected = value;
                            _radioVal = '0';
                          });
                        },
                      ),
                      // Text('Deny'),
                      Text(denyList[int.parse(languageId)]),
                      Radio(
                        value: 2,
                        groupValue: _radioSelected,
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            _radioSelected = value;
                            _radioVal = '1';
                          });
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Visibility(
                  visible: widget._accType == "CA" ? false : true,
                  child: Row(
                    children: [
                      // Expanded(child: Text("Interest Rate")),
                      Expanded(
                          child: Text(
                        interestRateList[int.parse(languageId)],
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      )),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(10.0, 13, 00, 00),
                            height: 40.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  width: 0.80,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            child: Text(intr_rate == "" ? "" : intr_rate)),
                        //  child: Text("Interest")),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),

                /*       Container(
                  height: 40.0,
                  child: TextFormField(
                    readOnly: true,
                    controller: dateController,
                    onTap: () async{
                      {
                        var date =  await showDatePicker(
                            context: context,
                            initialDate:DateTime.now(),
                            firstDate:DateTime(1900),
                            lastDate: DateTime(2100));
                        dateController.text = date.toString().substring(0,10);
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Meturity Date',hintStyle: TextStyle(
                      color: Colors.black12
                    )
                    ),
                  ),
                ),*/

                Visibility(
                  visible: widget._accType == "CA" ? false : true,
                  child: Row(
                    children: [
                      // Expanded(child: Text("Maturity Date")),
                      Expanded(
                          child: Text(
                        maturityDateList[int.parse(languageId)],
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      )),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(10.0, 13, 00, 00),
                            height: 40.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  width: 0.80,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            child:
                                Text(maturity_Date == "" ? "" : maturity_Date)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Visibility(
                  visible: widget._accType == "CA" ? false : true,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        widget._accType == "UNNATI"
                            // ? "Total Amount Payable"
                            ? totalAmtPayableList[int.parse(languageId)]
                            // : "Maturity Amount")),
                            : maturityAmtList[int.parse(languageId)],
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      )),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(10.0, 13, 00, 00),
                            height: 40.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  width: 0.80,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            child:
                                Text(maturity_Amnt == "" ? "" : maturity_Amnt)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Visibility(
                  visible:
                      widget._accType == "MIS" || widget._accType == "UNNATI"
                          ? true
                          : false,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(widget._accType == "MIS"
                              // ? "Interest Payout"
                              ? interestPayoutList[int.parse(languageId)]
                              // : "Monthly Payout")),
                              : monthlyPayoutList[int.parse(languageId)])),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(10.0, 13, 00, 00),
                            height: 40.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  width: 0.80,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            child: Text(
                                interest_Payout == "" ? "" : interest_Payout)),
                      ),
                    ],
                  ),
                ),
                /*     SizedBox(
                  height: 10.0,
                ),
                Visibility(
                  visible: widget._accType == "UD"?true:false,
                  child: Row(
                    children: [
                      Expanded(child: Text("Principal Payout")),
                      Expanded(
                        child: Container(

                            padding: EdgeInsets.fromLTRB(10.0, 13, 00, 00),
                            height: 40.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                  style: BorderStyle.solid, width: 0.80),
                            ),
                            child: Text(principal_Payout == ""?"":principal_Payout)),
                      ),
                    ],
                  ),
                ),*/
                SizedBox(
                  height: 10.0,
                ),
                /* Text(widget._accType == "FD"?"":widget._accType =="RD"?"AMOUNT WILL BE DEDUCTED AUTOMATICALLY AS PER TERMS AND CONDITION.":widget._accType == "DD"?"AMOUNT WILL BE DEDUCTED AUTOMATICALLY AS PER TERMS AND CONDITION.":widget._accType == "UNNATI"? "AMOUNT WILL BE DEDUCTED AUTOMATICALLY AS PER TERMS AND CONDITION.":"AMOUNT WILL BE DEDUCTED AUTOMATICALLY AS PER TERMS AND CONDITION.",


                  style: TextStyle(
                      color: Colors.red
                  ),),
                SizedBox(height: 8.0,),*/

                Row(
                  children: <Widget>[
                    Checkbox(
                      value: monVal,
                      onChanged: (bool value) {
                        setState(() {
                          monVal = value;
                          print(monVal.toString());
                          _accTerms = monVal;
                        });
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(monVal.toString())));
                      },
                    ),
                    // Text("I Accept the terms and conditions"),
                    Text(
                      iAcceptTermsConditionsList[int.parse(languageId)],
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: _accTerms ? true : false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text("1.  Maturity Amount Before TDS"),
                      Text(
                          "1.  ${maturityAmtBeforeTDSList[int.parse(languageId)]}"),
                      // Text("2.  TDS will Deduct if Applicable"),
                      Text(
                          "2.  ${tdsDeductIfApplicableList[int.parse(languageId)]}"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),

                /*   Container(
                  height: 40.0,
                  child: TextFormField(
                    controller: meturityAmnt,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Meturity Amount',
                        hintStyle: TextStyle(
                          color: Colors.black12
                        ),
                    ),
                  ),
                ),*/
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () async {
                      var response =
                          await RestAPI().post(get_otp_accopen, params: {
                        "MobileNo": mobileNo,
                        "Amt": depositAmntCtrl.text,
                        "SMS_Module": "GENERAL",
                        "SMS_Type": "GENERAL_OTP",
                        "OTP_Return": "Y"
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

                        Timer(Duration(minutes: 5), () {
                          setState(() {
                            str_Otp = "";
                          });
                        });
                      });

                      _rechargeConfirmation();

/*

                      if(widget._accType == "FD"){
                        if(str_accNo == "" || depositAmntCtrl.text == "" || str_schemeCode == "" || intr_rate == ""  || maturity_Date == "" || maturity_Amnt == "" ){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Fill All Fields"),
                          ));
                        }else{
                          if(intr_rate == "0" || maturity_Date == "0" ||  maturity_Amnt == "0"){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Value not be 0"),
                            ));
                          }
                          else{
                            if(monVal  == true){
                              saveAccountsFD();
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Accept Terms and Conditions")));
                            }

                          }

                        }

                      }else if(widget._accType == "RD"){
                        if(str_accNo == "" || depositAmntCtrl.text == "" || intr_rate == ""  || maturity_Date == "" || maturity_Amnt == "" || str_duration == "" &&  dateController.text == ""){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Fill All Fields"),
                          ));
                        }else{
                          if(intr_rate == "0" || maturity_Date == "0" ||  maturity_Amnt == "0"){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Value not be 0"),
                            ));
                          }
                          else{
                            if(monVal  == true){
                              saveAccountsRD();
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Accept Terms and Conditions")));
                            }

                          }

                        }

                      }
                      else if(widget._accType == "DD"){

                        if(str_accNo == "" || depositAmntCtrl.text == "" || intr_rate == ""  || maturity_Date == "" || maturity_Amnt == "" ){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Fill All Fields"),
                          ));
                        }else{
                          if(intr_rate == "0" || maturity_Date == "0" ||  maturity_Amnt == "0"){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Value not be 0"),
                            ));
                          }
                          else{
                            if(monVal  == true){
                              saveAccountsDD();
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Accept Terms and Conditions")));
                            }


                          }

                        }

                      }

                      else if(widget._accType == "UNNATI"){
                        if(str_accNo == "" || depositAmntCtrl.text == "" || intr_rate == ""  || maturity_Date == "" || maturity_Amnt == "" ){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Fill All Fields"),
                          ));
                        }else{
                          if(intr_rate == "0" || maturity_Date == "0" ||  maturity_Amnt == "0"){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Value not be 0"),
                            ));
                          }
                          else{
                            if(monVal  == true){
                              saveAccountsUD();
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Accept Terms and Conditions")));
                            }

                          }

                        }

                      }

                      else if(widget._accType == "MIS"){
                        if(str_accNo == "" || depositAmntCtrl.text == "" || intr_rate == ""  || maturity_Date == "" || maturity_Amnt == "" ){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Fill All Fields"),
                          ));
                        }else{
                          if(intr_rate == "0" || maturity_Date == "0" ||  maturity_Amnt == "0"){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Value not be 0"),
                            ));
                          }
                          else{
                            if(monVal  == true){
                              saveAccountsMIS();
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Accept Terms and Conditions")));
                            }

                          }

                        }

                      }
*/
                    },
                    child: _isLoadingSave
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                        : Text(
                            // "Save",
                            saveList[int.parse(languageId)],
                            style: TextStyle(color: Colors.white),
                          ),
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
