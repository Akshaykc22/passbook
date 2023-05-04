// To parse this JSON data, do
//
//     final accountScheme = accountSchemeFromJson(jsonString);

import 'dart:convert';

List<AccountScheme> accountSchemeFromJson(String str) => List<AccountScheme>.from(json.decode(str).map((x) => AccountScheme.fromJson(x)));

String accountSchemeToJson(List<AccountScheme> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccountScheme {
  AccountScheme({
    this.schCode,
    this.schName,
  });

  String schCode;
  String schName;

  factory AccountScheme.fromJson(Map<String, dynamic> json) => AccountScheme(
    schCode: json["Sch_Code"],
    schName: json["Sch_Name"],
  );

  Map<String, dynamic> toJson() => {
    "Sch_Code": schCode,
    "Sch_Name": schName,
  };

  @override
  String toString() {
    return 'AccountScheme{schCode: $schCode, schName: $schName}';
  }
}
