import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:passbook_core/REST/RestAPI.dart';
import 'package:passbook_core/Util/GlobalWidgets.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomerDocuments1.dart';
import 'Model/BranchModel.dart';
import 'Model/CustomerPickupModel.dart';

class CustomerCreationHome extends StatefulWidget {
  String strMobNo;
  CustomerCreationHome({Key key, @required this.strMobNo}) : super(key: key);

  @override
  _CustomerCreationHomeState createState() => _CustomerCreationHomeState();
}

class _CustomerCreationHomeState extends State<CustomerCreationHome> {
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  String dropdownvalue = "Item 1";
  TextEditingController firtNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController fatherFirstNameController = TextEditingController();
  TextEditingController fatherMiddleNameController = TextEditingController();
  TextEditingController fatherLastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController primaryMobileNoController = TextEditingController();
  TextEditingController secondryMobileNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adharController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController address3Controller = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController talukController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  DateTime selectedFromDate = DateTime.now();

  TextEditingController fromDateController = TextEditingController();

  List<PickupTable> pickupTable = [];
  List<BranchTable> branchList = [];
  //List<PickupTable> custTypeList = [];
  var _custTypeList = <PickupTable>[];
  var _nameTitleList = <PickupTable>[];
  var _genderList = <PickupTable>[];
  var _houseTypeList = <PickupTable>[];
  var _branchList1 = <BranchTable>[];
  var _selectedAccNo;
  var _selectedCustType,
      _selectedNameType,
      _selectedGender,
      _selectedHouseType,
      _selectedBranch,
      _selectedNameType1;
  String str_accNo;
  String str_custTypeId;
  String str_selectedNameId;
  String str_selectedNameId1;
  String str_gender;
  String str_houseType;
  String str_branchId;
  bool _isLoading = false;
  bool adharVal = false;
  bool panVal = false;

  SharedPreferences preferences;
  var languageId = "";

  // En, Fr, Es, Pt
  // List<String> List = ["","","",""];
  List<String> customerCreationList = [
    "Customer Creation",
    "Création de client",
    "Creación de clientes",
    "Criação de cliente"
  ];
  List<String> selectBranchList = [
    "Select Branch",
    "Sélectionnez la succursale",
    "Seleccionar sucursal",
    "Selecione Filial"
  ];
  List<String> selectCustomerTypeList = [
    "Select Customer Type",
    "Sélectionnez le type de client",
    "Seleccionar tipo de cliente",
    "Selecione o tipo de cliente"
  ];
  List<String> selectTitleList = [
    "Select Title",
    "Sélectionnez le titre",
    "Seleccionar título",
    "Selecione o título"
  ];
  List<String> firstNameList = [
    "First Name",
    "Prénom",
    "Nombre de pila",
    "Primeiro nome"
  ];
  List<String> middleNameList = [
    "Middle Name",
    "Deuxième nom",
    "Segundo nombre",
    "Nome do meio"
  ];
  List<String> lastNameList = [
    "Last Name",
    "Nom de famille",
    "Apellido",
    "Sobrenome"
  ];
  List<String> selectFatherTitleList = [
    "Select Father Title",
    "Sélectionnez le titre du père",
    "Seleccione el título del padre",
    "Selecione o título do pai"
  ];
  List<String> fatherFNameList = [
    "Father First Name",
    "Prénom du père",
    "Nombre del padre",
    "Nome do Pai"
  ];
  List<String> fatherMNameList = [
    "Father Middle Name",
    "Deuxième prénom du père",
    "Segundo nombre del padre",
    "Nome do meio do pai"
  ];
  List<String> fatherLNameList = [
    "Father Last Name",
    "Nom du père",
    "Apellido del padre",
    "Sobrenome do pai"
  ];
  List<String> dobList = [
    "Date of Birth",
    "Date de naissance",
    "Fecha de nacimiento",
    "Data de nascimento"
  ];
  List<String> selectGenderList = [
    "Select Gender",
    "Sélectionnez le sexe",
    "Seleccione género",
    "Selecione o gênero"
  ];
  List<String> pMobileNoList = [
    "Primary Mobile Number",
    "Numéro de portable principal",
    "Número de móvil principal",
    "Número de celular primário"
  ];
  List<String> sMobileNoList = [
    "Secondary Mobile Number",
    "Numéro de portable secondaire",
    "Número de móvil secundario",
    "Número de móvil secundario"
  ];
  List<String> emailIDList = [
    "E-Mail ID",
    "Identifiant de messagerie",
    "correo electrónico identificatio",
    "Identificação do email"
  ];
  List<String> selectHouseTypeList = [
    "Select House Type",
    "Sélectionnez le type de maison",
    "Seleccionar tipo de casa",
    "Selecione o tipo de casa"
  ];
  List<String> address1List = [
    "Address 1",
    "Adresse 1",
    "DIRECCIÓN 1",
    "endereço 1"
  ];
  List<String> address2List = [
    "Address 2",
    "Adresse 2",
    "DIRECCIÓN 2",
    "endereço 2"
  ];
  List<String> address3List = [
    "Address 3",
    "Adresse 3",
    "DIRECCIÓN 3",
    "endereço 3"
  ];
  List<String> cityList = ["City", "Ville", "Ciudad", "Cidade"];
  List<String> cityTownVillageList = [
    "City / Town / Village",
    "Ville / Village",
    "Ciudad pueblo Villa",
    "Cidade / Vila / Aldeia"
  ];
  List<String> regionList = ["Region", "Région", "Región", "Região"];
  List<String> districtList = ["District", "District", "Distrito", "Distrito"];
  List<String> stateList = ["State", "État", "Estado", "Estado"];
  List<String> countryList = ["Country", "Pays", "País", "País"];
  List<String> pincodeList = [
    "Pincode",
    "Code postal",
    "Código postal",
    "código postal"
  ];
  List<String> landmarkList = [
    "Landmark",
    "Repère",
    "Punto de referencia",
    "Marco"
  ];
  List<String> nextList = ["Next", "Suivant", "Próximo", "Próximo"];
  List<String> selectDateList = [
    "Select Date",
    "Sélectionner une date",
    "Seleccione fecha",
    "Selecione a data"
  ];
  List<String> plsFillValidList = [
    "Please fill a valid",
    "Veuillez remplir un champ valide",
    "Por favor complete un válido",
    "Por favor, preencha um válido"
  ];
  List<String> plsFillMissingFieldsList = [
    "Please fill the missing fields",
    "Veuillez remplir les champs manquants",
    "Por favor complete los campos que faltan",
    "Por favor, preencha os campos que faltam"
  ];
  // List<String> List = ["","","",""];

