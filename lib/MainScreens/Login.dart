import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:passbook_core/AccountOpen/CustomerOnboarding/CustomerChecking.dart';
import 'package:passbook_core/MainScreens/Model/LoginModel.dart';
import 'package:passbook_core/MainScreens/Register.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/REST/app_exceptions.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// GlobalKey<ScaffoldState> _scaffoldKeyLang = GlobalKey();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  SharedPreferences preferences;
  var languageId = "";

  // List<String> List = ["","","",""];
  List<String> signInList = [
    "Sign In",
    "Connexion",
    "inicio de sesión",
    "Conecte-se"
  ];
  List<String> clickPlusList = [
    "Click + to register",
    "Cliquez sur + pour vous inscrire",
    "Haga clic en + para registrarse",
    "Clique em + para se registrar"
  ];
  List<String> doYouWantToExitList = [
    "Do you want to exit app?",
    "Voulez-vous quitter l'application ?",
    "Quieres salir de la aplicación?",
    "Deseja sair do aplicativo?"
  ];
  List<String> noList = ["No", "non", "no", "não"];
  List<String> yesList = ["Yes", "oui", "si", "sim"];

  int indexPage = 0;
  PageController _pageController = PageController(initialPage: 1);
  AnimationController _animationController, _floatingAnimationController;
  Animation<double> _animation, _floatingAnimation;
  static const int pageCtrlTime = 550;
  static const _animationCurves = Curves.fastLinearToSlowEaseIn;
  static const _pageCurves = Curves.easeIn;
  GlobalKey _regToolTipKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String MPin;
  String strOtp, str_Otp;
  String version = "";

  void reverseAnimate() {
    Future.delayed(Duration(milliseconds: pageCtrlTime), () {
      _animationController.reverse();
      _floatingAnimationController.reverse();
    });
  }

  void checkVersionCompatible() async {
    Map<String, dynamic> versionMap =
        await RestAPI().get(APis.mobileGetVersion);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    setState(() {
      version = packageInfo.version;
    });
    // String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    print("VersionNumber$buildNumber");
    print("appName $appName"
        " packageName $packageName"
        " version $version"
        " buildNumber $buildNumber");
    // print("VERSION${version}");
    print("VERSION1 $buildNumber");
    print(
        "VERSION2 ${(versionMap["Table"][0]["Ver_Code"] as double).round().toString()}");

    /* if (versionMap["Table"][0]["Ver_Name"].toString() != version &&
        versionMap["Table"][0]["Ver_Code"].toString() != buildNumber) {*/
    if ((versionMap["Table"][0]["Ver_Code"] as double).round().toString() !=
        buildNumber) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              if (Platform.isIOS) {
                SystemNavigator.pop();
              } else if (Platform.isAndroid) exit(0);
              return false;
            },
            child: AlertDialog(
              content:
                  Text("A new version of this application is available now. "
                      "Please update to get new features."),
              actions: [
                RaisedButton(
                  onPressed: () async {
                    if (Platform.isIOS) {
                      SystemNavigator.pop();
                    } else if (Platform.isAndroid) exit(0);
                  },
                  color: Colors.red,
                  child: Text("Exit"),
                ),
                RaisedButton(
                  onPressed: () async {
                    var url =
                        'https://play.google.com/store/apps/details?id=$packageName';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  color: Colors.green,
                  child: Text("Update Now"),
                ),
              ],
            ),
          );
        },
        useSafeArea: true,
      );
    }
  }

  termsAndConditions() async {
    SharedPreferences prefs = StaticValues.sharedPreferences;
    if (prefs.getBool("Accept_Terms") == null ||
        !prefs.getBool("Accept_Terms")) {
      showDialog(
          context: context,
          builder: (context) => WillPopScope(
                onWillPop: () async {
                  if (Platform.isIOS) {
                    SystemNavigator.pop();
                  } else if (Platform.isAndroid) exit(0);
                  return false;
                },
                child: AlertDialog(
                  title: Text("Warning"),
                  actions: [
                    FlatButton(
                      /* onPressed: () {
                      prefs.setBool("Accept_Terms", false);
                      exit(0);
                    },*/
                      onPressed: () async {
                        prefs.setBool("Accept_Terms", false);
                        if (Platform.isIOS) {
                          SystemNavigator.pop();
                        } else if (Platform.isAndroid) exit(0);
                      },
                      child: Text("Close"),
                    ),
                    RaisedButton(
                      onPressed: () {
                        //  prefs.setString('Accept_Terms', 'true');
                        prefs.setBool("Accept_Terms", true);
                        Navigator.of(context).pop();
                      },
                      child: Text("Accept"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    )
                  ],
                  content: Text("I Accept Terms and Conditions of this Bank"),
                ),
              ));
    }
  }

  @override
  void initState() {
    checkVersionCompatible();
    SharedPreferences pref = StaticValues.sharedPreferences;
    MPin = pref.getString(StaticValues.Mpin);
    //   print("MPIN : $MPin");
    /*  Future.delayed(Duration.zero, () {
      termsAndConditions();
    });*/

    //  String myTerms = prefs.getString('Accept_Terms');

    /*  if(myTerms != "true"){

    }*/

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: pageCtrlTime),
      reverseDuration: Duration(milliseconds: pageCtrlTime),
    );
    _floatingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: pageCtrlTime),
      reverseDuration: Duration(milliseconds: pageCtrlTime),
    );
    _animation =
        Tween<double>(begin: 1.41, end: 1.67).animate(_animationController)
          ..addListener(() {
            setState(() {
              print(_animationController.isDismissed);
            });
          });
    _floatingAnimation =
        Tween<double>(begin: .23, end: .1).animate(_floatingAnimationController)
          ..addListener(() {
            setState(() {});
          });
    Future.delayed(Duration(seconds: 2), () {
      final dynamic tooltip = _regToolTipKey.currentState;
      tooltip.ensureTooltipVisible();
    });

    loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show an alert dialog when the user presses the back button
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            // title: Text('Do you want to exit app?'),
            title: Text(doYouWantToExitList[int.parse(languageId)]),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).secondaryHeaderColor,
                ),
                onPressed: () => Navigator.of(context).pop(false),
                // child: Text('No'),
                child: Text(noList[int.parse(languageId)]),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).secondaryHeaderColor,
                ),
                onPressed: () => SystemNavigator.pop(),
                // child: Text('Yes'),
                child: Text(yesList[int.parse(languageId)]),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
          onWillPop: () async {
            if (_pageController.page == 0 || _pageController.page == 2) {
              _pageController.animateToPage(
                1,
                duration: Duration(milliseconds: pageCtrlTime),
                curve: _pageCurves,
              );
              reverseAnimate();
              return false;
            } else {
              return true;
            }
          },
          child: Stack(
            children: <Widget>[
              // Container(
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [
              //         // Theme.of(context).buttonColor,
              //         // Theme.of(context).accentColor,
              //         // Theme.of(context).primaryColor,
              //         Colors.indigo[400],
              //         Colors.indigo[400],
              //         Colors.indigo[400],
              //         Colors.indigo[400],
              //         // Theme.of(context).secondaryHeaderColor,
              //       ],
              //       tileMode: TileMode.repeated,
              //       begin: Alignment(0.0, 0.5),
              //       stops: [0.0, 0.5, 0.8, 1.0],
              //     ),
              //   ),
              // ),

              Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,

                ///Network Image
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: NetworkImage(
                //         "https://d36tnp772eyphs.cloudfront.net/blogs/1/2019/12/Lush-Cocora-Valley-Colombia-1200x853.jpg"),
                //     // "https://images.pexels.com/photos/3009861/pexels-photo-3009861.jpeg"),
                //     fit: BoxFit.cover,
                //   ),
                // ),

                ///Asset Image
                child: Image.asset(
                  "assets/login_bg.jpg",
                  fit: BoxFit.cover,
                  // color: Colors.white10,
                ),
              ),

              /*    Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    "assets/safesoftware_logo.png",
                    width: 200,
                  )),*/
              Align(
                alignment: Alignment.center,

                ///this SingleChildScrollView set to visible TextField when SoftKeyboard appears
                child: SingleChildScrollView(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: pageCtrlTime),
                    curve: Curves.easeIn,
                    width: MediaQuery.of(context).size.width * .8,
                    height:
                        MediaQuery.of(context).size.width * _animation.value,
                    //onRegister .83
                    child: Card(
                      color: Colors.white.withOpacity(0.6),
                      elevation: 0.0,
                      borderOnForeground: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: <Widget>[
                          ForgotUI(
                            scaffoldKey: _scaffoldKey,
                            onTap: () {
                              setState(() {
                                _pageController.nextPage(
                                  duration:
                                      Duration(milliseconds: pageCtrlTime),
                                  curve: _pageCurves,
                                );
                              });
                            },
                          ),
                          LoginUI(
                            version: version,
                            scaffold: _scaffoldKey,
                            onTap: () {
                              setState(() {
                                _pageController.previousPage(
                                  duration:
                                      Duration(milliseconds: pageCtrlTime),
                                  curve: _pageCurves,
                                );
                              });
                            },
                            forgotUser: () {
                              setState(() {
                                _pageController.nextPage(
                                  duration:
                                      Duration(milliseconds: pageCtrlTime),
                                  curve: _pageCurves,
                                );
                              });
                            },
                          ),
                          RegisterUI(
                            onTap: () {
                              setState(() {
                                _pageController.animateToPage(
                                  1,
                                  duration:
                                      Duration(milliseconds: pageCtrlTime),
                                  curve: _pageCurves,
                                );
                                reverseAnimate();
                              });
                            },
                            scaffoldKey: _scaffoldKey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                  duration: Duration(milliseconds: pageCtrlTime),
                  right: MediaQuery.of(context).size.width * .035,
                  curve: _animationCurves,
                  top: MediaQuery.of(context).size.width *
                      _floatingAnimation.value,
                  //onRegister .03
                  child: Tooltip(
                    key: _regToolTipKey,
                    // message: "Click + to register",
                    message: clickPlusList[int.parse(languageId)],
                    preferBelow: false,
                    decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                        borderRadius: BorderRadius.circular(20.0)),
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: pageCtrlTime),
                              curve: _pageCurves,
                            );
//                      _animationController.forward();
//                      _floatingAnimationController.forward();
                          },
                          disabledElevation: 1.0,
                          isExtended: true,
                          // backgroundColor: Theme.of(context).buttonColor,
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                          child: Icon(Icons.add),
                          elevation: 8.0,
                        ),
                        SizedBox(
                          width: 10,
                        ),
//                         FloatingActionButton(
//                           onPressed: () {
//                             showModalBottomSheet(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return LanquageUI();
//                               },
//                             );
// //                      _animationController.forward();
// //                      _floatingAnimationController.forward();
//                           },
//                           disabledElevation: 1.0,
//                           isExtended: true,
//                           backgroundColor: Theme.of(context).buttonColor,
//                           child: Icon(Icons.public),
//                           elevation: 8.0,
//                         ),
                      ],
                    ),
                  )),
