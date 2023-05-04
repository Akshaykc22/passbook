import 'package:flutter/material.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Settings/MpinGenerate.dart';
import 'package:passbook_core/Util/util.dart';
import 'package:passbook_core/lanquge_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SharedPreferences preferences;
  var userId = "", acc = "", name = "", address = "", languageId = "";

  TextEditingController userIdCtrl = TextEditingController(),
      oldPasCtrl = TextEditingController(),
      newPassCtrl = TextEditingController();
  bool idValid = false, oldPassValid = false, newPassValid = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // En, Fr, Es, Pr
  // List<String> List = ["","","",""];
  List<String> settingsList = [
    "Settings",
    "Paramètres",
    "Ajustes",
    "Configurações"
  ];
  List<String> changePasswordList = [
    "Change Password",
    "Changer le mot de passe",
    "Cambiar la contraseña",
    "Alterar a senha"
  ];
  List<String> changeSecPassList = [
    "Change Security Password",
    "Modifier le mot de passe de sécurité",
    "Cambiar contraseña de seguridad",
    "Alterar senha de segurança"
  ];
  List<String> aboutUsList = [
    "About Us",
    "À propos de nous",
    "Sobre nosotros",
    "Sobre nós"
  ];
  List<String> aboutAppList = [
    "About this App",
    "À propos de cette application",
    "Acerca de esta aplicación",
    "Sobre este aplicativo"
  ];
  List<String> languageList = ["Language", "Langue", "Idioma", "Linguagem"];
  List<String> selectLangList = [
    "Select the Language",
    "Sélectionnez la langue",
    "Seleccione el idioma",
    "Selecione o idioma"
  ];
  List<String> qrCodeList = ["QR Code", "QR Code", "Código QR", "Código QR"];
  List<String> getQrCodeList = [
    "Get Your QR Code",
    "Obtenez votre code QR",
    "Consigue tu Código QR",
    "Obtenha seu código QR"
  ];
  List<String> setUpdateMpinList = [
    "Set and Update MPin",
    "Définir et mettre à jour MPin",
    "Establecer y actualizar MPin",
    "Definir e atualizar MPin"
  ];
  List<String> cancelList = ["Cancel", "Annuler", "Cancelar", "Cancelar"];
  List<String> invalidCredentialsList = [
    "Invalid Credentials",
    "Les informations d'identification invalides",
    "Credenciales no válidas",
    "Credenciais inválidas"
  ];
  List<String> plsFillMissingFieldsList = [
    "Please fill the missing fields",
    "Veuillez remplir les champs manquants",
    "Por favor complete los campos que faltan",
    "Por favor, preencha os campos que faltam"
  ];
  List<String> enterUsernameList = [
    "Enter a Username",
    "Entrez un nom d'utilisateur",
    "ingrese un nombre de usuario",
    "Digite um nome de usuário"
  ];
  List<String> userShouldNotEmptyList = [
    "User should not be empty",
    "L'utilisateur ne doit pas être vide",
    "El usuario no debe estar vacío",
    "O usuário não deve estar vazio"
  ];
  List<String> pwLengthList = [
    "Password length should be 4",
    "La longueur du mot de passe doit être de 4",
    "La longitud de la contraseña debe ser 4",
    "O comprimento da senha deve ser 4"
  ];
  List<String> enterCurrentPWList = [
    "Enter Current Password",
    "Entrer le mot de passe actuel",
    "Introducir la contraseña actual",
    "Insira a senha atual"
  ];
  List<String> enterNewPWList = [
    "Enter New Password",
    "Entrez un nouveau mot de passe",
    "Ingrese nueva clave",
    "Insira a nova senha"
  ];
  // List<String> List = ["","","",""];
  // List<String> List = ["","","",""];

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
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context).pushReplacementNamed("/HomePage");
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width * 0.2,
          leading: Stack(
            children: [
              Positioned(
                left: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 1,
                  width: MediaQuery.of(context).size.width * 1,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          title: Text(
            settingsList[int.parse(languageId)],
            // "Settings"
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  profile(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    endIndent: 15,
                    indent: 15,
                    color: Colors.grey[200],
                    height: 1,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextView(
                    settingsList[int.parse(languageId)],
                    // "Settings",
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    size: 24.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ListTile(
                    onTap: () => changePassword(),
                    leading: Icon(
                      Icons.lock_outline,
                      // color: Theme.of(context).accentColor,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    title: TextView(
                      changePasswordList[int.parse(languageId)],
                      // "Change Password",
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                      size: 16.0,
                    ),
                    subtitle: TextView(
                      changeSecPassList[int.parse(languageId)],
                      // "Change security password",
                      size: 12.0,
                    ),
                  ),
                  Divider(
                    endIndent: 15,
                    indent: 15,
                    color: Colors.grey[200],
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      // color: Theme.of(context).accentColor,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    title: TextView(
                      aboutUsList[int.parse(languageId)],
                      // "About Us",
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                      size: 16.0,
                    ),
                    subtitle: TextView(
                      aboutAppList[int.parse(languageId)],
                      // "About this App",
                      size: 12.0,
                    ),
                  ),
                  Divider(
                    endIndent: 15,
                    indent: 15,
                    color: Colors.grey[200],
                    height: 1,
                    thickness: 1,
                  ),

                  ///Language
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LanquageSettings()));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.public,
                        // color: Theme.of(context).accentColor,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      title: TextView(
                        languageList[int.parse(languageId)],
                        //  "Language",
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                        size: 16.0,
                      ),
                      subtitle: TextView(
                        selectLangList[int.parse(languageId)],
                        // "Select the Language",
                        size: 12.0,
                      ),
                    ),
                  ),
                  Divider(
                    endIndent: 15,
                    indent: 15,
                    color: Colors.grey[200],
                    height: 1,
                    thickness: 1,
                  ),

                  ///QR Code
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => QRCodeHome()));
                  //   },
                  //   child: ListTile(
                  //     leading: Icon(
                  //       Icons.qr_code,
                  //       // color: Theme.of(context).accentColor,
                  //       color: Theme.of(context).secondaryHeaderColor,
                  //     ),
                  //     title: TextView(
                  //       qrCodeList[int.parse(languageId)],
                  //       // "QR Code",
                  //       color: Theme.of(context).secondaryHeaderColor,
                  //       fontWeight: FontWeight.bold,
                  //       size: 16.0,
                  //     ),
                  //     subtitle: TextView(
                  //       getQrCodeList[int.parse(languageId)],
                  //       // "Get Your QR Code",
                  //       size: 12.0,
                  //     ),
                  //   ),
                  // ),
                  // Divider(
                  //   endIndent: 15,
                  //   indent: 15,
                  //   color: Colors.grey[200],
                  //   height: 1,
                  //   thickness: 1,
                  // ),

                  ///MPIN
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MpinGenerate()));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.password,
                        // color: Theme.of(context).accentColor,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      title: TextView(
                        "MPin",
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                        size: 16.0,
                      ),
                      subtitle: TextView(
                        setUpdateMpinList[int.parse(languageId)],
                        // "Set and Update Mpin",
                        size: 12.0,
                      ),
                    ),
                  ),

                  // Divider(
                  //   endIndent: 15,
                  //   indent: 15,
                  //   color: Colors.grey[200],
                  //   height: 1,
                  //   thickness: 1,
                  // ),

                  ///Logout
                  // InkWell(
                  //   onTap: () {
                  //     //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //     //   builder: (context) => Login(),
                  //     // )),
                  //
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: Text('Logout'),
                  //           content: Text('Would you like to logout?'),
                  //           actions: <Widget>[
                  //             TextButton(
                  //               onPressed: () => Navigator.of(context).pop(false),
                  //               child: Text('No',style: TextStyle(color: Color(0xffE50003),),),
                  //             ),
                  //             TextButton(
                  //               child: Text('Yes',style: TextStyle(color: Color(0xffE50003),),),
                  //               onPressed: () =>
                  //                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login())),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //
                  //   },
                  //   child: ListTile(
                  //     leading: Image.asset(
                  //       "assets/logout.png",
                  //       color: Theme.of(context).accentColor,
                  //       height: 30.0,
                  //       width: 30.0,
                  //     ),
                  //     title: TextView(
                  //       "Logout",
                  //       fontWeight: FontWeight.bold,
                  //       size: 16.0,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // Positioned(
            //   left: -15,
            //   bottom: MediaQuery.of(context).size.width * 0.08,
            //   child: Container(
            //     height: MediaQuery.of(context).size.height * 0.05,
            //     width: MediaQuery.of(context).size.width * 0.3,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.rectangle,
            //       color: Theme.of(context).primaryColor,
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey.withOpacity(0.5),
            //           spreadRadius: 5,
            //           blurRadius: 7,
            //           offset: Offset(0, 3), // changes position of shadow
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Positioned(
            //   left: -15,
            //   bottom: MediaQuery.of(context).size.width * 0.13,
            //   child: Container(
            //     height: MediaQuery.of(context).size.height * 0.05,
            //     width: MediaQuery.of(context).size.width * 0.2,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.rectangle,
            //       color: Colors.indigo,
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey.withOpacity(0.5),
            //           spreadRadius: 5,
            //           blurRadius: 7,
            //           offset: Offset(0, 3), // changes position of shadow
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      userId = preferences?.getString(StaticValues.custID) ?? "";
      acc = preferences?.getString(StaticValues.accNumber) ?? "";
      name = preferences?.getString(StaticValues.accName) ?? "";
      address = preferences?.getString(StaticValues.address) ?? "";
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
      print("userName");
      print(userId);
      print(acc);
      print(name);
    });
  }

  void changePassword() {
    String isInvalid = "";
    GlobalWidgets().dialogTemplate(
        context: context,
        // title: "Change Password",
        title: changePasswordList[int.parse(languageId)],
        barrierDismissible: false,
        actions: [
          StatefulBuilder(
            builder: (context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Visibility(
                    visible: isInvalid.length > 0,
                    child: TextView(
                      isInvalid,
                      color: Theme.of(context).secondaryHeaderColor,
                    )),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        userIdCtrl.text = "";
                        oldPasCtrl.text = "";
                        newPassCtrl.text = "";
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextView(
                          // "Cancel",
                          cancelList[int.parse(languageId)],
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                    RaisedButton(
                      color: Theme.of(context).secondaryHeaderColor,
                      onPressed: idValid || oldPassValid || newPassValid
                          ? null
                          : () async {
                              if (userIdCtrl.text.length > 0 &&
                                  oldPasCtrl.text.length >= 4 &&
                                  newPassCtrl.text.length >= 4) {
                                Map response = await RestAPI().get<Map>(
                                    "${APis.changePassword}${userIdCtrl.text}&old_pin=${oldPasCtrl.text}"
                                    "&new_pin=${newPassCtrl.text}");
                                setState(() {
                                  bool error = response["Table"][0]["Status"]
                                          .toString()
                                          .toLowerCase() ==
                                      "invalid user";

                                  if (!error) {
                                    userIdCtrl.text = "";
                                    oldPasCtrl.text = "";
                                    newPassCtrl.text = "";
                                    GlobalWidgets().showSnackBar(
                                        _scaffoldKey,
                                        response["Table"][0]["Status"]
                                            .toString());
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      // isInvalid = "Invalid Credentials";
                                      isInvalid = invalidCredentialsList[
                                          int.parse(languageId)];
                                    });
                                  }
                                });
                              } else {
                                setState(() {
                                  // isInvalid = "Please fill up the fields";
                                  isInvalid = plsFillMissingFieldsList[
                                      int.parse(languageId)];
                                });
                              }
                            },
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextView(
                          // "Change Password",
                          changePasswordList[int.parse(languageId)],
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                EditTextBordered(
                  controller: userIdCtrl,
                  // hint: "Enter username",
                  hint: enterUsernameList[int.parse(languageId)],
                  hintColor: Theme.of(context).secondaryHeaderColor,
                  borderColor: Theme.of(context).secondaryHeaderColor,
                  // errorText: idValid ? "User should not be empty" : null,
                  errorText: idValid
                      ? userShouldNotEmptyList[int.parse(languageId)]
                      : null,
                  onChange: (value) {
                    setState(() {
                      idValid = value.trim().length == 0;
                      isInvalid = "";
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                EditTextBordered(
                  controller: oldPasCtrl,
                  // hint: "Enter current password",
                  hint: enterCurrentPWList[int.parse(languageId)],
                  hintColor: Theme.of(context).secondaryHeaderColor,
                  borderColor: Theme.of(context).secondaryHeaderColor,
                  // errorText: oldPassValid ? "Password length should be 4" : null,
                  errorText:
                      oldPassValid ? pwLengthList[int.parse(languageId)] : null,
                  obscureText: true,
                  showObscureIcon: true,
                  onChange: (value) {
                    setState(() {
                      oldPassValid = value.trim().length < 4;
                      isInvalid = "";
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                EditTextBordered(
                  controller: newPassCtrl,
                  // hint: "Enter new password",
                  hint: enterNewPWList[int.parse(languageId)],
                  hintColor: Theme.of(context).secondaryHeaderColor,
                  borderColor: Theme.of(context).secondaryHeaderColor,
                  obscureText: true,
                  showObscureIcon: true,
                  // errorText: newPassValid ? "Password length should be 4" : null,
                  errorText:
                      newPassValid ? pwLengthList[int.parse(languageId)] : null,
                  onChange: (value) {
                    setState(() {
                      newPassValid = value.trim().length < 4;
                      print(newPassValid);
                      isInvalid = "";
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ));
  }

  Widget profile() {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AssetImage("assets/people.png"),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
            name ?? "",
            fontWeight: FontWeight.bold,
            size: 16,
          ),
          TextView(
            acc ?? "",
            size: 14.0,
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
      subtitle: TextView(
        address ?? "",
        size: 12,
      ),
    );
  }

  var about =
      "Prima Finance FRIENDLY offers you information of your account, in just a touch away from anywhere,"
      " anytime. The application allows instant access to your transactions info.\n"
      "You can instantly know your account balance, makes fund transfers and mobile recharges on the move,"
      " real-time and lots more !\n    We provide Features to harness in the palm of your hands.";
}
