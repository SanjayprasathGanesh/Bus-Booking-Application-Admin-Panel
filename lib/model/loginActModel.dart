class LoginActivityModel{
  String? adminName;
  String? adminPhone;
  String? date;
  String? time;

  actMap(){
    var map = Map<String, dynamic>();
    map['adminName'] = adminName!;
    map['adminPhone'] = adminPhone!;
    map['date'] = date!;
    map['time'] = time!;
    return map;
  }
}