//               FloatingActionButton(
//                 onPressed: () {
//                   showModalBottomSheet(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return LanquageUI();
//                     },
//                   );
// //                      _animationController.forward();
// //                      _floatingAnimationController.forward();
//                 },
//                 disabledElevation: 1.0,
//                 isExtended: true,
//                 backgroundColor: Theme.of(context).buttonColor,
//                 child: Icon(Icons.public),
//                 elevation: 8.0,
//               ),
            ],
          ),
        ),
      ),
    );
  }

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
      print(languageId);
    });
  }
}

class LoginUI extends StatefulWidget {
  final GestureTapCallback onTap;
  final GestureTapCallback forgotUser;
  final GlobalKey<ScaffoldState> scaffold;
  final String version;

  const LoginUI(
      {Key key,
      this.onTap,
      @required this.scaffold,
      this.forgotUser,
      this.version})
      : super(key: key);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  SharedPreferences preferences;
  var languageId = "";

  // List<String> List = ["","","",""];
  List<String> languageList = ["Language", "Langue", "Idioma", "Linguagem"];
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
  List<String> pwLengthList = [
    "Password length should be 4",
    "La longueur du mot de passe doit être de 4",
    "La longitud de la contraseña debe ser 4",
    "O comprimento da senha deve ser 4"
  ];
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
  List<String> loginList = [
    "Login",
    "Connexion",
    "inicio de sesión",
    "Conecte-se"
  ];
  List<String> mpinLengthList = [
    "MPin length should be 4",
    "La longueur de MPin doit être de 4",
    "La longitud de MPin debe ser 4",
    "MPin comprimento deve ser 4"
  ];
  List<String> forgotpwList = [
    "Forgot Password ?",
    "mot de passe oublié ?",
    "olvidó contraseña ?",
    "Esqueceu sua senha ?"
  ];
  List<String> forgotUserList = [
    "Forgot user ?",
    "utilisateur oublié ?",
    "olvidó usuario ?",
    "Esqueceu usuário ?"
  ];
  List<String> customCreationList = [
    "Customer Creation",
    "Création de client",
    "Creación de clientes",
    "Criação de cliente"
  ];
  List<String> otpMissMatchList = [
    "OTP Miss Match",
    "Match manqué OTP",
    "Partido perdido de OTP",
    "Correspondência perdida OTP"
  ];

