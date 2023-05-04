// To parse this JSON data, do
//
//     final qrCodeModel = qrCodeModelFromJson(jsonString);

import 'dart:convert';

List<QrCodeModel> qrCodeModelFromJson(String str) => List<QrCodeModel>.from(json.decode(str).map((x) => QrCodeModel.fromJson(x)));

String qrCodeModelToJson(List<QrCodeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QrCodeModel {
  QrCodeModel({
    this.accNo,
    this.qrCode,
  });

  String accNo;
  String qrCode;

  factory QrCodeModel.fromJson(Map<String, dynamic> json) => QrCodeModel(
    accNo: json["Acc_No"],
    qrCode: json["QRCode"],
  );

  Map<String, dynamic> toJson() => {
    "Acc_No": accNo,
    "QRCode": qrCode,
  };

  @override
  String toString() {
    return 'QrCodeModel{accNo: $accNo, qrCode: $qrCode}';
  }


}