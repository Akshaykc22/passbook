// To parse this JSON data, do
//
//     final getAccNo = getAccNoFromJson(jsonString);

import 'dart:convert';

GetAccNo getAccNoFromJson(String str) => GetAccNo.fromJson(json.decode(str));

String getAccNoToJson(GetAccNo data) => json.encode(data.toJson());

class GetAccNo {
  GetAccNo({
    this.accTable,
  });

  List<AccTable> accTable;

  factory GetAccNo.fromJson(Map<String, dynamic> json) => GetAccNo(
    accTable: List<AccTable>.from(json["Table"].map((x) => AccTable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Table": List<dynamic>.from(accTable.map((x) => x.toJson())),
  };
}

class AccTable {
  AccTable({
    this.custId,
    this.column1,
    this.adds,
    this.brName,
    this.accNo,
    this.schCode,
    this.schName,
    this.brCode,
    this.depBranch,
    this.balance,
    this.module,
  });

  int custId;
  Column1 column1;
  Adds adds;
  BrName brName;
  String accNo;
  String schCode;
  String schName;
  String brCode;
  BrName depBranch;
  double balance;
  Module module;

  factory AccTable.fromJson(Map<String, dynamic> json) => AccTable(
    custId: json["Cust_Id"],
    column1: column1Values.map[json["Column1"]],
    adds: addsValues.map[json["Adds"]],
    brName: brNameValues.map[json["Br_Name"]],
    accNo: json["Acc_No"],
    schCode: json["Sch_Code"],
    schName: json["Sch_Name"],
    brCode: json["Br_Code"],
    depBranch: brNameValues.map[json["Dep_Branch"]],
    balance: json["Balance"].toDouble(),
    module: moduleValues.map[json["Module"]],
  );

  Map<String, dynamic> toJson() => {
    "Cust_Id": custId,
    "Column1": column1Values.reverse[column1],
    "Adds": addsValues.reverse[adds],
    "Br_Name": brNameValues.reverse[brName],
    "Acc_No": accNo,
    "Sch_Code": schCode,
    "Sch_Name": schName,
    "Br_Code": brCode,
    "Dep_Branch": brNameValues.reverse[depBranch],
    "Balance": balance,
    "Module": moduleValues.reverse[module],
  };
}

enum Adds { PLOT_NO_01_BRAR_FRAM_HOUSE_GURGAON_122017 }

final addsValues = EnumValues({
  "PLOT NO.01,,BRAR FRAM HOUSE,,,GURGAON,122017": Adds.PLOT_NO_01_BRAR_FRAM_HOUSE_GURGAON_122017
});

enum BrName { GURUGRAM_MAIN_BRANCH }

final brNameValues = EnumValues({
  "GURUGRAM MAIN BRANCH": BrName.GURUGRAM_MAIN_BRANCH
});

enum Column1 { NIRANJAN_VERMA }

final column1Values = EnumValues({
  "NIRANJAN  VERMA  ": Column1.NIRANJAN_VERMA
});

enum Module { DEPOSIT }

final moduleValues = EnumValues({
  "Deposit": Module.DEPOSIT
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