  void loadData() async {
    preferences = StaticValues.sharedPreferences;
    setState(() {
      languageId = preferences?.getString(StaticValues.languageId) ?? "0";
      print(languageId);
    });
  }

  Future<void> getPickupList() async {
    setState(() {
      _isLoading = true;
    });
    var response = await RestAPI().get(APis.getCustomerPickUp);
    CustomerPickupModel _customerPickUpModel =
        CustomerPickupModel.fromJson(response);
    setState(() {
      pickupTable = _customerPickUpModel.table;
      _isLoading = false;

      pickupTable.forEach((f) {
        // ignore: unrelated_type_equality_checks
        print("FFFFF : ${f.toString()}");
        if (f.type == "Customer Type") {
          setState(() {
            _custTypeList.add(f);
          });
        }
        if (f.type == "Name Title") {
          setState(() {
            _nameTitleList.add(f);
          });
        }
        if (f.type == "Gender") {
          setState(() {
            _genderList.add(f);
          });
        }
        if (f.type == "House Type") {
          setState(() {
            _houseTypeList.add(f);
          });
        }
        return pickupTable;
      });
      print("CUST Type : $_custTypeList");
    });
  }

  Future<void> getBranchList() async {
    var response = await RestAPI().get(APis.getBranchList);

    BranchListModel _branchList = BranchListModel.fromJson(response);
    setState(() {
      branchList = _branchList.table;
      _branchList1.addAll(branchList);
    });
  }

