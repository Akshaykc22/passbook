// To parse this JSON data, do
//
//     final branchListModel = branchListModelFromJson(jsonString);

import 'dart:convert';

BranchListModel branchListModelFromJson(String str) => BranchListModel.fromJson(json.decode(str));

String branchListModelToJson(BranchListModel data) => json.encode(data.toJson());

class BranchListModel {
  BranchListModel({
    this.table,
  });

  List<BranchTable> table;

  factory BranchListModel.fromJson(Map<String, dynamic> json) => BranchListModel(
    table: List<BranchTable>.from(json["Table"].map((x) => BranchTable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Table": List<dynamic>.from(table.map((x) => x.toJson())),
  };
}

class BranchTable {
  BranchTable({
    this.brCode,
    this.brName,
  });

  String brCode;
  String brName;

  factory BranchTable.fromJson(Map<String, dynamic> json) => BranchTable(
    brCode: json["Br_Code"],
    brName: json["Br_Name"],
  );

  Map<String, dynamic> toJson() => {
    "Br_Code": brCode,
    "Br_Name": brName,
  };
}
