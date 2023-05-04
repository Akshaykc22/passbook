import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
	LoginModel({
		this.table,
	});
	
	List<Table> table;
	
	factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
		table: List<Table>.from(json["Table"].map((x) => Table.fromJson(x))),
	);
	
	Map<String, dynamic> toJson() => {
		"Table": List<dynamic>.from(table.map((x) => x.toJson())),
	};
}

class Table {
	Table({
		this.custId,
		this.custName,
		this.adds,
		this.brName,
		this.accNo,
		this.schCode,
		this.schName,
		this.brCode,
		this.depBranch,
		this.balance,
		this.module,
		this.mobile,
		this.ifsc,
		this.accountNo,
	});
	
	int custId;
	String custName;
	String adds;
	String brName;
	String accNo;
	String schCode;
	String schName;
	String brCode;
	String depBranch;
	double balance;
	String module;
	String mobile;
	String ifsc;
	String accountNo;

	factory Table.fromJson(Map<String, dynamic> json) => Table(
		custId: json["Cust_id"],
		custName: json["Cust_name"],
		adds: json["adds"],
		brName: json["Br_Name"],
		accNo: json["Acc_No"],
		schCode: json["Sch_Code"],
		schName: json["Sch_Name"],
		brCode: json["Br_Code"],
		depBranch: json["Dep_Branch"],
		balance: json["balance"]?.toDouble(),
		module: json["Module"],
		mobile: json["Mobile"],
		ifsc: json["Ifsc"],
		accountNo: json["AccountNumber"],
	);
	
	Map<String, dynamic> toJson() => {
		"Cust_id": custId,
		"Cust_name": custName,
		"adds": adds,
		"Br_Name": brName,
		"Acc_No": accNo,
		"Sch_Code": schCode,
		"Sch_Name": schName,
		"Br_Code": brCode,
		"Dep_Branch": depBranch,
		"balance": balance,
		"Module": module,
		"Mobile": mobile,
		"Ifsc": ifsc,
		"accountNo": accountNo,
	};
}
