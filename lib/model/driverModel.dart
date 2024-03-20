class DriverModel{
  String? driverName;
  String? driverPhone;
  String? driverType;
  String? driverDob;
  int? driverAge;
  String? driverAddress;
  String? driverLicenceId;
  String? driverAadharNumber;
  String? driverImg;

  driverMap(){
    var map = Map<String, dynamic>();
    map['driverName'] = driverName!;
    map['driverPhone'] = driverPhone!;
    map['driverType'] = driverType!;
    map['driverDob'] = driverDob!;
    map['driverAge'] = driverAge!;
    map['driverAddress'] = driverAddress!;
    map['driverLicenseId'] = driverLicenceId!;
    map['driverAadharNumber'] = driverAadharNumber!;
    map['driverImg'] = driverImg;
    return map;
  }
}