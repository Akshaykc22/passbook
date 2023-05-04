import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDocuments1 extends StatefulWidget {
  String CustTypeCode,
      CustTitleCode,
      CustFirstName,
      CustMiddleName,
      CustLastName,
      CustFTitleCode,
      CustFFirstName,
      CustFMiddleName,
      CustFLastName,
      CustDobInc,
      CustGender,
      CustPrimaryMobile,
      CustSecondaryMobile,
      CustPrimaryEmail,
      CustAdhaarNo,
      CustPanCard,
      AddTypeName,
      AddAddress1,
      AddAddress2,
      AddAddress3,
      AddCity,
      AddTaluk,
      AddDistrict,
      AddState,
      AddCountry,
      AddPinCode,
      AddLandmark,
      BranchId;

  CustomerDocuments1(
      {Key key,
      @required this.CustTypeCode,
      @required this.CustTitleCode,
      @required this.CustFirstName,
      @required this.CustMiddleName,
      @required this.CustLastName,
      @required this.CustFTitleCode,
      @required this.CustFFirstName,
      @required this.CustFMiddleName,
      @required this.CustFLastName,
      @required this.CustDobInc,
      @required this.CustGender,
      @required this.CustPrimaryMobile,
      @required this.CustSecondaryMobile,
      @required this.CustPrimaryEmail,
      @required this.CustAdhaarNo,
      @required this.CustPanCard,
      @required this.AddTypeName,
      @required this.AddAddress1,
      @required this.AddAddress2,
      @required this.AddAddress3,
      @required this.AddCity,
      @required this.AddTaluk,
      @required this.AddDistrict,
      @required this.AddState,
      @required this.AddCountry,
      @required this.AddPinCode,
      @required this.AddLandmark,
      @required this.BranchId})
      : super(key: key);

  @override
  _CustomerDocuments1State createState() => _CustomerDocuments1State();
}

class _CustomerDocuments1State extends State<CustomerDocuments1> {
  File imageFile;
  File imageFile1;
  File imageFile2;
  File imageFile3;

  String base64Image;
  String base64Image1;
  String base64Image2;
  String base64Image3;
  bool _isLoading = false;
  bool check1 = false;

  SharedPreferences preferences;
  var languageId = "";

  // En, Fr, Es, Pt
  List<String> captureImgList = [
    "Capture Image",
    "Capturer une image",
    "Capturar imagen",
    "Capturar imagem"
  ];
  List<String> takePhotoList = [
    "Take Photo",
    "Prendre une photo",
    "Tomar foto",
    "Tirar fotos"
  ];
  List<String> signList = ["Signature", "Signature", "Firma", "Assinatura"];
  List<String> idProofList = [
    "ID Proof",
    "Preuve d'identité",
    "Prueba de Identificación",
    "Prova de identidade"
  ];
  List<String> okList = ["OK", "D'accord", "Bueno", "OK"];
  List<String> welcomeList = ["Welcome", "Bienvenu", "Bienvenido", "Bem-vindo"];
  List<String> yourAccCreatedList = [
    "Your Account is Created in PRIMA FINANCE",
    "Votre compte est créé dans PRIMA FINANCE",
    "Su cuenta se crea en PRIMA FINANCE",
    "Sua conta é criada no PRIMA FINANCE"
  ];
  List<String> iAcceptTermsConditionsList = [
    "I Accept the terms and conditions",
    "J'accepte les termes et conditions",
    "Acepto los términos y condiciones",
    "Eu aceito os termos e condições"
  ];
  List<String> saveList = ["Save", "Sauver", "salvar", "Salve"];
  List<String> fSideList = [
    "Front Side",
    "Face avant",
    "Lado delantero",
    "Frente"
  ];
  List<String> bSideList = ["Back Side", "Verso", "Parte trasera", "Verso"];