  void _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedFromDate)
      setState(() {
        selectedFromDate = picked;
        print("SELECTED DATE : $selectedFromDate");

        fromDateController.text =
            DateFormat("yyyy-MM-dd").format(selectedFromDate);
      });
  }

  showAlertDialog() {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Simple Alert"),
      content: Text("This is an alert message."),
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

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();

    getPickupList();
    getBranchList();
    primaryMobileNoController.text = widget.strMobNo;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text("Customer Creation"),
            Text(customerCreationList[int.parse(languageId)]),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    style: BorderStyle.solid,
                    width: 0.80,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, bottom: 2, top: 2),
                  child: DropdownButton<BranchTable>(
                      hint: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          // : Text('Select Branch'),
                          : Text(
                              selectBranchList[int.parse(languageId)],
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                      //  hint: Text('Select Acc No'),
                      icon: Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      value: _selectedBranch,
                      items: _branchList1.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Container(child: Text(item.brName)),
                        );
                      }).toList(),
                      onChanged: (selectedItem) {
                        str_branchId = selectedItem.brCode;
                        print(str_branchId);
                        setState(() => _selectedBranch = selectedItem);
                      }),
                )),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      style: BorderStyle.solid,
                      width: 0.80,
                      color: Theme.of(context).secondaryHeaderColor),
                ),
                child: DropdownButtonHideUnderline(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, bottom: 2, top: 2),
                  child: DropdownButton<PickupTable>(
                      hint: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          // : Text('Select Customer Type'),
                          : Text(
                              selectCustomerTypeList[int.parse(languageId)],
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                      //  hint: Text('Select Acc No'),
                      icon: Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      value: _selectedCustType,
                      items: _custTypeList.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Container(child: Text(item.name)),
                        );
                      }).toList(),
                      onChanged: (selectedItem) {
                        str_custTypeId = selectedItem.id.toString();
                        print(str_custTypeId);
                        setState(() => _selectedCustType = selectedItem);
                      }),
                )),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      style: BorderStyle.solid,
                      width: 0.80,
                      color: Theme.of(context).secondaryHeaderColor),
                ),
                child: DropdownButtonHideUnderline(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, bottom: 2, top: 2),
                  child: DropdownButton<PickupTable>(
                      hint: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          // : Text('Select Title'),
                          : Text(
                              selectTitleList[int.parse(languageId)],
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                      // hint: Text('Select Title'),
                      icon: Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      value: _selectedNameType,
                      items: _nameTitleList.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Container(child: Text(item.name)),
                        );
                      }).toList(),
                      onChanged: (selectedItem) {
                        str_selectedNameId = selectedItem.id.toString();
                        print(str_selectedNameId);
                        setState(() => _selectedNameType = selectedItem);
                      }),
                )),
              ),
              SizedBox(
                height: 12,
              ),
              EditTextBordered(
                // hint: "First Name",
                hint: firstNameList[int.parse(languageId)],
                hintColor: Theme.of(context).secondaryHeaderColor,
                controller: firtNameController,
                borderColor: Theme.of(context).secondaryHeaderColor,
              ),
              SizedBox(
                height: 12,
              ),
              EditTextBordered(
                // hint: "Middle Name",
                hint: middleNameList[int.parse(languageId)],
                hintColor: Theme.of(context).secondaryHeaderColor,
                controller: middleNameController,
                borderColor: Theme.of(context).secondaryHeaderColor,
              ),
              SizedBox(
                height: 12,
              ),
              EditTextBordered(
                controller: lastNameController,
                // hint: "Last Name",
                hint: lastNameList[int.parse(languageId)],
                hintColor: Theme.of(context).secondaryHeaderColor,
                borderColor: Theme.of(context).secondaryHeaderColor,
              ),
              // SizedBox(
              //   height: 12,
              // ),
              // Container(
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10.0),
              //     border: Border.all(style: BorderStyle.solid, width: 0.80),
              //   ),
              //   child: DropdownButtonHideUnderline(
              //       child: Padding(
              //         padding: const EdgeInsets.only(
              //             left: 12, right: 12, bottom: 2, top: 2),
              //         child: DropdownButton<PickupTable>(
              //             hint: _isLoading
              //                 ? Center(child: CircularProgressIndicator())
              //                 // : Text('Select Father Title'),
              //                 : Text(selectFatherTitleList[int.parse(languageId)]),
              //             //  hint: Text('Select Father Title'),
              //             icon: Icon(Icons.keyboard_arrow_down),
              //             isExpanded: true,
              //             value: _selectedNameType1,
              //             items: _nameTitleList.map((item) {
              //               return DropdownMenuItem(
              //                 value: item,
              //                 child: Container(child: Text(item.name)),
              //               );
              //             }).toList(),
              //             onChanged: (selectedItem) {
              //               str_selectedNameId1 = selectedItem.id.toString();
              //               print(str_selectedNameId1);
              //               setState(() => _selectedNameType1 = selectedItem);
              //             }),
              //       )),
              // ),
              // SizedBox(
              //   height: 12,
              // ),
              // EditTextBordered(
              //     controller: fatherFirstNameController,
              //     // hint: "Father First Name",
              //   hint: fatherFNameList[int.parse(languageId)],
              //   borderColor: Colors.black,
              // ),
              // SizedBox(
              //   height: 12,
              // ),
              // EditTextBordered(
              //     controller: fatherMiddleNameController,
              //     // hint: "Father Middle Name",
              //   hint: fatherMNameList[int.parse(languageId)],
              //   borderColor: Colors.black,),
              // SizedBox(
              //   height: 12,
              // ),
              // EditTextBordered(
              //     controller: fatherLastNameController,
              //     // hint: "Father Last Name",
              //   hint: fatherLNameList[int.parse(languageId)],
              //   borderColor: Colors.black,),
              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {
                  _selectFromDate(context);
                },
                child: Container(
                  height: 40.0,
                  child: TextFormField(
                    enabled: false,
                    controller: fromDateController,
                    validator: (value) {
                      if (value.isEmpty) {
                        // return "Select Date";
                        return selectDateList[int.parse(languageId)];
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        // labelText: "DOB",
                        labelText: dobList[int.parse(languageId)],
                        labelStyle: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      style: BorderStyle.solid,
                      width: 0.80,
                      color: Theme.of(context).secondaryHeaderColor),
                ),
                child: DropdownButtonHideUnderline(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, bottom: 2, top: 2),
                  child: DropdownButton<PickupTable>(
                      hint: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          // : Text('Select Gender'),
                          : Text(
                              selectGenderList[int.parse(languageId)],
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                      //  hint: Text('Gender'),
                      icon: Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      value: _selectedGender,
                      items: _genderList.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Container(child: Text(item.name)),
                        );
                      }).toList(),
                      onChanged: (selectedItem) {
                        str_gender = selectedItem.id.toString();
                        print(str_gender);
                        setState(() => _selectedGender = selectedItem);
                      }),
                )),
              ),
              SizedBox(
                height: 12,
              ),
              EditTextBordered(
                controller: primaryMobileNoController,
                // hint: "Primary Mobile No",
                hint: pMobileNoList[int.parse(languageId)],
                hintColor: Theme.of(context).secondaryHeaderColor,
                enabled: false,
                borderColor: Theme.of(context).secondaryHeaderColor,
                keyboardType: TextInputType.phone,
              ),
              // SizedBox(
              //   height: 12,
              // ),
              //
              // EditTextBordered(
              //   controller: secondryMobileNoController,
              //   // hint: "Secondary Mobile No",
              //   hint: sMobileNoList[int.parse(languageId)],
              //   borderColor: Colors.black,
              //   keyboardType: TextInputType.phone,
              //   // maxLength: 10,
              //   inputFormatters: [
              //     FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              //     LengthLimitingTextInputFormatter(10),
              //   ],
              // ),
              SizedBox(
                height: 12,
              ),
              EditTextBordered(
                controller: emailController,
                // hint: "Email ID",
                hint: emailIDList[int.parse(languageId)],
                hintColor: Theme.of(context).secondaryHeaderColor,
                borderColor: Theme.of(context).secondaryHeaderColor,
              ),
              SizedBox(
                height: 12,
              ),
              EditTextBordered(
                controller: adharController,
                hint: "CNI/NIC",
                hintColor: Theme.of(context).secondaryHeaderColor,
                // errorText: adharVal ? "Please fill a valid CNI/NIC" : null,
                errorText: adharVal
                    ? "${plsFillValidList[int.parse(languageId)]} CNI/NIC"
                    : null,
                borderColor: Theme.of(context).secondaryHeaderColor,
                // keyboardType: TextInputType.number,
                // onChange: (value) {
                //   setState(() {
                //     adharVal = value.trim().length < 12;
                //   });
                // },
              ),
              SizedBox(
                height: 12,
              ),
              EditTextBordered(
                controller: panNoController,
                hint: "NIU/TIN",
                hintColor: Theme.of(context).secondaryHeaderColor,
                // textCapitalization: TextCapitalization.characters,
                borderColor: Theme.of(context).secondaryHeaderColor,
                // errorText: panVal ? "Please fill a valid NIU/TIN" : null,
                errorText: panVal
                    ? "${plsFillValidList[int.parse(languageId)]} NIU/TIN"
                    : null,
                // onChange: (value) {
                //   setState(() {
                //     panVal = value.trim().length < 10;
                //   });
                // },
              ),
              // SizedBox(
              //   height: 12,
              // ),
              // Container(
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10.0),
              //     border: Border.all(style: BorderStyle.solid, width: 0.80),
              //   ),
              //   child: DropdownButtonHideUnderline(
              //       child: Padding(
              //     padding: const EdgeInsets.only(
              //         left: 12, right: 12, top: 2, bottom: 2),
              //     child: DropdownButton<PickupTable>(
              //         hint: _isLoading
              //             ? Center(child: CircularProgressIndicator())
              //             // : Text('Select House Type'),
              //             : Text(selectHouseTypeList[int.parse(languageId)]),
              //         //  hint: Text('House Type'),
              //         icon: Icon(Icons.keyboard_arrow_down),
              //         isExpanded: true,
              //         value: _selectedHouseType,
              //         items: _houseTypeList.map((item) {
              //           return DropdownMenuItem(
              //             value: item,
              //             child: Container(child: Text(item.name)),
              //           );
              //         }).toList(),
              //         onChanged: (selectedItem) {
              //           str_houseType = selectedItem.id.toString();
              //           print(str_houseType);
              //           setState(() => _selectedHouseType = selectedItem);
              //         }),
              //   )),
              // ),
              SizedBox(
                height: 12,
              ),
              EditTextBordered(
                controller: address1Controller,
                // hint: "Address 1",
                hint: address1List[int.parse(languageId)],
                hintColor: Theme.of(context).secondaryHeaderColor,
                borderColor: Theme.of(context).secondaryHeaderColor,
              ),
              SizedBox(
                height: 12,
              ),
              EditTextBordered(
                controller: address2Controller,
                // hint: "Address 2",
                hint: address2List[int.parse(languageId)],
                hintColor: Theme.of(context).secondaryHeaderColor,
                borderColor: Theme.of(context).secondaryHeaderColor,
              ),
              // SizedBox(
              //   height: 12,
              // ),
              // EditTextBordered(
              //   controller: address3Controller,
              //   // hint: "Address 3",
              //   hint: address3List[int.parse(languageId)],
              //   borderColor: Colors.black,
              // ),
              SizedBox(
                height: 12,
              ),
              EditTextBordered(
                controller: cityController,
                // hint: "City / Town / Village",
                hint: cityTownVillageList[int.parse(languageId)],
                hintColor: Theme.of(context).secondaryHeaderColor,
                borderColor: Theme.of(context).secondaryHeaderColor,
              ),
              // SizedBox(
              //   height: 12,
              // ),
              // EditTextBordered(
              //   controller: talukController,
              //   // hint: "Taluk",
              //   borderColor: Colors.black,
              // ),
              // SizedBox(
              //   height: 12,
              // ),
              // EditTextBordered(
              //   controller: districtController,
              //   // hint: "District",
              //   hint: districtList[int.parse(languageId)],
              //   borderColor: Colors.black,
              // ),
              SizedBox(
                height: 12,
              ),
              EditTextBordered(
                controller: stateController,
                // hint: "Region",
                hint: regionList[int.parse(languageId)],
                hintColor: Theme.of(context).secondaryHeaderColor,
                borderColor: Theme.of(context).secondaryHeaderColor,
              ),
              SizedBox(
                height: 12,
              ),
              EditTextBordered(
                controller: countryController,
                // hint: "Country",
                hint: countryList[int.parse(languageId)],
                hintColor: Theme.of(context).secondaryHeaderColor,
                borderColor: Theme.of(context).secondaryHeaderColor,
              ),
              // SizedBox(
              //   height: 12,
              // ),
              // EditTextBordered(
              //   controller: pincodeController,
              //   // hint: "Pincode",
              //   hint: pincodeList[int.parse(languageId)],
              //   hintColor: Theme.of(context).secondaryHeaderColor,
              //   borderColor: Theme.of(context).secondaryHeaderColor,
              //   keyboardType: TextInputType.phone,
              // ),
              // SizedBox(
              //   height: 12,
              // ),
              // EditTextBordered(
              //   controller: landmarkController,
              //   // hint: "Landmark",
              //   hint: landmarkList[int.parse(languageId)],
              //   hintColor: Theme.of(context).secondaryHeaderColor,
              //   borderColor: Theme.of(context).secondaryHeaderColor,
              // ),
              SizedBox(
                height: 12,
              ),
              /*   String str_custTypeId;
        String str_selectedNameId;
        String str_selectedNameId1;
        String str_gender;
            String str_houseType;*/
              ElevatedButton(
                onPressed: () {
                  if (str_branchId == null ||
                          str_custTypeId == null ||
                          str_selectedNameId == null ||
                          firtNameController.text == "" ||
                          middleNameController.text == "" ||
                          lastNameController.text == "" ||
                          // str_selectedNameId1 == null ||
                          // fatherFirstNameController.text == "" ||
                          // fatherMiddleNameController.text == "" ||
                          // fatherLastNameController.text == "" ||
                          selectedFromDate == "" ||
                          str_gender == null ||
                          primaryMobileNoController.text == "" ||
                          // secondryMobileNoController.text == "" ||
                          emailController.text == "" ||

                          ///Adhaar = CNI/NIC
                          adharController.text == "" ||

                          ///Pan = NIU/TIN
                          panNoController.text == "" ||
                          // str_houseType == null ||
                          address1Controller.text == "" ||
                          address2Controller.text == "" ||
                          // address3Controller.text == "" ||
                          cityController.text == "" ||
                          // talukController.text == "" ||
                          // districtController.text == "" ||
                          ///State = Region
                          stateController.text == "" ||
                          countryController.text == ""
                      // pincodeController.text == "" ||
                      // landmarkController.text == ""
                      ) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        // SnackBar(content: Text("Please fill all fields")));
                        SnackBar(
                            content: Text(plsFillMissingFieldsList[
                                int.parse(languageId)])));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CustomerDocuments1(
                            CustTypeCode: str_custTypeId,
                            CustTitleCode: str_selectedNameId,
                            CustFirstName: firtNameController.text,
                            CustMiddleName: middleNameController.text,
                            CustLastName: lastNameController.text,
                            // CustFTitleCode: str_selectedNameId1,
                            // CustFFirstName: fatherFirstNameController.text,
                            // CustFMiddleName: fatherMiddleNameController.text,
                            // CustFLastName: fatherLastNameController.text,
                            CustDobInc: selectedFromDate.toString(),
                            CustGender: str_gender,
                            CustPrimaryMobile: primaryMobileNoController.text,
                            // CustSecondaryMobile: secondryMobileNoController.text,
                            CustPrimaryEmail: emailController.text,
                            CustAdhaarNo: adharController.text,
                            CustPanCard: panNoController.text,
                            // AddTypeName: str_houseType,
                            AddAddress1: address1Controller.text,
                            AddAddress2: address2Controller.text,
                            // AddAddress3: address3Controller.text,
                            AddCity: cityController.text,
                            // AddTaluk: talukController.text,
                            // AddDistrict: districtController.text,
                            AddState: stateController.text,
                            AddCountry: countryController.text,
                            // AddPinCode: pincodeController.text,
                            // AddLandmark: landmarkController.text,
                            BranchId: str_branchId)));
                  }

                  /*  Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CustomerDocuments1(
                            CustTypeCode: str_custTypeId,
                            CustTitleCode: str_selectedNameId,
                            CustFirstName: firtNameController.text,
                            CustMiddleName: middleNameController.text,
                            CustLastName: lastNameController.text,
                            CustFTitleCode: str_selectedNameId1,
                            CustFFirstName: fatherFirstNameController.text,
                            CustFMiddleName: fatherMiddleNameController.text,
                            CustFLastName: fatherLastNameController.text,
                            CustDobInc: selectedFromDate.toString(),
                            CustGender: str_gender,
                            CustPrimaryMobile: primaryMobileNoController.text,
                            CustSecondaryMobile: secondryMobileNoController.text,
                            CustPrimaryEmail: emailController.text,
                            CustAdhaarNo: adharController.text,
                            CustPanCard: panNoController.text,
                            AddTypeName: str_houseType,
                            AddAddress1: address1Controller.text,
                            AddAddress2: address2Controller.text,
                            AddAddress3: address3Controller.text,
                            AddCity: cityController.text,
                            AddTaluk: talukController.text,
                            AddDistrict: districtController.text,
                            AddState: stateController.text,
                            AddCountry: countryController.text,
                            AddPinCode: pincodeController.text,
                            AddLandmark: landmarkController.text,
                            BranchId: str_branchId)));*/
                },
                // child: Text("Next"),
                child: Text(nextList[int.parse(languageId)]),
                style: ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all(Colors.red),
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).secondaryHeaderColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
