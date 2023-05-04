import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:passbook_core/MainScreens/Model/LoginModel.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/REST/app_exceptions.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUI extends StatefulWidget {
  final GestureTapCallback onTap;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const RegisterUI({
    Key key,
    this.onTap,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  _RegisterUIState createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI>
    with SingleTickerProviderStateMixin {
  SharedPreferences preferences;
  var languageId = "";
  double _iconSize = 25.0;

  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> signInList = [
    "Sign In",
    "Connexion",
    "inicio de sesión",
    "Conecte-se"
  ];
  List<String> signUpList = [
    "Sign Up",
    "S'inscrire",
    "inscribirse",
    "Inscrever-se"
  ];
  List<String> userNameList = [
    "Username",
    "Nom d'utilisateur",
    "nombre de usuario",
    "nome do usuário"
  ];
  List<String> mobileNoList = [
    "Mobile Number",
    "Numéro de portable",
    "Número de móvil",
    "Número de celular"
  ];
  List<String> mobileNoInvalidList = [
    "Mobile number is invalid",
    "Le numéro de portable est invalide",
    "El número de móvil no es válido",
    "O número do celular é inválido"
  ];
  List<String> enterOTPList = [
    "Enter OTP",
    "Entrez OTP",
    "Ingresar OTP",
    "Digite OTP"
  ];
  List<String> otpLengthList = [
    "OTP length should be 4",
    "La longueur de l'OTP doit être de 4",
    "La longitud de OTP debe ser 4",
    "O comprimento do OTP deve ser 4"
  ];
  List<String> selectACnoList = [
    "Select A/C No",
    "Sélectionnez un numéro de compte",
    "Seleccione un número de cuenta",
    "Selecione um número de conta"
  ];
  List<String> enterUsernameList = [
    "Enter a Username",
    "Entrez un nom d'utilisateur",
    "ingrese un nombre de usuario",
    "Digite um nome de usuário"
  ];
  List<String> invalidUsernameList = [
    "Invalid Username",
    "Nom d'utilisateur invalide",
    "Nombre de usuario no válido",
    "Nome de usuário Inválido"
  ];
  List<String> pwList = ["Password", "mot de passe", "contraseña", "senha"];
  List<String> includeSpCharList = [
    "Please include special charcters",
    "Veuillez inclure des caractères spéciaux",
    "Por favor incluya caracteres especiales",
    "Inclua caracteres especiais"
  ];
  List<String> cpwList = [
    "Confirm Password",
    "Confirmez le mot de passe",
    "Confirmar la contraseña",
    "Confirme a Senha"
  ];
  List<String> pwNotMatchList = [
    "Password not matching",
    "Mot de passe ne correspondant pas",
    "La contraseña no coincide",
    "A senha não corresponde"
  ];
  List<String> sendOTPList = [
    "Send OTP",
    "Envoyer OTP",
    "Enviar OTP",
    "Enviar OTP"
  ];
  List<String> validateOTPList = [
    "Validate OTP",
    "Valider OTP",
    "Validar OTP",
    "Validar OTP"
  ];
  List<String> registerList = [
    "Register",
    "Enregistrer",
    "Registro",
    "Registro"
  ];
  List<String> otpSentList = [
    "OTP Sent",
    "OTP envoyé",
    "OTP enviado",
    "OTP Enviado"
  ];
  List<String> invalidMobileNoList = [
    "Invalid Mobile Number",
    "Numéro de portable invalide",
    "Numero de celular invalido",
    "Número de celular inválido"
  ];
  List<String> invalidOtpOrMobileNoList = [
    "Invalid OTP or Mobile Number",
    "OTP ou numéro de mobile invalide",
    "OTP o número de móvil no válido",
    "OTP ou número de celular inválido"
  ];
  List<String> plsFillMissingFieldsList = [
    "Please fill the missing fields",
    "Veuillez remplir les champs manquants",
    "Por favor complete los campos que faltan",
    "Por favor, preencha os campos que faltam"
  ];
  List<String> usercodeExistsList = [
    "Usercode Already Exists",
    "Le code utilisateur existe déjà",
    "El código de usuario ya existe",
    "O código de usuário já existe"
  ];
  List<String> maxLengthUN10Min4List = [
    "Max length for username is 10 and Min is 4",
    "La longueur maximale du nom d'utilisateur est de 10 et la longueur minimale est de 4",
    "La longitud máxima para el nombre de usuario es 10 y la mínima es 4",
    "O comprimento máximo do nome de usuário é 10 e o mínimo é 4"
  ];
  List<String> plsRemoveSpaceUNAndPWList = [
    "Please remove space from username or password",
    "Veuillez supprimer l'espace du nom d'utilisateur ou du mot de passe",
    "Quite el espacio del nombre de usuario o la contraseña",
    "Remova o espaço do nome de usuário ou senha"
  ];
  // List<String> List = ["","","",""];
// List<String> List = ["","","",""];
  // List<String> List = ["","","",""];

  TextEditingController mobCtrl = TextEditingController(),
      otpCtrl = TextEditingController(),
      accCtrl = TextEditingController(),
      passCtrl = TextEditingController(),
      rePassCtrl = TextEditingController(),
      usernameCtrl = TextEditingController();
  List<String> accNos = List();
  FocusNode chapass = FocusNode();
  bool isSendOTP = false, isOtpValid = false;
  bool mobVal = false,
      passVal = false,
      rePassVal = false,
      accVal = false,
      userNameVal = false,
      otpVal = false;
  LoginModel login = LoginModel();
  AnimationController _controller;
  Animation<double> _fadeIn;

  bool _isLoading = false;

  final _listController = ScrollController();

  void saveData(LoginModel loginModel) async {
    SharedPreferences preferences = StaticValues.sharedPreferences;
    print("CUST ID :: ${loginModel.table[0].toString()}");
    await preferences.setString(
        StaticValues.custID, loginModel.table[0].custId.toString());
    await preferences.setString(
        StaticValues.accNumber, loginModel.table[0].accNo.toString());
    await preferences.setString(
        StaticValues.accName, loginModel.table[0].custName.toString());
    Navigator.of(context).pushReplacementNamed("/SubPage");
  }

  void _showAccList(TextEditingController textCtrl) {
    showModalBottomSheet(
      context: context,
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: List.generate(accNos.length, (index) {
                return GestureDetector(
                    onTap: () {
                      textCtrl.text = accNos[index];
                      Navigator.of(context).pop();
                    },
                    child: ListTile(title: TextView(accNos[index])));
              }),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 450), vsync: this);
    _fadeIn = Tween(begin: 0.5, end: 1.0).animate(_controller);
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: widget.onTap,
          child: Card(
            elevation: 3.0,
            margin: EdgeInsets.all(10.0),
            color: Theme.of(context).secondaryHeaderColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * .15,
          left: 20.0,
          child: TextView(
            // "Sign Up",
            signUpList[int.parse(languageId)],
            size: 20.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * .25,
          left: 0.0,
          right: 0.0,
          height: MediaQuery.of(context).size.width * 1.31,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: KeyboardAvoider(
              autoScroll: true,
              focusPadding: 100.0,
              child: SingleChildScrollView(
                controller: _listController,
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    EditTextBordered(
                        controller: mobCtrl,
                        keyboardType: TextInputType.number,
                        // hint: "Mobile No",
                        hint: mobileNoList[int.parse(languageId)],
                        // errorText: mobVal ? "Mobile number is invalid" : null,
                        hintColor: Theme.of(context).scaffoldBackgroundColor,
                        color: Colors.white, //Input Text Color
                        filled: true,
                        fillColor: Theme.of(context).secondaryHeaderColor,
                        errorText: mobVal
                            ? mobileNoInvalidList[int.parse(languageId)]
                            : null,
                        textInputAction: TextInputAction.next,
                        borderColor: Colors.black,
                        onSubmitted: (_) {
                          onRegister();
                          FocusScope.of(context).nextFocus();
                        },
                        onChange: (value) {
                          setState(() {
                            print(value.trim().length != 10);

                            mobVal = value.trim().length != 10;
                            setState(() {
                              isOtpValid = false;
                              isSendOTP = false;
                              _controller.reverse();
                            });
                          });
                        }),
                    SizedBox(
                      height: 20.0,
                    ),
                    EditTextBordered(
                      controller: otpCtrl,
                      keyboardType: TextInputType.number,
                      // hint: "Enter OTP",
                      hint: enterOTPList[int.parse(languageId)],
                      // errorText: otpVal ? "OTP length should be 4" : null,
                      hintColor: Theme.of(context).scaffoldBackgroundColor,
                      color: Colors.white, //Input Text Color
                      filled: true,
                      fillColor: Theme.of(context).secondaryHeaderColor,
                      errorText:
                          otpVal ? otpLengthList[int.parse(languageId)] : null,
                      borderColor: Colors.black,
                      onChange: (value) {
                        setState(() {
                          otpVal = value.trim().length < 4;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FadeTransition(
                      opacity: _fadeIn,
                      child: IgnorePointer(
                        ignoring: false /*!isOtpValid && !isSendOTP*/,
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _showAccList(accCtrl);
                              },
                              child: EditTextBordered(
                                enabled: false,
                                controller: accCtrl,
                                // hint: "Select A/C No",
                                hint: selectACnoList[int.parse(languageId)],
                                // errorText: accVal ? "Select an account" : null,
                                hintColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                color: Colors.white, //Input Text Color
                                filled: true,
                                fillColor:
                                    Theme.of(context).secondaryHeaderColor,
                                errorText: accVal
                                    ? selectACnoList[int.parse(languageId)]
                                    : null,
                                borderColor: Colors.black,
                                obscureIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                    size: 25.0,
                                  ),
                                ),
                                onChange: (value) {
                                  setState(() {
                                    accVal = value.trim().length <= 0;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            EditTextBordered(
                              controller: usernameCtrl,
                              // hint: "Enter a user name",
                              hint: enterUsernameList[int.parse(languageId)],
                              // errorText: userNameVal ? "Invalid username" : null,
                              hintColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              color: Colors.white, //Input Text Color
                              filled: true,
                              fillColor: Theme.of(context).secondaryHeaderColor,
                              errorText: userNameVal
                                  ? invalidUsernameList[int.parse(languageId)]
                                  : null,
                              borderColor: Colors.black,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                FocusScope.of(context).nextFocus();
                              },
                              onChange: (value) {
                                setState(() {
                                  userNameVal = value.trim().length <= 3 ||
                                      value.trim().length >= 11;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            EditTextBordered(
                              controller: passCtrl,
                              // hint: "Password",
                              hint: pwList[int.parse(languageId)],
                              // errorText: passVal ? "Please include special characters" : null,
                              hintColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              color: Colors.white, //Input Text Color
                              filled: true,
                              fillColor: Theme.of(context).secondaryHeaderColor,
                              errorText: passVal
                                  ? includeSpCharList[int.parse(languageId)]
                                  : null,
                              borderColor: Colors.black,
                              obscureText: true,
                              showObscureIcon: true,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                FocusScope.of(context).nextFocus();
                              },
                              onChange: (value) {
                                setState(() {
                                  //  passVal = value.trim().length < 4;
                                  //   passVal = RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value);
                                  passVal =
                                      RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value);
                                  //    passVal = RegExp(r"^([a-zA-Z])(0-9)+$").hasMatch(value);
                                  //   passVal = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{4,}$').hasMatch(value);
                                  //  passVal = RegExp("^(.{8,32}\$)(.*[A-Z])(.*[a-z])(.*[0-9])(.*[!@#\$%^&*(),.?:{}|<>]).*").hasMatch(value);
                                });
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            EditTextBordered(
                              controller: rePassCtrl,
                              focusNode: chapass,
                              // hint: "Confirm Password",
                              hint: cpwList[int.parse(languageId)],
                              // errorText: rePassVal ? "Password not matching" : null,
                              hintColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              color: Colors.white, //Input Text Color
                              filled: true,
                              fillColor: Theme.of(context).secondaryHeaderColor,
                              errorText: rePassVal
                                  ? pwNotMatchList[int.parse(languageId)]
                                  : null,
                              borderColor: Colors.black,
                              obscureText: true,
                              showObscureIcon: true,
                              onChange: (value) {
                                setState(() {
                                  rePassVal = rePassCtrl.text != passCtrl.text;
                                });
                              },
                            ),
                            SizedBox(
                              height: 140.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: CustomRaisedIndigoButton(
            loadingValue: _isLoading,
            // buttonText: !isSendOTP ? "Send OTP" : isSendOTP && !isOtpValid ? "Validate OTP" : "Register",
            buttonText: !isSendOTP
                ? sendOTPList[int.parse(languageId)]
                : isSendOTP && !isOtpValid
                    ? validateOTPList[int.parse(languageId)]
                    : registerList[int.parse(languageId)],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            onPressed: () async {
              onRegister();
            },
          ),
        )
      ],
    );
  }

  void onRegister() async {
    if (!isSendOTP && !isOtpValid) {
      if (mobCtrl.text.trim().length >= 9) {
        _isLoading = true;
        try {
          Map response = await RestAPI().post(
            "${APis.getRegisterOTP}?MobileNo=${mobCtrl.text}",
          );
          setState(() {
            _isLoading = false;
          });

          if (response["Table"][0]["Result"].toString().toLowerCase() == 'y') {
            // GlobalWidgets().showSnackBar(widget.scaffoldKey, "OTP sent");
            GlobalWidgets().showSnackBar(
                widget.scaffoldKey, otpSentList[int.parse(languageId)]);
            setState(() {
              isSendOTP = true;
            });
          } else {
            setState(() {
              isSendOTP = false;
            });
            // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Invalid mobile number");
            GlobalWidgets().showSnackBar(
                widget.scaffoldKey, invalidMobileNoList[int.parse(languageId)]);
          }
        } on RestException catch (e) {
          setState(() {
            _isLoading = false;
          });

          GlobalWidgets().showSnackBar(widget.scaffoldKey, e.message);
        }
      } else {
        setState(() {
          isSendOTP = false;
        });
        // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Invalid mobile number");
        GlobalWidgets().showSnackBar(
            widget.scaffoldKey, invalidMobileNoList[int.parse(languageId)]);
      }
    } else if (isSendOTP && !isOtpValid) {
      if (mobCtrl.text.trim().length >= 9 && otpCtrl.text.length >= 4) {
        _isLoading = true;
        try {
          Map response = await RestAPI().get(
            "${APis.validateOTP}?MobileNo=${mobCtrl.text}&OTP=${otpCtrl.text}",
          );
          _isLoading = false;
          if (response["Table"][0]["ACCNO"].toString().toLowerCase() == 'n') {
            // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Invalid OTP or Mobile number");
            GlobalWidgets().showSnackBar(widget.scaffoldKey,
                invalidOtpOrMobileNoList[int.parse(languageId)]);
            setState(() {
              isOtpValid = false;
              isSendOTP = true;
            });
          } else {
            setState(() {
              (response["Table"] as List).forEach((f) {
                accNos.add(f["ACCNO"]);
              });
              isOtpValid = true;
              isSendOTP = true;
              _controller.forward();
            });
          }
        } on RestException catch (e) {
          setState(() {
            _isLoading = false;
          });
          GlobalWidgets().showSnackBar(widget.scaffoldKey, e.message);
        }
      } else {
        // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Invalid OTP or Mobile number");
        GlobalWidgets().showSnackBar(widget.scaffoldKey,
            invalidOtpOrMobileNoList[int.parse(languageId)]);
        setState(() {
          isOtpValid = false;
          isSendOTP = true;
        });
      }
    } else {
      bool passValue = passCtrl.text.contains(new RegExp(r"^[a-zA-Z0-9]+$"));

      if (passValue) {
        // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Please include special characters in password");
        GlobalWidgets().showSnackBar(
            widget.scaffoldKey, includeSpCharList[int.parse(languageId)]);
      } else if (passCtrl.text != rePassCtrl.text) {
        // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Password Miss match");
        GlobalWidgets().showSnackBar(
            widget.scaffoldKey, pwNotMatchList[int.parse(languageId)]);
      } else if (usernameCtrl.text.length <= 3 ||
          usernameCtrl.text.length >= 11) {
        // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Max length for password is 10 and Min is 4");
        GlobalWidgets().showSnackBar(
            widget.scaffoldKey, maxLengthUN10Min4List[int.parse(languageId)]);
      } else if (passCtrl.text.length <= 3 || passCtrl.text.length >= 11) {
        // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Max length for password is 10 and Min is 4");
        GlobalWidgets().showSnackBar(
            widget.scaffoldKey, maxLengthUN10Min4List[int.parse(languageId)]);
      } else if (passCtrl.text.contains(" ") ||
          usernameCtrl.text.contains(" ")) {
        // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Please remove space from username or password");
        GlobalWidgets().showSnackBar(widget.scaffoldKey,
            plsRemoveSpaceUNAndPWList[int.parse(languageId)]);
      } else {
        if (mobCtrl.text.trim().length >= 9 &&
                otpCtrl.text.length >= 4 &&
                accCtrl.text.length > 0 &&
                //   usernameCtrl.text.length > 3 &&
                usernameCtrl.text.length >= 3 ||
            usernameCtrl.text.length <= 11 &&
                //  passCtrl.text.length >= 4 &&
                //  passCtrl.text.length>=6 && !passCtrl.text.contains(RegExp(r'\W')) && RegExp(r'\d+\w*\d+').hasMatch(passCtrl.text) &&
                //  passCtrl.text.length>=4 && !passCtrl.text.contains(RegExp(r'\W')) && RegExp(r'\d+\w*\d+').hasMatch(passCtrl.text) &&
                //  passCtrl.text.length>=4 && passCtrl.text.contains(RegExp(r"^[a-zA-Z0-9]+$")) && RegExp(r"^[a-zA-Z0-9]+$").hasMatch(passCtrl.text) &&

                passCtrl.text == rePassCtrl.text) {
          String url =
              "${APis.registerAcc}?userid=${usernameCtrl.text}&password=${passCtrl.text}"
              "&MobileNo=${mobCtrl.text}&Accno=${accCtrl.text}";
          _isLoading = true;
          Map response = await RestAPI().post(url);
          _isLoading = false;
          if (response["Table"][0]["Status"].toString() ==
              "Usercode Already Exists") {
            // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Usercode Already Exists");
            GlobalWidgets().showSnackBar(
                widget.scaffoldKey, usercodeExistsList[int.parse(languageId)]);
          } else {
            print(response["Table"][0]["Status"].toString());
            GlobalWidgets().showSnackBar(
                widget.scaffoldKey, response["Table"][0]["Status"].toString());
            widget.onTap();
          }
        } else {
          // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Please fill the missing fields");
          GlobalWidgets().showSnackBar(widget.scaffoldKey,
              plsFillMissingFieldsList[int.parse(languageId)]);
        }
      }
    }

    //   GlobalWidgets().showSnackBar(widget.scaffoldKey, passValue.toString());

    /*  if (mobCtrl.text.trim().length == 10 &&
          otpCtrl.text.length >= 4 &&
          accCtrl.text.length > 0 &&
       //   usernameCtrl.text.length > 3 &&
          usernameCtrl.text.length >= 3 ||  usernameCtrl.text.length <= 11 &&
        //  passCtrl.text.length >= 4 &&
        //  passCtrl.text.length>=6 && !passCtrl.text.contains(RegExp(r'\W')) && RegExp(r'\d+\w*\d+').hasMatch(passCtrl.text) &&
        //  passCtrl.text.length>=4 && !passCtrl.text.contains(RegExp(r'\W')) && RegExp(r'\d+\w*\d+').hasMatch(passCtrl.text) &&
        //  passCtrl.text.length>=4 && passCtrl.text.contains(RegExp(r"^[a-zA-Z0-9]+$")) && RegExp(r"^[a-zA-Z0-9]+$").hasMatch(passCtrl.text) &&

          passCtrl.text == rePassCtrl.text) {
        String url = "${APis.registerAcc}?userid=${usernameCtrl.text}&password=${passCtrl.text}"
            "&MobileNo=${mobCtrl.text}&Accno=${accCtrl.text}";
        _isLoading = true;
        Map response = await RestAPI().post(url);
        _isLoading = false;
        if (response["Table"][0]["Status"].toString() == "Usercode Already Exists") {
          GlobalWidgets().showSnackBar(widget.scaffoldKey, "Usercode Already Exists");
        } else {
          print(response["Table"][0]["Status"].toString());
          GlobalWidgets().showSnackBar(widget.scaffoldKey, response["Table"][0]["Status"].toString());
          widget.onTap();
        }
      } else {
        GlobalWidgets().showSnackBar(widget.scaffoldKey, "Please fill the missing fields");
      }
    }*/
  }

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
      print(languageId);
    });
  }
}
