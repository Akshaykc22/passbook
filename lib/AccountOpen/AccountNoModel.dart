// To parse this JSON data, do
//
//     final accountNumber = accountNumberFromJson(jsonString);

import 'dart:convert';

List<AccountNumber> accountNumberFromJson(String str) => List<AccountNumber>.from(json.decode(str).map((x) => AccountNumber.fromJson(x)));

String accountNumberToJson(List<AccountNumber> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccountNumber {
  AccountNumber({
    this.accNo,
  });

  String accNo;

  factory AccountNumber.fromJson(Map<String, dynamic> json) => AccountNumber(
    accNo: json["Acc_No"],
  );

  Map<String, dynamic> toJson() => {
    "Acc_No": accNo,
  };

  @override
  String toString() {
    return 'AccountNumber{accNo: $accNo}';
  }
}
