// To parse this JSON data, do
//
//     final depositSearchModel = depositSearchModelFromJson(jsonString);

import 'dart:convert';

DepositSearchModel depositSearchModelFromJson(String str) => DepositSearchModel.fromJson(json.decode(str));

String depositSearchModelToJson(DepositSearchModel data) => json.encode(data.toJson());

class DepositSearchModel {
  DepositSearchModel({
    this.depositTable,
  });

  List<DepositTable> depositTable;

  factory DepositSearchModel.fromJson(Map<String, dynamic> json) => DepositSearchModel(
    depositTable: List<DepositTable>.from(json["Table"].map((x) => DepositTable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Table": List<dynamic>.from(depositTable.map((x) => x.toJson())),
  };
}

class DepositTable {
  DepositTable({
    this.id,
    this.accNo,
    this.schCode,
    this.brCode,
    this.trDate,
    this.tranType,
    this.display,
    this.amount,
    this.narration,
    this.balance,
    this.seqNo,
    this.show,
    this.dailyBalance,
    this.tranBalance,
  });

  double id;
  String accNo;
  String schCode;
  String brCode;
  DateTime trDate;
  TranType tranType;
  Display display;
  double amount;
  String narration;
  double balance;
  double seqNo;
  Show show;
  double dailyBalance;
  double tranBalance;

  factory DepositTable.fromJson(Map<String, dynamic> json) => DepositTable(
    id: json["ID"],
    accNo: json["Acc_No"],
    schCode: json["Sch_Code"],
    brCode: json["Br_Code"],
    trDate: DateTime.parse(json["Tr_Date"]),
    tranType: tranTypeValues.map[json["Tran_Type"]],
    display: displayValues.map[json["Display"]],
    amount: json["Amount"],
    narration: json["Narration"],
    balance: json["balance"].toDouble(),
    seqNo: json["Seq_No"],
    show: showValues.map[json["Show"]],
    dailyBalance: json["DailyBalance"].toDouble(),
    tranBalance: json["TranBalance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Acc_No": accNo,
    "Sch_Code": schCode,
    "Br_Code": brCode,
    "Tr_Date": trDate.toIso8601String(),
    "Tran_Type": tranTypeValues.reverse[tranType],
    "Display": displayValues.reverse[display],
    "Amount": amount,
    "Narration": narration,
    "balance": balance,
    "Seq_No": seqNo,
    "Show": showValues.reverse[show],
    "DailyBalance": dailyBalance,
    "TranBalance": tranBalance,
  };
}

enum Display { AMOUNT }

final displayValues = EnumValues({
  "AMOUNT": Display.AMOUNT
});

enum Show { DEPOSIT, WITHDRAWAL }

final showValues = EnumValues({
  "Deposit": Show.DEPOSIT,
  "Withdrawal": Show.WITHDRAWAL
});

enum TranType { C, D }

final tranTypeValues = EnumValues({
  "C": TranType.C,
  "D": TranType.D
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
