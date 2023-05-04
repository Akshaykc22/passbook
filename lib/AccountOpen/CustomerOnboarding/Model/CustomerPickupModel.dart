// To parse this JSON data, do
//
//     final customerPickupModel = customerPickupModelFromJson(jsonString);

import 'dart:convert';

CustomerPickupModel customerPickupModelFromJson(String str) => CustomerPickupModel.fromJson(json.decode(str));

String customerPickupModelToJson(CustomerPickupModel data) => json.encode(data.toJson());

class CustomerPickupModel {
  CustomerPickupModel({
    this.table,
  });

  List<PickupTable> table;

  factory CustomerPickupModel.fromJson(Map<String, dynamic> json) => CustomerPickupModel(
    table: List<PickupTable>.from(json["Table"].map((x) => PickupTable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Table": List<dynamic>.from(table.map((x) => x.toJson())),
  };
}

class PickupTable {
  PickupTable({
    this.type,
    this.id,
    this.name,
  });

  String type;
  int id;
  String name;

  factory PickupTable.fromJson(Map<String, dynamic> json) => PickupTable(
    type: json["Type"],
    id: json["ID"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "Type": type,
    "ID": id,
    "Name": name,
  };
}
