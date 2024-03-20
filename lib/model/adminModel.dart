class AdminModel{
  String? adminName;
  String? adminEmail;
  String? adminPhone;
  String? adminPsw;
  String? adminType;

  adminMap(){
    var map = Map<String, dynamic>();
    map['adminName'] = adminName!;
    map['adminEmail'] = adminEmail!;
    map['adminPhone'] = adminPhone!;
    map['adminPsw'] = adminPsw!;
    map['adminType'] = adminType!;
    return map;
  }
}