  // List<String> List = ["","","",""];

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
      print(languageId);
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
        // title: Text("Capture Image"),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(captureImgList[int.parse(languageId)]),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ///Person's Image
              Card(
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: InkWell(
                    onTap: () {
                      getImage1();
                    },
                    child: imageFile != null
                        ? Container(
                            decoration: BoxDecoration(
                              image:
                                  DecorationImage(image: FileImage(imageFile)),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              getImage1();
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(Icons.camera_enhance_rounded),
                                  SizedBox(
                                    height: 150,
                                    width: 250,
                                    child: Icon(
                                      Icons.photo_camera,
                                      size: MediaQuery.of(context).size.height *
                                          0.15,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                  ),
                                  // Text("Take Photo"),
                                  Text(
                                    takePhotoList[int.parse(languageId)],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),

              ///Signature
              Visibility(
                visible: false,
                child: Card(
                  child: Container(
                    width: 175,
                    height: MediaQuery.of(context).size.height / 2,
                    child: InkWell(
                      onTap: () {
                        getImage2();
                      },
                      child: imageFile1 != null
                          ? Container(
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(imageFile1)),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                getImage2();
                              },
                              child: Container(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_enhance_rounded),
                                    // Text("Signature"),
                                    Text(signList[int.parse(languageId)]),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              ///ID Proof
              Visibility(
                visible: true,
                child: Card(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: InkWell(
                      onTap: () {
                        getImage3();
                      },
                      child: imageFile2 != null
                          ? Container(
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(imageFile2)),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                getImage3();
                              },
                              child: Container(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Icon(Icons.camera_enhance_rounded),
                                    SizedBox(
                                      height: 150,
                                      width: 250,
                                      child: Icon(
                                        Icons.featured_video_outlined,
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.13,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                    ),
                                    // Text("ID Proof 1"),
                                    Text(
                                      "${idProofList[int.parse(languageId)]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              ///ID Proof Front & Back
              Visibility(
                visible: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      child: Container(
                        width: 175,
                        height: MediaQuery.of(context).size.height / 3,
                        child: InkWell(
                          onTap: () {
                            getImage3();
                          },
                          child: imageFile2 != null
                              ? Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(imageFile2)),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    getImage3();
                                  },
                                  child: Container(
                                    height: 200,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.camera_enhance_rounded),
                                        SizedBox(
                                          height: 150,
                                          width: 250,
                                          child: Icon(
                                            Icons.featured_video_outlined,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.13,
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          ),
                                        ),
                                        // Text("ID Proof 1"),
                                        Text(
                                          "${idProofList[int.parse(languageId)]} ${fSideList[int.parse(languageId)]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        width: 175,
                        height: MediaQuery.of(context).size.height / 3,
                        child: InkWell(
                          onTap: () {
                            getImage4();
                          },
                          child: imageFile3 != null
                              ? Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(imageFile3)),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    getImage4();
                                  },
                                  child: Container(
                                    height: 200,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.camera_enhance_rounded),
                                        SizedBox(
                                          height: 150,
                                          width: 250,
                                          child: Icon(
                                            Icons.credit_card_rounded,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          ),
                                        ),
                                        // Text("ID Proof 2"),
                                        Text(
                                          "${idProofList[int.parse(languageId)]} ${bSideList[int.parse(languageId)]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CheckboxListTile(
                value: check1,
                controlAffinity:
                    ListTileControlAffinity.leading, //checkbox at left
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
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    // log("Person Img : ${base64Image}");
                    // log("Id FSide Img : ${base64Image2}");
                    // log("Id BSide Img : ${base64Image3}");

                    /*  log("2 : ${base64Image1}");
                  log("3 : ${base64Image2}");
                  log("4 : ${base64Image2}");*/

                    var response =
                        await RestAPI().post(APis.saveCustomerNew, params: {
                      "BrCode": widget.BranchId,
                      "CustTypeCode": widget.CustTypeCode,
                      "CustTitleCode": widget.CustTitleCode,
                      "CustFirstName": widget.CustFirstName,
                      "CustMiddleName": widget.CustMiddleName,
                      "CustLastName": widget.CustLastName,
                      "CustFTitleCode": "",
                      "CustFFirstName": "",
                      "CustFMiddleName": "",
                      "CustFLastName": "",
                      "CustDobInc": widget.CustDobInc,
                      "CustGender": widget.CustGender,
                      "CustPrimaryMobile": widget.CustPrimaryMobile,
                      "CustSecondaryMobile": "",
                      "CustPrimaryEmail": widget.CustPrimaryEmail,
                      "CustAdhaarNo": widget.CustAdhaarNo,
                      "CustPanCard": widget.CustPanCard,
                      "AddTypeName": "",
                      "AddAddress1": widget.AddAddress1,
                      "AddAddress2": widget.AddAddress2,
                      "AddAddress3": "",
                      "AddCity": widget.AddCity,
                      "AddTaluk": "",
                      "AddDistrict": "",
                      "AddState": widget.AddState,
                      "AddCountry": widget.AddCountry,
                      "AddPinCode": "",
                      "AddLandmark": "",
                      "Photo": base64Image,
                      "Signature": base64Image1,
                      "Document": base64Image2,
                      "Document2": base64Image3
                    });

                    setState(() {
                      _isLoading = false;
                    });

                    print(response.toString());

                    if (response["Table"][0]["CustomerID"].toString() != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      var response1 =
                          await RestAPI().post(APis.saveCustImage, params: {
                        "CustomerID":
                            response["Table"][0]["CustomerID"].toString(),
                        "ImageType": "Photo",
                        "ImageData": base64Image
                      });
                      // print(response1.toString());
                      setState(() {
                        _isLoading = false;
                      });
                    }

                    showAlertDialog(
                        context,
                        response["Table"][0]["CustomerID"].toString(),
                        response["Table"][0]["SBNo"].toString());
                  },
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          // ):Text("Save"),
                        )
                      : Text(saveList[int.parse(languageId)]),
                  style: ButtonStyle(
                    // backgroundColor: MaterialStateProperty.all(Colors.red),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).secondaryHeaderColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, String custId, String SBNo) {
    // set up the button
    Widget okButton = TextButton(
      // child: Text("OK"),
      child: Text(okList[int.parse(languageId)]),
      onPressed: () {
        //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
        Navigator.pop(context);
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/LoginPage', (Route<dynamic> route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Column(
        children: [
          // Text("Welcome"),
          Text(welcomeList[int.parse(languageId)]),
          SizedBox(
            height: 16,
          ),
          // Text("Your Account is Created in PRIMA FINANCE",
          Text(
            yourAccCreatedList[int.parse(languageId)],
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      content: Container(
        height: 100,
        child: Column(
          children: [
            Text("Cust Id : $custId"),
            Text("SB No : $SBNo"),
          ],
        ),
      ),
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

/*  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Close"),
      onPressed: () {
        Navigator.of(context).pop();
      },

    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Column(
        children: [
          Text(response["Table"]["CustomerID"])
        ],
      ),

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
  }*/

  void getImage1() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);

    if (file?.path != null) {
      setState(() {
        imageFile = File(file.path);
        final bytes = File(file.path).readAsBytesSync();
        // base64Image =  "data:image/png;base64,"+base64Encode(bytes);
        base64Image = base64Encode(bytes);

        // log("LJT : $base64Image");
        //  printWrapped("LJT : $base64Image");
        //  print(base64Image.toString());
      });
    }
  }

  void getImage2() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);

    if (file?.path != null) {
      setState(() {
        imageFile1 = File(file.path);
        final bytes = File(file.path).readAsBytesSync();
        //  base64Image1 =  "data:image/png;base64,"+base64Encode(bytes);
        base64Image1 = base64Encode(bytes);
        // print(base64Image1);
      });
    }
  }

  void getImage3() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);

    if (file?.path != null) {
      setState(() {
        imageFile2 = File(file.path);
        final bytes = File(file.path).readAsBytesSync();
        //  base64Image2 =  "data:image/png;base64,"+base64Encode(bytes);
        base64Image2 = base64Encode(bytes);
        // print(base64Image2);
      });
    }
  }

  void getImage4() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);

    // final file  = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {});

    if (file?.path != null) {
      setState(() {
        imageFile3 = File(file.path);

        final bytes = File(file.path).readAsBytesSync();
        //  base64Image3 =  "data:image/png;base64,"+base64Encode(bytes);
        base64Image3 = base64Encode(bytes);
        // print(base64Image3);
      });
    }
  }
}