  // List<String> List = ["","","",""];
  // List<String> List = ["","","",""];
  // List<String> List = ["","","",""];

  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController mpinCtrl = TextEditingController();
  bool mobVal = false, passVal = false, mpinVal = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  LoginModel login = LoginModel();
  bool _isLoading = false;
  String MPin, strCustName;
  Map response;
  String str_Otp;
  var _pass;
  bool isLoading = false;
  int count = 0;

  void saveData(LoginModel loginModel) async {
    SharedPreferences preferences = StaticValues.sharedPreferences;
    print("CUST ID :: ${loginModel.table[0].toString()}");
    await preferences.setString(
        StaticValues.custID, loginModel.table[0].custId.toString());
    await preferences.setString(
        StaticValues.branchCode, loginModel.table[0].brCode.toString());
    await preferences.setString(
        StaticValues.schemeCode, loginModel.table[0].schCode.toString());
    await preferences.setString(
        StaticValues.accNumber, loginModel.table[0].accNo.toString());
    await preferences.setString(
        StaticValues.ifsc, loginModel.table[0].ifsc.toString());
    await preferences.setString(
        StaticValues.accName, loginModel.table[0].custName.toString());
    await preferences.setString(
        StaticValues.mobileNo, loginModel.table[0].mobile.toString());
    await preferences.setString(
        StaticValues.accountNo, loginModel.table[0].accountNo.toString());
    //  await preferences.setString(StaticValues.userPass, passCtrl.text);
    await preferences.setString(
        StaticValues.address,
        loginModel.table[0].adds
            .split(",")
            .toList()
            .where((element) => element.isNotEmpty)
            .join(",")
            .toString());
    Navigator.of(context).pushReplacementNamed("/HomePage");
  }

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
      print(languageId);
    });
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  void initState() {
    setState(() {
      SharedPreferences pref = StaticValues.sharedPreferences;
      MPin = pref.getString(StaticValues.Mpin);
      strCustName = pref.getString(StaticValues.accName);
      print("MPIN : $MPin");
      /*usernameCtrl.text = "nira";
      passCtrl.text = "1234";*/
//      usernameCtrl.text = "vidya";
//      passCtrl.text = "123456";
//      usernameCtrl.text = "9895564690";
//      passCtrl.text = "123456";
    });

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
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // GlobalWidgets().logoWithText(context, StaticValues.titleDecoration),
              // GlobalWidgets().logoWithoutText(context, StaticValues.titleDecoration),
              Image.asset(
                "assets/mini-logo.png",
                width: 150,
                height: 150,
                // color: Colors.white10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextView(
                            // "Sign In",
                            signInList[int.parse(languageId)],
                            size: MediaQuery.of(context).size.width / 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            height: 50,
                            width: 130,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: OutlinedButton(
                              // style: ButtonStyle(
                              //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              //     RoundedRectangleBorder(
                              //       side: BorderSide(color: Colors.black, width: 1,),
                              //       borderRadius: BorderRadius.circular(10.0),
                              //     ),
                              //   ),
                              // ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return LanquageUI();
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.public,
                                    // color: Colors.red,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    size:
                                        MediaQuery.of(context).size.width / 22,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    // "Language",
                                    languageList[int.parse(languageId)],
                                    style: TextStyle(
                                      // color: Theme.of(context).primaryColor,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              27,
                                    ),
                                  ),
                                  // Text(languageId),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Visibility(
                      visible: MPin == null ? true : false,
                      child: Column(
                        children: [
                          EditTextBordered(
                            controller: usernameCtrl,
                            // hint: "Username",
                            hint: userNameList[int.parse(languageId)],
                            // errorText: mobVal ? "Username is invalid" : null,
                            hintColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            color: Colors.white,
                            //Input Text Color
                            filled: true,
                            fillColor: Theme.of(context).secondaryHeaderColor,
                            errorText: mobVal
                                ? invalidUsernameList[int.parse(languageId)]
                                : null,
                            setBorder: true,
                            borderColor: Colors.black,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.none,
                            textInputAction: TextInputAction.next,
                            setDecoration: true,
                            onChange: (value) {
                              setState(() {
                                mobVal = value.trim().length == 0;
                              });
                            },
                            onSubmitted: (_) {
                              FocusScope.of(context).nextFocus();
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          EditTextBordered(
                            controller: passCtrl,
                            // hint: "Password",
                            hint: pwList[int.parse(languageId)],
                            // errorText: passVal ? "Password length should be 4" : null,
                            hintColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            color: Colors.white,
                            //Input Text Color
                            filled: true,
                            fillColor: Theme.of(context).secondaryHeaderColor,
                            errorText: passVal
                                ? pwLengthList[int.parse(languageId)]
                                : null,
                            obscureText: true,
                            showObscureIcon: true,
                            borderColor: Colors.black,
                            onChange: (value) {
                              setState(() {
                                passVal = value.trim().length < 4;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          // Container(
                          //   height: 50,
                          //   width: 130,
                          //   decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.black),
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          //   child: OutlinedButton(
                          //     // style: ButtonStyle(
                          //     //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          //     //     RoundedRectangleBorder(
                          //     //       side: BorderSide(color: Colors.black, width: 1,),
                          //     //       borderRadius: BorderRadius.circular(10.0),
                          //     //     ),
                          //     //   ),
                          //     // ),
                          //     onPressed: () {
                          //       showModalBottomSheet(
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return LanquageUI();
                          //         },
                          //       );
                          //     },
                          //     child: Row(
                          //       children: [
                          //         Icon(
                          //           Icons.public,
                          //           color: Colors.red,
                          //         ),
                          //         SizedBox(
                          //           width: 10,
                          //         ),
                          //         Text(
                          //           "Language",
                          //           style: TextStyle(color: Colors.black),
                          //         ),
                          //         // Text(languageId),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10.0,
                          // ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: MPin == null ? false : true,
                      child: Column(
                        children: [
                          TextView(
                            strCustName,
                            size: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          EditTextBordered(
                            controller: mpinCtrl,
                            hint: "MPin",
                            hintColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            color: Colors.white,
                            //Input Text Color
                            filled: true,
                            fillColor: Theme.of(context).secondaryHeaderColor,
                            errorText: mpinVal
                                ? mpinLengthList[int.parse(languageId)]
                                : null,
                            keyboardType: TextInputType.number,
                            borderColor: Colors.black,
                            // obscureText: true,
                            // showObscureIcon: true,
                            onChange: (value) {
                              setState(() {
                                mpinVal = value.trim().length < 4;
                              });
                            },
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: widget.onTap,
                            child: TextView(
                              // "Forgot password ?",
                              forgotpwList[int.parse(languageId)],
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: widget.forgotUser,
                            child: TextView(
                              // "Forgot user ?",
                              forgotUserList[int.parse(languageId)],
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              //     showAlertDialog(context);

                              //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomerCreationHome()));
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CustomerChecking()));
                            },
                            child: TextView(
                              // "Customer Creation",
                              customCreationList[int.parse(languageId)],
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        child: TextView(
                          "Version : ${widget.version}",
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // CustomRaisedIndigoButton(
              //   loadingValue: _isLoading,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.only(
              //       bottomLeft: Radius.circular(20.0),
              //       bottomRight: Radius.circular(20.0),
              //     ),
              //   ),
              //   onPressed: () async {
              //     print(usernameCtrl.text);
              //     setState(() {
              //       passVal = passCtrl.text.trim().length < 4;
              //       mobVal = usernameCtrl.text.trim().length == 0;
              //     });
              //
              //     if (MPin == null) {
              //       if (!passVal && !mobVal) {
              //         print("ALL true");
              //         _isLoading = true;
              //         try {
              //           response = await RestAPI().get(
              //               "${APis.loginUrl}Mob_no=${usernameCtrl.text}&pwd=${passCtrl.text}&IMEI=863675039500942");
              //
              //           setState(() async {
              //             _isLoading = false;
              //
              //             //   if ((response["Table"][0] as Map).containsKey("Invalid")) {
              //             if (response["Table"][0]["Cust_id"] == "Invalid") {
              //               setState(() {
              //                 _isLoading = false;
              //               });
              //               print("LIJITH");
              //               GlobalWidgets().showSnackBar(
              //                   widget.scaffold, response["Table"][0]["Msg"]);
              //             }
              //             if (response["Table"][0]["Cust_id"] == "Blocked") {
              //               setState(() {
              //                 _isLoading = false;
              //               });
              //               //  if (response["Table"][0]["Cust_id"] == "Invalid"){
              //               print("Blocked");
              //               GlobalWidgets().showSnackBar(
              //                   widget.scaffold, response["Table"][0]["Msg"]);
              //             } else {
              //               var response1 =
              //                   await RestAPI().post(APis.GenerateOTP, params: {
              //                 "MobileNo": response["Table"][0]["Mobile"],
              //                 "Amt": "0",
              //                 "SMS_Module": "GENERAL",
              //                 "SMS_Type": "GENERAL_OTP",
              //                 "OTP_Return": "Y"
              //               });
              //               print("rechargeResponse::: $response1");
              //               str_Otp = response1[0]["OTP"];
              //
              //               //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(str_Message)));
              //               //  RestAPI().get(APis.rechargeMobile(params));
              //               /*    Map response =
              //                     await RestAPI().get(APis.rechargeMobile(params));*/
              //               //   getMobileRecharge();
              //               setState(() {
              //                 //     isLoading = false;
              //
              //                 Timer(Duration(minutes: 5), () {
              //                   setState(() {
              //                     str_Otp = "";
              //                   });
              //                 });
              //               });
              //
              //               ///TODO  for otp while login
              //               _loginConfirmation();
              //
              //               /*LoginModel login = LoginModel.fromJson(response);
              //                 saveData(login);*/
              //             }
              //           });
              //         } on RestException catch (e) {
              //           setState(() {
              //             _isLoading = false;
              //           });
              //
              //           GlobalWidgets()
              //               .showSnackBar(widget.scaffold, e.message);
              //         }
              //       }
              //     } else {
              //       if (!mpinVal) {
              //         print("ALL true");
              //         _isLoading = true;
              //         try {
              //           SharedPreferences pref = StaticValues.sharedPreferences;
              //
              //           response = await RestAPI().get(
              //               "${APis.loginMPin}CustId=${pref.getString(StaticValues.custID)}&MPin=${mpinCtrl.text}");
              //           /*   response = await RestAPI().post(APis.loginMpin,params: {
              //
              //               "CustID": "1010001",
              //               "MPIN": mpinCtrl.text
              //             });*/
              //
              //           setState(() async {
              //             _isLoading = false;
              //             /*     if ((response["Table"][0] as Map).containsKey("Invalid")) {
              //             //  if (response["Table"][0]["Cust_id"] == "Invalid"){
              //                 print("Invalis");
              //                 GlobalWidgets()
              //                     .showSnackBar(widget.scaffold, "Invalid Credentials");
              //               }
              //          if ((response["Table"][0] as Map).containsKey("Blocked")) {
              //                 //  if (response["Table"][0]["Cust_id"] == "Invalid"){
              //                 print("Blocked");
              //                 GlobalWidgets()
              //                     .showSnackBar(widget.scaffold, "Your Account is Blocked");
              //               }*/
              //             if ((response["Table"][0]["Cust_id"]) == "Invalid") {
              //               print("LIJITH");
              //               setState(() {
              //                 _isLoading = false;
              //               });
              //               GlobalWidgets().showSnackBar(
              //                   widget.scaffold, response["Table"][0]["Msg"]);
              //             }
              //             if (response["Table"][0]["Cust_id"] == "Blocked") {
              //               //  if (response["Table"][0]["Cust_id"] == "Invalid"){
              //               setState(() {
              //                 _isLoading = false;
              //               });
              //               print("Blocked");
              //               GlobalWidgets().showSnackBar(
              //                   widget.scaffold, response["Table"][0]["Msg"]);
              //             } else {
              //               var response1 =
              //                   await RestAPI().post(APis.GenerateOTP, params: {
              //                 "MobileNo": response["Table"][0]["Mobile"],
              //                 "Amt": "0",
              //                 "SMS_Module": "GENERAL",
              //                 "SMS_Type": "GENERAL_OTP",
              //                 "OTP_Return": "Y"
              //               });
              //               print("rechargeResponse::: $response1");
              //               str_Otp = response1[0]["OTP"];
              //
              //               //   getMobileRecharge();
              //               setState(() {
              //                 //     isLoading = false;
              //
              //                 Timer(Duration(minutes: 5), () {
              //                   setState(() {
              //                     str_Otp = "";
              //                   });
              //                 });
              //               });
              //
              //               ///TODO  for otp while login
              //               _loginConfirmation();
              //
              //               /* LoginModel login = LoginModel.fromJson(response);
              //                 saveData(login);*/
              //             }
              //           });
              //         } on RestException catch (e) {
              //           setState(() {
              //             _isLoading = false;
              //           });
              //
              //           GlobalWidgets()
              //               .showSnackBar(widget.scaffold, e.message);
              //         }
              //       }
              //     }
              //   },
              //   // buttonText: "Login"
              //   buttonText: loginList[int.parse(languageId)],
              // ),

              /*CustomRaisedButton(
                color: Theme.of(context).buttonColor,
                disabledColor: Theme.of(context).buttonColor,
                padding: EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                onPressed: _isLoading
                    ? null
                    : () async {
	          print(usernameCtrl.text);
	          setState(() {
		          passVal = passCtrl.text.trim().length < 4;
		          mobVal = usernameCtrl.text.trim().length == 0;
	          });

	          if (!passVal && !mobVal) {
		          print("ALL true");
		          _isLoading = true;
		          Map response = await RestAPI().get(
				          "${APis.loginUrl}Mob_no=${usernameCtrl.text}&pwd=${passCtrl.text}&IMEI=863675039500942");
		          setState(() {

			          _isLoading = false;
			          if ((response["Table"][0] as Map).containsKey("invalid")) {
				          GlobalWidgets().showSnackBar(widget.scaffold, "Invalid Credentials");
			          } else {
				          LoginModel login = LoginModel.fromJson(response);
				          saveData(login);
			          }
		          });
	          }
                },
                child: _isLoading
                    ? SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          semanticsLabel: "Loading",
                        ))
                    : TextView(
                        "Login",
                        color: Colors.white,
                        size: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
              )*/
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          width: MediaQuery.of(context).size.width * .78,
          child: CustomRaisedIndigoButton(
            loadingValue: _isLoading,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            onPressed: () async {
              print(usernameCtrl.text);
              setState(() {
                passVal = passCtrl.text.trim().length < 4;
                mobVal = usernameCtrl.text.trim().length == 0;
              });

              if (MPin == null) {
                if (!passVal && !mobVal) {
                  print("ALL true");
                  _isLoading = true;
                  try {
                    response = await RestAPI().get(
                        "${APis.loginUrl}Mob_no=${usernameCtrl.text}&pwd=${passCtrl.text}&IMEI=863675039500942");

                    setState(() async {
                      _isLoading = false;

                      //   if ((response["Table"][0] as Map).containsKey("Invalid")) {
                      if (response["Table"][0]["Cust_id"] == "Invalid") {
                        setState(() {
                          _isLoading = false;
                        });
                        print("LIJITH");
                        GlobalWidgets().showSnackBar(
                            widget.scaffold, response["Table"][0]["Msg"]);
                      }
                      if (response["Table"][0]["Cust_id"] == "Blocked") {
                        setState(() {
                          _isLoading = false;
                        });
                        //  if (response["Table"][0]["Cust_id"] == "Invalid"){
                        print("Blocked");
                        GlobalWidgets().showSnackBar(
                            widget.scaffold, response["Table"][0]["Msg"]);
                      } else {
                        var response1 =
                            await RestAPI().post(APis.GenerateOTP, params: {
                          "MobileNo": response["Table"][0]["Mobile"],
                          "Amt": "0",
                          "SMS_Module": "GENERAL",
                          "SMS_Type": "GENERAL_OTP",
                          "OTP_Return": "Y"
                        });
                        print("rechargeResponse::: $response1");
                        str_Otp = response1[0]["OTP"];

                        //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(str_Message)));
                        //  RestAPI().get(APis.rechargeMobile(params));
                        /*    Map response =
                                await RestAPI().get(APis.rechargeMobile(params));*/
                        //   getMobileRecharge();
                        setState(() {
                          //     isLoading = false;

                          Timer(Duration(minutes: 5), () {
                            setState(() {
                              str_Otp = "";
                            });
                          });
                        });

                        ///TODO  for otp while login
                        _loginConfirmation();

                        /*LoginModel login = LoginModel.fromJson(response);
                            saveData(login);*/
                      }
                    });
                  } on RestException catch (e) {
                    setState(() {
                      _isLoading = false;
                    });

                    GlobalWidgets().showSnackBar(widget.scaffold, e.message);
                  }
                }
              } else {
                if (!mpinVal) {
                  print("ALL true");
                  _isLoading = true;
                  try {
                    SharedPreferences pref = StaticValues.sharedPreferences;

                    response = await RestAPI().get(
                        "${APis.loginMPin}CustId=${pref.getString(StaticValues.custID)}&MPin=${mpinCtrl.text}");
                    /*   response = await RestAPI().post(APis.loginMpin,params: {

                          "CustID": "1010001",
                          "MPIN": mpinCtrl.text
                        });*/

                    setState(() async {
                      _isLoading = false;
                      /*     if ((response["Table"][0] as Map).containsKey("Invalid")) {
                        //  if (response["Table"][0]["Cust_id"] == "Invalid"){
                            print("Invalis");
                            GlobalWidgets()
                                .showSnackBar(widget.scaffold, "Invalid Credentials");
                          }
                     if ((response["Table"][0] as Map).containsKey("Blocked")) {
                            //  if (response["Table"][0]["Cust_id"] == "Invalid"){
                            print("Blocked");
                            GlobalWidgets()
                                .showSnackBar(widget.scaffold, "Your Account is Blocked");
                          }*/
                      if ((response["Table"][0]["Cust_id"]) == "Invalid") {
                        print("LIJITH");
                        setState(() {
                          _isLoading = false;
                        });
                        GlobalWidgets().showSnackBar(
                            widget.scaffold, response["Table"][0]["Msg"]);
                      }
                      if (response["Table"][0]["Cust_id"] == "Blocked") {
                        //  if (response["Table"][0]["Cust_id"] == "Invalid"){
                        setState(() {
                          _isLoading = false;
                        });
                        print("Blocked");
                        GlobalWidgets().showSnackBar(
                            widget.scaffold, response["Table"][0]["Msg"]);
                      } else {
                        var response1 =
                            await RestAPI().post(APis.GenerateOTP, params: {
                          "MobileNo": response["Table"][0]["Mobile"],
                          "Amt": "0",
                          "SMS_Module": "GENERAL",
                          "SMS_Type": "GENERAL_OTP",
                          "OTP_Return": "Y"
                        });
                        print("rechargeResponse::: $response1");
                        str_Otp = response1[0]["OTP"];

                        //   getMobileRecharge();
                        setState(() {
                          //     isLoading = false;

                          Timer(Duration(minutes: 5), () {
                            setState(() {
                              str_Otp = "";
                            });
                          });
                        });

                        ///TODO  for otp while login
                        _loginConfirmation();

                        /* LoginModel login = LoginModel.fromJson(response);
                            saveData(login);*/
                      }
                    });
                  } on RestException catch (e) {
                    setState(() {
                      _isLoading = false;
                    });

                    GlobalWidgets().showSnackBar(widget.scaffold, e.message);
                  }
                }
              }
            },
            // buttonText: "Login"
            buttonText: loginList[int.parse(languageId)],
          ),
        )
      ],
    );
  }

  void _loginConfirmation() {
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
            size: 16.0,
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
      actionButton: StatefulBuilder(
        builder: (context, setState) => CustomRaisedIndigoButton(
          loadingValue: isLoading,
          // buttonText: isLoading?CircularProgressIndicator():"LOGIN",
          buttonText: isLoading
              ? CircularProgressIndicator()
              : loginList[int.parse(languageId)],
          onPressed: isLoading
              ? null
              : () async {
                  if (_pass == str_Otp) {
                    if (MPin == null) {
                      SharedPreferences preferences =
                          StaticValues.sharedPreferences;
                      preferences.setString(
                          StaticValues.userPass, passCtrl.text);
                      LoginModel login = LoginModel.fromJson(response);
                      saveData(login);

                      print("LIJU");
                    } else {
                      LoginModel login = LoginModel.fromJson(response);
                      saveData(login);
                      print("LIJU");
                    }
                  } else {
                    Fluttertoast.showToast(
                        // msg: "OTP Miss match",
                        msg: otpMissMatchList[int.parse(languageId)],
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
        ),
      ),
    );
  }
}

class ForgotUI extends StatefulWidget {
  final Function onTap;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ForgotUI({Key key, this.onTap, @required this.scaffoldKey})
      : super(key: key);

  @override
  _ForgotUIState createState() => _ForgotUIState();
}

class _ForgotUIState extends State<ForgotUI> {
  SharedPreferences preferences;
  var languageId = "";

  TextEditingController userIdCtrl = TextEditingController(),
      otpCtrl = TextEditingController(),
      rePassCtrl = TextEditingController(),
      passCtrl = TextEditingController();
  bool userIdVal = false,
      otpValid = false,
      passValid = false,
      rePassValid = false,
      isGetOTP = false;
  String strOtp;

  bool _isLoading = false;

  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> mobileNoInvalidList = [
    "Mobile number is invalid",
    "Le numéro de portable est invalide",
    "El número de móvil no es válido",
    "O número do celular é inválido"
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
  List<String> pwLengthList = [
    "Password length should be 4",
    "La longueur du mot de passe doit être de 4",
    "La longitud de la contraseña debe ser 4",
    "O comprimento da senha deve ser 4"
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
  List<String> loginList = [
    "Login",
    "Connexion",
    "inicio de sesión",
    "Conecte-se"
  ];
  List<String> mpinLengthList = [
    "MPin length should be 4",
    "La longueur de MPin doit être de 4",
    "La longitud de MPin debe ser 4",
    "MPin comprimento deve ser 4"
  ];
  List<String> forgotUserList = [
    "Forgot user",
    "utilisateur oublié",
    "olvidó usuario",
    "Esqueceu usuário"
  ];
  List<String> customCreationList = [
    "Customer Creation",
    "Création de client",
    "Creación de clientes",
    "Criação de cliente"
  ];

  List<String> forgotpwList = [
    "Forgot Password?",
    "mot de passe oublié",
    "olvidó contraseña",
    "Esqueceu sua senha"
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
  List<String> npwList = [
    "New Password",
    "nouveau mot de passe",
    "Nueva contraseña",
    "Nova Senha"
  ];
  List<String> enterUserIDList = [
    "Enter User ID",
    "Entrez l'ID utilisateur",
    "Ingrese la identificación de usuario",
    "Digite o ID do usuário"
  ];
  List<String> invalidUserIDList = [
    "Invalid User ID",
    "Identifiant invalide",
    "ID de usuario invalido",
    "ID de usuário inválido"
  ];
  List<String> upwList = [
    "Update Password",
    "Mettre à jour le mot de passe",
    "Actualiza contraseña",
    "Atualizar senha"
  ];
  List<String> getOTPList = [
    "Get OTP",
    "Obtenir OTP",
    "Obtener OTP",
    "Obter OTP"
  ];
  List<String> otpNotMatchList = [
    "OTP not maching",
    "OTP ne correspond pas",
    "OTP no coincide",
    "OTP não correspondente"
  ];
  List<String> removeSpacePwList = [
    "Please remove space from password",
    "Veuillez supprimer l'espace du mot de passe",
    "Quite el espacio de la contraseña",
    "Remova o espaço da senha"
  ];
  List<String> includeSpCharPwList = [
    "Please include special charcters in password",
    "Veuillez inclure des caractères spéciaux dans le mot de passe",
    "Por favor incluya caracteres especiales en la contraseña",
    "Inclua caracteres especiais na senha"
  ];
  List<String> sentList = ["Sent", "Envoyé", "Enviado", "Enviado"];
  List<String> somethingWrongList = [
    "Something went wrong",
    "Quelque chose s'est mal passé",
    "Algo salió mal",
    "algo deu errado"
  ];
  List<String> plsFillMissingFieldsList = [
    "Please fill the missing fields",
    "Veuillez remplir les champs manquants",
    "Por favor complete los campos que faltan",
    "Por favor, preencha os campos que faltam"
  ];
  List<String> pwChangedSuccessfullyList = [
    "Password changed successfully",
    "Le mot de passe a été changé avec succès",
    "Contraseña cambiada con éxito",
    "Senha alterada com sucesso"
  ];

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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextView(
                // "Forgot Password ?",
                forgotpwList[int.parse(languageId)],
                size: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).secondaryHeaderColor,
              ),
              SizedBox(
                height: 30.0,
              ),
              EditTextBordered(
                controller: userIdCtrl,
                // hint: "Enter User ID",
                hint: enterUserIDList[int.parse(languageId)],
                // errorText: userIdVal ? "Invalid User ID" : null,
                hintColor: Theme.of(context).scaffoldBackgroundColor,
                color: Colors.white,
                //Input Text Color
                filled: true,
                fillColor: Theme.of(context).secondaryHeaderColor,
                errorText:
                    userIdVal ? invalidUserIDList[int.parse(languageId)] : null,
                borderColor: Colors.black,
                onChange: (value) {
                  setState(() {
                    userIdVal = value.trim().isEmpty;
                    isGetOTP = false;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              EditTextBordered(
                controller: otpCtrl,
                // hint: "Enter OTP",
                hint: enterOTPList[int.parse(languageId)],
                // errorText: otpValid ? "OTP length should be 4" : null,
                hintColor: Theme.of(context).scaffoldBackgroundColor,
                color: Colors.white,
                //Input Text Color
                filled: true,
                fillColor: Theme.of(context).secondaryHeaderColor,
                errorText:
                    otpValid ? otpLengthList[int.parse(languageId)] : null,
                borderColor: Colors.black,
                onChange: (value) {
                  setState(() {
                    otpValid = value.trim().length < 4;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              EditTextBordered(
                controller: passCtrl,
                // hint: "New password",
                hint: npwList[int.parse(languageId)],
                hintColor: Theme.of(context).scaffoldBackgroundColor,
                color: Colors.white,
                //Input Text Color
                filled: true,
                fillColor: Theme.of(context).secondaryHeaderColor,
                obscureText: true,
                showObscureIcon: true,
                borderColor: Colors.black,
                // // errorText: passValid ? "Password length should be 4" : null,
                // errorText: passValid ? "Please include special charcters" : null,
                errorText:
                    passValid ? includeSpCharList[int.parse(languageId)] : null,
                onChange: (value) {
                  setState(() {
                    //  passValid = value.trim().length < 4;
                    passValid = RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value);
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              EditTextBordered(
                controller: rePassCtrl,
                // hint: "Confirm new password",
                hint: cpwList[int.parse(languageId)],
                hintColor: Theme.of(context).scaffoldBackgroundColor,
                color: Colors.white,
                //Input Text Color
                filled: true,
                fillColor: Theme.of(context).secondaryHeaderColor,
                obscureText: true,
                showObscureIcon: true,
                borderColor: Colors.black,
                // errorText: rePassValid ? "Password not matching" : null,
                errorText:
                    rePassValid ? pwNotMatchList[int.parse(languageId)] : null,
                onChange: (value) {
                  setState(() {
                    rePassValid = rePassCtrl.text != passCtrl.text;
                  });
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: CustomRaisedIndigoButton(
            // buttonText: isGetOTP ? "Update Password" : "Get OTP",
            buttonText: isGetOTP
                ? upwList[int.parse(languageId)]
                : getOTPList[int.parse(languageId)],
            loadingValue: _isLoading,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            onPressed: () async {
              if (!isGetOTP) {
                if (userIdCtrl.text.length > 0) {
                  _isLoading = true;
                  Map response = await RestAPI()
                      .get("${APis.getPassChangeOTP}UserId=${userIdCtrl.text}");
                  _isLoading = false;
                  if (response["Table"][0]["statuscode"] == 1) {
                    strOtp = response["Table"][0]["OTP"];
                    GlobalWidgets()
                        // .showSnackBar(widget.scaffoldKey, "OTP sent");
                        .showSnackBar(widget.scaffoldKey,
                            "OTP ${sentList[int.parse(languageId)]}");
                    setState(() {
                      isGetOTP = true;
                    });
                  } else {
                    // GlobalWidgets()
                    //     .showSnackBar(widget.scaffoldKey, "Invalid User ID");
                    GlobalWidgets().showSnackBar(widget.scaffoldKey,
                        invalidUserIDList[int.parse(languageId)]);
                  }
                } else {
                  // GlobalWidgets()
                  //     .showSnackBar(widget.scaffoldKey, "Invalid User ID");
                  GlobalWidgets().showSnackBar(widget.scaffoldKey,
                      invalidUserIDList[int.parse(languageId)]);
                }
              } else {
                bool passValue =
                    passCtrl.text.contains(new RegExp(r"^[a-zA-Z0-9]+$"));
                if (passValue) {
                  // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Please include special charcters in password");
                  GlobalWidgets().showSnackBar(widget.scaffoldKey,
                      includeSpCharPwList[int.parse(languageId)]);
                } else if (strOtp != otpCtrl.text) {
                  // GlobalWidgets().showSnackBar(widget.scaffoldKey, "OTP miss match");
                  GlobalWidgets().showSnackBar(widget.scaffoldKey,
                      otpNotMatchList[int.parse(languageId)]);
                } else if (passCtrl.text != rePassCtrl.text) {
                  // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Password miss match");
                  GlobalWidgets().showSnackBar(widget.scaffoldKey,
                      pwNotMatchList[int.parse(languageId)]);
                } else if (passCtrl.text.contains(" ")) {
                  // GlobalWidgets().showSnackBar(widget.scaffoldKey, "Please remove space from password");
                  GlobalWidgets().showSnackBar(widget.scaffoldKey,
                      removeSpacePwList[int.parse(languageId)]);
                } else {
                  if (userIdCtrl.text.length <= 0 &&
                      otpCtrl.text.length < 4 &&
                      passCtrl.text.length < 4) {
                    GlobalWidgets().showSnackBar(
                        // widget.scaffoldKey, "Please fill the missing fields");
                        widget.scaffoldKey,
                        plsFillMissingFieldsList[int.parse(languageId)]);
                  } else {
                    _isLoading = true;
                    try {
                      Map response = await RestAPI().post(
                          "${APis.changeForgotPass}userid=${userIdCtrl.text}&Newpassword=${passCtrl.text}");
                      setState(() {
                        _isLoading = false;
                      });
                      if (response["Table"][0]["Column1"] ==
                          "Password Updated Successfully") {
                        GlobalWidgets().showSnackBar(
                            // widget.scaffoldKey, "Password changed successfully");
                            widget.scaffoldKey,
                            pwChangedSuccessfullyList[int.parse(languageId)]);
                        widget.onTap();
                      } else {
                        GlobalWidgets().showSnackBar(
                            // widget.scaffoldKey, "Something went wrong");
                            widget.scaffoldKey,
                            somethingWrongList[int.parse(languageId)]);
                      }
                      print(response);
                    } on RestException catch (e) {
                      setState(() {
                        _isLoading = false;
                      });

                      GlobalWidgets()
                          .showSnackBar(widget.scaffoldKey, e.message);
                    }
                  }
                }
              }
            },
          ),
        )
      ],
    );
  }
}

class LanquageUI extends StatefulWidget {
  const LanquageUI(
      {Key key, Null Function() onTap, GlobalKey<ScaffoldState> scaffoldKey})
      : super(key: key);

  @override
  _LanquageUIState createState() => _LanquageUIState();
}

class _LanquageUIState extends State<LanquageUI> {
  String languageId = "English";
  String languageId1 = "0";

  @override
  void initState() {
    super.initState();
    setLanguage();
  }

  void setLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String language = preferences.getString(StaticValues.languageId) ?? "0";
    setState(() {
      switch (language) {
        case "0":
          languageId = "English";
          break;
        case "1":
          languageId = "French";
          break;
        case "2":
          languageId = "Spanish";
          break;
        case "3":
          languageId = "Portuguese";
          break;
        default:
          languageId = "English"; // fallback to default
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context).pushReplacementNamed("/LoginPage");
      },
      child: Scaffold(
        // key: _scaffoldKeyLang,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select Language"),
              InkWell(
                onTap: () {
                  saveData();
                  Navigator.of(context).pushReplacementNamed("/LoginPage");

                  print("Language : $languageId");
                  print("LanguageId : $languageId1");
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: RadioListTile(
                  activeColor: Theme.of(context).secondaryHeaderColor,
                  title: Text("English"),
                  value: "English",
                  groupValue: languageId,
                  onChanged: (value) {
                    setState(() {
                      languageId = value.toString();
                      languageId1 = "0";
                    });
                  },
                ),
              ),
              Card(
                child: RadioListTile(
                  activeColor: Theme.of(context).secondaryHeaderColor,
                  title: Text("French"),
                  value: "French",
                  groupValue: languageId,
                  onChanged: (value) {
                    setState(() {
                      languageId = value.toString();
                      languageId1 = "1";
                    });
                  },
                ),
              ),
              Card(
                child: RadioListTile(
                  activeColor: Theme.of(context).secondaryHeaderColor,
                  title: Text("Spanish"),
                  value: "Spanish",
                  groupValue: languageId,
                  onChanged: (value) {
                    setState(() {
                      languageId = value.toString();
                      languageId1 = "2";
                    });
                  },
                ),
              ),
              Card(
                child: RadioListTile(
                  activeColor: Theme.of(context).secondaryHeaderColor,
                  title: Text("Portuguese"),
                  value: "Portuguese",
                  groupValue: languageId,
                  onChanged: (value) {
                    setState(() {
                      languageId = value.toString();
                      languageId1 = "3";
                    });
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("/LoginPage");
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all<Color>(Color(0xffE50003)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).secondaryHeaderColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveData() async {
    SharedPreferences preferences = StaticValues.sharedPreferences;

    await preferences.setString(StaticValues.languageId, languageId1);

    Navigator.of(context).pushReplacementNamed("/LoginPage");
  }
}
