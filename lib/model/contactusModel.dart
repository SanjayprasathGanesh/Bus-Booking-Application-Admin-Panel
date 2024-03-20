class ContactUsModel{
  String? uEmail;
  String? date;
  String? day;
  String? email;
  String? sub;
  String? content;
  bool? isReplied;

  contactMap(){
    var map = Map<String, dynamic>();
    map['uEmail'] = uEmail;
    map['date'] = date;
    map['day'] = day;
    map['email'] = email;
    map['sub'] = sub;
    map['content'] = content;
    map['isReplied'] = isReplied;
    return map;
  }
}