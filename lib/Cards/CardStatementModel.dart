// To parse this JSON data, do
//
//     final cardStatementModel = cardStatementModelFromJson(jsonString);

import 'dart:convert';

CardStatementModel cardStatementModelFromJson(String str) => CardStatementModel.fromJson(json.decode(str));

String cardStatementModelToJson(CardStatementModel data) => json.encode(data.toJson());

class CardStatementModel {
  CardStatementModel({
    this.data,
    this.errorMessage,
    this.statusCode,
    this.successMessage,
  });

  List<CardTransTable> data;
  String errorMessage;
  int statusCode;
  String successMessage;

  factory CardStatementModel.fromJson(Map<String, dynamic> json) => CardStatementModel(
    data: List<CardTransTable>.from(json["data"].map((x) => CardTransTable.fromJson(x))),
    errorMessage: json["errorMessage"],
    statusCode: json["statusCode"],
    successMessage: json["successMessage"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "errorMessage": errorMessage,
    "statusCode": statusCode,
    "successMessage": successMessage,
  };
}

class CardTransTable {
  CardTransTable({
    this.voucherNo,
    this.amount,
    this.availableBalance,
    this.dtTransactionDate,
    this.intTransactionType,
    this.strNarration,
    this.strUserRemark,
    this.strVoucherType,
    this.transactionHeadId,
  });

  dynamic voucherNo;
  String amount;
  int availableBalance;
  String dtTransactionDate;
  int intTransactionType;
  String strNarration;
  dynamic strUserRemark;
  String strVoucherType;
  String transactionHeadId;

  factory CardTransTable.fromJson(Map<String, dynamic> json) => CardTransTable(
    voucherNo: json["VoucherNo"],
    amount: json["amount"],
    availableBalance: json["availableBalance"],
    dtTransactionDate: json["dtTransactionDate"],
    intTransactionType: json["intTransactionType"],
    strNarration: json["strNarration"],
    strUserRemark: json["strUserRemark"],
    strVoucherType: json["strVoucherType"],
    transactionHeadId: json["transaction_head_id"],
  );

  Map<String, dynamic> toJson() => {
    "VoucherNo": voucherNo,
    "amount": amount,
    "availableBalance": availableBalance,
    "dtTransactionDate": dtTransactionDate,
    "intTransactionType": intTransactionType,
    "strNarration": strNarration,
    "strUserRemark": strUserRemark,
    "strVoucherType": strVoucherType,
    "transaction_head_id": transactionHeadId,
  };

  @override
  String toString() {
    return 'CardTransTable{voucherNo: $voucherNo, amount: $amount, availableBalance: $availableBalance, dtTransactionDate: $dtTransactionDate, intTransactionType: $intTransactionType, strNarration: $strNarration, strUserRemark: $strUserRemark, strVoucherType: $strVoucherType, transactionHeadId: $transactionHeadId}';
  }
}
