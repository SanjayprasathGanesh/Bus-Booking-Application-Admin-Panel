class RentBusModel{
  String? uEmail;
  String? phone;
  String? from;
  String? to;
  String? fromDate;
  String? toDate;
  int? ttlDays;
  String? busType;
  String? reqDriver;
  bool? isAssigned;

  rentMap(){
    var mapping = Map<String, dynamic>();
    mapping['uEmail'] = uEmail!;
    mapping['phone'] = phone!;
    mapping['from'] = from;
    mapping['to'] = to;
    mapping['fromDate'] = fromDate;
    mapping['toDate'] = toDate;
    mapping['ttlDays'] = ttlDays;
    mapping['busType'] = busType;
    mapping['reqDriver'] = reqDriver;
    mapping['isAssigned'] = isAssigned;
    return mapping;
  }
}